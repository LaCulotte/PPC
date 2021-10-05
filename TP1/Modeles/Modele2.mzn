include "globals.mzn";

int: nbTeams;
set of int: jours = 1..nbTeams-1;
set of int: equipes = 1..nbTeams;
array[equipes, equipes] of var 1..2: pv;

array[equipes, jours] of var 1..nbTeams: tab;

/*
constraint forall(j in jours) (
  forall(e in equipes) (
    tab[j, e] = e
  )
);
*/

constraint forall(j in jours) (
  forall(e in equipes) (
    tab[tab[e, j], j] = e
  )
);

constraint forall(e in equipes) (
  alldifferent([tab[e, j] | j in jours])
);

constraint forall(j in jours) (
  alldifferent([tab[e, j] | e in equipes])
);

constraint forall(j in jours) (
  forall(e in equipes) (
    tab[e, j] != e
  )
);

array[equipes, jours] of var 0..1 : totalCosts; 

constraint forall(e in equipes) (
  forall(j in 2..nbTeams-3) (
    (pv[e, tab[e, j]] != pv[e, tab[e, j-1]] \/ pv[e, tab[e, j]] != pv[e, tab[e, j+1]] \/ pv[e, tab[e, j]] != pv[e, tab[e, j+2]]) /\
    (if pv[e, tab[e, j+1]] == 2 /\ pv[e, tab[e, j]] == 1 /\ pv[e, tab[e, j-1]] == 2 then totalCosts[e, j] = 1 else totalCosts[e, j] = 0 endif)
/*   /\ (if j == 2 then (if pv[e, tab[e, 1]] == 1 /\ pv[e, tab[e, 2]] == 2 then totalCosts[e, 1] = 1 else totalCosts[e, 1] = 0 endif) 
    elseif j == nbTeams - 2 then (if pv[e, tab[e, nbTeams-2]] == 2 /\ pv[e, tab[e, nbTeams-1]] == 1 then totalCosts[e, nbTeams-1] = 1 else totalCosts[e, nbTeams-1] = 0 endif) else endif)*/
  )
);


constraint forall(e in equipes) (
  (if pv[e, tab[e, 1]] == 1 /\ pv[e, tab[e, 2]] == 2 then totalCosts[e, 1] = 1 else totalCosts[e, 1] = 0 endif) /\
  (if pv[e, tab[e, nbTeams-3]] == 2 /\ pv[e, tab[e, nbTeams-2]] == 1 /\ pv[e, tab[e, nbTeams-1]] == 2 then totalCosts[e, nbTeams-2] = 1 else totalCosts[e, nbTeams-2] = 0 endif) /\
  (if pv[e, tab[e, nbTeams-2]] == 2 /\ pv[e, tab[e, nbTeams-1]] == 1 then totalCosts[e, nbTeams-1] = 1 else totalCosts[e, nbTeams-1] = 0 endif)
);




%Cout 
/*
set of int: SHIFT= 1..2;
set of int: STATES= 1..4;
array[STATES, SHIFT] of int: t = 
[|2, 4
 |4, 3,
 |3, 4,
 |2, 4|];

set of int: F= 1..4;
*/

solve minimize sum(e in equipes, j in jours)(totalCosts[e, j]);
%solve satisfy;

output [ if fix(pv[e, tab[e, j]]) == 2 then " @" else "  " endif ++ show(tab[e,j]) ++ if j == nbTeams-1 then "\n" else "" endif | e in equipes, j in jours];
output [show(totalCosts), "\n"];
output [show(sum(e in equipes, j in jours)(totalCosts[e, j]))];
