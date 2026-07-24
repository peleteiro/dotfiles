# Ansible — máquinas da casa

Configuração **básica** das máquinas que rodam agentes, rotinas e serviços da casa.
Roda do **laptop → máquina via SSH**. Este Ansible **não instala** os agentes/serviços —
só ajusta a máquina (que já tem o [dotfiles](../README.md) instalado).

Máquinas:

| Máquina | SO | Papel | Playbook |
|---------|----|-------|----------|
| `macmini` | macOS | Roda agentes e rotinas | [`macmini.yml`](./macmini.yml) |

## Pré-requisitos

**No controller (laptop):**

- `ansible` — via mise (`mise install`) ou `brew install ansible`.
- `op` (1Password CLI) **autenticado**: `op signin` (ou `eval "$(op signin)"`). Os playbooks
  leem a chave SSH do 1Password em runtime — nada de segredo no repo.
- SSH de entrada pra máquina já funcionando (a chave pública do laptop já está no
  `authorized_keys` da máquina).

- `community.general` (collection) — `ansible-galaxy collection install -r requirements.yml`
  (o `mise install` não faz isso; rode uma vez).

**Na máquina alvo:**

- `python3` — necessário pros módulos do Ansible. No macOS vem com o Command Line Tools;
  no Linux, `apt install python3` (normalmente já presente).
- **macmini:** `sudo` disponível e **FileVault desligado** (com FileVault o macOS ignora o
  auto-login).

### Segredos locais (senha de sudo) — arquivo único, evita o `-K`

Um **único** arquivo **gitignored** guarda a senha de sudo de cada máquina (podem ser
diferentes). Cada `group_vars/<máquina>.yml` mapeia o `ansible_become_password` pra chave
da sua máquina.

```bash
cp ansible/group_vars/all/secrets.example.yml ansible/group_vars/all/secrets.yml
# edite secrets.yml e preencha macmini_become_password
```

Fica em `group_vars/all/secrets.yml` (não `group_vars/secrets.yml`) porque o Ansible
auto-carrega `group_vars/<grupo>/` — `all` é o grupo especial "todos os hosts"; um
`group_vars/secrets.yml` seria interpretado como um grupo `secrets` (inexistente) e
ignorado. Os runners do mise **verificam a senha da máquina alvo** e **abortam** se faltar
ou estiver com placeholder — sem `-K`. Para um run avulso sem o secret, chame o
`ansible-playbook` direto com `-K`.

## Configuração

1. Cadastre o host em [`inventory.ini`](./inventory.ini): `ansible_host` (IP fixo da LAN ou
   nome DNS/mDNS, ex.: `macmini.casa`) e `ansible_user`.
2. Confirme o item do 1Password em [`group_vars/all.yml`](./group_vars/all.yml)
   (`op_ssh_item`). Liste os seus com `op item list --categories "SSH Key"`.

## Rodar

```bash
# via mise (recomendado — convenção do repo). Cada runner valida o secret da máquina.
mise run ansible                           # todas as máquinas ativas
mise run ansible -- --check                # dry-run (não altera nada)
mise run ansible:macmini                    # só o Mac Mini
mise run ansible:macmini -- --check         # dry-run
mise run ansible:check-secrets -- macmini   # só valida o secret

# run avulso sem secrets.yml (informa a senha na hora):
cd ansible && ansible-playbook macmini.yml --check -K
```

## O que faz

| Role              | Aplica a | O que configura |
|-------------------|----------|-----------------|
| `ssh-keys`        | Todas    | Deposita o par de chaves SSH (`~/.ssh/id_ed25519` + `.pub`) lido do 1Password, e sobrepõe `~/.ssh/config` para a máquina usar o **arquivo de chave** em vez do **agent do 1Password** (indisponível numa máquina headless). OS-agnóstica (macOS e Linux). |
| `prepare`         | Todas    | Instala as ferramentas base pros scripts: **bash** (macOS traz 3.2), **curl** e **rust CLI** (`rg`, `fd`, `sd`, `bat`). Dispatch por SO (Homebrew no macOS, apt no Linux). |
| `macos-autologin` | macmini  | Habilita o **auto-login** do usuário no boot (`autoLoginUser` + `/etc/kcpassword`), pré-requisito pro Colima subir headless sem ninguém logar. |
| `macos-nosleep`   | macmini  | **Nunca dormir** (`pmset -a sleep 0` + disksleep/powernap/womp), pra o servidor ficar sempre ligado e acessível por SSH. |
| `docker`          | macmini  | Docker **headless via Colima** (Docker Desktop precisa de GUI): instala/atualiza `colima`+`docker` via Homebrew, cria a VM, habilita autostart no boot (LaunchAgent) e valida `docker info`. **Remove o Docker Desktop** se presente. Dispatch por SO (`tasks/Darwin.yml`; `Debian.yml` quando o HA precisar). |

> **Docker headless:** o par `macos-autologin` + `docker` faz o Colima subir sozinho a cada
> reboot (auto-login → LaunchAgent → `colima start`), sem login manual. Exige FileVault off.

> **Ordem com o dotfiles:** rode o Ansible **depois** do `./dotfiles`. O dotfiles
> reescreve o `~/.ssh/config` inteiro; o bloco de override é reaplicado a cada run do
> Ansible (idempotente), então basta rodar de novo se reinstalar o dotfiles.

## Estrutura

```
ansible/
├── ansible.cfg              # config (inventory, roles_path, python)
├── inventory.ini            # hosts + grupos (por máquina e por SO)
├── requirements.yml         # collections do Galaxy (community.general)
├── site.yml                 # playbook MESTRE — importa um playbook por máquina
├── macmini.yml              # máquina: Mac Mini (macOS)
├── group_vars/
│   ├── all/
│   │   ├── main.yml         # vars compartilhadas (ponteiros op://, não-secretos)
│   │   ├── secrets.example.yml  # template do secrets (versionado)
│   │   └── secrets.yml      # senhas de sudo por máquina (GITIGNORED)
│   ├── darwin.yml           # vars só de macOS (specs da VM do Colima)
│   └── macmini.yml          # mapeia ansible_become_password ← macmini_become_password
└── roles/
    ├── ssh-keys/            # chaves SSH + desligar agent 1Password (todas as máquinas)
    ├── prepare/             # bash, curl, rust CLI (dispatch por SO)
    ├── macos-autologin/     # auto-login no boot (macmini)
    ├── macos-nosleep/       # nunca dormir — pmset (macmini)
    └── docker/              # Colima headless + remove Docker Desktop (dispatch por SO)
```

### Adicionar uma máquina nova

1. **Inventory** ([`inventory.ini`](./inventory.ini)): cadastre o host no grupo dela
   (ex.: `[servidor]`) e no grupo de SO (`[darwin:children]` / `[linux:children]`).
2. **Playbook**: crie o playbook da máquina (`hosts: <grupo>`, listando as roles).
3. **site.yml**: adicione o `import_playbook` correspondente.
4. **Vars**: comuns vão em `group_vars/all/`; específicas de SO em
   `group_vars/darwin.yml` ou `group_vars/linux.yml`; por-host em `host_vars/<host>.yml`.
   A senha de sudo entra no `group_vars/all/secrets.yml` como `<máquina>_become_password`.
   Roles que rodam em Linux precisam de um `tasks/Debian.yml` (dispatch por SO).

Configurações reutilizáveis viram **roles** em `roles/`, adicionadas ao playbook da máquina.
