package hxmath.math ;

/**
 * A 2D vector with 16-bit integer values. Uses the underlying native Int type of the target platform and requires no memory allocation.
 * 
 * Differences from IntVector2:
 * - Extremely fast: no heap allocation, lives on the stack like a value type.
 * - Maximum value for X and Y fields is 2^16 - 1 instead of 2^32 - 1.
 * - Clone semantics are the same as any other value type: clone is degenerate, can't be modified by reference, etc.
 * - No functions modifying object state (e.g. addWith, subtractWith, array element set, etc).
 * - Equality operator comes from the underlying type.
 */
abstract ShortVector2(Int) from Int to Int
{
    // The number of (implicit) elements in this structure
    public static inline var elementCount:Int = 2;
    
    // The max number of bits that can be used for x or y
    public static inline var bitsPerField = 16;
    
    // The inclusive max for either the x or y field
    public static inline var fieldMax:Int = 0xffff;
    
    // Zero vector (v + 0 = v)
    public static var zero(get, never):ShortVector2;
    
    // X axis (1, 0)
    public static var xAxis(get, never):ShortVector2;
    
    // Y axis (0, 1)
    public static var yAxis(get, never):ShortVector2;
    
    // Vector dotted with itself
    public var lengthSq(get, never):Int;
    
    // 90 degree rotation to the left
    public var rotatedLeft(get, never):ShortVector2;
    
    // 90 degree rotation to the right
    public var rotatedRight(get, never):ShortVector2;
    
    // Get the X portion of the index
    public var x(get, never):Int;
    
    // Get the Y portion of the index
    public var y(get, never):Int;
    
    /**
     * Constructor.
     * Pack (x, y) coordinates into a single int. Throws if x or y exceeds the maximum size.
     * 
     * @param index     A packed index.
     */
    public function new(x:Int, y:Int) 
    {
        if (!indexInBounds(x, y))
        {
            throw 'Specified (x=$x, y=$y) fields not in the range [0, $fieldMax]';
        }
        
        this = (y << bitsPerField) | x;
    }
    
    /**
     * Construct a ShortVector2 from an array.
     * 
     * @param rawData   The input array.
     * @return          The constructed structure.
     */
    public static inline function fromArray(rawData:Array<Int>):ShortVector2
    {
        if (rawData.length != ShortVector2.elementCount)
        {
            throw "Invalid rawData.";
        }
        
        return new ShortVector2(rawData[0], rawData[1]);
    }
    
    /**
     * Dot product.
     * 
     * @param a
     * @param b
     * @return      sum_i (a_i * b_i)
     */
    @:op(A * B)
    public static inline function dot(a:ShortVector2, b:ShortVector2):Int
    {
        return
            a.x * b.x +
            a.y * b.y;
    }
    
    /**
     * Multiply a scalar with a vector.
     * 
     * @param a
     * @param s
     * @return      s * a
     */
    @:op(A * B)
    @:commutative
    public static inline function multiply(a:ShortVector2, s:Int):ShortVector2
    {
        return new ShortVector2(
            s * a.x,
            s * a.y);
    }
    
    /**
     * Add two vectors.
     * 
     * @param a
     * @param b
     * @return      a + b
     */
    @:op(A + B)
    public static inline function add(a:ShortVector2, b:ShortVector2):ShortVector2
    {
        return new ShortVector2(
            a.x + b.x,
            a.y + b.y);
    }
    
    /**
     * Subtract one vector from another.
     * 
     * @param a
     * @param b
     * @return      a - b
     */
    @:op(A - B)
    public static inline function subtract(a:ShortVector2, b:ShortVector2):ShortVector2
    {
        return new ShortVector2(
            a.x - b.x,
            a.y - b.y);
    }
    
    /**
     * Create a negated copy of a vector.
     * 
     * @param a
     * @return      -a
     */
    @:op(-A)
    public static inline function negate(a:ShortVector2):ShortVector2
    {
        return new ShortVector2(
            -a.x,
            -a.y);
    }
    
    /**
     * Returns a vector built from the componentwise max of the input vectors.
     * 
     * @param a
     * @param b
     * @return      max(a_i, b_i)
     */
    public static inline function max(a:ShortVector2, b:ShortVector2):ShortVector2
    {
        return new ShortVector2(
            MathUtil.intMax(a.x, b.x),
            MathUtil.intMax(a.y, b.y));
    }
    
    /**
     * Returns a vector built from the componentwise min of the input vectors.
     * 
     * @param a
     * @param b
     * @return      min(a_i, b_i)
     */
    public static inline function min(a:ShortVector2, b:ShortVector2):ShortVector2
    {
        return new ShortVector2(
            MathUtil.intMin(a.x, b.x),
            MathUtil.intMin(a.y, b.y));
    }
    
    /**
     * Get an element by position.
     * 
     * @param i         The element index.
     * @return          The element.
     */
    @:arrayAccess
    public inline function getArrayElement(i:Int):Int
    {
        var self:ShortVector2 = this;
        switch (i)
        {
            case 0:
                return self.x;
            case 1:
                return self.y;
            default:
                throw "Invalid element";
        }
    }
    
    /**
     * Convert to a Vector2.
     * 
     * @return  The equivalent Vector2.
     */
    @:to
    public inline function toVector2():Vector2 
    {
        var self:ShortVector2 = this;
        return new Vector2(self.x, self.y);
    }
    
    /**
     * Check whether the specified index can be stored in a SparseArray2.
     * 
     * @param x
     * @param y
     */
    public inline static function indexInBounds(x:Int, y:Int)
    {
        return x >= 0 && y >= 0 && x <= fieldMax && y <= fieldMax;
    }
    
    private static inline function get_zero():ShortVector2
    {
        return new ShortVector2(0, 0);
    }
    
    private static inline function get_xAxis():ShortVector2
    {
        return new ShortVector2(1, 0);
    }
    
    private static inline function get_yAxis():ShortVector2
    {
        return new ShortVector2(0, 1);
    }
    
    private inline function get_x():Int
    {
        return this & fieldMax;
    }
    
    private inline function get_y():Int
    {
        return (this >> bitsPerField) & fieldMax;
    }
    
    private inline function get_lengthSq():Int
    {
        var self:ShortVector2 = this;
        return
            self.x * self.x +
            self.y * self.y;
    }
    
    private inline function get_rotatedLeft():ShortVector2
    {
        var self:ShortVector2 = this;
        return new ShortVector2(-y, x);
    }
    
    private inline function get_rotatedRight():ShortVector2
    {
        var self:ShortVector2 = this;
        return new ShortVector2(y, -x);
    }
}