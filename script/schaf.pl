

start([ziege, kohl, wolf], []).
ziel([], [ziege, kohl, wolf]).

seite(links).
seite(rechts).

nomnom(ziege, kohl).
nomnom(wolf, ziege).
nomnom(A, B):- nomnom(B, A).



change(A, B):-
  member(Tier, A),
  member(Other, A),
  not(nomnom(Tier,Other)).
  change(B, A).

change(A, B):-
  member(Tier, A),
  member(Other, A),
  not(nomnom(Tier,Other)).
  change(B, A).

change([], B, _, _):- 
  permutation(B, X),
  X == [ziege, kohl, wolf].

  