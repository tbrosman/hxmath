package hxmath.ds;

/**
 * A wrapper for the hash indices used by SparseArray2.
 */
abstract SparseArray2Index(Int) from Int to Int
{
    // The max number of bits that can be used for x or y
    public static inline var bitsPerField = 15;
    
    // The inclusive max for either the x or y field
    public static inline var fieldMax:Int = 0x7fff;
    
    // Get/set the X portion of the index
    public var x(get, set):Int;
    
    // Get/set the Y portion of the index
    public var y(get, set):Int;
    
    /**
     * Constructor.
     * 
     * @param index     A packed index.
     */
    public function new(index:Int) 
    {
        this = index;
    }
    
    /**
     * Pack (x, y) coordinates into a single int. Throws if x or y exceeds the maximum size.
     * 
     * @param x
     * @param y
     * @return      The packed index.
     */
    public static inline function packIndex(x:Int, y:Int):SparseArray2Index
    {
        if (!indexInBounds(x, y))
        {
            throw 'Specified (x=$x, y=$y) fields not in the range [0, $fieldMax]';
        }
        
        return (y << bitsPerField) | x;
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
    
    private inline function get_x():Int
    {
        return this & fieldMax;
    }
    
    private inline function set_x(x:Int):Int
    {
        var self:SparseArray2Index = this;
        self = packIndex(x, self.y);
        return x;
    }
    
    private inline function get_y():Int
    {
        return (this >> bitsPerField) & fieldMax;
    }
    
    private inline function set_y(y:Int):Int
    {
        var self:SparseArray2Index = this;
        self = packIndex(self.x, y);
        return y;
    }
}