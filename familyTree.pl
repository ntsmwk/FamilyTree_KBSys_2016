%% Logic of a family tree

%%<examples>
female(lydia).
female(may).
female(magarethe).
female(alberta).
female(cleo).
female(kathy).
female(debbie).
female(martha).
female(elisabeth).
female(katharina).
female(helene).
male(albertus).
male(albert).
male(johann).
male(ralph).
male(john).
male(sean).
male(neal).
male(daniel).
male(wayne).
male(bernhard).
male(johannes).

married(albertus, lydia).
married(lydia, albertus).
married(albert, magarethe).
married(magarethe, albert).
married(johann, alberta).
married(alberta, johann).
married(ralph, cleo).
married(cleo, ralph).
married(neal, debbie).
married(debbie, neal).
married(daniel, martha).
married(martha, daniel).
inrelation(wayne, elisabeth).
inrelation(elisabeth, wayne).
inrelation(bernhard, katharina).
inrelation(katharina, bernhard).

parent(albertus, alberta).
parent(may, alberta).
parent(albertus, ralph).
parent(may, ralph).
parent(albert, cleo).
parent(magarethe, cleo).
parent(albert, john).
parent(magarethe, john).
parent(johann, sean).
parent(alberta, sean).
parent(johann, kathy).
parent(alberta, kathy).
parent(ralph, debbie).
parent(cleo, debbie).
parent(ralph, martha).
parent(cleo, martha).
parent(ralph, wayne).
parent(cleo, wayne).
parent(neal, katharina).
parent(debbie, katharina).
parent(bernhard, helene).
parent(katharina, helene).
parent(martha, johannes).
parent(daniel, johannes).

%% rules
prospectofchildren(X, Y) :-  inrelation(X, Y), not(child(Z, X)), not(child(Z, Y)).
prospectofchildren(X, Y) :-  married(X, Y),    not(child(Z, X)), not(child(Z, Y)).
prospectofmarrige(X, Y)  :-  inrelation(X, Y).

%%generation -2
grandchild(X, Z)         :-  grandparent(Z, X).
grandson(X, Z)           :-  male(X),          grandchild(X, Z).
granddaughter(X, Z)      :-  female(X),        grandchild(X, Z).
stepgrandchild(X, Y)     :-  child(Z, Y),      married(Z, W),            parent(W, X), not(parent(Z, X)).
stepgrandchild(X, Y)     :-  stepchild(Z, Y),  child(X, Z).
stepgrandson(X, Y)       :-  male(X),          stepgrandchild(X, Y).
stepgranddaughter(X, Y)  :-  female(X),        stepgrandchild(X, Y).
grandnieceornephew(X, Y) :-  parent(Z, X),     parent(W, Z),             sibling(W, Y).
grandnephew(X, Y)        :-  male(X),          grandnieceornephew(X, Y).
grandniece(X, Y)         :-  female(X),        grandnieceornephew(X, Y).

%%generation -1
child(Y, X)              :-  parent(X, Y).
stepchild(X, Y)          :-  married(Y, Z), child(X, Z), not(child(X, Y)).
son(Y, X)                :-  male(Y),       child(Y, X).
daughter(Y, X)           :-  female(Y),     child(Y, X).
childinlaw(X, Y)         :-  married(X, Z), child(Z, Y).
soninlaw(X, Y)           :-  male(X),       childinlaw(X, Y).
daughterinlaw(X, Y)      :-  female(X),     childinlaw(X, Y).
nieceornephew(X, Y)      :-  parent(Z, X),  sibling(Z, Y).
nephew(X, Y)             :-  male(X),       nieceornephew(X, Y).
niece(X, Y)              :-  female(X),     nieceornephew(X, Y).
stepnieceornephew(X, Y)  :-  parent(Z, X),  stepsibling(Z, Y).
stepnieceornephew(X, Y)  :-  parent(W, X),  married(W, Z),          sibling(Z, Y), not(parent(Z, X)).
stepnephew(X, Y)         :-  male(X),       stepnieceornephew(X, Y).
stepniece(X, Y)          :-  female(X),     stepnieceornephew(X, Y).

%%generation 0
spouse(X, Y)             :-  married(X, Y).
husband(X, Y)            :-  male(X),       married(X, Y).
wife(X, Y)               :-  female(X),     married(X, Y).
sibling(X, Y)            :-  father(Z, X),  father(Z, Y),           mother(W, X), mother(W, Y), not(X = Y).
brother(X, Y)            :-  male(X),       sibling(X, Y).
sister(X, Y)             :-  female(X),     sibling(X, Y).
siblinginlaw(X, Y)       :-  married(Y, Z), sibling(X, Z).
brotherinlaw(X, Y)       :-  male(X),       siblinginlaw(X, Y).
sisterinlaw(X, Y)        :-  female(X),     siblinginlaw(X, Y).
stepsibling(X, Y)        :-  parent(Z, X),  stepparent(Z, Y).
stepbrother(X, Y)        :-  male(X),       stepsibling(X, Y).
stepsister(X, Y)         :-  female(X),     stepsibling(X, Y).
cousin(X, Y)             :-  parent(Z, X),  auntoruncle(Z, Y).
stepcousin(X, Y)         :-  parent(Z, X),  stepauntoruncle(Z, Y).

%%generation 1
father(X, Y)             :-  male(X),           parent(X, Y).
mother(X, Y)             :-  female(X),         parent(X, Y).
parentinlaw(X, Y)        :-  married(Y, Z),     parent(X, Z).
fatherinlaw(X, Y)        :-  male(X),           parentinlaw(X, Y).
motherinlaw(X, Y)        :-  female(X),         parentinlaw(X, Y).
stepparent(X, Y)         :-  parent(Z, Y),      married(X, Z),         not(parent(X, Y)).
stepfather(X, Y)         :-  male(X),           stepparent(X, Y).
stepmother(X, Y)         :-  female(X),         stepparent(X, Y).
stepparentinlaw(X, Y)    :-  spouse(Z, Y),      stepparent(X, Z).
stepfatherinlaw(X, Y)    :-  male(X),           stepparentinlaw(X, Y).
stepmotherinlaw(X, Y)    :-  female(X),         stepparentinlaw(X, Y).
auntoruncle(X, W)        :-  sibling(X, Y),     parent(Y, W).
uncle(X, W)              :-  male(X),           auntoruncle(X, W).
aunt(X, W)               :-  female(X),         auntoruncle(X, W).
stepauntoruncle(X, Y)    :-  auntoruncle(Z, Y), married(X, Z),         not(auntoruncle(X, Y)).
stepaunt(X, Y)           :-  female(X),         stepauntoruncle(X, Y).
stepuncle(X, Y)          :-  male(X),           stepauntoruncle(X, Y).

%%generation 2
grandparent(X, Z)        :-  parent(X, Y),      parent(Y, Z).
grandfather(X, Z)        :-  male(X),           grandparent(X, Z).
grandmother(X, Z)        :-  female(X),         grandparent(X, Z).
grandparentinlaw(X, Y)   :-  married(Y, Z),     grandparent(X, Z).
grandfatherinlaw(X, Y)   :-  male(X),           grandparentinlaw(X, Y).
grandmotherinlaw(X, Y)   :-  female(X),         grandparentinlaw(X, Y).
stepgrandparent(X, Y)    :-  grandparent(Z, Y), married(X, Z),          not(grandparent(X, Y)).
stepgrandfather(X, Y)    :-  male(X),           stepgrandparent(X, Y).
stepgrandmother(X, Y)    :-  female(X),         stepgrandparent(X, Y).

