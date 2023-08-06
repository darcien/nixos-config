#!/usr/bin/env bash
set -eu

POP_SMTP_HOST=smtp.purelymail.com POP_SMTP_PORT=465 POP_SMTP_USERNAME=shigure@darcien.me /run/current-system/sw/bin/pop <<<"$(systemctl status --full ${1})" \
  --from "shigure+systemd@darcien.me" \
  --to "admin@darcien.me" \
  --subject "${1} service failure" \
  --preview
