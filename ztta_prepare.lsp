; ######################################################
; #### Move all entities in other layers to layer 0 ####
; ## Delete all layers except layer 0, create layer 1 ##
; ######################################################
(defun c:mergelayers ()
  ; set current layer 0
  (setvar "CLAYER" "0")
  ; change layer of each entity to "0"
  (setq en (entnext))
  (while en
    (setq el (entget en))
    (setq el (subst (cons 8 "0") (assoc 8 el) el))
    (entmod el)
    (setq en (entnext en))
  )
  ; delete all layers except 0
  (command "_-PURGE" "_LA" "*" "_N")
  ; create layer 1, by default change to current
  (command "._-LAYER" "_M" "1" "")
  ; set back current layer 0
  (setvar "CLAYER" "0")
)