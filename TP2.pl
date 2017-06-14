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
	forall(trabaja(Persona,Proyecto), bienAsignada(Persona,Proyecto)),
	not(variosLideres(Proyecto)),
	tieneLider(Proyecto).

variosLideres(Proyecto) :-
	liderDeProyecto(Proyecto, Persona1),
	liderDeProyecto(Proyecto, Persona2),
	Persona1 \= Persona2.

tieneLider(Proyecto) :-
	trabaja(Persona, Proyecto),
	rol(Persona, projectLeader).
	
liderDeProyecto(Proyecto, Persona) :-
	trabaja(Persona, Proyecto),
	rol(Persona, projectLeader).
	
proyecto(Proyecto) :- requiere(Proyecto,_).

estaMalDefinido(Proyecto) :- 
	proyecto(Proyecto),
	not(estaBienDefinido(Proyecto)).
	
/* 2-Casos de Prueba */

/*
1-Al consultar los lenguajes del proyecto Sumatra deben estar en el universo de soluciones los lenguajes Java y .Net
?- requiere(sumatra, Lenguaje).
Lenguaje = java ;
Lenguaje = net.

2-No es cierto que haya otro lenguaje distinto de COBOL para el proyecto Prometeus
?- forall(requiere(prometeus,Lenguaje),Lenguaje == cobol).
true.

3-Fernando trabaja en el proyecto Prometeus
?- trabaja(fernando, prometeus).
true.

4-Santiago trabaja en el proyecto Prometeus
?- trabaja(santiago, prometeus).
true.

5-El universo de programadores del proyecto Sumatra se compone de Julieta, Marcos y Andrés
?- trabaja(Personas, sumatra).
Personas = julieta ;
Personas = marcos ;
Personas = andres.

6-En el proyecto Sumatra Julieta, Marcos y Andrés están bien asignados.
?- bienAsignada(julieta, sumatra).
true .
?- bienAsignada(marcos, sumatra).
true .
?- bienAsignada(andres, sumatra).
true .

7-En el proyecto Prometeus solo Fernando está bien asignado.
?- bienAsignada(Persona, prometeus).
Persona = fernando ;
Persona = fernando ;
false.

8-La lista de personas bien asignadas a algún proyecto se compone de Julieta, Marcos, Andrés y Fernando
?- bienAsignada(Persona, _).
Persona = fernando ;
Persona = julieta ;
Persona = marcos ;
Persona = fernando ;
Persona = andres ;
false.

9-Los proyectos que tienen a alguien bien asignado es el universo conformado por Prometeus y Sumatra.
?- bienAsignada(_, Proyecto).
Proyecto = prometeus ;
Proyecto = sumatra ;
Proyecto = sumatra ;
Proyecto = prometeus ;
Proyecto = sumatra ;
false.

10-La lista de proyectos bien definidos incluye al proyecto Sumatra
?- estaBienDefinido(Proyecto).
Proyecto = sumatra .

11-El proyecto Prometeus está mal definido
?- estaBienDefinido(prometeus).
false.

12-La lista de proyectos mal definidos está formado por un conjunto con un solo proyecto: Prometeus
?- estaMalDefinido(Proyecto).
Proyecto = prometeus.


*/
	





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