nodo(X,Y) :- integer(X), X > 0, is_list(Y).
arista(X,nodo(Y,Z)) :- integer(X), X > 0, nodo(Y,Z).

len([], 0).

len([_|XS], S) :-
	len(XS, S1),
	S is S1+1.

describirEtiquetamiento(nodo(X, [])) :-
	write('\n(0)  '),
	write(X),
	write('\n'), !.
describirEtiquetamiento(nodo(X, [arista(Y, nodo(Z, W)) | V])) :-
	S = [0],
	write('\n(0)  '),
	write(X),
	write('\n'),
	imprimirArbol(nodo(X, [arista(Y, nodo(Z, W)) | V]), S, 0).

imprimirArbol(nodo(_,[]),_,_).
imprimirArbol(nodo(X, [arista(Y, nodo(Z, W)) | V]), S, T) :-
	append(S,[T],L),
	write('('),
	imprimirIndice(L),
	write('   '),
	write(Z),
	write('   con arista   '),
	write(Y),
	write('   a   ('),
	imprimirIndice(S),
	write('\n'),
	T1 is T+1,
	imprimirArbol(nodo(Z,W),L,0),
	imprimirArbol(nodo(X,V),S,T1), !.

imprimirIndice([X]) :-
	write(X),
	write(')').
imprimirIndice([X | XS]) :-
	write(X),
	write('.'),
	imprimirIndice(XS), !.
