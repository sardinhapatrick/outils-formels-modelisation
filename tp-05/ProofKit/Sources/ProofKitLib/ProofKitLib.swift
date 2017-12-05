// SARDINHA Patrick

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
        case .proposition(_):
            return self
        case .negation(let a):
            switch a {
            case .proposition(_):
                return self
            case .negation(let b):
                return b.nnf
            case .disjunction(let b, let c):
                return (!b).nnf && (!c).nnf
            case .conjunction(let b, let c):
                return (!b).nnf || (!c).nnf
            case .implication(_):
                return (!a.nnf).nnf
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
        switch self.nnf { // Pour commencer, on repart de la nnf.
        case .proposition(_): // Dans le cas d'une proposition:
            return self.nnf // On la retourne à l'identique.
        case .negation(let a): // Dans le cas d'une négation:
            return (!a).nnf // On fait (¬a)
        case .disjunction(let b, let c): // Dans le cas d'une disjonction:
            switch b.cnf { // Si le premier terme est:
            case .conjunction(let d, let e): // - Une conjonction:
                return ((d.cnf || c.cnf) && (e.cnf || c.cnf)).cnf // Alors on distribue et les .cnf comme en haut permettent de rappeler la fonction récursivement.
            default: // Sinon on stoppe.
                break
            }
            switch c.cnf { // Si le deuxième terme est:
            case .conjunction(let d, let e): // - Une conjonction:
                return ((d.cnf || b.cnf) && (e.cnf || b.cnf)).cnf // Alors comme avant.
            default:
                break
            }
        case .conjunction(let b, let c): // Dans le cas d'une conjonction:
            return b.cnf && c.cnf // On retourne simplement celle-ci.
        case .implication(let b, let c): // Dans le cas d'une implication:
            return (!b).cnf || c.cnf // On fait la même chose que pour le nnf.
        }
        return self.nnf // On rappelle récursivement (pour implication)
    }

    /// The disjunction normal form of the formula.
    public var dnf: Formula {
        switch self.nnf { // On repart de la nnf.
        case .proposition(_): // Dans le cas d'une proposition:
            return self.nnf // On la retourne à l'identique.
        case .negation(_): // Dans le cas d'une négation:
            return self.nnf // On fait comme le nnf.
        case .disjunction(let b, let c): // Dans le cas d'une disjonction:
            return b.dnf || c.dnf // On retourne simplement.
        case .conjunction(let b, let c): // Pour une conjonction:
            switch b.dnf { // Si le premier terme est:
            case .disjunction(let d, let e): // - Une disjonction:
                return ((d.dnf && c.dnf) || (e.dnf && c.dnf)).dnf // Alors on distribue et on rappelle récursivement.
            default: // Sinon on stoppe.
                break
            }
            switch c.dnf { // Si le deuxième terme est:
            case .disjunction(let d, let e): // -Une disjonction:
                return ((d.dnf && b.dnf) || (e.dnf && b.dnf)).dnf // Idem.
            default:
                break
            }
        default:
            break
        }
        return self.nnf // Idem à la cnf.
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
