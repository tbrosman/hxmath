package hxmath.frames;
import hxmath.math.MathUtil;
import hxmath.math.Matrix2x2;
import hxmath.math.Matrix3x2;
import hxmath.math.Vector2;
 
/**
 * An abstract 2D affine frame that can be extended without carrying over all the variables of the full Frame2 class.
 */
class BaseFrame2
{
    // The associated affine transformation matrix. The private variable holds the cached/last calculated matrix.
    public var matrix(get, never):Matrix3x2;
    
    // The associated linear transformation matrix
    public var linearMatrix(get, never):Matrix2x2;
    
    // The offset between the origin and the outer frame
    public var offset(get, set):Vector2;
    
    // The angle by which the frame is rotated about the origin
    public var angleDegrees(get, set):Float;
    
    /**
     * Constructor. Private to avoid direct instantiation (should be used as a base class only).
     */
    private function new() 
    {
    }
    
    /**
     * Concat this frame with another frame to produce a new frame.
     * 
     * result = this * other
     * 
     * @param other     The transformation applied before this one.
     * @return          The combined result.
     */
    public inline function concat(other:BaseFrame2):BaseFrame2
    {
        return this.toFrame2()
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
    public inline function concatWith(other:BaseFrame2):BaseFrame2
    {
        var resultOffset = linearMatrix * other.offset + offset;
        angleDegrees = MathUtil.wrap(angleDegrees + other.angleDegrees, 360);
        offset = resultOffset;
        return this;
    }
    
    /**
     * Transform a point from this frame into the outer frame (affine transformation).
     * 
     * @param p     The point to transform.
     * @return      The transformed point.
     */
    public inline function transformFrom(p:Vector2):Vector2
    {
        return matrix.transform(p);
    }
    
    /**
     * Transform a point from the outer frame into this frame (affine transformation).
     * 
     * @param p     The point to transform.
     * @return      The transformed point.
     */
    public inline function transformTo(p:Vector2):Vector2
    {
        return linearMatrix.transposeMultiplyVector(p - matrix.t);
    }
    
    /**
     * Transform a vector from this frame into the outer frame (linear transformation).
     * 
     * @param v     The vector to transform.
     * @return      The transformed vector.
     */
    public inline function linearTransformFrom(v:Vector2):Vector2
    {
        return linearMatrix * v;
    }
    
    /**
     * Transform a vector from the outer frame into this frame (linear transformation).
     * 
     * @param v     The vector to transform.
     * @return      The transformed vector.
     */
    public inline function linearTransformTo(v:Vector2):Vector2
    {
        return linearMatrix.transposeMultiplyVector(v);
    }
    
    /**
     * Get the inverse frame (the effect of to/from will be swapped in the new frame).
     * 
     * @return      The inverse of this frame.    
     */
    public inline function inverse():Frame2
    {
        return new Frame2(-linearMatrix.transposeMultiplyVector(offset), -angleDegrees);
    }
    
    /**
     * Create a new Frame2 from this frame.
     * 
     * @return  The clone.    
     */
    public inline function toFrame2():Frame2
    {
        return new Frame2(offset, angleDegrees);
    }
    
    private function get_matrix():Matrix3x2
    {
        throw "Unimplemented";
    }
    
    private inline function get_linearMatrix():Matrix2x2
    {
        return matrix.linearSubMatrix;
    }
    
    private function get_offset():Vector2
    {
        throw "Unimplemented";
    }
    
    private function set_offset(offset:Vector2):Vector2
    {
        throw "Unimplemented";
    }
    
    private function get_angleDegrees():Float
    {
        throw "Unimplemented";
    }
    
    private function set_angleDegrees(angleDegrees:Float):Float
    {
        throw "Unimplemented";
    }
}