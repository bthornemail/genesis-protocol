;; genesis.layer.2.scm
;; Layer 2: identity envelope (address + fingerprint policy)
;; No parsing, no execution.

(define (L2.address-of-path path)
  ;; Placeholder deterministic address.
  ;; Replace with your IPv6-like 8-byte (or 8x5-line) scheme later.
  (string-append "ip6::" path))

(define (L2.assign l0-record l1-class)
  (let ((path (cdr (assoc 'path l0-record))))
    (cond
      ((eq? l1-class 'unknown-unknown)
       '((visibility . dark)))
      ((eq? l1-class 'known-unknown)
       `((visibility . shadow)
         (address . ,(L2.address-of-path path))))
      ((eq? l1-class 'known-known)
       `((visibility . light)
         (address . ,(L2.address-of-path path))
         (fingerprint-policy . "content-hash-later")))
      (else
       '((visibility . dark))))))
