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
    private function randomFloat(center:Float=0.0, width:Float = 1.0, precision:Float=1e-4)
    {
        // Generate a float in the range [center - width/2, center + width/2)
        var x = (Math.random() - 0.5) * width + center;
        
        // Round the the specified precision
        return Math.floor(x / precision) * precision;
    }
    
    private function randomArray(size:Int, distribution:Distribution=null):Array<Float>
    {
        var data = new Array<Float>();
        var distribution = distribution == null ? new Distribution() : distribution;
        
        for (i in 0...size)
        {
            data.push(randomFloat(distribution.center, distribution.width, distribution.precision));
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
    
    private function randomMatrix2x2(precision:Float=1e-4):Matrix2x2
    {
        var distribution = new Distribution();
        distribution.precision = precision;
        var data = randomArray(4, distribution);
        return new Matrix2x2(data[0], data[1], data[2], data[3]);
    }

    private function randomMatrix3x3(precision:Float=1e-4):Matrix3x3
    {
        var distribution = new Distribution();
        distribution.precision = precision;
        return new Matrix3x3(randomArray(9, distribution));
    }
    
    private function randomMatrix4x4(precision:Float=1e-4):Matrix4x4
    {
        var distribution = new Distribution();
        distribution.precision = precision;
        return new Matrix4x4(randomArray(16, distribution));
    }
}