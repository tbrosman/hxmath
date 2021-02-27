package hxmath.frames;

import hxmath.math.MathUtil;
import hxmath.math.Matrix2x2;
import hxmath.math.Matrix3x2;
import hxmath.math.Vector2;

/**
 * The default underlying type for Frame2.
 */
class Frame2Default implements IFrame2
{
    // The associated affine transformation matrix. The private variable holds the cached/last calculated matrix.
    public var matrix(get, never):Matrix3x2;
    
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
        isDirty = true;
        internalMatrix = Matrix3x2.identity;
    }
    
    public function toString():String
    {
        return 'Frame2 { offset: $internalOffset, angleDegrees: $angleDegrees }';
    }

    private inline function get_matrix():Matrix3x2
    {
        // If no caching or the matrix is cached but dirty, recalculate it
        if (!isCached || isDirty)
        {
            Frame2.calculateMatrix(internalMatrix, offset, angleDegrees);
            isDirty = false;
        }
        
        return internalMatrix;
    }
    
    private inline function get_offset():Vector2
    {
        return internalOffset;
    }
    
    private inline function set_offset(offset:Vector2):Vector2
    {
        internalOffset = offset;
        isDirty = true;
        return offset;
    }
    
    private inline function get_angleDegrees():Float
    {
        return internalAngleDegrees;
    }
    
    private inline function set_angleDegrees(angleDegrees:Float):Float
    {
        internalAngleDegrees = angleDegrees;
        isDirty = true;
        return angleDegrees;
    }
}