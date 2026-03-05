;; genesis.layer.4.scm
;; Layer 4: representation wrapper (bytes -> org/src blocks), no meaning.

(define (L4.ext->lang path)
  (cond
    ((string-suffix? path ".scm") "scheme")
    ((string-suffix? path ".c") "c")
    ((string-suffix? path ".h") "c")
    ((string-suffix? path ".json") "json")
    ((string-suffix? path ".jsonl") "json")
    ((string-suffix? path ".yaml") "yaml")
    ((string-suffix? path ".yml") "yaml")
    ((string-suffix? path ".org") "org")
    ((string-suffix? path ".md") "markdown")
    ((string-suffix? path ".lean") "lean")
    (else "text")))

(define (L4.represent l0 l1 l2 read-bytes-fn)
  (let* ((path (cdr (assoc 'path l0)))
         (lang (L4.ext->lang path))
         (size (cdr (assoc 'size l0))))
    (cond
      ((eq? l1 'unknown-unknown)
       '((rep.kind . none)))

      ((eq? l1 'known-unknown)
       `((rep.kind . org-src)
         (rep.lang . ,lang)
         (rep.tangle . ,path)
         (rep.body . "<<CONTENT-DEFERRED>>")
         (rep.size . ,size)
         (rep.encoding . "unknown")))

      ((eq? l1 'known-known)
       (let ((bytes (read-bytes-fn path)))
         `((rep.kind . org-src)
           (rep.lang . ,lang)
           (rep.tangle . ,path)
           (rep.body . ,bytes)
           (rep.size . ,size)
           (rep.encoding . "utf-8|binary"))))

      (else '((rep.kind . none))))))
