studies(student_0, physics201).
studies(student_0, mech202).
studies(student_0, csen202).

studies(student_1, physics201).
studies(student_1, physics201).

studies(student_2, csen202).
studies(student_2, signals402).

studies(student_3, netw201).
studies(student_3, elct402).
studies(student_3, signals402).

day_schedule(saturday, [[math203],[physics201, csen202],[signls402, netw201],[],[]]).
day_schedule(sunday, [[math203],[chem101, mech202],[],[],[]]).
day_schedule(monday, [[math203],[physics201, csen202],[],[],[]]).
day_schedule(tuesday, [[signals402],[physics201, csen202],[],[],[]]).
day_schedule(wednesday, [[math203],[],[physics201, elct402],[],[]]).
day_schedule(thursday, [[math203],[],[],[netw201, csen202],[]]).



% e) assembly_hours/2 - Find common free slots for all students

assembly_hours(Schedules, AH) :-
    % Get all possible days and slot numbers (assuming 5 slots per day)
    member(Day, [saturday, sunday, monday, tuesday, wednesday]),
    between(1, 5, SlotNumber),
    
    % Check if this slot is free for all students
    forall(member(sched(StudentID, StudentSlots), Schedules),
           (student_free(StudentID, StudentSlots, Day, SlotNumber),
            not_students_day_off(StudentSlots, Day))),
    
    % Collect all such slots
    findall(slot(Day, SlotNumber), 
            (member(Day, [saturday, sunday, monday, tuesday, wednesday]),
             between(1, 5, SlotNumber),
             forall(member(sched(StudentID, StudentSlots), Schedules),
                    (student_free(StudentID, StudentSlots, Day, SlotNumber),
                     not_students_day_off(StudentSlots, Day)))),
            AH),
    !.

% Helper for assembly_hours: check if student is free in this slot
student_free(StudentID, StudentSlots, Day, SlotNumber) :-
    \+ member(slot(Day, SlotNumber, _), StudentSlots).

% Helper for assembly_hours: check if day is not a day off for student
not_students_day_off(StudentSlots, Day) :-
    findall(D, (member(slot(D, _, _), StudentSlots), DaysWithClasses),
    sort(DaysWithClasses, UniqueDays),
    length(UniqueDays, DayCount),
    DayCount =< 5, % Students have 2 days off (7-2=5)
    member(Day, UniqueDays).

								


