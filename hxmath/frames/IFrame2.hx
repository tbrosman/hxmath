package hxmath.frames;

import hxmath.math.Matrix3x2;
import hxmath.math.Vector2;

/**
 * ...
 * @author TABIV
 */
interface IFrame2
{
    // The associated affine transformation matrix. The private variable holds the cached/last calculated matrix.
    public var matrix(get, never):Matrix3x2;
    
    // The offset between the origin and the outer frame
    public var offset(get, set):Vector2;
    
    // The angle by which the frame is rotated about the origin
    public var angleDegrees(get, set):Float;
}