len([X], 1).
len([_|Y], S) :- len(Y,R), S is R+1.	

sumlist([], 0).
sumlist([X | Y], R) :- sumlist(Y, P), R is X + P. 

esq([Y, X | S]) :- sumlist(Y, R), len(X,P), R =:= P, esq([X | S]).
esq([X]) :- sumlist(X, R), R =:= 0.

esqueleto(1, 0, esq([[1], [0]])).
esqueleto(N, R,esq(X)) :- N1 is N-1, esqueleto(N1, 0, esq(Y)), append(Y,[[0]],X).

ceros(0, []).
ceros(Numero, Lista):- N1 is Numero-1, ceros(N1, L1), append([0], L1, Lista).

%agregarNivel(N, N, R, LA, SUM, L):-
%agregarNivel(Nmax, N, R, LA, SUM, L)