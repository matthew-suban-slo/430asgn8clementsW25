;; ExprC
; omg
(fn NumC [n] {:type "NumC" :n n})
(fn IdC [s] {:type "IdC" :s s})
(fn IfC [test then else] {:type "IfC" :test test :then then :else else})
(fn AppC [fun arg] {:type "AppC" :fun fun :arg arg})
(fn LamC [params body] {:type "LamC" :params params :body body})
(fn StringC [s] {:type "StringC" :s s})
(fn PrintC [expr] {:type "PrintC" :expr expr})
(fn ReadNumC [] {:type "ReadNumC"})
(fn ReadStringC [] {:type "ReadStringC"})
(fn SeqC [exprs] {:type "SeqC" :exprs exprs})
(fn RandomC [exprs] {:type "RandomC" :exprs exprs})

;; Value
(fn NumV [n] {:type "NumV" :n n})
(fn CloV [params body env] {:type "CloV" :params params :body body :env env})
(fn BooleanV [bool] {:type "BooleanV" :bool :bool})

;; Implement primop-add
(fn primop-add [vals]
  (var sum 0)
  (each [_ v (ipairs vals)]
    (if (= v.type "NumV")
        (set sum (+ sum v.n))
        (error "FENL5 args not NumV")))
  (NumV sum))

;; Simple test to ensure it runs, if print 6 then pass, big W
(local result (primop-add [(NumV 1) (NumV 2) (NumV 3)]))
(print result.n)

; interp function
(fn interp [expr]
  (match expr
    {:type "NumC" :n n} n
    {:type "IdC" :s s} s
    {:type "StringC" :s s} s
    {:type "BooleanV" :bool b} b
    {:type "IfC" :test test :then then :else else} (if (interp test) (interp then) (interp else))
    {:type "PrintC" :expr print-expr} (print (interp print-expr))
    other (error "Unsupported expression type")))

; testing printing
(print (interp (PrintC (StringC "StringC test passed!"))))

; yeah
(fn test-cases []  
  (assert (= (interp {:type "NumC" :n 100}) 100) "Test NumC failed")
  (assert (= (interp {:type "IdC" :s "a"}) "a") "Test IdC failed")
  (assert (= (interp {:type "StringC" :s "hello"}) "hello") "Test StringC failed")
  (assert (= (interp {:type "IfC" 
                      :test {:type "NumC" :n 1}
                      :then {:type "IdC" :s "t"}
                      :else {:type "IdC" :s "f"}}) "t") "Test IfC failed")

  (assert (= (interp {:type "IfC" 
                      :test {:type "BooleanV" :bool false}
                      :then {:type "IdC" :s "t"}
                      :else {:type "IdC" :s "f"}}) "f") "Test IfC failed")
  ; YAY
  (print "All typing tests passed!"))

(test-cases)