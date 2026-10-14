#!/usr/bin/env bash
set -euo pipefail

config_dir="${HOME}/.config/cbarabbitry"
key_file="${config_dir}/stripe-payment-links.key"

if [[ ! -t 0 ]]; then
  printf 'Run this command in an interactive terminal.\n' >&2
  exit 1
fi

if [[ -e "$key_file" ]]; then
  read -r -p 'A Stripe key is already saved. Replace it? [y/N] ' answer
  case "$answer" in
    y|Y|yes|YES) ;;
    *) printf 'Existing key kept.\n'; exit 0 ;;
  esac
fi

tty_settings=$(stty -g)
stty -echo
trap 'stty "$tty_settings"' EXIT
printf 'Paste your Stripe live restricted key (rk_live_...), then press Enter: '
stripe_key=''
input_complete=0
while IFS= read -r -n 1 key_char; do
  if [[ -z "$key_char" ]]; then
    input_complete=1
    break
  fi
  if [[ "$key_char" == $'\177' || "$key_char" == $'\b' ]]; then
    if [[ -n "$stripe_key" ]]; then
      stripe_key="${stripe_key%?}"
      printf '\b \b'
    fi
  else
    stripe_key+="$key_char"
    printf '*'
  fi
done
stty "$tty_settings"
trap - EXIT
printf '\n'
if (( ! input_complete )); then
  unset stripe_key
  printf 'Input ended before Enter. Nothing was saved.\n' >&2
  exit 1
fi
if [[ "$stripe_key" != rk_live_?* ]]; then
  unset stripe_key
  printf 'Expected a live restricted key beginning with rk_live_. Nothing was saved.\n' >&2
  exit 1
fi

install -d -m 700 "$config_dir"
chmod 700 "$config_dir"
umask 077
temp_file=$(mktemp "${key_file}.tmp.XXXXXX")
trap 'rm -f -- "$temp_file"' EXIT
printf '%s' "$stripe_key" > "$temp_file"
unset stripe_key
chmod 600 "$temp_file"
mv -f -- "$temp_file" "$key_file"
trap - EXIT

printf 'Stripe key saved to %s (permissions: 600).\n' "$key_file"
