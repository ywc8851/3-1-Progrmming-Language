hanoi(N) :- move(N,1,2,3).   
move(0,_,_,_) :-!.
move(N,A,B,C) :- 
  M is N-1,
  move(M,A,C,B),  
  write(N),
  printf(A,B),    
  move(M,C,B,A).  
printf(X,Y) :-
  write('->'),
  write([X,Y]),nl.    %move x to y 