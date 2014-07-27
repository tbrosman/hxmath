package test;
import haxe.PosInfos;
import hxmath.Matrix2x2;
import hxmath.Matrix3x3;
import hxmath.Matrix4x4;
import nanotest.NanoTestCase;

/**
 * ...
 * @author TABIV
 */
class MathTestCase extends NanoTestCase
{
    private function randomArray(size:Int, center:Float=0.0, width:Float=1.0):Array<Float>
    {
        var data = new Array<Float>();
        
        for (i in 0...size)
        {
            data.push((Math.random() - 0.5) * width + center);
        }
        
        return data;
    }
    
    private function assertApproxEquals(expected:Float, actual:Float, tolerance:Float=1e-6, ?p:PosInfos)
    {
        if (Math.abs(expected - actual) < tolerance)
        {
            success(p);
        }
        else
        {
            fail('expected $expected +-$tolerance but was $actual');
        }
    }

    private function randomMatrix3x3()
    {
        return new Matrix3x3(randomArray(9));
    }
    
    private function randomMatrix4x4()
    {
        return new Matrix4x4(randomArray(16));
    }
}