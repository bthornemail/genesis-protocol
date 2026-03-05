;; genesis.layer.5.scm
;; Layer 5: structure parse (deterministic), no execution.

(define (L5.structure l4-rep)
  (let ((lang (cdr (assoc 'rep.lang l4-rep))))
    (cond
      ((or (string=? lang "org") (string=? lang "markdown"))
       `((struct.kind . org)
         (struct.props . ())
         (struct.ast . ,(cdr (assoc 'rep.body l4-rep)))
         (struct.errors . ())))
      ((string=? lang "json")
       `((struct.kind . json)
         (struct.props . ())
         (struct.ast . "<<JSON-AST-PENDING>>")
         (struct.errors . ())))
      ((string=? lang "scheme")
       `((struct.kind . sexp)
         (struct.props . ())
         (struct.ast . "<<SEXP-AST-PENDING>>")
         (struct.errors . ())))
      (else
       `((struct.kind . bytes)
         (struct.props . ())
         (struct.ast . "<<BYTES>>")
         (struct.errors . ()))))))
