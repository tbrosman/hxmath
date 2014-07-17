package vtgmath;

// Note: All notation is column-major, e.g. m21 is the top element of the 2nd column
typedef Matrix2x2Shape = 
{
    // m11
    public var a:Float;
    
    // m21
    public var b:Float;
    
    // m12
    public var c:Float;
    
    // m22
    public var d:Float;
}