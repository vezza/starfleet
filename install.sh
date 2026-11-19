#!/usr/bin/env bash
set -euo pipefail

THEME=starfleet
THEME_DIR="/usr/share/plymouth/themes/${THEME}"
STATE_DIR="/var/lib/${THEME}-plymouth"

if [[ ${EUID} -ne 0 ]]; then
  echo "Esegui con sudo: sudo $0" >&2; exit 1
fi
if ! command -v plymouth-set-default-theme >/dev/null 2>&1; then
  echo "plymouth-scripts non risulta installato." >&2
  echo "Installa: dnf install plymouth plymouth-plugin-script plymouth-scripts dracut" >&2
  exit 1
fi
if ! rpm -q plymouth-plugin-script >/dev/null 2>&1; then
  echo "Manca il plugin Plymouth Script: dnf install plymouth-plugin-script" >&2; exit 1
fi

mkdir -p "$STATE_DIR"
if [[ ! -s "$STATE_DIR/previous-theme" ]]; then
  current="$(plymouth-set-default-theme 2>/dev/null || true)"
  [[ -n "$current" ]] || current="charge"
  printf '%s\n' "$current" > "$STATE_DIR/previous-theme"
fi

install -d -m 0755 "$THEME_DIR/images"
install -m 0644 starfleet.plymouth starfleet.script "$THEME_DIR/"
install -m 0644 images/*.png "$THEME_DIR/images/"
plymouth-set-default-theme "$THEME" -R

echo
echo "Tema Starfleet Command v6 installato e initramfs rigenerato."
echo "Tema precedente salvato in: $STATE_DIR/previous-theme"
echo "Per verificare: sudo plymouthd --debug --tty=tty1 (da una TTY testuale)."
echo "Per ripristinare: esegui sudo ./restore.sh dalla directory estratta."
