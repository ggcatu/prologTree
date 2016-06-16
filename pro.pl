/* 
	Definiciones de nodo y arista 
*/
nodo(X,Y) :- integer(X), X>0, is_list(Y).
arista(X,nodo(Y,Z)) :- integer(X), X>0, nodo(Y,Z).

/* 
	Funcion que calcula el tamaño de una lista
*/
len([], 0).
len([_|T], R) :- len(T, R1), R is R1+1. 

/* 
	Ejercicio 1)
	Bien etiquetado, verifica que un arbol este bien etiquetado
*/
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

aplanar([ [F | S] , Y | R], MAX, nodo(RN,P)):-
	F>0, go(MAX, RN),
	topLink2(RN, MAX, Y, F, P).

/* 
	Funcion que calcula la suma de una lista de enteros 
	R, es el resultado de la suma.
*/
sumlist([], 0).
sumlist([X | Y], R) :- sumlist(Y, P), R is X + P. 

/* 
	Genera una lista de ceros, de tamanio Numero
*/
ceros(0, []).
ceros(Numero, Lista):- Numero >= 1, N1 is Numero-1, ceros(N1, L1), append([0], L1, Lista).

/*
	Genera los numeros de X a 0
*/
g(X,X) :- X >= 0.
g(X,Y) :- X >= 0, X1 is X-1, g(X1,Y).

/*
	Genera los numeros de X a 1
*/
go(X,X) :- X > 0.
go(X,Y) :- X > 0,  X1 is X-1, go(X1,Y).

/*
	Regresa la cabeza de una lista
*/
head([], []).
head([X |_], X).

/*
	Genera todas las listas de tamanio Y, cuyo valor maximo es MAX
*/
lista(1, MAX, X, Acum) :- 
	g(MAX, X), 
	Acum = [X].

lista(Y , MAX, Sum, Acum) :- 
	Y > 1, 
	Y1 is Y-1, 
	lista(Y1, MAX, Sum1, Acum2), 
	g(MAX,X), 
	append([X],Acum2,Acum),
	head(Acum2, R),
	X >= R,
	Sum is Sum1 + X
	.

/*
	Verifica que una lista sea no creciente
*/
nocreciente([X]).
nocreciente([X , Y | S]) :- X >= Y, nocreciente([Y | S]),!.

/*
	Definicion de esq
*/
esq([Y, X | S]) :- sumlist(Y, R), len(X,P), R =:= P, esq([X | S]).
esq([X]) :- sumlist(X, R), R =:= 0.

/*
	Ejercicio 2)
	Genera todos los esqueletos N,R
*/
esqueleto(N,R, esq(ListaF)) :- empezar(N,R,ListaF).

/*
	Genera la raiz
*/
empezar(N,R,ListaF):-
	go(R, Raiz), 
	Raiz =< R, 
	K is N-Raiz-1, 
	continuar(K, R, Raiz, Lista3), 
	append([[Raiz]], Lista3, ListaF).

/* 
	Genera los hijos para la raiz
*/
continuar(0,R,Suma,[Res]):- ceros(Suma, Res).
continuar(N,R,Suma,ListaF) :-
		N > 0, 
		lista(Suma,R, Suma1,Lista), 
		Suma1 =< N, 
		K is N - Suma1, 
		continuar(K, R, Suma1, ListaRet), 
		append([Lista], ListaRet, ListaF).

/* 
	Calcula la suma de un esqueleto 
*/
sumarEsq(esq(X),R):- sumarAux(X,R).
sumarAux([], 0).
sumarAux([X | Y], R) :- len(X, Suma), sumarAux(Y, R1), R is Suma+R1. 

/*
	Regresa los primeros Num elementos de una lista
*/
take(0, Full, []).
take(Num, [S | Full], Take):- N1 is Num-1, take(N1, Full, Take1), append([S], Take1, Take), !.

/*
	Regresa los elementos despues de los primeros Num elementos.
*/
rest(0, Full, Full).
rest(Num, [_ | Full], Res):- N1 is Num-1, rest(N1, Full, Res), !.

/*
	Magia negra
*/
topLink2(Nodo, Max, Hijos, 0, []).
topLink2(Nodo, MAX, Hijos, F, Res):- F > 0, bajar2(Nodo, MAX, Hijos, F, Res).

/* 
		
*/
etiquetamiento(esq([[X] | S]), nodo(Num,P)) :- 
	sumarEsq(esq([[X] | S]), MAX), 
	go(MAX, Num),
	topLink2(Num, MAX, S, X, P),
	bienEtiquetado(nodo(Num,P)).

bajar2(Nodo, MAX, [[Y | K], R | S], 1, Res):- 
	go(MAX, No), 
	Ar is abs(Nodo - No), 
	(Ar =:= 0 -> fail; true),
	topLink2(No, MAX, [R | S], Y, Bottom), 
	Res = [arista(Ar, nodo(No, Bottom))].

bajar2(Nodo, MAX, [[0 | R]], 1, Res):-
	go(MAX, No), 
	Ar is abs(Nodo - No),
	(Ar =:= 0 -> fail; true),
	Res = [arista(Ar, nodo(No, []))].

bajar2(Nodo, MAX, [[0 | R]], Veces, Res):-
	Veces > 1,
	go(MAX, No), 
	Ar is abs(Nodo - No),
	(Ar =:= 0 -> fail; true),
	Res1 = [arista(Ar, nodo(No, []))],
	N1 is Veces-1,
	bajar2(Nodo, MAX, [R], N1,  Resp),
	append(Resp,Res1, Res).

bajar2(Nodo, MAX, [[Y | K], R | S], Veces , Res):- 
	Veces > 1,
	go(MAX, No), Ar is abs(Nodo - No),
	(Ar =:= 0 -> fail; true),
	rest(Y, R, Resto),
	topLink2(No, MAX, [R | S], Y, Bottom), 
	Res1 = [arista(Ar, nodo(No, Bottom))],
	N1 is Veces - 1, 
	bajar2(Nodo, MAX, [K, Resto | S], N1, Res2), 
	append(Res1,Res2, Res).

