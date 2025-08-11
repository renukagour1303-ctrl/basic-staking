;; Basic Staking Platform in Clarity
;; Only two functions: stake and get-stake

;; Map to store staked amounts
(define-map stakes principal uint)

;; Total staked amount in the contract
(define-data-var total-staked uint u0)

;; Error constants
(define-constant err-invalid-amount (err u100))

;; Stake STX into the contract
(define-public (stake (amount uint))
  (begin
    ;; Ensure the amount is greater than zero
    (asserts! (> amount u0) err-invalid-amount)

    ;; Transfer STX from sender to contract
    (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))

    ;; Update the user's stake
    (map-set stakes tx-sender
             (+ (default-to u0 (map-get? stakes tx-sender)) amount))

    ;; Update total staked
    (var-set total-staked (+ (var-get total-staked) amount))

    (ok true)
  )
)

;; Get the stake amount for a given account
(define-read-only (get-stake (account principal))
  (ok (default-to u0 (map-get? stakes account)))
)
