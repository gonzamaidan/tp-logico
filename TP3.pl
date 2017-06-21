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
	
/* ENTREGA 3 */

/* Punto 4: ¿Te copás?
Sabemos que: Fernando es copado con Santiago. Santiago es copado con Julieta y con Marcos. Julieta es copada con Andrés.
 
Ahora necesitamos saber si alguien le puede enseñar un lenguaje a otra persona, si el primero conoce ese lenguaje, el segundo no lo conoce, y además:
 * el primero es copado con la otra persona,
 * o bien el primero es copado con alguien que sea copado con esa persona.
Por ejemplo, Fernando le puede enseñar COBOL a Andrés, porque Fernando conoce COBOL y es copado con Santiago, que es copado con Julieta, que es copado con Andrés. Hacer un predicado que funcione a n niveles. */

esCopado(fernando, santiago).

esCopado(santiago, julieta).
esCopado(santiago, marcos).

esCopado(julieta, andres).

lePuedeEnseniar(Maestro, Alumno, Lenguaje) :-
	programa(Maestro, Lenguaje),
	esCopadoDeCopado(Maestro,Alumno),
	not(programa(Alumno, Lenguaje)).

esCopadoDeCopado(Persona1, PersonaFinal) :-
	esCopado(Persona1, PersonaFinal).
esCopadoDeCopado(Persona1, PersonaFinal) :-
	esCopado(Persona1, PersonaIntermedia),
	esCopadoDeCopado(PersonaIntermedia, PersonaFinal).
	
	
/*Punto 5: Seniority
De cada programador se sabe las tareas que hizo. Las tareas posibles son:
 * Evolutiva, que puede ser simple o compleja.
 * Correctiva, donde se indican la cantidad de líneas modificadas y el lenguaje (éste no tiene ninguna relación con los lenguajes que más conoce).
 * Algorítmica, donde cuentan la cantidad de líneas.
*/
tarea(fernando, evolutiva(compleja)).  
tarea(fernando, correctiva(8, brainfuck)).
tarea(fernando, algoritmica(150)).
tarea(marcos, algoritmica(20)).
tarea(julieta, correctiva(412, cobol)).
tarea(julieta, correctiva(21, go)).
tarea(julieta, evolutiva(simple)). 

gradoSeniority(evolutiva(compleja),5).
gradoSeniority(evolutiva(simple),3).

gradoSeniority(correctiva(Lineas,_), 4):-
	Lineas > 50.
gradoSeniority(correctiva(_,brainfuck),4).


gradoSeniority(algoritmica(Lineas),Puntaje) :-
	Puntaje is Lineas / 10.
	
persona(Persona) :- 
	trabaja(Persona,_).

seniority(Persona,Puntaje) :-
	persona(Persona),
	findall(PuntajeTarea,(tarea(Persona,Tarea), gradoSeniority(Tarea,PuntajeTarea)), Puntajes),
	sumlist(Puntajes, Puntaje).

	
/* Casos de prueba
* Sobre el punto 4: ¿Te copás?
1-Saber si Fernando es copado con Santiago. Esto es correcto.
?- esCopado(fernando, santiago).
true

2-Fernando no es copado con Julieta.
?- esCopado(fernando, julieta).
false.

3-Fernando le puede enseñar COBOL a Santiago, Julieta, Marcos y Andrés.
?- lePuedeEnseniar(fernando, A, cobol).
A = santiago ;
A = julieta ;
A = marcos ;
A = andres ;
false.

4-Es falso que Fernando le puede enseñar Haskell a alguien.
?- lePuedeEnseniar(fernando,_, haskell).
false.

5-A Andrés le pueden enseñar Java Fernando, Julieta y Santiago.
?- lePuedeEnseniar(Maestro, andres, java).
Maestro = fernando ;
Maestro = santiago ;
Maestro = julieta ;
false.

6-Fernando puede enseñarle COBOL, Visual Basic y Java a alguna persona.
?- lePuedeEnseniar(fernando,_,Lenguaje).
Lenguaje = cobol ;
Lenguaje = visualBasic ;
Lenguaje = cobol ;
Lenguaje = visualBasic ;
Lenguaje = cobol ;
Lenguaje = visualBasic ;
Lenguaje = cobol ;
Lenguaje = visualBasic ;
Lenguaje = java ;
false.

7-Marcos no puede enseñar nada a nadie (¡¡perdón Marcos!!).
?- lePuedeEnseniar(marcos,_,_).
false.

* Sobre el Punto 5: Seniority

1-Fernando tiene 24 de seniority.
?- seniority(fernando, 24).
true.

2-Se debe poder consultar quiénes tienen grado 0 de seniority, que es la lista compuesta por Santiago y Andrés.
?- seniority(Persona, 0).
Persona = santiago ;
Persona = andres.

3-Julieta no tiene seniority 6.
?- seniority(julieta,6).
false.

4-Julieta tiene seniority 7.
?- seniority(julieta,7).
true.

*/
	
:- begin_tests(programadores).

% ... tests anteriores ...

% Punto 4 - Te copas?

test(fernandoEsCopadoConSantiago, nondet) :-
	esCopado(fernando, santiago).

test(fernandoNoEsCopadoConJulieta, nondet) :-
	not(esCopado(fernando, julieta)).
		
test(aQuienesLesEnseniaFernandoCobol, set(Gente == [santiago, julieta, marcos, andres])) :-
	lePuedeEnseniar(fernando, Gente, cobol).

test(fernandoNoLeEnseniaHaskellAAlguien, nondet) :-
	not(lePuedeEnseniar(fernando, _, haskell)).

test(aQuienesLesEnseniaFernandoCobol, set(Gente == [santiago, julieta, fernando])) :-
	lePuedeEnseniar(Gente, andres, java).

test(queLenguajesEnseniaFernandoAAlguien, set(Lenguajes == [cobol, visualBasic, java])) :-
	lePuedeEnseniar(fernando, _, Lenguajes).

test(marcosNoPuedeEnseniarNadaANadie, nondet) :-
	not(lePuedeEnseniar(marcos, _, _)).

% Punto 5 - Seniority
test(fernandoTiene24DeSeniority, set(Puntajes == [24])) :-
	seniority(fernando, Puntajes).

test(genteSinSeniority, set(Gente == [santiago, andres])) :-
	seniority(Gente, 0).

test(julietaNoTieneSeniority6, nondet) :-
	not(seniority(julieta, 6)).

test(julietaTieneSeniority7, nondet) :-
	seniority(julieta, 7).

:- end_tests(programadores).