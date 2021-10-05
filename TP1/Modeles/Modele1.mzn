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

%Pas plus de 3 matchs consecutifs
set of int: SHIFT= 1..3;
set of int: STATES= 1..9;
array[STATES, SHIFT] of int: t = 
[|2, 5, 1,
 |3, 5, 9,
 |4, 5, 9,
 |8, 5, 9,
 |2, 6, 9,
 |2, 7, 9,
 |2, 8, 9,
 |8, 8, 8,
 |9, 9, 9|];
 
array[STATES, SHIFT] of int: costs = 
[|0, 0, 0,
 |0, 1, 1,
 |0, 0, 0,
 |0, 0, 0,
 |0, 0, 0,
 |0, 0, 0,
 |0, 0, 0,
 |0, 0, 0,
 |0, 0, 0|];

set of int: F= 9..9;

array[equipes] of var int: totalCosts;

constraint forall(e in equipes) (
  cost_regular([pv[e,tab[e,j]] | j in jours] ++ [3], 9, 3, t, 1, F, costs, totalCosts[e]) 
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

solve minimize sum(e in equipes)(totalCosts[e]);

output [ if fix(pv[e, tab[e, j]]) == 2 then " @" else "  " endif ++ show(tab[e,j]) ++ if j == nbTeams-1 then "\n" else "" endif | e in equipes, j in jours];
output [show(totalCosts)]
