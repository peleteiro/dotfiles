---
trigger: always_on
---

# Instalação via `./dotfiles`, tarefas de dev via `mise`

## Instalação (uso final)

- Para aplicar os dotfiles use **`./dotfiles`** diretamente. Não precisa de
  `mise` para instalar.

## Tarefas de desenvolvimento

- Use **`mise`** para lint, testes e debug. NUNCA use npm/pnpm/yarn (este
  projeto é shell, não Node).

### Correto

```bash
mise run lint
mise run test
mise run debug:linux:gui
mise run debug:linux:nogui
```

## Tasks são FILE-BASED

- As tasks ficam em **`.config/mise/tasks/`** (estrutura de diretórios).
- NUNCA defina tasks dentro de `mise.toml`.

## Shell / Lint

- Todo script deve passar em `mise run lint` (shellcheck, `shell=bash`).
- Sempre cite variáveis: `"$VAR"`, não `$VAR`.
- Prefira as alternativas modernas em Rust: `fd` (não `find`), `rg` (não
  `grep`), `sd` (não `sed`), `bat` (não `cat`) nos scripts de `home/.bin/`.
- Ao usar `sd`/`rg` com aspas simples, anote `# shellcheck disable=SC2016`.
