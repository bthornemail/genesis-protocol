;; genesis.layer.0.scm
;; Layer 0: existence only (POSIX stat + enumeration)
;; No content reads. No hashing. No parsing.

(define (L0.enumerate root)
  ;; Placeholder: implement with your Scheme runtime / OS bindings.
  ;; Returns list of relative paths under root.
  '())

(define (L0.stat root relpath)
  ;; Placeholder: implement with stat().
  ;; MUST NOT read file bytes.
  ;; Return immutable fact record.
  `((path . ,relpath)
    (kind . file)     ; file|dir|symlink
    (size . 0)
    (mtime . "UNKNOWN")
    (mode . "UNKNOWN")
    (uid . 0)
    (gid . 0)))
