---
trigger: always_on
---

# Comandos Destrutivos Proibidos

NUNCA execute estes comandos sem aprovação explícita do usuário:

## Sistema

Este repositório instala arquivos no `$HOME` do usuário (`./dotfiles`). Tenha
cuidado redobrado com escrita fora do repositório.

- `rm -rf` (especialmente em `/`, `$HOME`, `/etc`, e dentro de `.git`)
- `chmod -R 777`
- `chown -R`
- Sobrescrever `~/.zshrc`, `~/.gitconfig`, etc. **fora** do fluxo do `./dotfiles`

## Git

- `git push --force` / `git push -f` / `git push --force-with-lease` (reescreve histórico)
- `git reset --hard`
- `git clean -fd`
- `git commit --no-verify` (os hooks de validação devem sempre rodar)

> `git push` normal é permitido, mas só quando o usuário pedir — ver [[005-git-push]].

## Docker (usado só nos testes de Linux)

- `docker system prune`

Se o usuário pedir algum destes comandos, SEMPRE confirme antes de executar.
