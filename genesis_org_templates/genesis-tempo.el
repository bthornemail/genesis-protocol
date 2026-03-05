;;; genesis-tempo.el --- GENESIS templates for org-tempo -*- lexical-binding: t; -*-

(require 'org)
(require 'org-tempo)

;; We do NOT hardcode a “pinch point” meta-tag.
;; Any non-alphanumeric operator may serve as enclosure.
;; Emoji repetition = polynomial degree (user-chosen).

(defvar genesis-org-structure-template-alist
  '(("g" . "src sh")                 ; shell
    ("G" . "src org")                ; org-in-org (self reference)
    ("s" . "src scheme")             ; scheme/guile
    ("c" . "src C")                  ; C
    ("j" . "src js")                 ; JavaScript
    ("m" . "src markdown")           ; Markdown
    ("H" . "example")                ; provenance literal region
    ("S" . "quote")                  ; schema text / citations
    ("X" . "comment"))               ; excluded / inert
  "GENESIS structure templates for org-insert-structure-template.")

(dolist (tpl genesis-org-structure-template-alist)
  (add-to-list 'org-structure-template-alist tpl t))

(defvar genesis-org-tempo-keywords-alist
  '(("gs" . "src sh")
    ("gS" . "src scheme")
    ("gC" . "src C")
    ("gj" . "src js")
    ("gm" . "src markdown")
    ("gH" . "example")
    ("gX" . "comment"))
  "GENESIS tempo keywords.")

(dolist (kw genesis-org-tempo-keywords-alist)
  (add-to-list 'org-tempo-keywords-alist kw t))

(provide 'genesis-tempo)
;;; genesis-tempo.el ends here
