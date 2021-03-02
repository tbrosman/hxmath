package hxmath.frames;

import hxmath.math.Matrix4x4;
import hxmath.math.Vector3;
import hxmath.math.Quaternion;

/**
 * The shape over which all Frame2 operations are defined.
 */
interface IFrame3
{
    // Get the associated affine transformation matrix. Kept on the interface to allow for caching/etc depending on
    // the frame type (for example, explicit frames such as the default Frame3 implementation can be cached while
    // implicit frames cannot without the source object having a way to notify the frame that the cached value is
    // no longer valid).
    public var matrix(get, never):Matrix4x4;
    
    // The offset between the origin and the outer frame
    public var offset(get, set):Vector3;
    
    // The orientation of the frame about the origin
    public var orientation(get, set):Quaternion;
}