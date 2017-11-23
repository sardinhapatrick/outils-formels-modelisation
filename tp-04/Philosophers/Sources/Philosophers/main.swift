// SARDINHA Patrick

import PetriKit
import PhilosophersLib

do {
    enum C: CustomStringConvertible {
        case b, v, o

        var description: String {
            switch self {
            case .b: return "b"
            case .v: return "v"
            case .o: return "o"
            }
        }
    }

    func g(binding: PredicateTransition<C>.Binding) -> C {
        switch binding["x"]! {
        case .b: return .v
        case .v: return .b
        case .o: return .o
        }
    }

    let t1 = PredicateTransition<C>(
        preconditions: [
            PredicateArc(place: "p1", label: [.variable("x")]),
        ],
        postconditions: [
            PredicateArc(place: "p2", label: [.function(g)]),
        ])

    let m0: PredicateNet<C>.MarkingType = ["p1": [.b, .b, .v, .v, .b, .o], "p2": []]
    guard let m1 = t1.fire(from: m0, with: ["x": .b]) else {
        fatalError("Failed to fire.")
    }
    print(m1)
    guard let m2 = t1.fire(from: m1, with: ["x": .v]) else {
        fatalError("Failed to fire.")
    }
    print(m2)
}

print()

// Test pour 5 philosophes sans blocage:
print("1.")
print("Avec 5 philosophes, sans blocage:\n")
do {
    let philosophers = lockFreePhilosophers(n: 5)
    for m in philosophers.simulation(from: philosophers.initialMarking!).prefix(10) {
        print(m)

    }
    //print(philosophers.initialMarking)
    let m1 = philosophers.markingGraph(from: philosophers.initialMarking!)
    print("\nOn a",m1!.count,"marquages possibles !\n\n")

    // Pour tester si nous avons bien aucun bloquage dans le sans blocage:
    for block in m1! {
      // ******************* //
      print("Print_Test_1")        // Attention (pour 11 OK)
      // ******************* //
      if block.successors.count == 0{ // Si on a pas de successeurs:
        print("\nVoici un état bloqué où le réseau est bloqué:\n")
        print(block.marking)
        print("Print_Test_2\n") // --> Pas de print donc aucun bloquage.
        break // Si un blockage.
      }
    }
}

// Test pour 5 philosophes avec blocage:
print("\n2.")
print("Avec 5 philosophes, avec blocage:\n")
do {
    let philosophers = lockablePhilosophers(n: 5)
    for m in philosophers.simulation(from: philosophers.initialMarking!).prefix(10) {
        print(m)

    }
    //print(philosophers.initialMarking)
    let m2 = philosophers.markingGraph(from: philosophers.initialMarking!)
    print("\nOn a",m2!.count,"marquages possibles !\n\n")
}


// Test avec 5 philosophes avec blocage, en renvoie un état bloqué:
print("3.")
print("Avec 5 philosophes, avec blocage en imprimant un état de blocage:\n")
do {
    let philosophers = lockablePhilosophers(n: 5)
    for m in philosophers.simulation(from: philosophers.initialMarking!).prefix(10) {
        print(m)

    }
    //print(philosophers.initialMarking)
    let m3 = philosophers.markingGraph(from: philosophers.initialMarking!)
    print("\nOn a",m3!.count,"marquages possibles !")
    for block in m3! {
      if block.successors.count == 0{
        print("\nVoici un état bloqué où le réseau est bloqué:\n")
        print(block.marking)
        break // Si un blockage.
      }
    }
}
