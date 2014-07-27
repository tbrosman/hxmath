package hxmath;
import hxmath.Vector3Shape;

@:forward(s, v)
abstract Quaternion(QuaternionShape) from QuaternionShape to QuaternionShape
{
    public static var zero(get, never):Quaternion;
    public static var identity(get, never):Quaternion;
    
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
    public static inline function scalarMultiply(s:Float, a:Quaternion):Quaternion
    {
        return new Quaternion(s * a.s, s * a.v);
    }
    
    @:op(A * B)
    public static inline function multiply(a:Quaternion, b:Quaternion):Quaternion
    {
        return new Quaternion(a.s * b.s - a.v * b.v, a.s * b.v + b.s * a.v + a.v ^ b.v);
    }
    
    @:op(~A)
    public static inline function conjugate(a:Quaternion):Quaternion
    {
        return new Quaternion(a.s, -1.0 * a.v);
    }
    
    @:op(A == B)
    public static inline function equals(a:Quaternion, b:Quaternion):Bool
    {
        return a.s == b.s && a.v == b.v;
    }
    
    @:op(A != B)
    public static inline function notEquals(a:Quaternion, b:Quaternion):Bool
    {
        return !(a == b);
    }
    
    public static inline function normalize(a:Quaternion):Quaternion
    {
        var r2 = a.s * a.s + a.v * a.v;
        var r = Math.sqrt(r2);
        return (1.0 / r) * a;
    }
    
    public inline function clone():Quaternion
    {
        var self:Quaternion = this;
        return new Quaternion(self.s, self.v);
    }
    
    private static inline function get_zero():Quaternion
    {
        return new Quaternion(0.0, Vector3.zero);
    }
    
    private static inline function get_identity():Quaternion
    {
        return new Quaternion(1.0, Vector3.zero);
    }
}