package hxmath.converters.flixel ;
import hxmath.math.Vector2;

// The public structure of FlxPoint/FlxVector matching up with Vector2
typedef FlxPointShape =
{
    public var x(default, set):Float;
    public var y(default, set):Float;
}

/**
 * A set of converter functions for converting between hxmath Vector2 and flixel FlxPoint/FlxVector.
 */
class Vector2Converter
{
    /**
     * Copy an FlxPoint/FlxVector to a Vector2.
     * 
     * @param v     The Vector2.
     * @param p     The FlxPoint/FlxVector to copy.
     */
    public static inline function copyToFlxPoint(v:Vector2, p:FlxPointShape):Void
    {
        p.x = v.x;
        p.y = v.y;
    }
    
    /**
     * Copy a Vector2 to a FlxPoint/FlxVector.
     * 
     * @param v     The Vector2 to copy.
     * @param p     The FlxPoint/FlxVector.
     */
    public static inline function copyFromFlxPoint(v:Vector2, p:FlxPointShape):Void
    {
        v.x = p.x;
        v.y = p.y;
    }
}