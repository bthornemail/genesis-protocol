#!/usr/bin/env sh
set -eu

ORG="${1:-genesis.org}"

emacs --batch \
  --eval "(require 'org)" \
  --eval "(require 'ob-tangle)" \
  --eval "(setq org-confirm-babel-evaluate nil)" \
  --eval "(org-babel-tangle-file "${ORG}")"

echo "Tangled from ${ORG}"
