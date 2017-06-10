programa(fernando, cobol).
programa(fernando, visualBasic).
programa(fernando, java).

programa(julieta, java).
programa(marcos, java).

/* Como todavia no se sabe si julieta programo en Go no lo agrego */

programa(santiago, ecmaScript).
programa(santiago, java).

/* No lo agrego que nadie programo en el assembler ya el Prolog usa el principio de universo cerrado
	entonces si no se puede determinar que es verdadero, es falso */

rol(fernando, analistaFuncional).

rol(andres, projectLeader).
/*No hace falta especificar que no programa por principio de universo cerrado */

rol(Alguien,programador) :-
	programa(Alguien, _).
/*
2 Consultas:
programa(fernando, Lenguaje).
programa(Persona, java).
programa(Persona, assembler).
rol(fernando, programador).
rol(fernando, Rol).
rol(Persona, programador).
rol(Persona, projectLeader).
*/

/* Entrega 2 */
/* 1-Agregados */
/* Punto 2 Proyectos*/

requiere(sumatra, java).
requiere(sumatra, net).
requiere(prometeus, cobol).

trabaja(fernando, prometeus).
trabaja(santiago, prometeus).

trabaja(julieta,sumatra).
trabaja(marcos,sumatra).
trabaja(andres, sumatra).

bienAsignada(Persona, Proyecto) :- 
	trabaja(Persona, Proyecto),
	programa(Persona, Lenguaje),
	requiere(Proyecto, Lenguaje).
bienAsignada(Persona, Proyecto) :- 
	trabaja(Persona, Proyecto),
	rol(Persona, analistaFuncional).
bienAsignada(Persona, Proyecto) :- 
	trabaja(Persona, Proyecto),
	rol(Persona,projectLeader).

/* Punto 3 Validacion de proyectos */
estaBienDefinido(Proyecto):-
	proyecto(Proyecto),
	forall(trabaja(Persona,Proyecto), bienAsignada(Persona,Proyecto)).
	
proyecto(Proyecto) :- requiere(Proyecto,_).
	
	
	





:- begin_tests(programadores).

% Test Entrega 2 - Punto 2 Proyectos
test(lenguajesDeSumatra, nondet) :-
	requiere(sumatra, java), requiere(sumatra, net).
		
test(lenguajesDeSumatraExplicito, set(Lenguajes == [net, java])) :-
	requiere(sumatra, Lenguajes).

test(lenguajesDePrometeusEsSoloCobol, set(Lenguajes == [cobol])) :-
	requiere(prometeus, Lenguajes).

test(fernandoTrabajaEnPrometeus) :-
    trabaja(fernando, prometeus).

test(santiagoTrabajaEnPrometeus) :-
    trabaja(santiago, prometeus).

test(genteDeSumatra, set(Personas == [julieta, marcos, andres])) :-
    trabaja(Personas, sumatra).

test(trabajadoresDeSumatraBienAsignados, set(Gente == [julieta, marcos, andres])) :-
    bienAsignada(Gente, sumatra).

test(trabajadoresDePrometeusBienAsignados, set(Gente == [fernando])) :-
    bienAsignada(Gente, prometeus).

test(trabajadoresBienAsignados, set(Gente == [julieta, marcos, andres, fernando])) :-
    bienAsignada(Gente, _).

test(proyectosConGenteBienAsignada, set(Proyectos == [prometeus, sumatra])) :-
    bienAsignada(_, Proyectos).

% Punto 3 - Proyectos bien definidos
test(proyectosBienDefinidos, set(Proyectos == [sumatra])) :-
    estaBienDefinido(Proyectos).

test(prometeusNoEstaBienDefinido) :-
    not(estaBienDefinido(prometeus)).

test(proyectosMalDefinidos, set(Proyectos == [prometeus])) :-
    proyecto(Proyectos), not(estaBienDefinido(Proyectos)).

:- end_tests(programadores).
