package hxmath.converters;
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
 * ...
 * @author TABIV
 */
class Vector2Converter
{
    /**
     * Build an instance using only the constructor shape. This is useful for cases when the fields do not match the
     * shape used by HxMath (e.g. FlxPoint does not match Vector2Shape).
     * 
     * Example use:
     * 
     * var v = new Vector2(1.0, 2.0);
     * var point:FlxPoint = Vector2Converter.to(v);
     * 
     * Alternatively:
     *
     * using hxmath.converters.Vector2Converter;
     * 
     * var v = new Vector2(1.0, 2.0);
     * var point:FlxPoint = v.to();
     * 
     * @param v     The hxmath type to convert.
     * @return      The converted instance.
     */
    @:generic
    public static function to<T:ConstructableVector2>(v:Vector2):T
    {
        return new T(v.x, v.y);
    }
    
    /**
     * Convert an FlxPoint to a Vector2 by shape.
     * 
     * @param v     The Flixel type to convert.
     * @return      The type converted to a Vector2.
     */
    public static function fromFlxPoint(v:FlxPointShape):Vector2
    {
        return new Vector2(v.x, v.y);
    }
}