;; Project Administration
;; ----------------------

;; Constants
;; ---------
(define-constant administrator 'ST18PE05NG1YN7X6VX9SN40NZYP7B6NQY6C96ZFRC)
(define-constant not-allowed (err 1))
(define-constant not-found (err 2))

;; Storage
;; -------
;; project-map
;; params: 
;;     base-url - url from where to read project meta data
;;     mint-fee - fee 
(define-map project-map
  ((project-id principal))
  ((base-url (buff 40)) (mint-fee uint)))

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

(define-read-only (get-project (projectId principal))
  (match (map-get? project-map {project-id: projectId})
    myProject (ok myProject) (err not-found)  
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