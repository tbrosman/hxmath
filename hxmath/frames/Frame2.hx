package hxmath.frames;
import hxmath.math.MathUtil;
import hxmath.math.Matrix2x2;
import hxmath.math.Matrix3x2;
import hxmath.math.Vector2;
 
/**
 * A 2D affine frame with an offset and an angle. Frames allow you to transform between world/outer coordinates and
 * local/inner coordinates in a form that is more meaningful/less verbose compared to a matrix. Frames can be
 * concatenated, inverted, and converted to matrices.
 */
@:forward(matrix, offset, angleDegrees)
abstract Frame2(IFrame2) from IFrame2
{
    // The associated linear transformation matrix
    public var linearMatrix(get, never):Matrix2x2;
    
    /**
     * Constructor.
     * 
     * @param offset        The offset/translation of the origin of the frame.
     * @param angleDegrees  The angle/orientation of the frame.
     */
    public function new(offset:Vector2, angleDegrees:Float) 
    {
        this = new Frame2Default(offset, angleDegrees);
    }
    
    /**
     * Set a matrix to the specified transformation in-place to avoid reallocation.
     * 
     * @param matrix        The matrix to set.    
     * @param offset        The offset/translation.
     * @param angleDegrees  The angle in degrees.
     * @return              The matrix that was passed in.
     */
    public static inline function calculateMatrix(matrix:Matrix3x2, offset:Vector2, angleDegrees:Float):Matrix3x2
    {
        // Set fields in place to avoid reallocating
        matrix.setRotate(MathUtil.degToRad(angleDegrees));
        matrix.setTranslate(offset.x, offset.y);
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
    public static inline function lerp(frameA:Frame2, frameB:Frame2, t:Float):Frame2
    {
        return new Frame2(
            Vector2.lerp(frameA.offset, frameB.offset, t),
            MathUtil.lerpCyclic(frameA.angleDegrees, frameB.angleDegrees, t, 360));
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
        var self:Frame2 = this;
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
    public inline function concatWith(other:Frame2):Frame2
    {
        var self:Frame2 = this;
        var resultOffset = (self.linearMatrix * other.offset).addWith(self.offset);
        self.angleDegrees = MathUtil.wrap(self.angleDegrees + other.angleDegrees, 360);
        self.offset = resultOffset;
        return self;
    }
    
    /**
     * Transform a point from this frame into the outer frame (affine transformation).
     * 
     * @param p     The point to transform.
     * @return      The transformed point.
     */
    public inline function transformFrom(p:Vector2):Vector2
    {
        var self:Frame2 = this;
        return self.matrix * p;
    }
    
    /**
     * Transform a point from the outer frame into this frame (affine transformation).
     * 
     * @param p     The point to transform.
     * @return      The transformed point.
     */
    public inline function transformTo(p:Vector2):Vector2
    {
        var self:Frame2 = this;
        return self.linearMatrix.transposeMultiplyVector(p - self.offset);
    }
    
    /**
     * Transform a vector from this frame into the outer frame (linear transformation).
     * 
     * @param v     The vector to transform.
     * @return      The transformed vector.
     */
    public inline function linearTransformFrom(v:Vector2):Vector2
    {
        var self:Frame2 = this;
        return self.linearMatrix * v;
    }
    
    /**
     * Transform a vector from the outer frame into this frame (linear transformation).
     * 
     * @param v     The vector to transform.
     * @return      The transformed vector.
     */
    public inline function linearTransformTo(v:Vector2):Vector2
    {
        var self:Frame2 = this;
        return self.linearMatrix.transposeMultiplyVector(v);
    }
    
    /**
     * Get the inverse frame (the effect of to/from will be swapped in the new frame).
     * 
     * @return      The inverse of this frame.    
     */
    public inline function inverse():Frame2
    {
        var self:Frame2 = this;
        return new Frame2(
            self.linearMatrix.transposeMultiplyVector(self.offset).applyNegate(),
            -self.angleDegrees);
    }
    
    /**
     * Clone.
     * 
     * @return  The clone.    
     */
    public inline function clone():Frame2
    {
        var self:Frame2 = this;
        return new Frame2(self.offset, self.angleDegrees);
    }
    
    private inline function get_linearMatrix():Matrix2x2
    {
        var self:Frame2 = this;
        return self.matrix.linearSubMatrix;
    }
}