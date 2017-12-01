// SARDINHA Patrick

extension PredicateNet {

    /// Returns the marking graph of a bounded predicate net.
    public func markingGraph(from marking: MarkingType) -> PredicateMarkingNode<T>? {
        // Write your code here ...

        // Note that I created the two static methods `equals(_:_:)` and `greater(_:_:)` to help
        // you compare predicate markings. You can use them as the following:
        //
        //     PredicateNet.equals(someMarking, someOtherMarking)
        //     PredicateNet.greater(someMarking, someOtherMarking)
        //
        // You may use these methods to check if you've already visited a marking, or if the model
        // is unbounded.

        //let test = PredicateMarkingNode<T>(marking: marking, successors: [:])
        //print(test)

        let Graphe_Marquage = PredicateMarkingNode<T>(marking: marking, successors: [:]) // Nous définissons le graphe de marquage.
        var Marquage_A_Tester = [PredicateMarkingNode<T>]() // On définit les marquages à tester.
        Marquage_A_Tester.insert(Graphe_Marquage, at:0)
        var Marquage_Vu = [Graphe_Marquage] // Les marquages visités.
        var Binding_Tab = [PredicateTransition<T>.Binding]() // On déclare un tableau de bindings.

        while (Marquage_A_Tester.last) != nil {  // Nous bouclons jusqu'a ce qu'il n'y ait plus de marquages à tester.

        let M_tmp = Marquage_A_Tester.popLast()   // On place le dernier marquage de la liste des marquages à tester
            Marquage_Vu.append(M_tmp!)           // dans les marquages visités.

            let marquage = M_tmp!.marking
            for Transi in self.transitions { // Nous testons les transitions une par une.
                Binding_Tab = Transi.fireableBingings(from: marquage) // Nous regardons tous les bindings.
                var Binding_Creer : PredicateBindingMap<T> = [:]

                for i in Binding_Tab { // On teste tous les bindings.
                    if let fireable = Transi.fire(from: marquage, with: i) { // Si une transition est tirable.
                        let Marquage_Creer = PredicateMarkingNode<T>(marking: fireable, successors: [:]) //  Def création marquage.

                        if (Marquage_Vu.contains(where: {PredicateNet.greater(Marquage_Creer.marking, $0.marking)}) == true){ // Si ce marquage à déjà été visité.
                            return nil // Retour rien.
                        }
                        // else {
                        if (Marquage_Vu.contains(where: {PredicateNet.equals($0.marking, Marquage_Creer.marking)}) == false){ // Si nous ne l'avons pas encore visité.
                            Marquage_A_Tester.append(Marquage_Creer) // On append le marquages aux listes.
                            Marquage_Vu.append(Marquage_Creer)

                            Binding_Creer[i] = Marquage_Creer
                            M_tmp!.successors.updateValue(Binding_Creer, forKey: Transi) // On update les successeurs possibles.
                        }
                        else {
                            for block in Marquage_Vu { // On teste les marquages testés et on regarde si on revient à un marquage visité.
                                if (PredicateNet.equals(block.marking, Marquage_Creer.marking) == true) {
                                Binding_Creer[i] = block
                                M_tmp!.successors.updateValue(Binding_Creer, forKey: Transi) // ALors on remet à jour les successeurs.
                                }
                            }
                        }
                    }
                }
            }
        }
        // Ainsi, on renvoit le graphe de marquage.
        return Graphe_Marquage
    }

    // MARK: Internals

    private static func equals(_ lhs: MarkingType, _ rhs: MarkingType) -> Bool {
        guard lhs.keys == rhs.keys else { return false }
        for (place, tokens) in lhs {
            guard tokens.count == rhs[place]!.count else { return false }
            for t in tokens {
                guard tokens.filter({ $0 == t }).count == rhs[place]!.filter({ $0 == t }).count
                    else {
                        return false
                }
            }
        }
        return true
    }

    private static func greater(_ lhs: MarkingType, _ rhs: MarkingType) -> Bool {
        guard lhs.keys == rhs.keys else { return false }

        var hasGreater = false
        for (place, tokens) in lhs {
            guard tokens.count >= rhs[place]!.count else { return false }
            hasGreater = hasGreater || (tokens.count > rhs[place]!.count)
            for t in rhs[place]! {
                guard tokens.filter({ $0 == t }).count >= rhs[place]!.filter({ $0 == t }).count
                    else {
                        return false
                }
            }
        }
        return hasGreater
    }

}

/// The type of nodes in the marking graph of predicate nets.
public class PredicateMarkingNode<T: Equatable>: Sequence {

    public init(
        marking   : PredicateNet<T>.MarkingType,
        successors: [PredicateTransition<T>: PredicateBindingMap<T>] = [:])
    {
        self.marking    = marking
        self.successors = successors
    }

    public func makeIterator() -> AnyIterator<PredicateMarkingNode> {
        var visited = [self]
        var toVisit = [self]

        return AnyIterator {
            guard let currentNode = toVisit.popLast() else {
                return nil
            }

            var unvisited: [PredicateMarkingNode] = []
            for (_, successorsByBinding) in currentNode.successors {
                for (_, successor) in successorsByBinding {
                    if !visited.contains(where: { $0 === successor }) {
                        unvisited.append(successor)
                    }
                }
            }

            visited.append(contentsOf: unvisited)
            toVisit.append(contentsOf: unvisited)

            return currentNode
        }
    }

    public var count: Int {
        var result = 0
        for _ in self {
            result += 1
        }
        return result
    }

    public let marking: PredicateNet<T>.MarkingType

    /// The successors of this node.
    public var successors: [PredicateTransition<T>: PredicateBindingMap<T>]

}

/// The type of the mapping `(Binding) ->  PredicateMarkingNode`.
///
/// - Note: Until Conditional conformances (SE-0143) is implemented, we can't make `Binding`
///   conform to `Hashable`, and therefore can't use Swift's dictionaries to implement this
///   mapping. Hence we'll wrap this in a tuple list until then.
public struct PredicateBindingMap<T: Equatable>: Collection {

    public typealias Key     = PredicateTransition<T>.Binding
    public typealias Value   = PredicateMarkingNode<T>
    public typealias Element = (key: Key, value: Value)

    public var startIndex: Int {
        return self.storage.startIndex
    }

    public var endIndex: Int {
        return self.storage.endIndex
    }

    public func index(after i: Int) -> Int {
        return i + 1
    }

    public subscript(index: Int) -> Element {
        return self.storage[index]
    }

    public subscript(key: Key) -> Value? {
        get {
            return self.storage.first(where: { $0.0 == key })?.value
        }

        set {
            let index = self.storage.index(where: { $0.0 == key })
            if let value = newValue {
                if index != nil {
                    self.storage[index!] = (key, value)
                } else {
                    self.storage.append((key, value))
                }
            } else if index != nil {
                self.storage.remove(at: index!)
            }
        }
    }

    // MARK: Internals

    private var storage: [(key: Key, value: Value)]

}

extension PredicateBindingMap: ExpressibleByDictionaryLiteral {

    public init(dictionaryLiteral elements: ([Variable: T], PredicateMarkingNode<T>)...) {
        self.storage = elements
    }

}
