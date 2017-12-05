// SARDINHA Patrick

import ProofKitLib

let a: Formula = "a"
let b: Formula = "b"
let c: Formula = "c"
let d: Formula = "d"
let e: Formula = "e"
let f: Formula = "f"
let g: Formula = "g"
let h: Formula = "h"


// Testons les fonctions nnf, cnf et dnf pour les fonctions suivantes:
print("\nTestons les fonctions nnf, cnf et dnf pour les formules suivantes:\n")
//print("\n")

print("===== f1 ======")
let f1 = (!d) || ((a && c) && (c || g))
print("formula : \(f1)")
print("nnf : \(f1.nnf)") // ------> Pour obtenir le NNF de la formule.
print("cnf : \(f1.cnf)") // ------> Pour obtenir le CNF de la formule.
print("dnf : \(f1.dnf)") // ------> Pour obtenir le DNF de la formule.
print("\n")

print("===== f2 ======")
let f2 = (a || d) && (c || !(b || g))
print("formula : \(f2)")
print("nnf : \(f2.nnf)")
print("cnf : \(f2.cnf)")
print("dnf : \(f2.dnf)")
print("\n")

print("===== f3 ======")
let f3 = (a || d) => (c || !(b => g))
print("formula : \(f3)")
print("nnf : \(f3.nnf)")
print("cnf : \(f3.cnf)")
print("dnf : \(f3.dnf)")
print("\n")

print("===== f4 ======")
let f4 = (d || g) && (a => (b => c))
print("formula : \(f4)")
print("nnf : \(f4.nnf)")
print("cnf : \(f4.cnf)")
print("dnf : \(f4.dnf)")
print("\n")

print("===== f5 ======")
let f5 = (a) && (b || d)
print("formula : \(f5)")
print("nnf : \(f5.nnf)")
print("cnf : \(f5.cnf)")
print("dnf : \(f5.dnf)")
print("\n")


/*
let booleanEvaluation = f.eval { (proposition) -> Bool in
    switch proposition {
        case "p": return true
        case "q": return false
        default : return false
    }
}
print(booleanEvaluation)

enum Fruit: BooleanAlgebra {

    case apple, orange

    static prefix func !(operand: Fruit) -> Fruit {
        switch operand {
        case .apple : return .orange
        case .orange: return .apple
        }
    }

    static func ||(lhs: Fruit, rhs: @autoclosure () throws -> Fruit) rethrows -> Fruit {
        switch (lhs, try rhs()) {
        case (.orange, .orange): return .orange
        case (_ , _)           : return .apple
        }
    }

    static func &&(lhs: Fruit, rhs: @autoclosure () throws -> Fruit) rethrows -> Fruit {
        switch (lhs, try rhs()) {
        case (.apple , .apple): return .apple
        case (_, _)           : return .orange
        }
    }

}

let fruityEvaluation = f.eval { (proposition) -> Fruit in
    switch proposition {
        case "p": return .apple
        case "q": return .orange
        default : return .orange
    }
}
print(fruityEvaluation)
*/
