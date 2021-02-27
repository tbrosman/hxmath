package hxmath.frames;
import hxmath.math.MathUtil;
import hxmath.math.Matrix3x3;
import hxmath.math.Matrix4x4;
import hxmath.math.Quaternion;
import hxmath.math.Vector3;
 
/**
 * A 3D affine frame with an offset and an orientation. Frames allow you to transform between world/outer coordinates and
 * local/inner coordinates in a form that is more meaningful/less verbose compared to a matrix. Frames can be
 * concatenated, inverted, and converted to matrices.
 */
@:forward(matrix, offset, orientation)
abstract Frame3(IFrame3) from IFrame3
{
    // The associated linear transformation matrix
    public var linearMatrix(get, never):Matrix3x3;
    
    /**
     * Constructor.
     * 
     * @param offset        The offset/translation of the origin of the frame.
     * @param orientation   The orientation of the frame.
     */
    public function new(offset:Vector3, orientation:Quaternion) 
    {
        this = new Frame3Default(offset, orientation);
    }
    
    /**
     * Set a matrix to the specified transformation in-place to avoid reallocation.
     * 
     * @param matrix        The matrix to set.    
     * @param offset        The offset/translation.
     * @param angleDegrees  The angle in degrees.
     * @return              The matrix that was passed in.
     */
    public static inline function calculateMatrix(matrix:Matrix4x4, offset:Vector3, orientation:Quaternion):Matrix4x4
    {
        // Set fields in place to avoid reallocating
        matrix.setRotateFromQuaternion(orientation);
        matrix.setTranslate(offset.x, offset.y, offset.z);
        return matrix;
    }
    
    /**
     * Linearly interpolate between two frames.
     * 
     * @param frameA    The frame at t = 0
     * @param frameB    The frame at t = 1
     * @param t         A float in the range [0, 1]
     * @return          The interpolated frame
     */
    public static inline function lerp(frameA:Frame3, frameB:Frame3, t:Float):Frame3
    {
        return new Frame3(
            Vector3.lerp(frameA.offset, frameB.offset, t),
            Quaternion.lerp(frameA.orientation, frameB.orientation, t));
    }
    
    /**
     * Concat this frame with another frame to produce a new frame.
     * 
     * result = this * other
     * 
     * @param other     The transformation applied before this one.
     * @return          The combined result.
     */
    public inline function concat(other:Frame3):Frame3
    {
        var self:Frame3 = this;
        return self.clone()
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
    public inline function concatWith(other:Frame3):Frame3
    {
        var self:Frame3 = this;
        var resultOffset = self.orientation
            .rotate(other.offset)
            .addWith(self.offset);
        self.orientation = (self.orientation * other.orientation).normal;
        self.offset = resultOffset;
        return self;
    }
    
    /**
     * Transform a point from this frame into the outer frame (affine transformation).
     * 
     * @param p     The point to transform.
     * @return      The transformed point.
     */
    public inline function transformFrom(p:Vector3):Vector3
    {
        var self:Frame3 = this;
        return self.orientation
            .rotate(p)
            .addWith(self.offset);
    }
    
    /**
     * Transform a point from the outer frame into this frame (affine transformation).
     * 
     * @param p     The point to transform.
     * @return      The transformed point.
     */
    public inline function transformTo(p:Vector3):Vector3
    {
        var self:Frame3 = this;
        return self.orientation
            .invert()
            .rotate(p - self.offset);
    }
    
    /**
     * Transform a vector from this frame into the outer frame (linear transformation).
     * 
     * @param v     The vector to transform.
     * @return      The transformed vector.
     */
    public inline function linearTransformFrom(v:Vector3):Vector3
    {
        var self:Frame3 = this;
        return self.orientation
            .rotate(v);
    }
    
    /**
     * Transform a vector from the outer frame into this frame (linear transformation).
     * 
     * @param v     The vector to transform.
     * @return      The transformed vector.
     */
    public inline function linearTransformTo(v:Vector3):Vector3
    {
        var self:Frame3 = this;
        return self.orientation
            .invert()
            .rotate(v);
    }
    
    /**
     * Get the inverse frame (the effect of to/from will be swapped in the new frame).
     * 
     * @return      The inverse of this frame.    
     */
    public inline function inverse():Frame3
    {
        var self:Frame3 = this;
        var inverseRotation = self.orientation
            .invert();
            
        return new Frame3(
            inverseRotation
                .rotate(self.offset)
                .applyNegate(),
            inverseRotation);
    }
    
    /**
     * Clone.
     * 
     * @return  The clone.    
     */
    public inline function clone():Frame3
    {
        var self:Frame3 = this;
        return new Frame3(self.offset, self.orientation);
    }
    
    private inline function get_linearMatrix():Matrix3x3
    {
        var self:Frame3 = this;
        return self.matrix.subMatrix;
    }
}