package hxmath.math;
import hxmath.math.IntVector2.IntVector2Default;

/**
 * The default underlying type.
 */
class IntVector2Default
{
    public var x:Int;
    public var y:Int;
    
    public function new(x:Int, y:Int)
    {
        this.x = x;
        this.y = y;
    }
}

/**
 * A 2D vector with integer values. Used primarily for indexing into 2D grids.
 */
@:forward(x, y)
abstract IntVector2(IntVector2Default) from IntVector2Default to IntVector2Default
{
    // Zero vector (v + 0 = v)
    public static var zero(get, never):IntVector2;
        
    /**
     * Constructor.
     * 
     * @param x
     * @param y
     */
    public function new(x:Int, y:Int)
    {
        this = new IntVector2Default(x, y);
    }
    
    /**
     * Convert to a Vector2.
     * 
     * @return  The equivalent Vector2.
     */
    @:to
    public inline function toVector2():Vector2 
    {
        var self:IntVector2 = this;
        return new Vector2(self.x, self.y);
    }
    
    private static inline function get_zero():IntVector2
    {
        return new IntVector2(0, 0);
    }
}