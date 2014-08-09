package hxmath.frames;

import hxmath.math.MathUtil;
import hxmath.math.Matrix3x2;
import hxmath.math.Vector2;

/**
 * A 2D affine frame with an offset from the outer frame as well as a rotation relative to the outer frame.
 */
class Frame2
{
    // The associated transformation matrix
    public var matrix(get, never):Matrix3x2;
    
    // The offset between the origin and the outer frame
    public var offset(default, set):Vector2;
    
    // The angle by which the frame is rotated about the origin
    public var angleDegrees(default, set):Float;
    
    // True if the cached matrix needs to be recalculated
    private var isDirty:Bool = true;
    
    // The cached matrix
    private var cachedMatrix:Matrix3x2;
    
    public function new(offset:Vector2=null, angleDegrees:Float=0.0) 
    {
        this.offset = offset == null
            ? Vector2.zero
            : offset;
        this.angleDegrees = angleDegrees;
    }
    
    /**
     * Concat this frame with another frame to produce a new frame.
     * 
     * result = this * other
     * 
     * @param other     The transformation applied before this one.
     * @return          The combined result.
     */
    public inline function concat(other:Frame2):Frame2
    {
        return this.clone()
            .concatWith(other);
    }
    
    /**
     * Concat this frame in place with another frame. The result (this') will transform like this followed by other.
     * 
     * this' = this * other
     * 
     * @param other     The transformation applied before this one.
     * @return          The combined result (this object).
     */
    public inline function concatWith(other:Frame2):Frame2
    {
        var resultOffset = this.matrix.linearSubMatrix * other.offset + this.offset;
        this.angleDegrees = MathUtil.wrap(this.angleDegrees + other.angleDegrees, 360);
        this.offset = resultOffset;
        return this;
    }
    
    /**
     * Transform a point (affine transformation).
     * 
     * @param p     The point to transform.
     * @return      The transformed point.
     */
    public inline function transform(p:Vector2):Vector2
    {
        return this.matrix.transform(p);
    }
    
    /**
     * Transform a vector (linear transformation).
     * 
     * @param v     The vector to transform.
     * @return      The transformed vector.
     */
    public inline function linearTransform(v:Vector2):Vector2
    {
        return this.matrix.linearSubMatrix * v;
    }
    
    /**
     * Clone.
     * 
     * @return  The cloned object.
     */
    public inline function clone():Frame2
    {
        var result = new Frame2(offset, angleDegrees);
        
        // Copy the cached matrix if it is not dirty
        if (!isDirty)
        {
            result.cachedMatrix = cachedMatrix;
            result.isDirty = false;
        }
        
        return result;
    }
    
    private inline function get_matrix():Matrix3x2
    {
        if (isDirty)
        {
            cachedMatrix = Matrix3x2.rotate(MathUtil.degToRad(angleDegrees));
            cachedMatrix.t = offset;
        }
        
        return cachedMatrix;
    }
    
    private function set_offset(offset:Vector2):Vector2
    {
        this.offset = offset;
        isDirty = true;
        return this.offset;
    }
    
    private function set_angleDegrees(angleDegrees:Float):Float
    {
        this.angleDegrees = angleDegrees;
        isDirty = true;
        return this.angleDegrees;
    }
}