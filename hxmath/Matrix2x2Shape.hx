package hxmath;

// Note: All notation is column-major, e.g. m10 is the top element of the 2nd column
typedef Matrix2x2Shape = 
{
    // m00
    public var a:Float;
    
    // m10
    public var b:Float;
    
    // m01
    public var c:Float;
    
    // m11
    public var d:Float;
}