;; Project Administration
;; ----------------------
;; Projects are SaaS based clients of the platform. The platform provides
;; a common interface for different arts and collectibles projects to
;; to develop smart contract capabilities and provides maketplace and
;; bidding functionality. 

;; Constants
;; ---------
(define-constant administrator 'ST1ESYCGJB5Z5NBHS39XPC70PGC14WAQK5XXNQYDW)
(define-constant not-allowed u100)
(define-constant not-found u100)
;; uhu - error code 1000 means the error codes are not working - and out of time!!!!
;; (define-constant not-allowed (unwrap! (contract-call? .error-codes err-not-allowed) (err 1000)))
;; (define-constant not-found (unwrap! (contract-call? .error-codes err-not-found) (err 1000)))

;; Storage
;; -------
;; project-map
;;     base-url - for access to assets via project
;;     mint-fee - project determined minting fee 
(define-map project-map ((project-id principal)) ((base-url (buff 40)) (mint-fee uint)))

;; Public functions
;;-------------------

;; Add a new project - administrator level call.
(define-public (add-project (projectId principal) (baseUrl (buff 40)) (mintFee uint))
  (begin
    (if (is-create-allowed)
      (begin
        (map-insert project-map {project-id: projectId} ((base-url baseUrl) (mint-fee mintFee)))
        (ok projectId)
      )
      (err not-allowed)
    )
  )
)

;; get the minting fee for this project
(define-public (get-mint-fee (projectId principal))
  (ok (unwrap! (get mint-fee (map-get? project-map {project-id: projectId})) (err 1)))
)

;; get the meta data for the given project
(define-public (get-project (projectId principal))
  (match (map-get? project-map {project-id: projectId})
    myProject (ok myProject) (err not-found)
  )
)

;; Update new project - project owner level call.
(define-public (update-project (projectId principal) (baseUrl (buff 40)) (mintFee uint))
  (begin
    (if (is-update-allowed projectId)
      (begin
        (map-set project-map {project-id: projectId} ((base-url baseUrl) (mint-fee mintFee)))
        (ok projectId)
      )
      (err not-allowed)
    )
  )
)

;; sanity check the current contract address
(define-public (get-address)
  (ok (as-contract tx-sender))
)

;; Private functions
;;-------------------

;; Only contract administrator can do these things
(define-private (is-create-allowed)
  (is-eq tx-sender administrator)
)

;; Allowed by if project admin is tex sender
(define-private (is-update-allowed (projectId principal))
  (is-eq tx-sender projectId)
)

