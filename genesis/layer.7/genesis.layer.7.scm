;; genesis.layer.7.scm
;; Layer 7: projection / canonicalization (VM-visible state)

(define (L7.parity n) (if (= (modulo n 2) 0) 'even 'odd))

(define (L7.is-prime n)
  (cond
    ((< n 2) #f)
    ((= n 2) #t)
    ((= (modulo n 2) 0) #f)
    (else
     (let loop ((d 3))
       (cond
         ((> (* d d) n) #t)
         ((= (modulo n d) 0) #f)
         (else (loop (+ d 2))))))))

(define (L7.residue-from-address address)
  ;; Deterministic placeholder: replace with your ip6 8-byte fold.
  (modulo (string-length address) 8))

(define (L7.admissible-7point? r)
  ;; 8 -> 7 compression: reject residue 6
  (not (= r 6)))

(define (L7.project l2 l6)
  (let* ((addrp (assoc 'address l2))
         (address (if addrp (cdr addrp) "::"))
         (r (L7.residue-from-address address))
         (ad? (L7.admissible-7point? r))
         (facets (list (L7.parity r)
                       (if (L7.is-prime r) 'prime 'not-prime)))
         (gate (cdr (assoc 'gate.result l6))))
    `((vm.pointer . ,r)
      (vm.admissible? . ,ad?)
      (vm.facets . ,facets)
      (vm.gate . ,gate))))
