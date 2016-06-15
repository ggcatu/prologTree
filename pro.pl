len([X], 1).
len([_|Y], S) :- len(Y,R), S is R+1.	

sumlist([], 0).
sumlist([X | Y], R) :- sumlist(Y, P), R is X + P. 



esqueleto(1, 0, esq([[1], [0]])).
esqueleto(N, R,esq(X)) :- N1 is N-1, esqueleto(N1, 0, esq(Y)), append(Y,[[0]],X).

ceros(0, []).
ceros(Numero, Lista):- N1 is Numero-1, ceros(N1, L1), append([0], L1, Lista).

%agregarNivel(N, N, R, LA, SUM, L):-
%agregarNivel(Nmax, N, R, LA, SUM, L)


g(X,X) :- X > 0.
g(X,Y) :- X > 0, X1 is X-1, g(X1,Y).

lista(1, MAX, Acum) :- g(MAX, X), Acum = [X].
lista(Y , MAX, Acum) :- Y > 1, Y1 is Y-1, lista(Y1, MAX, Acum2), g(MAX,X), append([X],Acum2,Acum).

nocreciente([X]).
nocreciente([X , Y | S]) :- X >= Y, nocreciente([Y | S]),!.

listanocreciente(Tam, R, Z):- lista(Tam, R, Z), nocreciente(Z).