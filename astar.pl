arc([[H|T],Prede,Cost1], [Node,[[H|T]|Prede],Cost2], KB) :-
    member([H|B], KB),
    append(B, T, Node),
    length(B, L),
    Cost2 is Cost1 + 1 + L / (L + 1).

heuristic(Node, H) :-
    length(Node, H).

goal([]).

less_than([Node1,_, Cost1], [Node2,_, Cost2]) :-
    heuristic(Node1, Hvalue1),
    heuristic(Node2, Hvalue2),
    F1 is Cost1 + Hvalue1,
    F2 is Cost2 + Hvalue2,
    F1 =< F2.

add2frontier([], Frontier, Frontier).
add2frontier([Head|X],Restof,New) :- insert(Head,Restof,Result),
									add2frontier(X,Result,New).

empty([_|_]).

inverse([], []).
inverse([Head|Tail], Reversed) :-
    inverse(Tail, ReversedTail),
    append(ReversedTail, [Head], Reversed).



insert(X,[Y|T],[Y|NT]):- less_than(Y,X),insert(X,T,NT),!.
insert(X,[Y|T],[X,Y|T]):- less_than(X,Y),!.
insert(X,[],[X]).

search([[Node,Prede,Cost]|More],KB) :- goal(Node),write('Cost: '), write(Cost), nl,
    write('Path: '),inverse([Node|Prede],Path), write(Path), nl,empty(More),search(More,KB).

search([[Node,Prede,Cost] | More],KB) :-
empty(Node),
    findall(X, arc([Node,Prede,Cost], X, KB), Children),
    add2frontier(Children, More, New),
    search(New,KB).

astar(Node, Path, Cost, KB) :-
    search([[Node,[],0]|[]], KB).


