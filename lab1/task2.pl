:- ['one.pl'].

% Вариант представления: (12 % 4) + 1 = 1
% Вариант задания: (12 % 3) + 1 = 1


% -----------------------------------------------------------
% 1) Получить таблицу групп и средний балл по каждой из групп
% -----------------------------------------------------------

% Средний балл для списка оценок
average_grade(Grades, Avg) :-
    sum_list(Grades, Sum),
    length(Grades, Count),
    Count > 0, % проверяем, что есть хотя бы одна оценка
    Avg is Sum / Count.

% --- Средний балл по группе ---
group_average(Group, Avg) :-
    bagof(Grade, Student^Object^(student(Group, Student), grade(Student, Object, Grade)), Grades),
    average_grade(Grades, Avg).

get_group_average_table(Table) :-
    bagof((Group, Avg), group_average(Group, Avg), Table).

% --- Получение таблицы групп и среднего балла ---
% ?- group_average(Group, Avg).



% -------------------------------------------------------------------------------
% 2) Для каждого предмета получить список студентов, не сдавших экзамен (grade=2)
% -------------------------------------------------------------------------------

% --- Найти всех студентов, которые не сдали предмет (оценка 2) ---
failed_students_for_subject(Subject, FailedStudents) :-
    setof(Student, grade(Student, Subject, 2), FailedStudents).

get_failed_students_for_subject_table(Table) :-
    bagof((Subject, Students), failed_students_for_subject(Subject, Students), Table).

% --- Получение таблицы всех предметов и списков не сдавших студентов ---
% ?- failed_students_for_subject(Subject, FailedStudents).




% ----------------------------------------------------------
% 3) Найти количество не сдавших студентов в каждой из групп
% ----------------------------------------------------------

% Вспомогательный предикат: проверяет, завалил ли студент хотя бы один предмет
failed(Student) :-
    grade(Student, _, 2).  % Студент завалил предмет, если хотя бы по одному предмету оценка 2

% Основной предикат: считает количество студентов, заваливших экзамен, для каждой группы
count_failed_students_for_group(Group, Count) :-
    % Сначала собираем всех студентов в группе, у которых есть оценка 2
    setof(Student, (student(Group, Student), failed(Student)), FailedStudents),
    % Считаем длину списка, то есть количество студентов, заваливших хотя бы один экзамен в группе
    length(FailedStudents, Count).

get_count_failed_students_for_group_table(Table) :-
    bagof((Group, Count), count_failed_students_for_group(Group, Count), Table).

% --- Получение таблицы групп и количества несдавших студентов них ---
% ?- count_failed_students_for_group(Group, Count)