nodo(X,Y) :- integer(X), X>0, is_list(Y).
arista(X,nodo(Y,Z)) :- integer(X), X>0, nodo(Y,Z).

bienEtiquetado(nodo(X,[arista(Y,nodo(Z,P)) | J])) :- 
	bienEtiquetado(nodo(X,J)),
	bienEtiquetado(nodo(Z,P)),
	ordenado([arista(Y,nodo(Z,P)) | J] , R1),
	R1 == X,
	R is abs(X - Z),
	Y == R, !.

bienEtiquetado(nodo(X,[])) :- nodo(X,[]).


sumado(nodo(X, [])).
sumado(nodo(X,[arista(Y,nodo(Z,P)) | J]) :-
	R is abs(X-Z),
	Y == R,
	sumado(nodo(X,J)).

ordenado([arista(X,Y)], R) :- R is X.
ordenado([arista(Y,Z) | J], R) :- ordenado(J,R1), R is R1-1, Y == R, !.





len([], 0).
len([_|T], R) :- len(T, R1), R is R1+1. 