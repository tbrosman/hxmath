package hxmath.math ;

/**
 *  A 2D vector with 16-bit integer values. Uses the underlying native Int type of the target platform and requires no memory allocation.
 */
abstract ShortVector2(Int) from Int to Int
{
    // The max number of bits that can be used for x or y
    public static inline var bitsPerField = 16;
    
    // The inclusive max for either the x or y field
    public static inline var fieldMax:Int = 0xffff;
    
    // Zero vector (v + 0 = v)
    public static var zero(get, never):ShortVector2;
    
    // Get/set the X portion of the index
    public var x(get, set):Int;
    
    // Get/set the Y portion of the index
    public var y(get, set):Int;
    
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
    
    private inline function get_x():Int
    {
        return this & fieldMax;
    }
    
    private inline function set_x(x:Int):Int
    {
        var self:ShortVector2 = this;
        self = new ShortVector2(x, self.y);
        return x;
    }
    
    private inline function get_y():Int
    {
        return (this >> bitsPerField) & fieldMax;
    }
    
    private inline function set_y(y:Int):Int
    {
        var self:ShortVector2 = this;
        self = new ShortVector2(self.x, y);
        return y;
    }
}