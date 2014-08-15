package hxmath.frames;
import hxmath.math.MathUtil;
import hxmath.math.Matrix2x2;
import hxmath.math.Matrix3x2;
import hxmath.math.Vector2;
 
/**
 * An abstract 2D affine frame that can be extended without carrying over all the variables of the full Frame2 class.
 */
@:forward(matrix, offset, angleDegrees)
abstract Frame2(IFrame2) from IFrame2
{
    // The associated linear transformation matrix
    public var linearMatrix(get, never):Matrix2x2;

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
        
        // TODO: make this in-place and avoid allocating the vector
        matrix.t = offset;
        
        return matrix;
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
        var resultOffset = self.linearMatrix * other.offset + self.offset;
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
        return self.matrix.transform(p);
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
        return self.linearMatrix.transposeMultiplyVector(p - self.matrix.t);
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
        return new Frame2(-self.linearMatrix.transposeMultiplyVector(self.offset), -self.angleDegrees);
    }
    
    /**
     * Create a new Frame2 from this frame.
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