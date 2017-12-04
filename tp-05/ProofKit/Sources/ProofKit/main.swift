import ProofKitLib

let a: Formula = "a"
let b: Formula = "b"

// ----- //
let ftest = a && b
print(ftest)
// ----- //


// Test pour ex-09 //
let c: Formula = "c"
let d: Formula = "d"
let e: Formula = "e"
let f: Formula = "f"
let f1 = !(a && (b || c))
let f2 = (a => b) || !(a && c)
let f3 = (!a || b && c) && a
let f4 = (!a && b) || !c
let f5 = (a || (a || b)) || (c && d)
let f6 = (a && (e && f)) || (c && d)
let f7 = (a) || !(c && !(b && !(d && e)))
let f8 = (a) || !(b || c)
let f9 = (a || b) || (c && (d && e))
let f10 = !(a) || !(b && !(c && d))
let f11 = (a && b) || !(c && (d && e)) // a test 155
let f12 = (a || b) || !(c && (d || e))
let f13 = a && (c && (d || e))
let f14 = b || !(d && a)
let f15 = (!d) || (e || (f && a)) // 128
let f16 = ((a || f) && b) || (c && (d && e))
let f17 = (!d) || ((a || b) && (c || e))
let f18 = b || (e || (f && a))
let f19 = b || (d => e)
let f20 = (a || (b || (c && a)))

print("f1:")
print("formula : \(f1)")
print("nnf : \(f1.nnf)") // ------> Pour obtenir le NNF de f2
print("cnf : \(f1.cnf)")

print("TEST")
print("formula : \(f20)")
print("nnf : \(f20.nnf)")
print("cnf : \(f20.cnf)")
//print("dnf : \(f1.dnf)")
// -------------- //
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
