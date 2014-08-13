package hxmath.frames.adapters;

import hxmath.frames.Frame2;
import hxmath.math.Vector2;

typedef FlxObjectShape =
{
    public var x(default, set):Float;
    public var y(default, set):Float;
    public var angle(default, set):Float;
};

/**
 * A coordinate frame adapter for FlxSprite.
 */
class FlxSpriteFrame2 extends Frame2
{
    // The owning FlxObject
    private var owner:FlxObjectShape;
    
    /**
     * Constructor.
     * 
     * @param owner     The owning FlxObject for the coordinate frame.
     */
    public function new(owner:FlxObjectShape) 
    {
        super();
        this.owner = owner;
    }
    
    private override function get_offset():Vector2
    {
        return new Vector2(owner.x, owner.y);
    }
    
    private override function set_offset(offset:Vector2):Vector2
    {
        owner.x = offset.x;
        owner.y = offset.y;
        return offset;
    }
    
    private override function get_angleDegrees():Float
    {
        return owner.angle;
    }
    
    private override function set_angleDegrees(angleDegrees:Float)
    {
        return owner.angle = angleDegrees;
    }
}