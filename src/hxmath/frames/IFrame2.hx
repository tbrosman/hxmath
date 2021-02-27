package hxmath.frames;

import hxmath.math.Matrix3x2;
import hxmath.math.Vector2;

/**
 * The shape over which all Frame2 operations are defined.
 */
interface IFrame2
{
    // Get the associated affine transformation matrix. Kept on the interface to allow for caching/etc depending on
    // the frame type (for example, explicit frames such as the default Frame2 implementation can be cached while
    // implicit frames cannot without the source object having a way to notify the frame that the cached value is
    // no longer valid).
    public var matrix(get, never):Matrix3x2;
    
    // The offset between the origin and the outer frame
    public var offset(get, set):Vector2;
    
    // The angle by which the frame is rotated about the origin
    public var angleDegrees(get, set):Float;
}