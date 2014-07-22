package hxmath;
import hxmath.Vector3Shape;

@:forward(s, v)
abstract Quaternion(QuaternionShape) from QuaternionShape to QuaternionShape
{
    public function new(s:Float=1.0, v:Vector3Shape=null) 
    {
        this = {
            s: s,
            v: v != null
                ? v
                : { x: 0.0, y: 0.0, z: 0.0 }
        };
    }
    
    @:op(A * B)
    public static function scalarMultiply(s:Float, a:Quaternion):Quaternion
    {
        return new Quaternion(s * a.s, s * a.v);
    }
    
    @:op(A * B)
    public static function multiply(a:Quaternion, b:Quaternion):Quaternion
    {
        return new Quaternion(a.s * b.s - a.v * b.v, a.s * b.v + b.s * a.v + a.v ^ b.v);
    }
    
    public static function normalize(a:Quaternion):Quaternion
    {
        var r2 = a.s * a.s + a.v * a.v;
        var r = Math.sqrt(r2);
        return (1.0 / r) * a;
    }
    
    @:op(~A)
    public static function conjugate(a:Quaternion):Quaternion
    {
        return new Quaternion(a.s, -1.0 * a.v);
    }
}