(local ExprC {})

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

(fn interp [expr]
  (match expr
    {:type "NumC" :n n} n
    {:type "IdC" :s s} s
    {:type "StringC" :s s} s
    {:type "ifC" :test test :then then :else else} (if (interp test) (interp then) (interp else))
    {:type "PrintC" :expr print-expr} (print (interp print-expr))
    other (error "Unsupported expression type")))

(print (interp (NumC 100)))
(print (interp (IdC "a")))
(print (interp (PrintC (StringC "hello"))))
(print (interp (StringC "hello")))