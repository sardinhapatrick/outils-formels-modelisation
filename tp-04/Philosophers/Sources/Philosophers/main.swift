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
        case .b: return .v // g(b) = v
        case .v: return .b // g(v)  = b
        case .o: return .o // g(o) = o
        }
    }

    let t1 = PredicateTransition<C>(
        preconditions: [                // label -> soit variable soit fonction
            PredicateArc(place: "p1", label: [.variable("x")]),
            // de la place p1 veut un label (multiset = tab non trié) qui a la var x
        ],
        postconditions: [
            PredicateArc(place: "p2", label: [.function(g)]),
            // label avec fonction g
        ])

// fabrique marquage initial
    let m0: PredicateNet<C>.MarkingType = ["p1": [.b, .b, .v, .v, .b, .o], "p2": []]
    guard let m1 = t1.fire(from: m0, with: ["x": .b]) else { // tirer transition mais doit donner le binding: x vaut b --> T1/x=b
        fatalError("Failed to fire.")
    }
    print(m1)
    guard let m2 = t1.fire(from: m1, with: ["x": .v]) else { // idem
        fatalError("Failed to fire.")
    }
    print(m2)
}

print()

do {
    let philosophers = lockablePhilosophers(n: 3)
    for m in philosophers.simulation(from: philosophers.initialMarking!).prefix(10) {
        print(m)
    }
}

// Exo vendredi 17.11.2017

do {
  // Dom(Ingredients)
    enum Ingredients{
        case p,t,m
    }
    enum Smokers {
        case mia,tom,bob
    }
    enum Referee {
        case rob
    }
    enum Types {
        case ingredients(Ingredients)
        case smokers(Smokers)
        case referee(Referee)
    }

    let s = PredicateTransition<Types>{
        preconditions: [                // label -> soit variable soit fonction
            PredicateArc(place: "i", label: [.variable("x"),.variable("y")]),
            PredicateArc(place: "s", label: [.variable("s")]),
        ],
        postconditions: [
            PredicateArc(place: "r", label: [.function({_ in .referee(.rob)})]),
            PredicateArc(place: "w", label: [.function("s")]),
        ],
      condition       : [{ binding init() {
          guard case let .smokers(s)     = binding["s"]!,
                case let .ingredients(x) = binding["x"]!,
                case let .ingredients(y) = binding["y"]!
          else
      }}])

    }
  }
}
