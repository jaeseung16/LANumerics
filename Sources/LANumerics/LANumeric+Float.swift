import Accelerate
import Numerics

extension Float : LANumeric {
    
    public var manhattanLength : Float { return magnitude }
    
    public var adjoint : Float { return self }
    
    public var length : Self.Magnitude { return magnitude }
    
    public var lengthSquared : Self.Magnitude { return magnitude * magnitude }
    
    public var toInt : Int {
        return Int(self)
    }

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

    public static func blas_scal(_ N : Int32, _ alpha : Self, _ X : UnsafeMutablePointer<Self>, _ incX : Int32) {
        cblas_sscal(N, alpha, X, incX)
    }

    public static func blas_axpby(_ N : Int32, _ alpha : Self, _ X : UnsafePointer<Self>, _ incX : Int32, _ beta : Self, _ Y : UnsafeMutablePointer<Self>, _ incY : Int32) {
        catlas_saxpby(N, alpha, X, incX, beta, Y, incY)
    }
    
    public static func blas_iamax(_ N : Int32, _ X : UnsafePointer<Self>, _ incX : Int32) -> Int32 {
        cblas_isamax(N, X, incX)
    }

    public static func blas_iamax_inf(_ N : Int32, _ X : UnsafePointer<Self>, _ incX : Int32) -> Int32 {
        cblas_isamax(N, X, incX)
    }

    public static func blas_dot(_ N : Int32, _ X : UnsafePointer<Self>, _ incX : Int32, _ Y : UnsafePointer<Self>, _ incY : Int32) -> Self {
        cblas_sdot(N, X, incX, Y, incY)
    }
    
    public static func blas_adjointDot(_ N : Int32, _ X : UnsafePointer<Self>, _ incX : Int32, _ Y : UnsafePointer<Self>, _ incY : Int32) -> Self {
        cblas_sdot(N, X, incX, Y, incY)
    }

    public static func blas_gemm(_ Order : CBLAS_ORDER, _ TransA : CBLAS_TRANSPOSE, _ TransB : CBLAS_TRANSPOSE,
                                 _ M : Int32, _ N : Int32, _ K : Int32,
                                 _ alpha : Self, _ A : UnsafePointer<Self>, _ lda : Int32, _ B : UnsafePointer<Self>, _ ldb : Int32,
                                 _ beta : Self, _ C : UnsafeMutablePointer<Self>, _ ldc : Int32)
    {
        cblas_sgemm(Order, TransA, TransB, M, N, K, alpha, A, lda, B, ldb, beta, C, ldc)
    }

    public static func blas_gemv(_ Order : CBLAS_ORDER, _ TransA : CBLAS_TRANSPOSE, _ M : Int32, _ N : Int32,
                                 _ alpha : Self, _ A : UnsafePointer<Self>, _ lda : Int32,
                                 _ X : UnsafePointer<Self>, _ incX : Int32,
                                 _ beta : Self, _ Y : UnsafeMutablePointer<Self>, _ incY : Int32)
    {
        cblas_sgemv(Order, TransA, M, N, alpha, A, lda, X, incX, beta, Y, incY)
    }

    public static func blas_ger(_ Order : CBLAS_ORDER, _ M : Int32, _ N : Int32,
                                _ alpha : Self, _ X : UnsafePointer<Self>, _ incX : Int32,
                                _ Y : UnsafePointer<Self>, _ incY : Int32,
                                _ A : UnsafeMutablePointer<Self>, _ lda : Int32)
    {
        cblas_sger(Order, M, N, alpha, X, incX, Y, incY, A, lda)
    }

    public static func blas_gerAdjoint(_ Order : CBLAS_ORDER, _ M : Int32, _ N : Int32,
                                       _ alpha : Self, _ X : UnsafePointer<Self>, _ incX : Int32,
                                       _ Y : UnsafePointer<Self>, _ incY : Int32,
                                       _ A : UnsafeMutablePointer<Self>, _ lda : Int32)
    {
        cblas_sger(Order, M, N, alpha, X, incX, Y, incY, A, lda)
    }

    public static func lapack_gesv(_ n : UnsafeMutablePointer<IntLA>, _ nrhs : UnsafeMutablePointer<IntLA>,
                                   _ a : UnsafeMutablePointer<Self>, _ lda : UnsafeMutablePointer<IntLA>,
                                   _ ipiv : UnsafeMutablePointer<IntLA>,
                                   _ b : UnsafeMutablePointer<Self>, _ ldb : UnsafeMutablePointer<IntLA>,
                                   _ info : UnsafeMutablePointer<IntLA>) -> Int32
    {
        sgesv_(n, nrhs, a, lda, ipiv, b, ldb, info)
    }
    
    public static func lapack_gels(_ trans : Transpose,
                                   _ m : UnsafeMutablePointer<IntLA>, _ n : UnsafeMutablePointer<IntLA>, _ nrhs : UnsafeMutablePointer<IntLA>,
                                   _ a : UnsafeMutablePointer<Self>, _ lda : UnsafeMutablePointer<IntLA>,
                                   _ b : UnsafeMutablePointer<Self>, _ ldb : UnsafeMutablePointer<IntLA>,
                                   _ work : UnsafeMutablePointer<Self>, _ lwork : UnsafeMutablePointer<IntLA>,
                                   _ info : UnsafeMutablePointer<IntLA>) -> Int32
    {
        var trans : Int8 = trans.blas(complex: false)
        return sgels_(&trans, m, n, nrhs, a, lda, b, ldb, work, lwork, info)
    }

    public static func lapack_gesvd(_ jobu : UnsafeMutablePointer<Int8>, _ jobvt : UnsafeMutablePointer<Int8>,
                                    _ m : UnsafeMutablePointer<IntLA>, _ n : UnsafeMutablePointer<IntLA>,
                                    _ a : UnsafeMutablePointer<Self>, _ lda : UnsafeMutablePointer<IntLA>,
                                    _ s : UnsafeMutablePointer<Self.Magnitude>,
                                    _ u : UnsafeMutablePointer<Self>, _ ldu : UnsafeMutablePointer<IntLA>,
                                    _ vt : UnsafeMutablePointer<Self>, _ ldvt : UnsafeMutablePointer<IntLA>,
                                    _ work : UnsafeMutablePointer<Self>, _ lwork : UnsafeMutablePointer<IntLA>,
                                    _ info : UnsafeMutablePointer<IntLA>) -> Int32
    {
        sgesvd_(jobu, jobvt, m, n, a, lda, s, u, ldu, vt, ldvt, work, lwork, info)
    }
    
    public static func lapack_heev(_ jobz : UnsafeMutablePointer<Int8>, _ uplo : UnsafeMutablePointer<Int8>, _ n : UnsafeMutablePointer<IntLA>,
                                   _ a : UnsafeMutablePointer<Self>, _ lda : UnsafeMutablePointer<IntLA>,
                                   _ w : UnsafeMutablePointer<Self.Magnitude>,
                                   _ work : UnsafeMutablePointer<Self>, _ lwork : UnsafeMutablePointer<IntLA>,
                                   _ info : UnsafeMutablePointer<IntLA>) -> Int32
    {
        ssyev_(jobz, uplo, n, a, lda, w, work, lwork, info)
    }
    
    public static func lapack_gees(_ jobvs : UnsafeMutablePointer<Int8>, _ n : UnsafeMutablePointer<IntLA>,
                                   _ a : UnsafeMutablePointer<Self>, _ lda : UnsafeMutablePointer<IntLA>,
                                   _ wr : UnsafeMutablePointer<Self.Magnitude>,
                                   _ wi : UnsafeMutablePointer<Self.Magnitude>,
                                   _ vs : UnsafeMutablePointer<Self>, _ ldvs : UnsafeMutablePointer<IntLA>,
                                   _ work : UnsafeMutablePointer<Self>, _ lwork : UnsafeMutablePointer<IntLA>,
                                   _ info : UnsafeMutablePointer<IntLA>) -> Int32
    {
        var sort : Int8 = 0x4E /* "N" */
        var sdim : IntLA = 0
        return sgees_(jobvs, &sort, nil, n, a, lda , &sdim, wr, wi, vs, ldvs, work, lwork, nil, info)
    }
    
    public static func vDSP_elementwise_absolute(_ v : [Self]) -> [Self.Magnitude] {
        var result : [Self.Magnitude] = Array(repeating: 0, count: v.count)
        vDSP_vabs(v, 1, &result, 1, vDSP_Length(v.count))
        return result
    }

    public static func vDSP_elementwise_adjoint(_ v : [Self]) -> [Self] {
        return v
    }
    
    public static func vDSP_elementwise_multiply(_ u : [Self], _ v : [Self]) -> [Self] {
        let N = u.count
        precondition(N == v.count)
        var result : [Self] = Array(repeating: 0, count: N)
        vDSP_vmul(u, 1, v, 1, &result, 1, vDSP_Length(N))
        return result
    }

    public static func vDSP_elementwise_divide(_ u : [Self], _ v : [Self]) -> [Self] {
        let N = u.count
        precondition(N == v.count)
        var result : [Self] = Array(repeating: 0, count: N)
        vDSP_vdiv(v, 1, u, 1, &result, 1, vDSP_Length(N))
        return result
    }

}
