infix operator =>: LogicalDisjunctionPrecedence

public protocol BooleanAlgebra {

    static prefix func ! (operand: Self) -> Self
    static        func ||(lhs: Self, rhs: @autoclosure () throws -> Self) rethrows -> Self
    static        func &&(lhs: Self, rhs: @autoclosure () throws -> Self) rethrows -> Self

}

extension Bool: BooleanAlgebra {}

public enum Formula {

    /// p
    case proposition(String)

    /// ¬a
    indirect case negation(Formula)

    public static prefix func !(formula: Formula) -> Formula {
        return .negation(formula)
    }

    /// a ∨ b
    indirect case disjunction(Formula, Formula)

    public static func ||(lhs: Formula, rhs: Formula) -> Formula {
        return .disjunction(lhs, rhs)
    }

    /// a ∧ b
    indirect case conjunction(Formula, Formula)

    public static func &&(lhs: Formula, rhs: Formula) -> Formula {
        return .conjunction(lhs, rhs)
    }

    /// a → b
    indirect case implication(Formula, Formula)

    public static func =>(lhs: Formula, rhs: Formula) -> Formula {
        return .implication(lhs, rhs)
    }

    /// The negation normal form of the formula.
    public var nnf: Formula {
        switch self {
        case .proposition(_): //si c'est une proposition alors fait rien
            return self
        case .negation(let a): // si negation de a alors
            switch a {
            case .proposition(_): // si a est une proposition alors fait rien
                return self
            case .negation(let b): // ici negation de b
                return b.nnf
            case .disjunction(let b, let c):
                return (!b).nnf && (!c).nnf
            case .conjunction(let b, let c):
                return (!b).nnf || (!c).nnf
            case .implication(_):
                return (!a.nnf).nnf // ou ()
            }
        case .disjunction(let b, let c):
            return b.nnf || c.nnf
        case .conjunction(let b, let c):
            return b.nnf && c.nnf
        case .implication(let b, let c):
            return (!b).nnf || c.nnf
        }
    }

    /// The conjunctive normal form of the formula.
    public var cnf: Formula {
        switch self {
        case .proposition(_):  // ---> OK
            return self

        case .negation(let a): // ---> OK
            switch a {
            case .proposition(_): // ---> OK
                return self
            case .negation(let b): // ---> OK
                return b.cnf
            case .disjunction(let b, let c): // ---> OK
                return (!b).cnf && (!c).cnf
            case .conjunction(let b, let c): // ---> OK
                return (!b).cnf || (!c).cnf
            case .implication(_): // ---> OK
                return (!a.cnf).cnf
            }

        case .disjunction(let b, let c):  // ---> OK PRESQUE
            switch b {
            case .proposition(_): // OK
                switch c {
                case .proposition(_):
                    return (b.cnf || c.cnf) // self // ---> OK
                case .negation(let d): // ---> OK
                    /*switch d {
                    case .proposition(_):
                        return self
                    case .negation(let d):
                        return b.cnf || d.cnf
                    case .disjunction(let d, let e):
                        return ((b.cnf || (!d).cnf) && (b.cnf || (!e).cnf)).cnf
                    case .conjunction(let f, let g):
                        return (b.cnf || (!f).cnf || (!g).cnf).cnf
                    case .implication(_): // ---> ?
                        return (!c.cnf).cnf
                    }*/
                    return b.cnf || (!d).cnf

                case .disjunction(let d, let e): // ---> OK
                    return (b.cnf || d.cnf || e.cnf).cnf
                case .conjunction(let d, let e): // ---> OK
                    return ((b.cnf || d.cnf) && (b.cnf || e.cnf)).cnf
                case .implication(let d, let e): // ---> ? case .implication(_):
                    return b.cnf || (!c.cnf).cnf // INVERSE SIGNES non
              }
            case .negation(let d):
                switch c {
                case .proposition(_): // OK
                    return ((!d).cnf || c.cnf).cnf
                case .negation(let e): // OK
                    return ((!d).cnf || (!e).cnf).cnf
                case .disjunction(let e, let f): // OK
                    return (!d).cnf || (e.cnf || f.cnf).cnf
                    //return ((!d).cnf || (e.cnf || f.cnf).cnf) || ((!d).cnf || (e.cnf || f.cnf).cnf) PAS OK
                case .conjunction(let e, let f): // OK
                    return ((!d).cnf || (e.cnf).cnf) && ((!d).cnf || (f.cnf).cnf) // distribue pas
                    //return (((!d).cnf || e.cnf) && ((!d).cnf || f.cnf)).cnf
                case .implication(_): // ---> ?
                    return (!c.cnf).cnf
                    // return (((!d).cnf || (!f).cnf) || ((!d).cnf || g.cnf)).cnf
                }
            case .disjunction(let d, let e):
                switch c {
                case .proposition(_): // OK
                    return (c.cnf || d.cnf || e.cnf)
                case .negation(let f): // NORMAELEMNT OK
                    return ((!f).cnf || (d.cnf).cnf) || ((!f).cnf || (e.cnf).cnf)
                case .disjunction(let f, let g): // OK
                    return (d.cnf || e.cnf || f.cnf || g.cnf).cnf
                case .conjunction(let f, let g): // NORMAELEMNT OK
                    return ((d.cnf || e.cnf || f.cnf) && (d.cnf || e.cnf || g.cnf)).cnf
                case .implication(_): // ----> ?
                    return (!c.cnf).cnf
                    //(!d).cnf && (!e).cnf && f.cnf && (!g).cnf
                    // e.cnf || d.cnf || (!f).cnf || g.cnf
                }

            case .conjunction(let d, let e): // mettre des .cnf
                switch c {
                case .proposition(_):
                    return ((c.cnf || d.cnf).cnf && (c.cnf || e.cnf).cnf).cnf // OK
                case .negation(let f): // OKKKKKKKKKKK
                    return ((!f).cnf || (d.cnf).cnf) && ((!f).cnf || (e.cnf).cnf)
                case .disjunction(let f, let g): // OK
                    return ((f.cnf || g.cnf || d.cnf) && (f.cnf || g.cnf || e.cnf)).cnf
                case .conjunction(let f, let g): // OK NICE
                    return ((d.cnf || f.cnf).cnf && (e.cnf || f.cnf).cnf && (d.cnf || g.cnf).cnf && (e.cnf || g.cnf).cnf).cnf // ?
                case .implication(_): // ---> ?
                    return (!c.cnf).cnf
                }

            case .implication(_): // ---> ? SWITCH
                return (!b.cnf).cnf
          }

        case .conjunction(let b, let c):  // ---> X
            switch b {
            case .proposition(_):
                switch c {
                case .proposition(_): // OK
                    return (b.cnf && c.cnf)
                case .negation(let d):
                    return b.cnf && (!d).cnf // WTF f14
                case .disjunction(let d, let e):
                    return ((b.cnf && d.cnf) || (b.cnf && e.cnf)).cnf // Ok ?
                case .conjunction(let d, let e):
                    return (b.cnf && d.cnf && e.cnf).cnf // OK?
                case .implication(_): // ---> ?
                    return (!c.cnf).cnf
                    // return (b.cnf && (!d.cnf || e.cnf)).cnf
            }
            case .negation(let d):
                switch c {
                case .proposition(_): // OK
                    return ((!d).cnf && c.cnf).cnf
                case .negation(let e): // OK?? .cnf
                    return ((!d).cnf && (!e).cnf)
                case .disjunction(let e, let f): // ??
                    //return ((!d).cnf || e.cnf || f.cnf).cnf
                    return (!d).cnf && (c.cnf)
                case .conjunction(let e, let f): // PAS OK
                    return (((!d).cnf && e.cnf) && ((!d).cnf || f.cnf)).cnf
                case .implication(_): // ---> ?
                    return (!c.cnf).cnf
                  // return (((!d).cnf || (!f).cnf) || ((!d).cnf || g.cnf)).cnf
                }
            case .disjunction(let d, let e):
                switch c {
                case .proposition(_): // OK PRENDRE CAAAA C'EST BONNNNN
                    return c.cnf && (d.cnf || e.cnf).cnf
                case .negation(let f): // OKKK
                    return (!f).cnf && (d.cnf || e.cnf).cnf
                case .disjunction(let f, let g): // Ok
                    return (d.cnf || e.cnf).cnf && (f.cnf || g.cnf).cnf
                case .conjunction(let f, let g): // OK
                    return ((d.cnf || e.cnf) && f.cnf && g.cnf).cnf
                case .implication(_): // X
                    return (!c.cnf).cnf
              }
            case .conjunction(let d, let e):
                switch c {
                case .proposition(_): // OKKKK ---> PAS FAIRE SUR C
                    return c.cnf && (d.cnf && e.cnf).cnf
                case .negation(let f): // OK ?
                    return (!f.cnf && d.cnf && e.cnf).cnf
                case .disjunction(let f, let g): // X ?? test
                    return (d.cnf && e.cnf).cnf && (f.cnf || g.cnf).cnf
                case .conjunction(let f, let g): // OK
                    return (d.cnf && e.cnf && f.cnf && g.cnf).cnf
                case .implication(_): // --
                    return (!c.cnf).cnf

              }
            case .implication(_):
                return (!b.cnf).cnf
            }

        case .implication(let b, let c):  // ---> OK
            return (!b).cnf || c.cnf
        }
    }


    /// The disjunctive normal form of the formula.
    public var dnf: Formula {
        // Write your code here ...
        return self
    }

    /// The propositions the formula is based on.
    ///
    ///     let f: Formula = (.proposition("p") || .proposition("q"))
    ///     let props = f.propositions
    ///     // 'props' == Set<Formula>([.proposition("p"), .proposition("q")])
    public var propositions: Set<Formula> {
        switch self {
        case .proposition(_):
            return [self]
        case .negation(let a):
            return a.propositions
        case .disjunction(let a, let b):
            return a.propositions.union(b.propositions)
        case .conjunction(let a, let b):
            return a.propositions.union(b.propositions)
        case .implication(let a, let b):
            return a.propositions.union(b.propositions)
        }
    }

    /// Evaluates the formula, with a given valuation of its propositions.
    ///
    ///     let f: Formula = (.proposition("p") || .proposition("q"))
    ///     let value = f.eval { (proposition) -> Bool in
    ///         switch proposition {
    ///         case "p": return true
    ///         case "q": return false
    ///         default : return false
    ///         }
    ///     })
    ///     // 'value' == true
    ///
    /// - Warning: The provided valuation should be defined for each proposition name the formula
    ///   contains. A call to `eval` might fail with an unrecoverable error otherwise.
    public func eval<T>(with valuation: (String) -> T) -> T where T: BooleanAlgebra {
        switch self {
        case .proposition(let p):
            return valuation(p)
        case .negation(let a):
            return !a.eval(with: valuation)
        case .disjunction(let a, let b):
            return a.eval(with: valuation) || b.eval(with: valuation)
        case .conjunction(let a, let b):
            return a.eval(with: valuation) && b.eval(with: valuation)
        case .implication(let a, let b):
            return !a.eval(with: valuation) || b.eval(with: valuation)
        }
    }

}

extension Formula: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self = .proposition(value)
    }

}

extension Formula: Hashable {

    public var hashValue: Int {
        return String(describing: self).hashValue
    }

    public static func ==(lhs: Formula, rhs: Formula) -> Bool {
        switch (lhs, rhs) {
        case (.proposition(let p), .proposition(let q)):
            return p == q
        case (.negation(let a), .negation(let b)):
            return a == b
        case (.disjunction(let a, let b), .disjunction(let c, let d)):
            return (a == c) && (b == d)
        case (.conjunction(let a, let b), .conjunction(let c, let d)):
            return (a == c) && (b == d)
        case (.implication(let a, let b), .implication(let c, let d)):
            return (a == c) && (b == d)
        default:
            return false
        }
    }

}

extension Formula: CustomStringConvertible {

    public var description: String {
        switch self {
        case .proposition(let p):
            return p
        case .negation(let a):
            return "¬\(a)"
        case .disjunction(let a, let b):
            return "(\(a) ∨ \(b))"
        case .conjunction(let a, let b):
            return "(\(a) ∧ \(b))"
        case .implication(let a, let b):
            return "(\(a) → \(b))"
        }
    }

}
