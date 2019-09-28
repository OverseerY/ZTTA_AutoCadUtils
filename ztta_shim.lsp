; ########################################################################
; ############# Before use set <PEDITACCESS 1> in AutoCad ################
; ########################################################################

(defun c:shimdraw ()  
  (setq p1 (getpoint "\nSet start point : "))		; initial point
  (setq d1 (getdist "\nSet outer diameter : "))	 	; diameter of arc	
  (setq d2 (getdist "\nSet internal diameter : "))	; diameter of hole	
  (setq total (getint "\nSet amount : "))	 		; number of shims	
  (setq rows (getint "\nSet num of rows : "))		; number of rows
  
  
  (setq cntr 1)
  (while (<= cntr rows)
  	; draw first sine-similar wave made up of arcs
    (setq count 1)
    (while (<= count total)
      (setq p2 (list (+ (car p1) d1) (cadr p1)))
	  (if (= (rem count 2) 0)
	    (command "_ARC" p1 "_E" p2 "_A" -180)
	    (command "_ARC" p1 "_E" p2 "_A" 180)
	  )
	  (setq p1 p2)
	  (setq count (1+ count))
    )
  
    ; select and join all non-polyline elements (here: arcs) to polyline
	(setq arcs1 (ssget "_X" '((0 . "~LWPOLYLINE"))))
    (command "_.pedit" "_multiple" arcs1 "" "_join" "0.0" "")
  
    ; draw second sine-similar wave made up of arcs
    (setq count 1)
    (while (<= count total)
      (setq p2 (list (- (car p1) d1) (cadr p1)))
	  (if (= (rem total 2) 0)
	    (progn
	      (if (= (rem count 2) 0)
	        (command "_ARC" p1 "_E" p2 "_A" 180)
	        (command "_ARC" p1 "_E" p2 "_A" -180)
	      )
	    )
	    (progn
	      (if (= (rem count 2) 0)
	        (command "_ARC" p1 "_E" p2 "_A" -180)
	        (command "_ARC" p1 "_E" p2 "_A" 180)
	      )
	    )
	  )
	  (setq p1 p2)
	  (setq count (1+ count))
    )
  
    ; select and join all non-polyline elements (here: arcs) to polyline
    ; again, for different polyline
    (setq arcs1 (ssget "_X" '((0 . "~LWPOLYLINE"))))
    (command "_.pedit" "_multiple" arcs1 "" "_join" "0.0" "")
	
	; draw holes
	(setq p1 (list (+ (car p1) (/ d1 2)) (cadr p1)))
    (setq count 0)
    (while (< count total)
      (command "_circle" p1 "_D" d2)
	  (setq p1 (list (+ (car p1) d1) (cadr p1)))
      (setq count (1+ count))
    )
	
	; add shift for even rows
	(setq p1 (list (- (- (car p1) (* d1 total)) (/ d1 2)) (- (cadr p1) d1)))
	(if (> (rem cntr 2) 0)
	  (setq p1 (list (+ (car p1) (/ d1 2)) (cadr p1)))
	  (setq p1 (list (- (car p1) (/ d1 2)) (cadr p1)))
	)
	
	(setq cntr (1+ cntr))
  )
) ; end_defun