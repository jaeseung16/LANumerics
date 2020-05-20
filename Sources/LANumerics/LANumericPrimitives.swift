import Foundation
import Numerics
import Accelerate

public protocol LANumericPrimitives : MatrixElement, Numeric, ExpressibleByFloatLiteral {
    
    init(magnitude : Self.Magnitude)

    var manhattanLength : Self.Magnitude { get }
    
    var length : Self.Magnitude { get }
    
    var lengthSquared : Self.Magnitude { get }
        
    static func random(in : ClosedRange<Self.Magnitude>) -> Self

    static func randomWhole(in : ClosedRange<Int>) -> Self
    
    static func blas_asum(_ N : Int32, _ X : UnsafePointer<Self>, _ incX : Int32) -> Self.Magnitude
    
    static func blas_nrm2(_ N : Int32, _ X : UnsafePointer<Self>, _ incX : Int32) -> Self.Magnitude
    
}

extension Float : LANumericPrimitives {
    
    public var manhattanLength : Float { return magnitude }
    
    public var adjoint : Float { return self }
    
    public var length : Self.Magnitude { return magnitude }
    
    public var lengthSquared : Self.Magnitude { return magnitude * magnitude }

    public init(magnitude: Self.Magnitude) {
        self = magnitude
    }

    public static func randomWhole(in range : ClosedRange<Int>) -> Self {
        return Float(Int.random(in: range))
    }

    public static func blas_asum(_ N: Int32, _ X: UnsafePointer<Self>, _ incX: Int32) -> Self.Magnitude {
        return cblas_sasum(N, X, incX)
    }
    
    public static func blas_nrm2(_ N: Int32, _ X: UnsafePointer<Self>, _ incX: Int32) -> Self.Magnitude {
        return cblas_snrm2(N, X, incX)
    }

}

extension Double : LANumericPrimitives {
        
    public var manhattanLength : Double { return magnitude }

    public var adjoint : Double { return self }

    public var length : Self.Magnitude { return magnitude }
    
    public var lengthSquared : Self.Magnitude { return magnitude * magnitude }

    public init(magnitude: Self.Magnitude) {
        self = magnitude
    }

    public static func randomWhole(in range : ClosedRange<Int>) -> Self {
        return Double(Int.random(in: range))
    }

    public static func blas_asum(_ N: Int32, _ X: UnsafePointer<Self>, _ incX: Int32) -> Self.Magnitude {
        return cblas_dasum(N, X, incX)
    }
    
    public static func blas_nrm2(_ N: Int32, _ X: UnsafePointer<Self>, _ incX: Int32) -> Self.Magnitude {
        return cblas_dnrm2(N, X, incX)
    }

}

extension Complex : ExpressibleByFloatLiteral {

    public typealias FloatLiteralType = Double
    
    public init(floatLiteral: Self.FloatLiteralType) {
        let x : RealType
        if RealType.self == Float.self {
            x = Float(floatLiteral) as! RealType
        } else if RealType.self == Double.self {
            x = Double(floatLiteral) as! RealType
        } else {
            fatalError()
        }
        self.init(x)
    }
    
}


/*fileprivate func recast<U, V>(_ X : UnsafePointer<U>) -> UnsafePointer<V> {
    let _X = UnsafeRawPointer(X)
    return _X.assumingMemoryBound(to: V.self)
}*/

extension Complex : LANumericPrimitives {
        
    public var manhattanLength : Magnitude { return real.magnitude + imaginary.magnitude }

    public var adjoint : Complex { return self.conjugate }

    public init(magnitude: Self.Magnitude) {
        self = Complex(magnitude, 0)
    }

    public static func random(in range: ClosedRange<RealType>) -> Self {
        if RealType.self == Float.self {
            let r = range as! ClosedRange<Float>
            let x = Float.random(in: r) as! RealType
            let y = Float.random(in: r) as! RealType
            return Complex(x, y)
        } else if RealType.self == Double.self {
            let r = range as! ClosedRange<Double>
            let x = Double.random(in: r) as! RealType
            let y = Double.random(in: r) as! RealType
            return Complex(x, y)
        } else {
            fatalError()
        }
    }
    
    public static func randomWhole(in range : ClosedRange<Int>) -> Self {
        if RealType.self == Float.self {
            let x = Float.randomWhole(in: range) as! RealType
            let y = Float.randomWhole(in: range) as! RealType
            return Complex(x, y)
        } else if RealType.self == Double.self {
            let x = Double.randomWhole(in: range) as! RealType
            let y = Double.randomWhole(in: range) as! RealType
            return Complex(x, y)
        } else {
            fatalError()
        }
    }

    public static func blas_asum(_ N: Int32, _ X: UnsafePointer<Self>, _ incX: Int32) -> Self.Magnitude {
        if RealType.self == Float.self {
            return cblas_scasum(N, X, incX) as! Self.Magnitude
        } else if RealType.self == Double.self {
            return cblas_dzasum(N, X, incX) as! Self.Magnitude
        } else {
            fatalError()
        }
    }
    
    public static func blas_nrm2(_ N: Int32, _ X: UnsafePointer<Self>, _ incX: Int32) -> Self.Magnitude {
        if RealType.self == Float.self {
            return cblas_scnrm2(N, X, incX) as! Self.Magnitude
        } else if RealType.self == Double.self {
            return cblas_dznrm2(N, X, incX) as! Self.Magnitude
        } else {
            fatalError()
        }
    }

}

