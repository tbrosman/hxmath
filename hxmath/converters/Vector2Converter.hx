package hxmath.converters;
import hxmath.converters.Vector2Converter.FlxPointShape;
import hxmath.Vector2;

typedef ConstructableVector2 =
{
    public function new(x:Float, y:Float):Void;
}

typedef FlxPointShape =
{
    public var x(default, set):Float;
    public var y(default, set):Float;
}

/**
 * A set of converter functions for use with shape-incompatible libraries.
 */
class Vector2Converter
{
    /**
     * Create an instance using only the constructor shape. This is useful for cases when the fields do not match the
     * shape used by HxMath (e.g. FlxPoint does not match Vector2Shape).
     * 
     * Example use:
     * 
     * var v = new Vector2(1.0, 2.0);
     * var point:FlxPoint = Vector2Converter.cloneTo(v);
     * 
     * Alternatively:
     *
     * using hxmath.converters.Vector2Converter;
     * 
     * var v = new Vector2(1.0, 2.0);
     * var point:FlxPoint = v.cloneTo();
     * 
     * @param v     The hxmath type to convert.
     * @return      The converted instance.
     */
    @:generic
    public static inline function cloneTo<T:ConstructableVector2>(v:Vector2):T
    {
        return new T(v.x, v.y);
    }
    
    /**
     * Create an FlxPoint from a Vector2 by shape.
     * 
     * @param v     The Flixel type to convert.
     * @return      The type converted to a Vector2.
     */
    public static inline function cloneFromFlxPoint(v:FlxPointShape):Vector2
    {
        return new Vector2(v.x, v.y);
    }
    
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