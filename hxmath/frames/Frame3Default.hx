package hxmath.frames;

import hxmath.math.MathUtil;
import hxmath.math.Matrix4x4;
import hxmath.math.Matrix3x3;
import hxmath.math.Vector3;
import hxmath.math.Quaternion;

/**
 * The default underlying type for Frame2.
 */
class Frame3Default implements IFrame3
{
    // The associated affine transformation matrix. The private variable holds the cached/last calculated matrix.
    public var matrix(get, never):Matrix4x4;
    
    // The offset between the origin and the outer frame
    public var offset(get, set):Vector3;
    
    // The orientation of the frame about the origin
    public var orientation(get, set):Quaternion;
    
    // The last calculated/cached matrix
    private var internalMatrix:Matrix4x4;
    
    // Stores offset in non-adapter cases
    private var internalOffset:Vector3;
    
    // Stores orientation in non-adapter cases
    private var internalOrientation:Quaternion;
    
    // True if the matrix is cached
    private var isCached:Bool = true;
    
    // True if the cached matrix needs to be recalculated
    private var isDirty:Bool = true;
    
    /**
     * Constructor.
     * 
     * @param offset        The offset of the frame relative to the outer frame.
     * @param orientation   The orientation of the frame about the origin.
     * @param isCached      Cache the matrix if true.
     */
    public function new(offset:Vector3=null, orientation:Quaternion=null, isCached:Bool=true) 
    {
        internalOffset = offset == null
            ? Vector3.zero
            : offset;
        internalOrientation = orientation == null
            ? Quaternion.identity
            : orientation;
        this.isCached = isCached;
        isDirty = true;
        internalMatrix = Matrix4x4.identity;
    }
    
    public function toString():String
    {
        return 'Frame3 { offset: $internalOffset, orientation: $internalOrientation }';
    }

    private inline function get_matrix():Matrix4x4
    {
        // If no caching or the matrix is cached but dirty, recalculate it
        if (!isCached || isDirty)
        {
            Frame3.calculateMatrix(internalMatrix, offset, orientation);
            isDirty = false;
        }
        
        return internalMatrix;
    }
    
    private inline function get_offset():Vector3
    {
        return internalOffset;
    }
    
    private inline function set_offset(offset:Vector3):Vector3
    {
        internalOffset = offset;
        isDirty = true;
        return offset;
    }
    
    private inline function get_orientation():Quaternion
    {
        return internalOrientation;
    }
    
    private inline function set_orientation(orientation:Quaternion):Quaternion
    {
        internalOrientation = orientation;
        isDirty = true;
        return orientation;
    }
}