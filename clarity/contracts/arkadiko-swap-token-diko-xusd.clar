(impl-trait .arkadiko-swap-trait-v1.swap-trait)

(define-fungible-token diko-xusd)

(define-constant ERR-NOT-AUTHORIZED u21401)

(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (match (ft-transfer? diko-xusd amount sender recipient)
    response (begin
      (print memo)
      (ok response)
    )
    error (err error)
  )
)

(define-read-only (get-name)
  (ok "DIKO xUSD LP Token")
)

(define-read-only (get-symbol)
  (ok "DIKO-xUSD")
)

(define-read-only (get-decimals)
  (ok u6)
)

(define-read-only (get-balance (owner principal))
  (ok (ft-get-balance diko-xusd owner))
)

(define-read-only (get-total-supply)
  (ok (ft-get-supply diko-xusd))
)

(define-read-only (get-token-uri)
  (ok (some u"https://arkadiko.finance/tokens/diko-xusd-token.json"))
)
;; {
;;   "name":"DIKO-xUSD",
;;   "description":"DIKO-xUSD Arkadiko LP token",
;;   "image":"url",
;;   "vector":"url"
;; }

;; one stop function to gather all the data relevant to the LP token in one call
(define-read-only (get-data (owner principal))
  (ok {
    name: (unwrap-panic (get-name)),
    symbol: (unwrap-panic (get-symbol)),
    decimals: (unwrap-panic (get-decimals)),
    uri: (unwrap-panic (get-token-uri)),
    supply: (unwrap-panic (get-total-supply)),
    balance: (unwrap-panic (get-balance owner))
  })
)

;; the extra mint method used when adding liquidity
;; can only be used by arkadiko swap main contract
(define-public (mint (recipient principal) (amount uint))
  (begin
    (print "arkadiko-token-swap.mint")
    (print contract-caller)
    (print amount)
    ;; TODO - make dynamic
    (asserts! (is-eq contract-caller .arkadiko-swap-v1-1) (err ERR-NOT-AUTHORIZED))
    (ft-mint? diko-xusd amount recipient)
  )
)


;; the extra burn method used when removing liquidity
;; can only be used by arkadiko swap main contract
(define-public (burn (recipient principal) (amount uint))
  (begin
    (print "arkadiko-token-swap.burn")
    (print contract-caller)
    (print amount)
    ;; TODO - make dynamic
    (asserts! (is-eq contract-caller .arkadiko-swap-v1-1) (err ERR-NOT-AUTHORIZED))
    (ft-burn? diko-xusd amount recipient)
  )
)
