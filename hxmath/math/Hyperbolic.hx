package hxmath.math;
/** Hyperbolic
 * @author: Nanjizal
 * initial version based on nanjizal/geom/curve/Hyperbolic
 */

// Hyperbolic functions may also be deduced from trigonometric functions with complex arguments
// Some functions not provided in Haxe Math.
// Created using polyfills.
class Hyperbolic {
    
    /**
     * Arc Tan Hypobolic 
     *
     * @param angle
     * @return 
     */
    public static inline function sinh(x: Float):Float 
    {
        var y = Math.exp( x );
        return ( y - 1. / y ) / 2.;
    }
    
    /**
     * cosec Hypobolic 
     *
     * @param angle
     * @return 
     */
    public static inline function cosech(x: Float):Float 
    {
        return 1 / sinh(x);
    }
    
    /**
     * Sec Hypobolic 
     *
     * @param angle
     * @return   
     */
    public static inline function sech(x: Float):Float 
    {
        return 1 / cosh(x);
    }
    
    /**
     * Cosine Hypobolic 
     *
     * @param angle
     * @return       
     */
    public static inline function cosh(x: Float):Float 
    {
        var y = Math.exp( x );
        return ( y + 1. / y ) / 2.;
    }
    
    /**
     * Cot Hypobolic 
     *
     * @param angle
     * @return       
     */
    public static inline function coth(x:Float):Float 
    {
        return cosh(x) / sinh(x);
    }
    
    /**
     * Tan Hypobolic 
     *
     * @param angle
     * @return       
     */
    public static inline function tanh(x: Float):Float 
    {
        var a = Math.exp(x);
        var b = Math.exp(-x);
        return if(a == Math.POSITIVE_INFINITY)
        {
            1.;
        } else {
            if(b == Math.POSITIVE_INFINITY)
            {
                -1.;
            } else {
                (a - b) / (a + b);
            }
        }
    }
    
    /**
     * Arc Cosine Hypobolic 
     *
     * @param x
     * @return       angle
     */
    public static inline function acosh(x: Float):Float 
    {
        return Math.log(x + Math.sqrt(x * x - 1.));
    }
    
    /**
     * Arc Sine Hypobolic 
     *
     * @param x
     * @return       angle
     */
    public static inline function asinh(x: Float): Float 
    {
        return Math.log(x + Math.sqrt(x * x + 1.));
    }
    
    /**
     * Arc Tan Hypobolic 
     *
     * @param x
     * @return       angle
     */
    public static inline function atanh( x: Float ): Float 
    {
        return Math.log((1. + x) / (1. - x)) / 2.;
    }
}