;; genesis.layer.1.scm
;; Layer 1: selection only (light/dark classification)

(define (string-prefix? s prefix)
  (let ((ls (string-length s))
        (lp (string-length prefix)))
    (and (>= ls lp) (string=? (substring s 0 lp) prefix))))

(define (string-suffix? s suffix)
  (let ((ls (string-length s))
        (lf (string-length suffix)))
    (and (>= ls lf) (string=? (substring s (- ls lf) ls) suffix))))

(define (matches-any? path patterns)
  ;; Minimal matcher:
  ;; - treats pattern ending with "/" as prefix match
  ;; - treats "*.ext" as suffix match
  ;; - otherwise prefix match
  (let loop ((ps patterns))
    (if (null? ps) #f
        (let ((p (car ps)))
          (cond
            ((string=? p "") (loop (cdr ps)))
            ((string-suffix? p "/")
             (if (string-prefix? path p) #t (loop (cdr ps))))
            ((and (>= (string-length p) 2) (string-prefix? p "*."))
             (let ((ext (substring p 1 (string-length p))))
               (if (string-suffix? path ext) #t (loop (cdr ps)))))
            (else
             (if (string-prefix? path p) #t (loop (cdr ps)))))))))

(define (L1.classify l0-record ignore-patterns include-patterns)
  (let ((path (cdr (assoc 'path l0-record))))
    (cond
      ((matches-any? path ignore-patterns) 'unknown-unknown)
      ((matches-any? path include-patterns) 'known-known)
      (else 'known-unknown))))
