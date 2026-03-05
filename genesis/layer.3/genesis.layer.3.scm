;; genesis.layer.3.scm
;; Layer 3: provenance emitter (append-only .org nodes)

(define (alist-ref k a)
  (let ((p (assoc k a))) (if p (cdr p) #f)))

(define (L3.emit-org l0 l1 l2)
  (let ((path (alist-ref 'path l0))
        (kind (alist-ref 'kind l0))
        (size (alist-ref 'size l0))
        (mtime (alist-ref 'mtime l0))
        (addr (alist-ref 'address l2)))
    (string-append
     "* GENESIS
"
     ":PROPERTIES:
"
     ":GENESIS_LAYER: 3
"
     ":PATH: " (if path path "") "
"
     ":KIND: " (if kind (symbol->string kind) "") "
"
     ":SIZE: " (if size (number->string size) "0") "
"
     ":MTIME: " (if mtime mtime "") "
"
     ":CLASS: " (symbol->string l1) "
"
     (if addr (string-append ":ADDRESS: " addr "
") "")
     ":END:

")))
