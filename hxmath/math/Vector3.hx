package hxmath.math;

typedef Vector3Shape =
{
    public var x:Float;
    public var y:Float;
    public var z:Float;
}

@:forward(x, y, z)
abstract Vector3(Vector3Shape) from Vector3Shape to Vector3Shape
{
    public static inline var elementCount:Int = 3;
    
    public static var zero(get, never):Vector3;
    public static var xAxis(get, never):Vector3;
    public static var yAxis(get, never):Vector3;
    public static var zAxis(get, never):Vector3;
    
    public var length(get, never):Float;
    public var lengthSq(get, never):Float;
    
    public function new(x:Float = 0.0, y:Float = 0.0, z:Float = 0.0)
    {
        this = {x: x, y: y, z: z};
    }
    
    /**
     * Construct a Vector3 from an array.
     * 
     * @param rawData   The input array.
     * @return          The constructed structure.
     */
    public static inline function fromArray(rawData:Array<Float>):Vector3
    {
        if (rawData.length != Vector3.elementCount)
        {
            throw "Invalid rawData.";
        }
        
        return new Vector3(rawData[0], rawData[1], rawData[2]);
    }
    
    @:op(A * B)
    public static inline function dot(a:Vector3, b:Vector3):Float
    {
        return
            a.x * b.x +
            a.y * b.y +
            a.z * b.z;
    }
    
    @:op(A ^ B)
    public static inline function cross(a:Vector3, b:Vector3):Vector3
    {
        return new Vector3(
            a.y * b.z - a.z * b.y,
            a.z * b.x - a.x * b.z,
            a.x * b.y - a.y * b.x);
    }
    
    @:op(A * B)
    public static inline function scalarMultiply(s:Float, a:Vector3):Vector3
    {
        return new Vector3(
            s * a.x,
            s * a.y,
            s * a.z);
    }
    
    @:op(A + B)
    public static inline function add(a:Vector3, b:Vector3):Vector3
    {
        return a.clone()
            .addWith(b);
    }
    
    @:op(A - B)
    public static inline function subtract(a:Vector3, b:Vector3):Vector3
    {
        return a.clone()
            .subtractWith(b);
    }
    
    @:op(-A)
    public static inline function negate(a:Vector3):Vector3
    {
        return new Vector3(
            -a.x,
            -a.y,
            -a.z);
    }
    
    @:op(A == B)
    public static inline function equals(a:Vector3, b:Vector3):Bool
    {
        return (a == null && b == null) ||
            a != null &&
            b != null &&
            a.x == b.x && 
            a.y == b.y &&
            a.z == b.z;
    }
    
    public static inline function addWith(a:Vector3, b:Vector3):Vector3
    {
        a.x += b.x;
        a.y += b.y;
        a.z += b.z;
        return a;
    }
    
    public static inline function subtractWith(a:Vector3, b:Vector3):Vector3
    {
        a.x -= b.x;
        a.y -= b.y;
        a.z -= b.z;
        return a;
    }
    
    public static inline function lerp(a:Vector3, b:Vector3, t:Float):Vector3
    {
        return t*a + (1.0 - t)*b;
    }
    
    /**
     * Copy the contents of this structure to another.
     * 
     * @param other     The target structure.
     */
    public inline function copyTo(other:Vector3):Void
    {
        var self:Vector3 = this;
        
        for (i in 0...Vector3.elementCount)
        {
            other[i] = self[i];
        }
    }
    
    public inline function clone():Vector3
    {
        var self:Vector3 = this;
        return new Vector3(self.x, self.y, self.z);
    }
    
    @:arrayAccess
    public inline function getArrayElement(i:Int):Float
    {
        var self:Vector3 = this;
        switch (i)
        {
            case 0:
                return self.x;
            case 1:
                return self.y;
            case 2:
                return self.z;
            default:
                throw "Invalid element";
        }
    }
    
    @:arrayAccess
    public inline function setArrayElement(i:Int, value:Float):Float
    {
        var self:Vector3 = this;
        switch (i)
        {
            case 0:
                return self.x = value;
            case 1:
                return self.y = value;
            case 2:
                return self.z = value;
            default:
                throw "Invalid element";
        }
    }
    
    /**
     * Apply a scalar function to each element.
     * 
     * @param func  The function to apply.
     * @return      The modified object.
     */
    public inline function applyScalarFunc(func:Float->Float):Vector3
    {
        var self:Vector3 = this;
        
        for (i in 0...3)
        {
            self[i] = func(self[i]);
        }
        
        return self;
    }
    
    private inline function get_length():Float
    {
        var self:Vector3 = this;
        return Math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z);
    }
    
    private inline function get_lengthSq():Float
    {
        var self:Vector3 = this;
        return self.x * self.x + self.y * self.y + self.z * self.z;
    }
    
    private static inline function get_zero():Vector3
    {
        return new Vector3(0.0, 0.0, 0.0);
    }
    
    private static inline function get_xAxis():Vector3
    {
        return new Vector3(1.0, 0.0, 0.0);
    }
    
    private static inline function get_yAxis():Vector3
    {
        return new Vector3(0.0, 1.0, 0.0);
    }
    
    private static inline function get_zAxis():Vector3
    {
        return new Vector3(0.0, 0.0, 1.0);
    }
}

