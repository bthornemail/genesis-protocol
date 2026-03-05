;; genesis.layer.6.scm
;; Layer 6: schema gate (valid/invalid/unknown-schema)

(define (L6.require-signature? realm)
  (or (string=? realm "protected")
      (string=? realm "public")))

(define (L6.validate l2 l5 schema-db)
  ;; placeholder: schema-db will come from .genesisschema or schema.bin later
  (let* ((realm "private")
         (req? (L6.require-signature? realm)))
    `((gate.result . unknown-schema)
      (gate.realm . ,realm)
      (gate.require-signature? . ,req?)
      (gate.violations . ()))))
