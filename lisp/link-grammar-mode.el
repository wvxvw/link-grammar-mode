(defgroup link-grammar nil
  "Configuration of link-grammar-mode"
  :prefix 'link-grammar)

(defcustom lg-text-filter-functions '(("Org" . lg-org-filter))
  "Alist of the form ((mode . function) (mode . function))
which specifies what function should be used to extract text for parsing.
This function will be called with one argument--the location of the point.
It should return a complete sentence at the given location.")

(defun lg-org-filter (loc)
  
  )

(defun lg-default-filter (loc)
  (save-excursion
    (goto-char loc)
    (thing-at-point 'sentence)))

(define-prefix-command 'lg-prefix-map)
(defalias 'link-grammar-prefix-map lg-prefix-map)

(define-key lg-prefix-map "s" 'lg-parse-sentence)
(define-key lg-prefix-map "p" 'lg-parse-paragraph)
(define-key lg-prefix-map "r" 'lg-parse-region)
(define-key lg-prefix-map "b" 'lg-parse-region)

(defun lg--select-filter ()
  (or 
   (cl-loop for (mode . filter) in lg-text-filter-functions
            when (string-equal mode mode-name) do
            (cl-return filter))
   'lg-default-filter))

(defun lg-parse-sentence (&optional sentence)
  (interactive)
  (unless sentence
    (setf sentence (funcall (lg--select-filter) (point))))
  (message "Parsing sentence '%s'" sentence))

(defun lg-parse-paragraph (&optional paragraph)
  (interactive)
  (message "Parsing paragraph"))

(defun lg-parse-region (start end)
  (interactive "r")
  (message "Parsing region"))

(defun lg-parse-buffer ()
  (interactive)
  (message "Parsing buffer")
  (save-excursion
    (goto-char (point-min))
    (cl-loop for sentence = (lg-parse-sentence)
             until (eobp)
             do (goto-char (+ (point) (max 1 (length sentence)))))))

(defvar link-grammar-hooks nil
  "Hooks to run when activating the link-grammar minor mode")
(defalias 'lg-hooks link-grammar-hooks)

(define-minor-mode link-grammar-mode
  "Enables display of the parse of the natural language text
produced by link-grammar parser library"
  :initial-value nil
  :lighter " LG"
  :keymap '(([?\C-.] . link-grammar-prefix-map))
  :group 'link-grammar
  (message "link-grammar minor mode activated"))
(defalias 'lg-mode link-grammar-mode)

(provide 'link-grammar-mode)
