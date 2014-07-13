package vtgmath;

// Note: All notation is column-major, e.g. m21 is the top element of the 2nd column
typedef Matrix3x3Shape = 
{
    public var m11:Float;
    public var m12:Float;
    public var m13:Float;
    public var m21:Float;
    public var m22:Float;
    public var m23:Float;
    public var m31:Float;
    public var m32:Float;
    public var m33:Float;
}

abstract Matrix3x3(Matrix3x3Shape) from Matrix3x3Shape to Matrix3x3Shape
{
    // Row-major rawData
    public function new(rawData:Array<Float> = null) 
    {
        if (rawData == null)
        {
            this = identity();
        }
        else
        {
            if (rawData.length != 9)
            {
                throw "Invalid rawData.";
            }
            
            this = {
                m11: rawData[0], m21: rawData[1], m31: rawData[2],
                m21: rawData[3], m22: rawData[4], m32: rawData[5],
                m31: rawData[6], m32: rawData[7], m33: rawData[8] };
        }
    }
    
    public static inline function identity():Matrix3x3
    {
        return new Matrix3x3([
            1.0, 0.0, 0.0,
            0.0, 1.0, 0.0,
            0.0, 0.0, 1.0]);
    }
}
