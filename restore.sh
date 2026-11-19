#!/usr/bin/env bash
set -euo pipefail
STATE_FILE="/var/lib/starfleet-plymouth/previous-theme"
THEME_DIR="/usr/share/plymouth/themes/starfleet"
if [[ ${EUID} -ne 0 ]]; then echo "Esegui con sudo: sudo $0" >&2; exit 1; fi
if [[ ! -s "$STATE_FILE" ]]; then echo "Nessun tema precedente registrato in $STATE_FILE" >&2; exit 1; fi
previous="$(cat "$STATE_FILE")"
if [[ ! -d "/usr/share/plymouth/themes/$previous" ]]; then echo "Il tema precedente '$previous' non è presente." >&2; exit 1; fi
plymouth-set-default-theme "$previous" -R
rm -rf "$THEME_DIR"
echo "Ripristinato il tema: $previous"
