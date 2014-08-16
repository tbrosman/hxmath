package hxmath.frames.adapters;

import hxmath.frames.Frame2;
import hxmath.frames.IFrame2;
import hxmath.math.Matrix3x2;
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
class FlxSpriteFrame2 implements IFrame2
{
    // The owning FlxObject
    private var owner:FlxObjectShape;
    
    // The internal matrix to avoid reallocation
    private var internalMatrix:Matrix3x2 = Matrix3x2.identity;
    
    // The associated affine transformation matrix. The private variable holds the cached/last calculated matrix.
    public var matrix(get, never):Matrix3x2;
    
    // The offset between the origin and the outer frame
    public var offset(get, set):Vector2;
    
    // The angle by which the frame is rotated about the origin
    public var angleDegrees(get, set):Float;
    
    /**
     * Constructor.
     * 
     * @param owner     The owning FlxObject for the coordinate frame.
     */
    public function new(owner:FlxObjectShape) 
    {
        this.owner = owner;
    }
    
    private inline function get_matrix():Matrix3x2
    {
        return Frame2.calculateMatrix(internalMatrix, offset, angleDegrees);
    }
    
    private inline function get_offset():Vector2
    {
        return new Vector2(owner.x, owner.y);
    }
    
    private inline function set_offset(offset:Vector2):Vector2
    {
        owner.x = offset.x;
        owner.y = offset.y;
        return offset;
    }
    
    private inline function get_angleDegrees():Float
    {
        return owner.angle;
    }
    
    private inline function set_angleDegrees(angleDegrees:Float)
    {
        return owner.angle = angleDegrees;
    }
}