quickSort([],[]).  %더이상 정렬할 수 없으면 종료
quickSort([Head|Tail],Sorted) :- 
  partition(Head, Tail, List1, List2), 
  devide(Head,Tail,List1,List2),
  quickSort(List1, SortedList1), 
  quickSort(List2, SortedList2),
  merge(SortedList1,SortedList2,Head),
  append(SortedList1, [Head|SortedList2],Sorted).
quickSort([Head|Tail]):-
  quickSort([Head|Tail],Sorted),
  write(Sorted),nl.

devide(_,_,[],[]).
devide(Head,_,List1,List2) :-
  write('devide= '),write(Head),write('|'),write(List1),write(List2),nl.

merge([],[],Head) :-
  write('merge: '),write('['),write(Head),write(']'),nl. 
merge(SortedList1,SortedList2,Head) :-
  write('merge: '),write(SortedList1),write('['),write(Head),write(']'),write(SortedList2),nl. 

partition(_, [], [], []). 
partition(Pivot, [Head|Tail], [Head|LessOrEqualThan], GreaterThan) :- 
  Pivot >= Head, 
  partition(Pivot, Tail, LessOrEqualThan, GreaterThan). 
partition(Pivot, [Head|Tail], LessOrEqualThan, [Head|GreaterThan]) :- 
  Pivot < Head,
  partition(Pivot, Tail, LessOrEqualThan, GreaterThan).


