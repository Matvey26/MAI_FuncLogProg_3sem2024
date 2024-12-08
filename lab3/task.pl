% Генерация новых состояний
move([X, e | Rest], [e, X | Rest]) :- X \= e.
move([e, X | Rest], [X, e | Rest]) :- X \= e.
move([X, Y, e | Rest], [e, Y, X | Rest]) :- X \= e, Y \= e.
move([e, Y, X | Rest], [X, Y, e | Rest]) :- X \= e, Y \= e.
move([H | T1], [H | T2]) :- move(T1, T2).

% Целевое состояние
% goal([b, b, b, e, w, w, w]).

% Можно использовать такой запрос: solve_bfs([w, e, b], Solution).
% И такое целевое состояние, чтобы решение искалось быстрее
goal([b, e, w]).


% +--------------------- BFS алгоритм ---------------------+
% | Берём текущее состояние и путь к нему, генерируем все  |
% | возможные состояния, которые не встречались в пути     |
% | и добавляем их в конец очереди. Короче говоря имеем    |
% | дело с традиционным обходом дерева состояний в ширину. |

bfs([[State | Path] | _], [State | Path]) :-
    goal(State).


bfs([[State | Path] | RestQueue], Solution) :-
    findall([NewState, State | Path],
            (move(State, NewState), \+ member(NewState, [State | Path])),
            NewStates),
    append(RestQueue, NewStates, NewQueue),
    bfs(NewQueue, Solution).

% Запуск BFS
solve_bfs(Start, Solution) :-
    bfs([[Start]], Solution).

% +---------------------- конец BFSа ----------------------+






% +--------------------- DFS алгоритм ---------------------+
% | Берём текущее состояние и путь к нему, генерируем все  |
% | возможные состояния, которые не встречались в пути и   |
% | запускаем DFS от нового состояния. Таким образом пролог|
% | найдёт сначала одно решение, потом вернётся и пойдёт   |
% | искать другое решение, потом снова вернётся и т.д.     |

dfs([State | Path], [State | Path]) :-
    goal(State).

dfs([State | Path], Solution) :-
    move(State, NewState),
    \+ member(NewState, Path),
    dfs([NewState, State | Path], Solution).

solve_dfs(Start, Solution) :-
    dfs([Start], Solution).

% +---------------------- конец DFSа ----------------------+

