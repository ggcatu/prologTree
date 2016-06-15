nodo(X,Y) :- integer(X), X>0, is_list(Y).
arista(X,nodo(Y,Z)) :- integer(X), X>0, nodo(Y,Z).

len([], 0).
len([_|T], R) :- len(T, R1), R is R1+1. 

bienEtiquetado(nodo(1,[])).
bienEtiquetado(nodo(X,Y)) :- 
	aplanar(nodo(X,Y), LN,LA,N),
	sort(LN, LNO),
	sort(LA, LAO), !,
	member(1,LNO),
	member(N, LNO),
	N1 is N-1,
	member(1, LAO),
	member(N1, LAO),
	len(LNO,R1),
	len(LAO,R2),
	R1 =:= N,
	R2 =:= N1.

nivel(nodo(X, []), [], [], 0).
nivel(nodo(X, [arista(Y, nodo(P,[])) | K]), LN, LA, N):- 
		nivel(nodo(X, K), LN1, LA1, N1),
		Y is abs(P-X),
		append([P], LN1, LN),
		append([Y], LA1, LA),
		N is N1+1.
nivel(nodo(X, [arista(Y, nodo(P,R)) | K]), LN, LA, N):- 
		nivel(nodo(X, K), LN1, LA1, N1),
		Y is abs(P-X),
		aplanar(nodo(P,R), LN2, LA2, N2),
		append(LN1, LN2, LN),
		N is N1+N2,
		append([Y |LA2], LA1, LA).

aplanar(nodo(X, []), [], [], 0).
aplanar(nodo(X, [arista(Y, J) | K]), LN, LA, N):- 
		nivel(nodo(X, [arista(Y, J) | K]), LN1, LA1, N1),
		aplanar(J, LN2, LA2, N2),
		append(LN1, [X | LN2], LN),
		append(LA1, LA2, LA),
		N is N1+1.


esq([Y, X | S]) :- sumlist(Y, R), len(X,P), R =:= P, esq([X | S]).
esq([X]) :- sumlist(X, R), R =:= 0.

g(X,X) :- X >= 0.
g(X,Y) :- X >= 0, X1 is X-1, g(X1,Y).

ceros(0, []).
ceros(Numero, Lista):- Numero >= 1, N1 is Numero-1, ceros(N1, L1), append([0], L1, Lista).

lista(1, MAX, Acum) :- g(MAX, X), Acum = [X].
lista(Y , MAX, Acum) :- Y > 1, Y1 is Y-1, lista(Y1, MAX, Acum2), g(MAX,X), append([X],Acum2,Acum).

nocreciente([X]).
nocreciente([X , Y | S]) :- X >= Y, nocreciente([Y | S]),!.

listanocreciente(Tam, R, Z):- lista(Tam, R, Z), nocreciente(Z).

empezar(N,R,ListaF):- lista(1, R, Lista), sumlist(Lista,Suma), Suma =< N, K is N-Suma-1, continuar(K, R, Suma, Lista3), append([Lista], Lista3, ListaF).

continuar(N,R,Suma,ListaF) :- lista(Suma,R,Lista), nocreciente(Lista), sumlist(Lista, Suma1), Suma1 < N, K is N - Suma1, continuar(K, R, Suma1, ListaRet), append([Lista], ListaRet, ListaF).
continuar(N,R,Suma,ListaF) :- lista(Suma,R,Lista), nocreciente(Lista), sumlist(Lista, Suma1), Suma1 =:= N, ceros(Suma1, ListaCero), append([Lista], [ListaCero], ListaF).