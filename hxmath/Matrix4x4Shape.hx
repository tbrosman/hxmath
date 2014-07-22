package hxmath;

// Note: All notation is column-major, e.g. m10 is the top element of the 2nd column
typedef Matrix4x4Shape = 
{
    public var m00:Float;
    public var m01:Float;
    public var m02:Float;
    public var m03:Float;
    
    public var m10:Float;
    public var m11:Float;
    public var m12:Float;
    public var m13:Float;
    
    public var m20:Float;
    public var m21:Float;
    public var m22:Float;
    public var m23:Float;
    
    public var m30:Float;
    public var m31:Float;
    public var m32:Float;
    public var m33:Float;
}