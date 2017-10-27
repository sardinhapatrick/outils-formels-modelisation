<<<<<<< HEAD
// SARDINHA Patrick
// Tous droits réservés.

import PetriKit
import SmokersLib
import Foundation
=======
import PetriKit
import SmokersLib
>>>>>>> 90132b5e5bad46d14f2ad8c5a40be0fe8ce3fbab

// Instantiate the model.
let model = createModel()

// Retrieve places model.
guard let r  = model.places.first(where: { $0.name == "r" }),
      let p  = model.places.first(where: { $0.name == "p" }),
      let t  = model.places.first(where: { $0.name == "t" }),
      let m  = model.places.first(where: { $0.name == "m" }),
      let w1 = model.places.first(where: { $0.name == "w1" }),
      let s1 = model.places.first(where: { $0.name == "s1" }),
      let w2 = model.places.first(where: { $0.name == "w2" }),
      let s2 = model.places.first(where: { $0.name == "s2" }),
      let w3 = model.places.first(where: { $0.name == "w3" }),
<<<<<<< HEAD
      let s3 = model.places.first(where: { $0.name == "s3" }),

      let tpt  = model.transitions.first(where: { $0.name == "tpt" }),
      let tpm  = model.transitions.first(where: { $0.name == "tpm" }),
      let ttm  = model.transitions.first(where: { $0.name == "ttm" }),
      let ts1  = model.transitions.first(where: { $0.name == "ts1" }),
      let ts2  = model.transitions.first(where: { $0.name == "ts2" }),
      let ts3  = model.transitions.first(where: { $0.name == "ts3" }),
      let tw1  = model.transitions.first(where: { $0.name == "tw1" }),
      let tw2  = model.transitions.first(where: { $0.name == "tw2" }),
      let tw3  = model.transitions.first(where: { $0.name == "tw3" })

=======
      let s3 = model.places.first(where: { $0.name == "s3" })
>>>>>>> 90132b5e5bad46d14f2ad8c5a40be0fe8ce3fbab
else {
    fatalError("invalid model")
}

<<<<<<< HEAD
// Nous plotons le réseau de pétri pour le visualiser en génerant un .dot

let pn = PTNet(places: [r, p, t, m, w1, s1, w2, s2, w3, s3], transitions: [tpt, tpm, ttm, ts1, ts2, ts3, tw1, tw2, tw3])
try pn.saveAsDot(to: URL(fileURLWithPath: "pn.dot"), withMarking: [r: 1, p: 0 , t: 0, m: 0, w1: 1, s1: 0, w2: 1, s2: 0, w3: 1, s3: 0])

// Create the initial marking.

let initialMarking: PTMarking = [r: 1, p: 0, t: 0, m: 0, w1: 1, s1: 0, w2: 1, s2: 0, w3: 1, s3: 0]

// On créé la fonction countNodes afin de compter les noeuds/Etats possibles du réseau
// Renvoie un entier

func countNodes(markingGraph: MarkingGraph) -> Int {
  // iteration
    var seen    = [markingGraph]
    var toVisit = [markingGraph]
    // var result: Int = 0
    // result += markingGraph.successors.count
    while let current = toVisit.popLast(){
        for (_, successor) in current.successors{
            if !seen.contains(where: { $0 === successor }) {  // ''==='' Afin de savoir si c'est la meme classe
                seen.append(successor)
                toVisit.append(successor) //  Permet de voir tous les noeuds au moins une fois
            }
        }
    }
    //print(seen.count)
    return seen.count
}

// On créé la fonction nombreFumeurs afin de savoir si 2 fumeurs différents
// peuvent fumer en même temps
// Renvoie un Booléen

func nombreFumeurs(markingGraph: MarkingGraph) -> Bool {
  // iteration
    var seen    = [markingGraph]
    var toVisit = [markingGraph]

    while let current = toVisit.popLast(){
        for (_, successor) in current.successors{
            if !seen.contains(where: { $0 === successor }) {  // ''==='' Afin de savoir si c'est la meme classe
                seen.append(successor)
                toVisit.append(successor)
                if (successor.marking[s1] == 1 && successor.marking[s2] == 1) || // Les conditions pour fumer en même temps
                (successor.marking[s2] == 1 && successor.marking[s3] == 1) {
                    return true
                }
                else if (successor.marking[s3] == 1 && successor.marking[s1] == 1){
                    return true
                }
                /*switch value {
                case value:

                default:

                }*/
            }
        }
    }
    return false // Sinon
}


// On créé la fonction nombreIngredients afin de savoir si un même ingrédient peut
// être deux fois présents sur la table (en même temps)
// Renvoie un Booléen

func nombreIngredients(markingGraph: MarkingGraph) -> Bool {
      // iteration
    var seen    = [markingGraph]
    var toVisit = [markingGraph]

    while let current = toVisit.popLast(){
        for (_, successor) in current.successors{
            if !seen.contains(where: { $0 === successor }) {  // ''==='' Afin de savoir si c'est la meme classe
                seen.append(successor)
                toVisit.append(successor)
                if (successor.marking[p] == 2){  // Conditions pour qu'un ingrédient soit 2 fois sur la table
                    return true
                }
                else if (successor.marking[m] == 2){
                    return true
                }
                else if (successor.marking[t] == 2){
                    return true
                }
            }
        }
    }
    return false  // Sinon
}


// Create the marking graph (if possible).

if let markingGraph = model.markingGraph(from: initialMarking) {
    // Write here the code necessary to answer questions of Exercise 4.
    print("\n ============ TP 02 ==============")
    print(" ======= Analyse du modèle =======\n")

    // On print le nombre d'Etats possible du réseau
    var a = countNodes(markingGraph : markingGraph)
    print("Il y a", a,"états différents pour ce réseau !")
    //print(a)

    //var b = nombreFumeurs(markingGraph: markingGraph)
    //print(b)

    // Boucle if pour savoir si deux fumeurs différents peuvent fumer en même temps
    if nombreFumeurs(markingGraph: markingGraph) == true {
        print("Deux fumeurs différents peuvent fumer en même temps !")
    }
    else {
        print("Il est impossible que deux fumeurs différents puissent fumer en même temps !")
    }

    //var c = nombreIngredients(markingGraph: markingGraph)
    //print(c)

    // Boucle if pour savoir si un même ingrédient peut être deux fois sur la table en même temps
    if nombreIngredients(markingGraph: markingGraph) == true {
        print("Un même ingrédient peut se retrouver deux fois en même temps sur la table !")
    }
    else {
        print("Un même ingrédient ne peut pas se retrouver deux fois en même temps sur la table !")
    }
=======
// Create the initial marking.
let initialMarking: PTMarking = [r: 1, p: 0, t: 0, m: 0, w1: 1, s1: 0, w2: 1, s2: 0, w3: 1, s3: 0]

// Create the marking graph (if possible).
if let markingGraph = model.markingGraph(from: initialMarking) {
    // Write here the code necessary to answer questions of Exercise 4.
>>>>>>> 90132b5e5bad46d14f2ad8c5a40be0fe8ce3fbab
}
