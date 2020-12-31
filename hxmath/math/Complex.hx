package hxmath.math;
/**
 * Complex - A Complex Float Type. 
 * @author: Nanjizal
 * initial version based on nanjizal/geom/matrix/Complex
 */
@:forward
abstract Complex( hxmath.math.Vector2 ) from hxmath.math.Vector2 to hxmath.math.Vector2 {
    
    // The number of elements in this structure 
    public static inline var elementCount:Int = 2;
    
    // Magnitude
    public var length(get, never):Float;
    
    // Zero Complex number
    public static var zero(get, never):Complex;
    
    // One real, 0 imaginary
    public static var identity(get, never):Complex;
    
    // 1 real, 0 imaginary
    public static var one(get, null):Complex;
    
    // Minus one real, 0 imaginary
    public static var minus1(get, null):Complex;
    
    // One real, one imaginary
    public static var unit(get, null):Complex;
    
    // One zero, one imaginary
    public static var i1(get, null):Complex;
    
    // One zero, minus one imaginary
    public static var iMinus1(get, null):Complex;
    
    // Minus Unit
    public static var minusUnit(get, null):Complex;
    
    // infinity, infinity i
    public static var unitInfinity(get, null):Complex;
    
    // 1, -infinity i
    public static var unitMinusInfinity(get, null):Complex;
    
    // infinity, 0 i
    public static var realInfinity(get, null):Complex;
    
    // -infinity, 0 i
    public static var minusInfinity(get, null):Complex;
    
    // 0, infinity i
    public static var iInfinity(get, null):Complex;
    
    // 0, - infinity i
    public static var iMinusInfinity(get, null):Complex;
    
    // infinity, - infinity
    public static var posNegInfinity(get, null):Complex;
    
    // -infinity, infinity
    public static var negPosInfinity(get, null):Complex;
    
    // pi + 0i
    public static var realPi(get, null):Complex;
    
    // -pi + 0i
    public static var minusPi(get, null):Complex;
    
    // 0 + pi i
    public static var iPi(get, null):Complex;
    
    // pi + pi i
    public static var unitPi(get, null):Complex;
    
    // -pi -pi i
    public static var unitMinusPi(get, null):Complex;
    
    // 0 + -pi i
    public static var iMinusPi(get, null):Complex;
    
    // pi + -pi i
    public static var posNegPi(get, null):Complex;
    
    // -pi + pi i
    public static var negPosPi(get, null):Complex;
    
    // tau + 0 i
    public static var realTau(get, null):Complex;
    
    // 0 + tau i
    public static var iTau(get, null):Complex;
    
    // tau + tau i
    public static var unitTau(get, null):Complex;
    
    // - tau - tau i
    public static var unitMinusTau(get, null):Complex;
    
    // 0 - tau i
    public static var iMinusTau(get, null):Complex;
    
    // -tau + 0
    public static var minusTau(get, null):Complex;
    
    // tau - tau i
    public static var posNegTau(get, null):Complex;
    
    // -tau + tau
    public static var negPosTau(get, null):Complex;
    
    // real part
    public var real(get, set):Float;
    inline function get_real(): Float
    {
        return this.x;
    }
    inline function set_real(r: Float){
        this.x = r;
        return r;
    }
    
    // complex part
    public var imaginary(get, set):Float;
    inline function get_imaginary():Float
    {
        return this.y;
    }
    inline function set_imaginary(i: Float):Float
    {
        this.y = i;
        return i;
    }
    
    // complex part small form
    public var i(get, set):Float;
    inline function get_i():Float
    {
       return this.y;
    }
    inline function set_i(v: Float):Float
    {
        this.y = v;
        return v;
    }
    
    /**
     * Constructor.
     * 
     * @param v     Vector2
     * @return      new Complex
     */
    public inline function new(real:Float, imaginary:Float)
    { 
        this = new Vector2(real, imaginary);
    }
    
    /**
     * fromString - allows construction via a String
     * 
     * @param s     String representation of a complex number eg: '1 + 2i'
     * @return      new Complex
     */
    @:from
    static public inline function fromString(s: String):Complex
    {
        var removeI = s.substr(0,s.length-1);
        var split = removeI.split('+');
        var c: Complex = Complex.zero;
        c.real = Std.parseFloat(split[0]);
        c.i = Std.parseFloat(split[1]);
        return c;
    }
    
    /**
     * fromRealImaginary - allows construction via an Object  { real: 1, imaginary: 2 }
     * 
     * @param c      { real: 1, imaginary: 2 }
     * @return      new Complex
     */
    @:from
    static public inline function fromRealImaginary(c:{ real:Float, imaginary:Float }):Complex
    {
        return new Complex(c.real, c.imaginary);
    }
    
    /**
     * fromReali - allows construction via an Object  { real: 1, i: 2 }
     * 
     * @param c      { real: 1, i: 2 }
     * @return      new Complex
     */
    @:from
    static public inline function fromReali(c:{ real:Float, i:Float }):Complex
    {
        return new Complex(c.real, c.i);
    }
    
    /**
     * toString - provides a brief output in the form  1 + 2i
     * 
     * @param c      { real: 1, imaginary: 2 }
     * @return      new Complex
     */
    @:to
    public inline function toString(): String
    {
        var r: Float = real;
        var i: Float = i;
        return '$r + $i i'; 
    }
    
    static inline function get_zero():Complex
    {
        return new Complex(0., 0.);
    }
    
    static inline function get_one():Complex
    {
        return new Complex(1., 0.);
    }

    static inline function get_minus1():Complex
    {
        return new Complex(-1., 0.);
    }
    
    static inline function get_identity():Complex{
        return get_unit();
    }
    
    static inline function get_unit():Complex
    {
        return new Complex(1., 1.);
    }

    static inline function get_i1():Complex
    {
        return new Complex(0., 1.);
    }    

    static inline function get_iMinus1():Complex
    {
        return new Complex(0., -1.);
    }

    static inline function get_minusUnit():Complex
    {
        return new Complex(-1., -1.);
    }

    static inline function get_unitInfinity():Complex
    {
        return new Complex(Math.POSITIVE_INFINITY, Math.POSITIVE_INFINITY);
    }

    static inline function get_unitMinusInfinity():Complex
    {
        return new Complex(Math.NEGATIVE_INFINITY, Math.NEGATIVE_INFINITY);
    }

    static inline function get_realInfinity():Complex
    {
        return new Complex(Math.POSITIVE_INFINITY, 0.);
    }

    static inline function get_minusInfinity():Complex
    {
        return new Complex(Math.NEGATIVE_INFINITY, 0.);
    }
    
    static inline function get_iInfinity():Complex
    {
        return new Complex(0., Math.POSITIVE_INFINITY);
    }

    static inline function get_iMinusInfinity():Complex
    {
        return new Complex(0., Math.NEGATIVE_INFINITY);
    }
    
    static inline function get_posNegInfinity():Complex
    {
        return new Complex(Math.POSITIVE_INFINITY, Math.NEGATIVE_INFINITY);
    }
    
    static inline function get_negPosInfinity():Complex
    {
        return new Complex(Math.NEGATIVE_INFINITY, Math.POSITIVE_INFINITY);
    }
    
    static inline function get_realPi():Complex
    {
        return new Complex((Math.PI),0);
    }
    
    static inline function get_iPi():Complex
    {
        return new Complex(0.,(Math.PI));
    }
    
    static inline function get_unitPi():Complex
    {
        return new Complex((Math.PI), (Math.PI));
    }
    
    static inline function get_unitMinusPi():Complex
    {
        return new Complex((-Math.PI), (-Math.PI));
    }
    
    static inline function get_iMinusPi():Complex
    {
        return new Complex( 0., (-Math.PI) );
    }
    
    static inline function get_minusPi():Complex
    {
        return new Complex( (-Math.PI), 0. );
    }

    static inline function get_posNegPi():Complex
    {
        return new Complex( (Math.PI), (-Math.PI) );
    }
    
    static inline function get_negPosPi():Complex
    {
        return new Complex( (-Math.PI), (Math.PI) );
    }
    
    static inline function get_realTau():Complex
    {
        return new Complex( (Math.PI*2), 0. );
    }
    
    static inline function get_iTau():Complex
    {
        return new Complex( 0., (Math.PI*2) );
    }
    
    static inline function get_unitTau():Complex
    {
        return new Complex((Math.PI*2), (Math.PI*2));
    }
    
    static inline function get_unitMinusTau():Complex
    {
        return new Complex((-Math.PI*2), (-Math.PI*2));
    }
    
    static inline function get_iMinusTau():Complex
    {
        return new Complex(0., (-Math.PI*2));
    }
    
    static inline function get_minusTau():Complex
    {
        return new Complex((-Math.PI*2), 0.);
    }
    
    static inline function get_posNegTau():Complex
    {
        return new Complex((Math.PI*2), (-Math.PI*2));
    }
    
    static inline function get_negPosTau():Complex
    {
        return new Complex((-Math.PI*2), (Math.PI*2));
    }

    public inline function clone():Complex
    {
        return new Complex(this.x, this.y);
    }
    
    public inline function swap():Complex
    {
        return new Complex(this.y, this.x);
    }
    
    @:op( A == B ) 
    public static inline function equal(a:Complex, b:Complex):Bool
    {
        var delta = 0.0000001;
        return !(Math.abs(a.x - b.x) >= delta || Math.abs(a.y - b.y) >= delta);
    }
    
    @:op(A != B) 
    public static inline function notEqual(a:Complex, b:Complex):Bool
    {
        return !equal(a, b);
    }
    
    @:op(A + B) 
    public static inline function add(a:Complex, b:Complex):Complex
    {
      	return new Complex(a.x + b.x, a.y + b.y);
    }
    
    @:op(A - B) 
    public static inline function subtract(a:Complex, b:Complex):Complex
    {
        return new Complex(a.x - b.x, a.y - b.y);
    }
    
    @:op(A * B) 
    public static inline function scale(a:Float, b:Complex):Complex
    {
        return new Complex(a * b.x , a * b.y);    
    }     
    
    @:op(A * B)
    public static inline function multiply(a:Complex, b:Complex):Complex
    {
        return new Complex((a.x * b.x ) - (a.y * b.y), (a.x * b.y) + (a.y * b.x));    
    }
    
    public inline function addExponents(): Float {
        return real + i;
    }
    
    @:op(~A)
    public static inline function conjugate(a:Complex):Complex
    {
        return new Complex(a.x, -a.y);
    }
    
    @:op(A / B)
    public static inline function divide(c1:Complex, c2:Complex):Complex
    {
        var conj = ~c2; 
        var numr = c1 * conj;
        var demr = c2 * conj;    
        var dval = demr.real + demr.i; 
        return new Complex(numr.real/dval, numr.i/dval);
    }
    
    @:op(-A) 
    public static inline function negate(a:Complex):Complex
    {
        return new Complex( -a.x, -a.y );
    }
    
    public inline function magnitudeSquared():Float
    {
        return this.x * this.x + this.y * this.y;
    }
    
    inline function get_length():Float
    {
        return Math.sqrt( magnitudeSquared() );
    }
    inline function set_length(l: Float):Float
    {
        var currentLength = get_length();
        return if( currentLength == 0. ){ 
            0.;
        } else {
            var mul = l / currentLength;
            this.x *= mul;
            this.y *= mul;
            l;
        }
    }
    
    public inline function phase():Float
    {
        return Math.atan2(i, real);
    }

    public inline function isReal():Bool
    {
        return i == 0;
    }

    public inline function isImaginary():Bool
    {
        return real == 0;
    }

    public static inline function cis(angle: Float):Complex
    {
       return new Complex(Math.cos(angle), Math.sin(angle));
    }
    
    public static inline function fromCircle(r:Float, angle:Float):Complex // ofPolar alternate name??
    {
        return r* cis( angle ); 
    }

    public static inline function square(c:Complex):Complex
    {
       return if(c.isReal() == true)
       {
            new Complex(c.real*c.real, 0);
       } else {
            //return magnitude * cis( theta );
            var here = new Complex(c.x, c.y);
            here*here;
       }
    }
    
    public static inline function exp(c:Complex):Complex
    {
       return if(c.isReal() == true)
       {
            new Complex(Math.exp(c.real), 0);
       } else {
            new Complex(Math.exp(c.real) * Math.cos(c.i), Math.exp(c.real) * Math.sin(c.i));
       }
    }

    public static inline function ln(c:Complex):Complex
    {
        return if(c.isReal() == true)
        {
            new Complex(Math.log(c.real), 0);
        } else {
            new Complex(0.5*Math.log(c.magnitudeSquared()), arg(c));
        }
    }

    public static inline function arg(c:Complex):Float
    {
        return if(c.real > 0.)
        {
            Math.atan(c.i/c.real);
        } else if(c.real < 0. && c.i >= 0.){
            Math.atan(c.i/c.real) + Math.PI;
        } else if(c.real < 0. && c.i < 0.){
            Math.atan(c.i/c.real) - Math.PI;
        } else if(c.real == 0. && c.i > 0.){
            Math.PI/2;
        } else if(c.real == 0. && c.i < 0.){
            -Math.PI/2;
        } else {
            throw 'Complex.zero does not have arg?';
        }
    }
    
    public inline function reciprocal():Complex
    {
        var scale = real*real + i*i;
        return new Complex( real / scale, -i / scale );
    }
    
    // pow using DeMoivre's Theorem
    public static inline function pow(c:Complex,n:Float):Complex
    {
        return if(c.isReal() == true)
        {
            new Complex(Math.pow( c.real, n),  0);
        } else {
            Math.pow(c.length , n)*cis(n*c.phase());
        }
    }
    
    /**
     * squareRoot see pow
     */
    public static inline function squareRoot(c:Complex):Complex
    {
        return pow(c, 0.5);
    }
    /**
     * root2 see pow
     */
    public inline function root2():Complex
    {
        return squareRoot(this);
    }
    
    public static inline function sin(c:Complex):Complex
    {
       return if(c.isReal() == true)
       {
            new Complex(Math.sin( c.real ), 0);
        } else { 
            new Complex(Math.sin(c.real) * Hyperbolic.cosh(c.i), Math.cos(c.real) * Hyperbolic.sinh(c.i));
        }
    }
    
    public static inline function cos(c:Complex):Complex
    {
        return if(c.isReal() == true)
        {
            new Complex(Math.cos(c.real), 0);
        } else {
            new Complex(Math.cos(c.real) * Hyperbolic.cosh(c.i), -Math.sin(c.real) * Hyperbolic.sinh(c.i));
        }
    }
    
    public static inline function tan(c:Complex):Complex
    {
        return if(c.isReal() == true)
        {
            new Complex(Math.tan( c.real ), 0);
        } else {
            var s = sin(c);
            var c = cos(c);
            s/c;
        }
    }
    
    public static inline function sinh( c:Complex ):Complex
    {
        return if(c.isReal() == true){
             new Complex(Hyperbolic.sinh(c.real), 0);
         } else { 
             new Complex(Hyperbolic.sinh(c.real) * Math.cos(c.i), Hyperbolic.cosh(c.real) * Math.sin(c.i));
         }
    }
    
    public static inline function cosh( c:Complex ):Complex
    {
        return if(c.isReal() == true)
        {
             new Complex(Hyperbolic.cosh(c.real),0);
         } else { 
             new Complex( Hyperbolic.cosh(c.real) * Math.cos(c.i), Hyperbolic.sinh(c.real) * Math.sin(c.i));
         }
    }
    
    public static inline function tanh(c:Complex ):Complex
    {
        return if(c.isReal() == true)
        {
             new Complex(Hyperbolic.tanh(c.real), 0);
         } else { 
             var hx = Hyperbolic.tanh(c.real);
             var ty = Math.tan(c.i);
             var n = new Complex(hx, ty);
             var d = new Complex(1, hx * ty);
             n/d;
         }
    }
}