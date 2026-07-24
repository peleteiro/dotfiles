---
trigger: always_on
---

# Git push só quando pedido explicitamente

Só execute `git push` quando o usuário pedir **explicitamente**. NUNCA faça push por
iniciativa própria.

- Commitar localmente é ok no fluxo normal; publicar (push) não — espere o pedido.
- `git push --force` / `-f` / `--force-with-lease` e `git commit --no-verify` seguem
  **proibidos** (reescrevem histórico / burlam os hooks).
