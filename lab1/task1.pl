% Пункт 3
my_length([], 0).

my_length([_|Tail], Length) :-
    my_length(Tail, TailLength),
    Length is TailLength + 1.

my_append([], L, L).
my_append([H|T], L2, [H|L3]) :-
    my_append(T, L2, L3).

my_member(X, L) :- my_append(_, [X|_], L).

my_remove(X, [X|T], T).
my_remove(X, [Y|L1], [Y|L2]) :- my_remove(X, L1, L2).

my_permute([],[]).
my_permute(L,[X|T]) :-
    my_remove(X, L, R), my_permute(R, T).

my_sublist(S, L) :-
    my_append(_, L1, L), my_append(S, _, L1).

% Пункт 4
% Насколько я понял, нужно взять свой номер в списке группы и подставить в формулу.
% Тогда мой вариант (12 % 19) + 1 = 13
% "Нахождение элемента списка, следующего за данным"

% X - данный элемент
% L - список
% Y - следующий элемент после данного
next_1(X, L, Y) :- my_append(_, L1, L), my_append([X, Y], _, L1).

next_2(X, [X, Y|_], Y).
next_2(X, [_|L], Y) :- next_1(X, L, Y).

% Пункт 5
% Мой вариант: (12 + 5) % 20 + 1 = 18
% "Разделение списка на два по принципу четности элементов"

even(X) :- X mod 2 =:= 0.

% L - исходный список
% E - чётные числа из списка
% O - нечётные числа из списка
split_by_even([], [], []).
split_by_even([X | L], [X | E], O) :- even(X), split_by_even(L, E, O).
split_by_even([X | L], E, [X | O]) :- \+ even(X), split_by_even(L, E, O).


% Пункт 6

% Найти следующий элемент с такой же чётностью, как у данного
next_same(X, L, Y) :-
    split_by_even(L, E, _),
    even(X),
    next_1(X, E, Y).

next_same(X, L, Y) :-
    split_by_even(L, _, O),
    \+ even(X),
    next_1(X, O, Y).
