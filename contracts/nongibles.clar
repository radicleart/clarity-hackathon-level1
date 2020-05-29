;; Basic contract demonstrating minting of non fungible tokens - nongibles.

;; This contract demonstrates;
;;   minting of NFT tokens for a configurable amount of stax
;;   using contract-call to exteranlise commonly used code

;; Non Fungible Token - clarity built in data structure
(define-non-fungible-token nongibles (buff 32))
(define-constant administrator 'ST1ESYCGJB5Z5NBHS39XPC70PGC14WAQK5XXNQYDW)

;; Contract address - produced by calling cargo run --bin blockstack-cli generate-sk --testnet
;; (define-constant contract-address 'ST18PE05NG1YN7X6VX9SN40NZYP7B6NQY6C96ZFRC.nongibles)

;; Storage
;; nongible-project-map : linked list of an owners assets
(define-map nongible-project-map ((asset-hash (buff 32))) ((project-id int)))

;; mint token: 
;;      transfer fee from tx-sender to contract, 
;;      mint the token to tx-sender,
;;      call the projects contract to get the lookup the project
(define-public (mint-to (projectId int) (mint-fee uint) (assetHash (buff 32)))
  (begin
    (stx-transfer? mint-fee tx-sender (as-contract tx-sender))
    (nft-mint? nongibles assetHash tx-sender)
    ;; (let ((project-id (unwrap! (contract-call? .projects get-project projectId) false))))
    (ok
      (map-set nongible-project-map {asset-hash: assetHash} ((project-id projectId)))
    )
  )
)

;; lookup the assets project
(define-public (admin-mint (assetHash (buff 32)) (projectId int))
  (begin
    (nft-mint? nongibles assetHash (as-contract tx-sender))
    ;; (let ((project-id (contract-call? .projects get-project projectId))) (some project-id))
    (ok
      (map-set nongible-project-map {asset-hash: assetHash} ((project-id projectId)))
    )
  )
)

;; lookup the assets project
(define-public (get-project-id (asset-hash (buff 32)))
  (ok (map-get? nongible-project-map {asset-hash: asset-hash}))
)

;; lookup the assets project
(define-public (get-owner (asset-hash (buff 32)))
  (ok (nft-get-owner? nongibles asset-hash))
)

;; owner is passed in as an argument
(define-read-only (get-nongible (assetHash (buff 32)))
  (unwrap-panic (map-get? nongible-project-map {asset-hash: assetHash})))

;; sanity check the current contract address
(define-public (get-address)
  (ok (as-contract tx-sender))
)