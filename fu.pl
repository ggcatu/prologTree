

agregar([], Acum, Acum).
agregar([X | S], Acum, Ret):- agregar(S, [X | Acum], Ret).

notmember(X, Lista):- not(member(X,Lista)).