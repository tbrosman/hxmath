package hxmath.math;

@:enum
abstract Orient2DResult(Int)
{
    var Left = 1;
    var Colinear = 0;
    var Right = -1;
}

class MathUtil
{
    // Standard epsilon value
    public static inline var eps = 1e-6;
    
    /**
     * Int max.
     * 
     * @param a
     * @param b
     * @return  max(a, b)
     */
    public static inline function intMax(a:Int, b:Int):Int
    {
        return b > a ? b : a;
    }
    
    /**
     * Int min.
     * 
     * @param a
     * @param b
     * @return  min(a, b)
     */
    public static inline function intMin(a:Int, b:Int):Int
    {
        return b < a ? b : a;
    }
    
    /**
     * Linear inteprolation for a cyclic coordinate.
     * 
     * @param a     The value at t = 0
     * @param b     The value at t = 1
     * @param t     A float in the range [0, 1]
     * @param max   a, b are numbers in a range [0, max) (e.g. for degrees: [0, 360))
     * @return      The interpolated value
     */
    public static inline function lerpCyclic(a:Float, b:Float, t:Float, max:Float):Float
    {
        // If the difference between the two is greater than one half cycle
        if (Math.abs(a - b) > 0.5 * max)
        {
            // Add one cycle to the smaller number
            if (a < b)
            {
                a += max;
            }
            else
            {
                b += max;
            }
        }
        
        return MathUtil.wrap((1.0 - t) * a + t * b, max);
    }
    
    /**
     * The sign function with a tolerance.
     * 
     * @param   x   The number to test.
     * @param   w   The width of the deadzone.
     * @return  Possible results: {-1, 0, +1}
     */
    public static inline function sign(x:Float, w:Float = 0):Int
    {
        if (Math.abs(x) < w)
        {
            return 0;
        }
        else
        {
            return x <= -w ? -1 : 1;
        }
    }
    
    /**
     * Find the minimum distance between two ranges.
     * 
     * @param aStart
     * @param aWidth
     * @param bStart
     * @param bWidth
     * @return          The minimum distance between two ranges.
     */
    public static inline function rangeDistance(aStart:Float, aWidth:Float, bStart:Float, bWidth:Float):Float
    {
        if (aStart + aWidth < bStart)
        {
            return bStart - (aStart + aWidth);
        }
        else if (bStart + bWidth < aStart)
        {
            return aStart - (bStart + bWidth);
        }
        else
        {
            return 0;
        }
    }
    
    /**
     * Check to see if the open range (aStart, aStart + aWidth) contains the value x.
     * 
     * @param aStart
     * @param aWidth
     * @param x
     * @return          True if the range contains x.    
     */
    public static inline function openRangeContains(aStart:Float, aWidth:Float, x:Float):Bool
    {
        return (x > aStart) &&
            (x < aStart + aWidth);
    }
    
    /**
     * Check to see if the open ranges (aStart, aStart + aWidth) and (bStart, bStart + bWidth) intersect.
     * 
     * @param    aStart
     * @param    aWidth
     * @param    bStart
     * @param    bWidth
     * @return              True if the ranges intersect.       
     */
    public static inline function openRangesIntersect(aStart:Float, aWidth:Float, bStart:Float, bWidth:Float):Bool
    {
        return !(aStart >= bStart + bWidth ||
            bStart >= aStart + aWidth);
    }
    
    /**
     * Check to see if the closed range [aStart, aStart + aWidth] contains the value x.
     * 
     * @param aStart
     * @param aWidth
     * @param x
     * @return          True if the range contains x.    
     */
    public static inline function closedRangeContains(aStart:Float, aWidth:Float, x:Float):Bool
    {
        return (x >= aStart) &&
            (x <= aStart + aWidth);
    }
    
    /**
    * Converts specified angle in radians to degrees.
    * @return angle in degrees (not normalized to 0...360)
    */
    public inline static function radToDeg(rad:Float):Float
    {
        return 180 / Math.PI * rad;
    }
    /**
    * Converts specified angle in degrees to radians.
    * @return angle in radians (not normalized to 0...Math.PI*2)
    */
    public inline static function degToRad(deg:Float):Float
    {
        return Math.PI / 180 * deg;
    }
    
    /**
     * Wrap a positive or negative number to between 0 and some exclusive positive bound.
     * 
     * @param    x    The number to wrap.
     * @param    n    The positive bound.
     * @return    The wrapped number in the range [0, n)
     */
    public static inline function wrap(x:Float, n:Float):Float
    {
        if (x < 0)
        {
            // To avoid ambiguity with modulo sign conventions (some use the divisor's sign, others
            // use dividend's, etc) force the dividend to be positive.
            return n - (-x % n);
        }
        else
        {
            return x % n;
        }
    }
    
    /**
    * "Clamps" a value to boundaries [min, max].
    * Example:
    * clamp(2, 1, 5) == 2;
    * clamp(0, 1, 5) == 1;
    * clamp(6, 1, 5) == 5;
    */
    public inline static function clamp(value:Float, min:Float, max:Float):Float
    {
        if (value < min)
        {
            return min;
        }
        else if (value > max)
        {
            return max;
        }
        else
        {
            return value;
        }
    }
    
    /**
     * 2D orientation predicate.
     * 
     * @param   a   The first point in the line ab.
     * @param   b   The second point in the line ab.
     * @param   c   The point to test against ab.
     * 
     * @return  The orientation of point c with regards to ab.
     */
    public static inline function orient2d(a:Vector2, b:Vector2, c:Vector2):Orient2DResult
    {
        var result = MathUtil.det2x2(a.x - c.x, a.y - c.y, b.x - c.x, b.y - c.y);
        
        // > 0 if c lies to the left of line ab (vector b - a)
        //     equivalently triangle abc is counterclockwise
        if (result > 0)
        {
            return Orient2DResult.Left;
        }
        
        // < 0 if c lies to the right of line ab (vector b - a)
        //     equivalently triangle abc is clockwise
        else if (result < 0)
        {
            return Orient2DResult.Right;
        }
        
        // = 0 if c is colinear with b and a
        else
        {
            return Orient2DResult.Colinear;
        }
    }
    
    /**
     * Calculate the determinant of a 2x2 matrix in-place without creating a new matrix.
     * 
     * @param m00
     * @param m10
     * @param m01
     * @param m11
     * @return      The determinant.
     */
    public static inline function det2x2(
        m00:Float, m10:Float,
        m01:Float, m11:Float):Float
    {
        return m00 * m11 - m10 * m01;
    }
    
    /**
     * Calculate the determinant of a 3x3 matrix in-place without creating a new matrix.
     * 
     * @param m00
     * @param m10
     * @param m20
     * @param m01
     * @param m11
     * @param m21
     * @param m02
     * @param m12
     * @param m22
     * @return      The determinant
     */
    public static inline function det3x3(
        m00:Float, m10:Float, m20:Float,
        m01:Float, m11:Float, m21:Float,
        m02:Float, m12:Float, m22:Float):Float
    {
        return
            m00 * det2x2(
                m11, m21,
                m12, m22) -
            m10 * det2x2(
                m01, m21,
                m02, m22) +
            m20 * det2x2(
                m01, m11,
                m02, m12);
    }

    /**
     * Calculate the determinant of a 4x4 matrix in-place without creating a new matrix.
     * 
     * @param m00
     * @param m10
     * @param m20
     * @param m30
     * @param m01
     * @param m11
     * @param m21
     * @param m31
     * @param m02
     * @param m12
     * @param m22
     * @param m32
     * @param m03
     * @param m13
     * @param m23
     * @param m33
     * @return      The determinant.
     */
    public static inline function det4x4(
        m00:Float, m10:Float, m20:Float, m30:Float,
        m01:Float, m11:Float, m21:Float, m31:Float,
        m02:Float, m12:Float, m22:Float, m32:Float,
        m03:Float, m13:Float, m23:Float, m33:Float):Float
    {
        return
            m00 * det3x3(
                m11, m21, m31,
                m12, m22, m32,
                m13, m23, m33) -
            m10 * det3x3(
                m01, m21, m31,
                m02, m22, m32,
                m03, m23, m33) +
            m20 * det3x3(
                m01, m11, m31,
                m02, m12, m32,
                m03, m13, m33) -
            m30 * det3x3(
                m01, m11, m21,
                m02, m12, m22,
                m03, m13, m23);
    }
}