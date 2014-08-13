package hxmath.frames;

import hxmath.math.MathUtil;
import hxmath.math.Matrix2x2;
import hxmath.math.Matrix3x2;
import hxmath.math.Vector2;

/**
 * A 2D affine frame with an offset from the outer frame as well as a rotation relative to the outer frame.
 */
class Frame2
{
    // The associated affine transformation matrix. The private variable holds the cached/last calculated matrix.
    public var matrix(get, never):Matrix3x2;
    
    // The associated linear transformation matrix
    public var linearMatrix(get, never):Matrix2x2;
    
    // The offset between the origin and the outer frame
    public var offset(get, set):Vector2;
    
    // The angle by which the frame is rotated about the origin
    public var angleDegrees(get, set):Float;
    
    // The last calculated/cached matrix
    private var internalMatrix:Matrix3x2;
    
    // Stores offset in non-adapter cases
    private var internalOffset:Vector2;
    
    // Stores angle in non-adapter cases
    private var internalAngleDegrees:Float;
    
    // True if the matrix is cached
    private var isCached:Bool = true;
    
    // True if the cached matrix needs to be recalculated
    private var isDirty:Bool = true;
    
    /**
     * Constructor.
     * 
     * @param offset        The offset of the frame relative to the outer frame.
     * @param angleDegrees  The angle of the frame relative to the outer frame.
     * @param isCached      Cache the matrix if true.
     */
    public function new(offset:Vector2=null, angleDegrees:Float=0.0, isCached:Bool=true) 
    {
        internalOffset = offset == null
            ? Vector2.zero
            : offset;
        internalAngleDegrees = angleDegrees;
        this.isCached = isCached;
        internalMatrix = new Matrix3x2();
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
            result.internalMatrix = internalMatrix;
            result.isDirty = false;
        }
        
        return result;
    }
    
    private inline function get_matrix():Matrix3x2
    {
        // If no caching or the matrix is cached but dirty, recalculate its
        if (!isCached || isDirty)
        {
            // Set fields in place to avoid reallocating
            internalMatrix.linearSubMatrix.setRotate(MathUtil.degToRad(angleDegrees));
            internalMatrix.t = offset;
            isDirty = false;
        }
        
        return internalMatrix;
    }
    
    private inline function get_linearMatrix():Matrix2x2
    {
        return matrix.linearSubMatrix;
    }
    
    private function get_offset():Vector2
    {
        return internalOffset;
    }
    
    private function set_offset(offset:Vector2):Vector2
    {
        internalOffset = offset;
        isDirty = true;
        return offset;
    }
    
    private function get_angleDegrees():Float
    {
        return internalAngleDegrees;
    }
    
    private function set_angleDegrees(angleDegrees:Float):Float
    {
        internalAngleDegrees = angleDegrees;
        isDirty = true;
        return angleDegrees;
    }
}