<<<<<<< HEAD
// SARDINHA Patrick
// Tous droits réservés.

=======
>>>>>>> 90132b5e5bad46d14f2ad8c5a40be0fe8ce3fbab
import PetriKit

public class MarkingGraph {

    public let marking   : PTMarking
    public var successors: [PTTransition: MarkingGraph]

    public init(marking: PTMarking, successors: [PTTransition: MarkingGraph] = [:]) {
        self.marking    = marking
        self.successors = successors
    }

}

public extension PTNet {

<<<<<<< HEAD
      public func markingGraph(from marking: PTMarking) -> MarkingGraph? {
        // Write here the implementation of the marking graph generation.

        var Etat = MarkingGraph(marking: marking) // On construit l'état initial
        //print(Etat)
        var ProchainEtat = [MarkingGraph]() // On créé le prochain état à analyser. Initialisé à vide pour le moment
        ProchainEtat.insert(Etat, at:0) // On met l'Etat initial dans ProchainEtat
        //print(ProchainEtat)
        var EtatVisite = [MarkingGraph]()// On définie les états visités, vide pour le moment
        EtatVisite.insert(Etat, at:0) // On insert l'Etat initial dedans
        //print(EtatVisite)
        let m = marking

        // On créé une boucle afin de parcourir les graphes de marquages

          while let EtatActuel = ProchainEtat.popLast(){ // while !(ProchainEtat.isEmpty){
                                                        // var EtatActuel = ProchainEtat.popLast()
          EtatVisite.append(EtatActuel) // On append la liste afin d'ajouter les MarkingGraph visités
          for Transi in self.transitions{ // On fait les transitions une par une
              if let fireable = Transi.fire(from: EtatActuel.marking){ // Teste si tirable
                  if ProchainEtat.contains(where: {$0.marking == fireable}){ // Pour les états pas encore testés
                                                                            //  Contains nous permet de savoir si un élément satisfait le prédicat
                      EtatActuel.successors[Transi] = ProchainEtat.first(where: {$0.marking == fireable}) // Le prochain état atteignable par Transi dans ProchainEtat?
                                                                                                         // .first nous permet d'obtenir le premier élément qui satisfait le prédicat
                  }
                  else if EtatVisite.contains(where: {$0.marking == fireable}) { // Pour les états déjà testés
                      EtatActuel.successors[Transi] = EtatVisite.first(where: {$0.marking == fireable}) // Le prochain état atteignable par Transi dans EtatVisite?
                  }
                  else {
                      var NouvelEtat = MarkingGraph(marking: fireable) // Sinon on créé un nouvel état
                      ProchainEtat.append(NouvelEtat) // Et append
                      EtatActuel.successors[Transi] = NouvelEtat

                  }
              }

          }

        }
      return Etat // On renvoit les Etats
     }
=======
    public func markingGraph(from marking: PTMarking) -> MarkingGraph? {
        // Write here the implementation of the marking graph generation.
        return nil
    }

>>>>>>> 90132b5e5bad46d14f2ad8c5a40be0fe8ce3fbab
}
