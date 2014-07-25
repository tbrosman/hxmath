package hxmath;

enum Orient2DResult
{
    Left;
    Colinear;
    Right;
}

class MathUtil
{
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
     * Check to see if the open ranges (aStart, aStart + aWidth) and (bStart, bStart + bWidth) overlap.
     * 
     * @param    aStart
     * @param    aWidth
     * @param    bStart
     * @param    bWidth
     */
    public static inline function openRangeOverlaps(aStart:Float, aWidth:Float, bStart:Float, bWidth:Float):Bool
    {
        return (aStart + aWidth > bStart)
            && (aStart < bStart + bWidth);
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
        return ((x % n) + n) % n;
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
        var result = new Matrix2x2(a.x - c.x, a.y - c.y, b.x - c.x, b.y - c.y)
            .det;
        
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
}