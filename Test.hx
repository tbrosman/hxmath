import test.TestMain;
import vtgmath.Matrix3x2;
import vtgmath.Quaternion;
import vtgmath.Vector2;
import vtgmath.Vector3;

class MyVector2
{
    public var x:Float;
    public var y:Float;
    
    public function new()
    {
        
    }
}

abstract MyVector2Abstract(MyVector2) from MyVector2 to MyVector2
{
}

class Test {
    static function main() {
        
        TestMain.main();
        
        #if sys
        Sys.stdin().readLine();
        #end
        return;
        
        var p = new Vector2(1.0, 2.0);
        var q = new Vector2(1.0, 4.0);
        trace(Vector2.dot(p, q));
        trace(p*q);
        trace(2 * p);
        
        var x = new Vector3(1, 0, 0);
        var y = new Vector3(0, 1, 0);
        var z = x ^ y;
        trace(z);
        var none = (x ^ y) ^ z;
        trace(none);
        trace(Vector2.xAxis);
        
        var q = new Quaternion(1, Vector3.xAxis);
        var p = new Quaternion(1, Vector3.yAxis);
        
        var m = new Matrix3x2(1.0, 0.0, 0.0, 1.0, 10, 1.0);
        var v = new Vector2(1.0, 0.0);
        trace(m * v);
        trace(Matrix3x2.transform(m, v));
        
        trace(q * p);
        
        var myVec = new MyVector2();
        var vec2:Vector2 = myVec;
        trace(vec2);
        
        
        #if sys
        Sys.stdin().readLine();
        #end
    }
}