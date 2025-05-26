:- consult(publicKB).

%Part_A	
university_schedule(S):-
	var(S), universityScheduleHelper1(S);
	nonvar(S) , universityScheduleHelper2(S).
universityScheduleHelper1(S) :- 
	findAllStudents(L),
	allSched(L,[],S1),
	permutation(S1,S).
universityScheduleHelper2(S) :- 
	allDiffStudents(S),
	findAllStudents(Students),
	length(Students,L),
	length(S,L),
	checkValid(S).

checkValid([]).
checkValid([H|T]):-
	H=sched(StudentID,Slots),
	student_schedule(StudentID,Slots),
	checkValid(T).

allSched([],S,S).
allSched([Student|T] , Acc , S):-
	student_schedule(Student, Slots),
	append(Acc,[sched(Student,Slots)],NewAcc),
	allSched(T,NewAcc,S).
	
findAllStudents(L):-
	findall(S,studies(S,_),LAll),
	removeDuplicates(LAll,L).
removeDuplicates([],[]).
removeDuplicates([S|T],L):-
	member(S,T),!,
	removeDuplicates(T,L).
removeDuplicates([S|T] ,[S|L]):-
	removeDuplicates(T,L).
allDiffStudents([]).
allDiffStudents([H|T]):-
	H = sched(StudentID,_),
	\+member(H,T),
	allDiffStudents(T).
 
%Part_B	
student_schedule(StudentID,Slots):-
	var(Slots), studentScheduleHelper1(StudentID , Slots);
	nonvar(Slots) , studentScheduleHelper2(StudentID , RandomSlots),permutation(Slots,RandomSlots).

studentScheduleHelper1(StudentID , Slots):-
	studies(StudentID,_),
	findAllSubjects(StudentID,Subjects),
	getOneSlotPerSubject(Subjects,[],S),
	no_clashes(S),
	study_days(S,5),
	permutation(S,Slots).

studentScheduleHelper2(StudentID , Slots):-
	studies(StudentID, _),
	findAllSubjects(StudentID,Subjects),
	getOneSlotPerSubject(Subjects,[],Slots),
	no_clashes(Slots),
	study_days(Slots,5).

getOneSlotPerSubject([],S,S).
getOneSlotPerSubject([H|T],Acc,S):-
	getAllSlotsPerSubject(H,Slots),
	member(Slot,Slots),
	NewAcc = [Slot|Acc],
	getOneSlotPerSubject(T,NewAcc,S).
	
findAllSubjects(StudentID,Subjects):-
	findall(Subject , studies(StudentID,Subject) , S),
	removeDuplicates(S,Subjects).

getAllSlotsPerSubject(Subject,Slots):-
	findall(slot(Day,N,Subject) , getSlot(Day,N,Subject) , Slots).
	
getSlot(Day,N,Course):-
	day_schedule(Day,L),
	nth1(N,L,S),
	member(Course,S).
	
%Part_C
no_clashes(Slots) :- remove_duplicate_slots(Slots, Unique),
					length(Slots, L1),
					length(Unique, L2),
					L1 == L2.
					
remove_duplicate_slots(List, Unique) :-
										remove_dup_slots_acc(List, [], RevUnique),
										reverse(RevUnique, Unique).

remove_dup_slots_acc([], Acc, Acc).
remove_dup_slots_acc([slot(Days, Num, _)|T], Acc, Unique) :-
															member(slot(Days, Num, _), Acc),
															!,
															remove_dup_slots_acc(T, Acc, Unique).
remove_dup_slots_acc([H|T], Acc, Unique) :- remove_dup_slots_acc(T, [H|Acc], Unique).
 
%Part_D
study_days(Slots, DayCount):-
	daysCountHelper(Slots,[],Count),
	Count=<DayCount.
daysCountHelper([],Acc,DayCount):-
	length(Acc,DayCount).
daysCountHelper([slot(Day,_,_)|T] , Acc , DayCount):-
	member(slot(Day,_,_),Acc),!,
	daysCountHelper(T,Acc,DayCount).
daysCountHelper([H|T] , Acc , DayCount):-
	daysCountHelper(T,[H|Acc],DayCount).	
	
%Part_E						
assembly_hours(Schedules, AH) :- common_days(Schedules, CommonDays),
								 findall(FreeSlot, 
									(   member(Day, CommonDays),
										occupied_slots(Schedules, Day, Occupied),
										free_slots(Occupied, FreeSlots),
										member(SlotNumber, FreeSlots),
										FreeSlot = slot(Day, SlotNumber)
									), AH).
								
student_days(sched(_, Slots), Days) :- findall(Day, member(slot(Day, _, _), Slots), Days).

common_days([], []).
common_days([Sched], Days) :- student_days(Sched, Days).
common_days([Sched |T], CommonDays) :-  student_days(Sched, Days1),
										common_days(T, Days2),
										intersect(Days1, Days2, CommonDays1),
										sort(CommonDays1, CommonDays).

intersect([],_,[]).											
intersect([X|Y],M,[X|Z]) :- member(X,M), intersect(Y,M,Z).
intersect([X|Y],M,Z) :- \+ member(X,M), intersect(Y,M,Z).
		

occupied_slots([], _, []).
occupied_slots([sched(_, Slots) |T], Day, Occupied) :-  findall(Slot, member(slot(Day, Slot, _), Slots), SlotsToday),
														occupied_slots(T, Day, RestOccupied),
														append(SlotsToday, RestOccupied, Occupied1),
														sort(Occupied1, Occupied).
free_slots([],[]).														
free_slots(Occupied, FreeSlots) :-  numlist(1, 5, AllSlots),
									subtract(AllSlots, Occupied, FreeSlots).