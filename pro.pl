esq([Elem]).


tail([elem], elem).
tail([_|elemx], elem) :- tail(elemx, elem).