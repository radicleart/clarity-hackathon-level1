;; Basic contract providing generic error codes to other contracts.

(define-constant not-allowed (err 1))
(define-constant not-found (err 2))

(define-public (err-not-allowed)
  (err not-allowed))

(define-public (err-not-found)
  (err not-found))
