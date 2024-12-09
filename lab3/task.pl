% Генерация новых состояний
move([X, e | Rest], [e, X | Rest]) :- X \= e.
move([e, X | Rest], [X, e | Rest]) :- X \= e.
move([X, Y, e | Rest], [e, Y, X | Rest]) :- X \= e, Y \= e.
move([e, Y, X | Rest], [X, Y, e | Rest]) :- X \= e, Y \= e.
move([H | T1], [H | T2]) :- move(T1, T2).

% Целевое состояние
goal([b, b, b, e, w, w, w]).

% Можно использовать такой запрос: solve_bfs([w, e, b], Solution).
% И такое целевое состояние, чтобы решение искалось быстрее
% goal([b, e, w]).


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





% +------------------ Поиск с итеративным углублением ------------------+
% | Алгоритм последовательно увеличивает максимальную глубину поиска,   |
% | начиная с 1. Для каждой глубины запускается ограниченный DFS,       |
% | который проверяет, достигнута ли цель, углубляясь до установленной  |
% | глубины. Если цель не найдена, глубина увеличивается на 1, и поиск  |
% | продолжается с новой глубиной. Это гарантирует нахождения кратчай-  |
% | шего пути имеет низкие требования к памяти. Пролог автоматически    |
% | перебирает значения глубины, создавая поведение, аналогичное циклу  |
% | в императивных языках.                                              |

dfs_limited([State | Path], [State | Path], _, _) :-
    goal(State).

% Поиск в глубину с ограничением
dfs_limited([State | Path], Solution, Depth, MaxDepth) :-
    Depth < MaxDepth,                      % Проверка глубины
    move(State, NewState),                 % Генерация следующего состояния
    \+ member(NewState, Path),             % Проверка на повторные состояния
    NewDepth is Depth + 1,                 % Увеличение глубины
    dfs_limited([NewState, State | Path], Solution, NewDepth, MaxDepth).

% Итеративное углубление
iddfs(Start, Solution, MaxDepth) :-
    between(1, MaxDepth, Depth),           % Последовательный перебор уровней глубины
    write(Depth), nl,
    dfs_limited([Start], Solution, 0, Depth).

solve_iddfs(Start, Solution, MaxDepth) :-
    iddfs(Start, Solution, MaxDepth).

% +--------------- Конец поиск с итеративным углублением ---------------+


