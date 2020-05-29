;; Project Administration
;; ----------------------

;; Constants
;; ---------
(define-constant administrator 'ST1ESYCGJB5Z5NBHS39XPC70PGC14WAQK5XXNQYDW)
(define-constant not-allowed (err 100))
(define-constant not-found (err 200))

;; Storage
;; -------
;; project-map
;; params: 
;;     base-url - url from where to read project meta data
;;     mint-fee - fee 
(define-map project-map ((project-id principal)) ((base-url (buff 40)) (mint-fee uint)))

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

;; get the valmeta data for the given project
(define-public (get-project (projectId principal))
  (match (map-get? project-map {project-id: projectId})
    myProject (ok myProject) (err 2)
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
      (err 2)
    )
  )
)

;; Only contract administrator can do these things.
(define-private (is-create-allowed)
  (is-eq tx-sender administrator)
)

;; Only contract administrator can do these things.
(define-private (is-update-allowed (projectId principal))
  (is-eq tx-sender projectId)
)

;; sanity check the current contract address
(define-public (get-address)
  (ok (as-contract tx-sender))
)