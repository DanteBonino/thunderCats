%Base de conocimiento:
%---------------------
personaje(thundercat(leonO, 5)). %nombre, fuerza
personaje(thundercat(jaga, 0)). %¡es un espíritu!
personaje(thundercat(panthro, 4)).
personaje(thundercat(cheetara, 3)).
personaje(thundercat(tigro, 3)).
personaje(thundercat(grune, 4)).
personaje(mutante(reptilio, 4)). %nombre, fuerza
personaje(mutante(chacalo, 2)).
personaje(mutante(buitro, 2)).
personaje(mutante(mandrilok, 3)).
personaje(lunatack(luna)).
personaje(lunatack(chilla)).
personaje(momia(mummRa)).
personaje(momia(mummRana)).

traidor(grune).
traidor(chacalo).

lider(thundercat, leonO). %facción, líder
lider(mutante, reptilio).
lider(lunatack, luna).

guia(jaga).

%Punto 1:
viveEn(Personaje, Lugar):-
    personaje(Personaje),
    lugarDondeVive(Personaje, Lugar).

lugarDondeVive(mutante(_,_), madriguera).
lugarDondeVive(momia(_), piramide).
lugarDondeVive(thundercat(Nombre,_), cubilFelino):-
    not(traidor(Nombre)).

%Punto 2:
faccion(Faccion):-
    lider(Faccion,_).

%Punto 3:
caracteristicas(NombrePersonaje, Faccion, Fuerza):-
    caracteristicas(_,NombrePersonaje,Faccion,Fuerza).

atributosDePersonaje(thundercat(Nombre,Fuerza), Nombre, Fuerza, thundercat).
atributosDePersonaje(momia(Nombre), Nombre, 8, momia).
atributosDePersonaje(mutante(Nombre, Fuerza), Nombre, Fuerza, mutante).
atributosDePersonaje(lunatack(Nombre), Nombre,3, lunatack).

%Punto 4:
esArmonico(Personajes):-
    personaje(Personaje),
    member(Personaje, Personajes),
    todosTraidoresOTodosMismaFaccion(Personajes).

todosTraidoresOTodosMismaFaccion(Personajes):-
    faccion(Faccion),
    forall(member(Personaje, Personajes), esDeYNoEsTraidor(Personaje, Faccion)).
todosTraidoresOTodosMismaFaccion(Personajes):-
    forall(member(Personaje,Personajes), esTraidor(Personaje)).

esDeYNoEsTraidor(Personaje, Faccion):-
    faccionDe(Personaje, Faccion),
    not(esTraidor(Personaje)).
    

caracteristicas(Personaje,Nombre,Faccion,Fuerza):-
    personaje(Personaje),
    atributosDePersonaje(Personaje,Nombre, Fuerza,Faccion).

esTraidor(Personaje):-
    caracteristicas(Personaje,Nombre,_,_),
    traidor(Nombre).

faccionDe(Personaje, Faccion):-
    caracteristicas(Personaje,_,Faccion,_).

%Punto 5:
puedeGuiar(NombreGuia, NombreGuiado):-
    sonDistintos(NombreGuia, NombreGuiado),
    puedeGuiarlo(NombreGuia, NombreGuiado).
puedeGuiar(mummRa, NombreGuiado):-
    esMalo(NombreGuiado).

puedeGuiarlo(NombreGuia, NombreGuiado):-
    guia(NombreGuia),
    not(lider(_,NombreGuiado)).
puedeGuiarlo(NombreGuia, NombreGuiado):-
    not(guia(NombreGuiado)),
    esMasFuerte(NombreGuia, NombreGuiado).

esMasFuerte(Personaje, OtroPersonaje):-
    caracteristicas(Personaje, _, Fuerza),
    caracteristicas(OtroPersonaje,_,OtraFuerza),
    Fuerza > OtraFuerza.

esMalo(mummRa).
esMalo(Personaje):-
    traidor(Personaje).
esMalo(Personaje):-
    caracteristicas(Personaje,Faccion,_),
    member(Faccion, [lunatack, mutante]).

sonDistintos(Nombre, OtroNombre):-
    caracteristicas(Nombre,_,_),
    caracteristicas(OtroNombre,_,_),
    Nombre \= OtroNombre.

%Punto 6:
fuerzaGuiada(Personaje, FuerzaTotal):-
    caracteristicas(Personaje,NombrePersonaje,_,FuerzaPersonaje),
    findall(Fuerza, fuerzaDeGuiado(NombrePersonaje, Fuerza), Fuerzas),
    sum_list(Fuerzas, FuerzaCasiTotal),
    FuerzaTotal is FuerzaPersonaje + FuerzaCasiTotal.
    
fuerzaDeGuiado(Nombre, Fuerza):-
    puedeGuiar(Nombre, OtroNombre),
    caracteristicas(OtroNombre,_,Fuerza).

%Punto 7:


guiaCompleta(Personaje, OtroPersonaje):-
    puedeGuiar(Personaje, OtroPersonaje),
    caracteristicas(AlgunPersonaje,_,_),
    guiaCompleta(OtroPersonaje,AlgunPersonaje).

%Punto 8:
seArmoLaHecatombe(Personajes):-
    faccionDePersonajePertenecienteA(_, Personajes, Faccion1),
    faccionDePersonajePertenecienteA(_, Personajes, Faccion2),
    faccionDePersonajePertenecienteA(_, Personajes, Faccion3),
    Faccion1 \= Faccion2,
    Faccion2 \= Faccion3,
    Faccion1 \= Faccion3.

personajePertenecienteA(Personaje, Personajes):-
    personaje(Personaje),
    member(Personaje, Personajes).

faccionDePersonajePertenecienteA(Personaje, Personajes, Faccion):-
    personajePertenecienteA(Personaje, Personajes),
    caracteristicas(Personaje,_, Faccion,_).