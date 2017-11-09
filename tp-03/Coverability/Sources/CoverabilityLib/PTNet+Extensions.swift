// SARDINHA Patrick
// Tous droits réservés.

import PetriKit

public extension PTNet {

// La fonction ConvToMarking permet de convertir un graphe de couverture en un PTMarking
  public func ConvToMarking (from marking: CoverabilityMarking) -> PTMarking {

      var Dico1_marquage : PTMarking = [:]
      for place in self.places{
      //Jetons = 0->100

          let JetMin : Int = 0
          let JetMax : Int = 100
          Dico1_marquage[place] = 100 // Init
          //print(place)
          for i in JetMin...JetMax{
              if UInt(i) == marking[place]!{ // UInt
                                              // marking[place]
                  Dico1_marquage[place] = UInt(i)
              }
          }
      }
      // Retourne un PTMarking
      return Dico1_marquage
  }

// La fonction ConvToCoverMarking permet de convertir un PTMarking en un graphe de couverture
  public func ConvToCoverMarking (from marking: PTMarking) -> CoverabilityMarking {

      var Dico2_marquage : CoverabilityMarking = [:] // Vide
      // Conversion
      for place in self.places{
          if marking[place]!<100{
              Dico2_marquage[place] = .some(marking[place]!)
          }
          else {
              Dico2_marquage[place] = .omega
          }
      }
      // Retourne un CoverabilityMarking
      return Dico2_marquage
  }

// La fonction coverabilityGraph permet de générer le graphe de couverture et
// renvoie les Etats avec les Omegas pour les cas nécessaires
  public func coverabilityGraph(from marking: CoverabilityMarking) -> CoverabilityGraph {
      // Write here the implementation of the coverability graph generation.

      // Note that CoverabilityMarking implements both `==` and `>` operators, meaning that you
      // may write `M > N` (with M and N instances of CoverabilityMarking) to check whether `M`
      // is a greater marking than `N`.

      // IMPORTANT: Your function MUST return a valid instance of CoverabilityGraph! The optional
      // print debug information you'll write in that function will NOT be taken into account to
      // evaluate your homework.

      // Init
      var Etat = CoverabilityGraph(marking: marking)
      var ProchainEtat = [CoverabilityGraph]()
      ProchainEtat.insert(Etat, at:0)
      var EtatVisite = [CoverabilityGraph]()
      EtatVisite.insert(Etat, at:0)

      while let EtatActuel = ProchainEtat.popLast(){
          EtatVisite.append(EtatActuel)

          let Mark1_Conv = ConvToMarking(from: EtatActuel.marking)
          for Transi in self.transitions{
              if let Mark2_Conv = Transi.fire(from: Mark1_Conv){
                  var marquage = ConvToCoverMarking(from: Mark2_Conv)
                  // Nous regardons les Etats parents
                  for EtatParent in Etat{
                      if marquage > EtatParent.marking{
                          for place in self.places{
                              // Si le marquage est supérieur alors on met un Omega
                              if marquage[place]! > EtatParent.marking[place]!{
                                  marquage[place] = .omega
                              }
                          }
                      }
                  }
                      // Comme pour le graphe de marquage
                      if ProchainEtat.contains(where: {$0.marking == marquage}){

                          EtatActuel.successors[Transi] = ProchainEtat.first(where: {$0.marking == marquage})
                      }
                      else if EtatVisite.contains(where: {$0.marking == marquage}) {
                          EtatActuel.successors[Transi] = EtatVisite.first(where: {$0.marking == marquage})
                      }
                      else {
                          var NouvelEtat = CoverabilityGraph(marking: marquage)
                          ProchainEtat.append(NouvelEtat)
                          EtatActuel.successors[Transi] = NouvelEtat
                      }
                  }
              }
          }
      // Retourne un CoverabilityGraph
      return Etat
      }

  }
