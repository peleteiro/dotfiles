# Secrets & 1Password

Everything that involves a private key — SSH authentication to remotes, git
commit signing — flows through 1Password. There is no local `~/.ssh/id_*`
private key, no GPG keyring, no `gpg-agent`. The 1Password app holds the
keys and answers signing/auth requests through its SSH agent socket.

This document explains the moving parts and how to recover when something
breaks.

## Components

| Piece | Role | Installed by |
|-------|------|--------------|
| **1Password Desktop** | Hosts the SSH agent socket. Required for auth/signing to work. | `apply-install` (GUI environments only on Linux; always present on macOS) |
| **1Password CLI** (`op`) | Read items from the command line (`my-key`, scripts). | `apply-install` (always — works without GUI) |
| **`my-key`** | Fetches the SSH key (public or private) from 1Password via `op`. | Copied to `~/.bin/` by `apply-files`. See [`utilities.md`](./utilities.md#my-key--read-ssh-key-from-1password). |
| **SSH key (1Password item)** | Used for both SSH auth and git signing. Item ID exported as `OP_SSH_KEY_ID`. | Created manually in 1Password. |

## How the SSH agent integration works

1Password Desktop opens a Unix socket and listens for SSH-protocol messages.
Our shell config exports `SSH_AUTH_SOCK` pointing at that socket:

- **macOS:** `$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock`
- **Linux (with GUI):** `$HOME/.1password/agent.sock`

Set in:
- [`home/.shared_shell_config-macos`](../home/.shared_shell_config-macos)
- [`home/.shared_shell_config-linux`](../home/.shared_shell_config-linux)

When `ssh`, `git fetch`, or `ssh-keygen -Y sign` runs, OpenSSH talks to that
socket; 1Password pops a confirmation dialog; the operation completes.

## SSH authentication

There is **no** private key in `~/.ssh/`. The `~/.ssh/config` references
`IdentityAgent` (path replaced by `apply-files` at copy time to handle the
macOS Group Container with spaces), so OpenSSH knows to always go through the
1Password agent.

Verify it is working:

```bash
echo $SSH_AUTH_SOCK     # Should point at the 1Password socket
ssh-add -L              # Should list your public key(s) — no prompt
ssh -T git@github.com   # Should authenticate without password
```

## Git commit signing (SSH-based)

We use git's native SSH signing (no GPG, no `~/.gnupg/`).

### What is configured where

[`home/.gitconfig-base`](../home/.gitconfig-base):

```ini
[gpg]
  format = ssh
[user]
  signingkey = key::ssh-ed25519 AAAAC3NzaC1lZDI1NTE5...
```

The `key::` prefix tells git to use the inline string as the public key
instead of reading from a file. The public key is, well, public — versioning
it in the repository is safe.

**`commit.gpgsign` is intentionally NOT set in `.gitconfig-base`.** Instead,
`apply-files` appends it to `~/.gitconfig` only when an SSH agent is reachable:

```bash
if ssh-add -L > /dev/null 2>&1; then
  # …append [commit] gpgsign = true and [tag] gpgsign = true
fi
```

This means cloning the dotfiles on a headless server (no 1Password Desktop)
leaves `git commit` working — it just doesn't sign. On GUI machines with
1Password running, signing is enabled automatically.

### Signing flow

1. `git commit` calls the SSH signing program (default: `ssh-keygen -Y sign`).
2. `ssh-keygen` uses the `key::` inline pubkey to identify which key to ask
   the agent for.
3. The agent (1Password) prompts for confirmation (TouchID / Watch / system
   auth), produces a signature, returns it to git.
4. Git embeds the signature in the commit object.

### Verifying signatures locally

You don't have an `allowed_signers` file by default, so `git log
--show-signature` will not be able to verify your own commits. To enable
verification, write a file like `~/.ssh/allowed_signers` with:

```
your-email@example.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5... (same key)
```

And configure:

```bash
git config --global gpg.ssh.allowedSignersFile ~/.ssh/allowed_signers
```

Not part of the base config because it duplicates the pubkey.

### Push the public key to GitHub

For GitHub to show commits as **Verified**, add the same SSH key under
**Settings → SSH and GPG keys**, and pick the **"Signing Key"** type
(not "Authentication Key" — you can add the same key twice with both roles).

## When things break

### SSH auth fails / "Could not open connection to your authentication agent"

```bash
echo $SSH_AUTH_SOCK         # empty? agent socket is not exported
ls -la "$SSH_AUTH_SOCK"     # missing? 1Password Desktop is not running
```

Open 1Password Desktop, enable **Settings → Developer → Use the SSH agent**.
Restart the shell.

### Commit signing fails

```bash
git config --global gpg.format          # → ssh
git config --global user.signingkey     # → key::ssh-ed25519 …
git config --global commit.gpgsign      # → true  (set by apply-files if agent OK)
ssh-add -L                              # → lists your key
```

If `ssh-add -L` shows the key but signing still fails, try the signing
operation directly:

```bash
echo test | ssh-keygen -Y sign -n git -f <(echo "ssh-ed25519 AAAAC3...")
```

The error message from `ssh-keygen` is usually more informative than git's
generic *"gpg failed to sign the data"*.

### `op` says you are not signed in

```bash
op account list             # → empty if not signed in
op signin                   # → interactive sign-in
```

After signing in, any script that uses `op` (like `my-key`, or the optional
commit-signing activation in `apply-files`) will work.

## Rotating the SSH key

1. Generate a new key in 1Password (let it manage the key material).
2. Update `OP_SSH_KEY_ID` in [`shared_shell_config-{macos,linux}`](../home/)
   if the item ID changed.
3. Replace the inline pubkey in [`.gitconfig-base`](../home/.gitconfig-base).
4. Run `./dotfiles apply:files`.
5. Add the new pubkey to GitHub (both auth + signing roles) and any other
   remotes.
6. Remove the old key from GitHub once you have confirmed signing works.
