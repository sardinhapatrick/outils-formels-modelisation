<<<<<<< HEAD
// cette class définie un noeud du graphe.
=======
>>>>>>> 90132b5e5bad46d14f2ad8c5a40be0fe8ce3fbab
public class MarkingGraph {

    public typealias Marking = [String: Int]

<<<<<<< HEAD
    public let marking   : Marking // dans graphe de marquage correspond au marquage du noeud.
    public var successors: [String: MarkingGraph] // correspond aux arcs sortants des noeuds. (dictionnaire)
=======
    public let marking   : Marking
    public var successors: [String: MarkingGraph]
>>>>>>> 90132b5e5bad46d14f2ad8c5a40be0fe8ce3fbab

    public init(marking: Marking, successors: [String: MarkingGraph] = [:]) {
        self.marking    = marking
        self.successors = successors
    }

<<<<<<< HEAD

}
// parcours de graphe en profondeur.
// fonction qui prend graphe de marquage et renvoit un nombre de noeuds.
func countNodes(markingGraph: MarkingGraph) -> Int {
  // iteration
    var seen    = [markingGraph]
    var toVisit = [markingGraph]
    //var result: Int = 0
    //result += markingGraph.successors.count
    while let current = toVisit.poplast(){
        for (_, successor) in current.successors{
            if !seen.contains(where: { $0 === successor }) {// === si c'est la meme classe  / instance.
                seen.append(successor)
                toVisit.append(successor) //  permet de voir tous les noeuds au moins une fois
                // if marking.first(where: { $0.1 > 1}) != nil {return true} -> existe-t-il un moment ou il y a plus de 2 jetons dans une place $0.1 = deuxieme elts
            }
        }
    }
    return seen.count
}

// recursion
func countNodes2(markingGraph: MarkingGraph{, seen: inout [markingGraph]) -> Int {
    seen.append(markingGraph)
    for (_,successor) in markingGraph.successors{
        if !seen.contains(where: { $0 === successor}){
            seen.append(successor)
            _ = countNodes2(markingGraph: successor, seen: &seen)
        }
    }
    return seen.count
=======
>>>>>>> 90132b5e5bad46d14f2ad8c5a40be0fe8ce3fbab
}

// Ex. 1: Mutual exclusion
do {
<<<<<<< HEAD
    // Write your code here ...
=======
>>>>>>> 90132b5e5bad46d14f2ad8c5a40be0fe8ce3fbab
    let m0 = MarkingGraph(marking: ["s0": 1, "s1": 0, "s2": 1, "s3": 0, "s4": 1])
    let m1 = MarkingGraph(marking: ["s0": 0, "s1": 1, "s2": 0, "s3": 0, "s4": 1])
    let m2 = MarkingGraph(marking: ["s0": 1, "s1": 0, "s2": 0, "s3": 1, "s4": 0])

    m0.successors = ["t1": m1, "t3": m2]
    m1.successors = ["t0": m0]
    m2.successors = ["t2": m0]
}

// Ex. 2: PetriNet 1
do {
    let m0 = MarkingGraph(marking: ["p0": 2, "p1": 0])
    let m1 = MarkingGraph(marking: ["p0": 1, "p1": 1])
    let m2 = MarkingGraph(marking: ["p0": 0, "p1": 2])

    m0.successors = ["t0": m1]
    m1.successors = ["t0": m2, "t1": m0]
    m2.successors = ["t1": m1]

    // Write your code here ...
<<<<<<< HEAD

=======
>>>>>>> 90132b5e5bad46d14f2ad8c5a40be0fe8ce3fbab
}

// Ex. 2: PetriNet 2
do {
    let m0 = MarkingGraph(marking: ["p0": 1, "p1": 0, "p2": 0, "p3": 0, "p4": 0])
    let m1 = MarkingGraph(marking: ["p0": 0, "p1": 1, "p2": 0, "p3": 1, "p4": 0])
    let m2 = MarkingGraph(marking: ["p0": 0, "p1": 0, "p2": 1, "p3": 1, "p4": 0])
    let m3 = MarkingGraph(marking: ["p0": 0, "p1": 1, "p2": 0, "p3": 0, "p4": 1])
    let m4 = MarkingGraph(marking: ["p0": 0, "p1": 0, "p2": 0, "p3": 1, "p4": 0])
    let m5 = MarkingGraph(marking: ["p0": 0, "p1": 0, "p2": 1, "p3": 0, "p4": 1])
    let m6 = MarkingGraph(marking: ["p0": 0, "p1": 1, "p2": 0, "p3": 0, "p4": 0])
    let m7 = MarkingGraph(marking: ["p0": 0, "p1": 0, "p2": 0, "p3": 0, "p4": 1])
    let m8 = MarkingGraph(marking: ["p0": 0, "p1": 0, "p2": 1, "p3": 0, "p4": 0])
    let m9 = MarkingGraph(marking: ["p0": 0, "p1": 0, "p2": 0, "p3": 0, "p4": 0])

    m0.successors = ["t0": m1]
    m1.successors = ["t1": m2, "t3": m3]
    m2.successors = ["t2": m4, "t3": m5]
    m3.successors = ["t1": m5, "t4": m6]
    m4.successors = ["t3": m7]
    m5.successors = ["t2": m7, "t4": m8]
    m6.successors = ["t1": m8]
    m7.successors = ["t4": m9]
    m8.successors = ["t2": m9]

    // Write your code here ...
}

// Ex. 2: PetriNet 3
do {
    let m0 = MarkingGraph(marking: ["p0": 0, "p1": 2])
    let m1 = MarkingGraph(marking: ["p0": 1, "p1": 1])
    let m2 = MarkingGraph(marking: ["p0": 2, "p1": 0])

    m0.successors = ["t1": m1]
    m1.successors = ["t0": m1, "t1": m2]
    m2.successors = ["t2": m0]

    // Write your code here ...
}
