;; tools/genesis-run.scm
;; Orchestrates layers 0–7.
;; This file is non-authoritative convenience tooling.

(load "genesis/layer.0/genesis.layer.0.scm")
(load "genesis/layer.1/genesis.layer.1.scm")
(load "genesis/layer.2/genesis.layer.2.scm")
(load "genesis/layer.3/genesis.layer.3.scm")
(load "genesis/layer.4/genesis.layer.4.scm")
(load "genesis/layer.5/genesis.layer.5.scm")
(load "genesis/layer.6/genesis.layer.6.scm")
(load "genesis/layer.7/genesis.layer.7.scm")

(define (read-bytes-stub path)
  ;; Replace with real file IO.
  "<<BYTES>>")

(define (genesis-run root)
  ;; Placeholder pipeline demo: no real enumeration yet.
  (let* ((l0 (L0.stat root "README.org"))
         (ignore '(".git/" ".org/"))
         (include '("*.org" "*.scm" "genesis/"))
         (l1 (L1.classify l0 ignore include))
         (l2 (L2.assign l0 l1))
         (l3 (L3.emit-org l0 l1 l2))
         (l4 (L4.represent l0 l1 l2 read-bytes-stub))
         (l5 (L5.structure l4))
         (l6 (L6.validate l2 l5 '()))
         (l7 (L7.project l2 l6)))
    (display l3) (newline)
    (display l7) (newline)))

;; (genesis-run ".")
