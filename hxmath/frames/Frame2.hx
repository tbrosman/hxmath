package hxmath.frames;

import hxmath.math.MathUtil;
import hxmath.math.Matrix2x2;
import hxmath.math.Matrix3x2;
import hxmath.math.Vector2;

/**
 * A 2D affine frame with an offset from the outer frame as well as a rotation relative to the outer frame.
 */
class Frame2 extends BaseFrame2
{
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
        super();
        
        internalOffset = offset == null
            ? Vector2.zero
            : offset;
        internalAngleDegrees = angleDegrees;
        this.isCached = isCached;
        internalMatrix = new Matrix3x2();
    }

    private override function get_matrix():Matrix3x2
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
    
    private override function get_offset():Vector2
    {
        return internalOffset;
    }
    
    private override function set_offset(offset:Vector2):Vector2
    {
        internalOffset = offset;
        isDirty = true;
        return offset;
    }
    
    private override function get_angleDegrees():Float
    {
        return internalAngleDegrees;
    }
    
    private override function set_angleDegrees(angleDegrees:Float):Float
    {
        internalAngleDegrees = angleDegrees;
        isDirty = true;
        return angleDegrees;
    }
}