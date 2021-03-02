package hxmath.test;

import haxe.PosInfos;
import hxmath.frames.Frame2;
import hxmath.frames.Frame3;
import hxmath.math.IntVector2;
import hxmath.math.Matrix2x2;
import hxmath.math.Matrix3x2;
import hxmath.math.Matrix3x3;
import hxmath.math.Matrix4x4;
import hxmath.math.Quaternion;
import hxmath.math.ShortVector2;
import hxmath.math.Vector2;
import hxmath.math.Vector3;
import hxmath.math.Vector4;
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
    
    private function randomInt():Int
    {
        return Math.floor(Math.random() * 10);
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
            fail('expected $expected +-$tolerance but was $actual', p);
        }
    }
    
    private function randomVector2(precision:Float = 1e-4):Vector2
    {
        var distribution = new Distribution();
        distribution.precision = precision;
        return Vector2.fromArray(randomArray(Vector2.elementCount, distribution));
    }
    
    private function randomVector3(precision:Float = 1e-4):Vector3
    {
        var distribution = new Distribution();
        distribution.precision = precision;
        return Vector3.fromArray(randomArray(Vector3.elementCount, distribution));
    }
    
    private function randomVector4(precision:Float = 1e-4):Vector4
    {
        var distribution = new Distribution();
        distribution.precision = precision;
        return Vector4.fromArray(randomArray(Vector4.elementCount, distribution));
    }
    
    private function randomMatrix2x2(precision:Float=1e-4):Matrix2x2
    {
        var distribution = new Distribution();
        distribution.precision = precision;
        return Matrix2x2.fromArray(randomArray(Matrix2x2.elementCount, distribution));
    }
    
    private function randomMatrix3x2(precision:Float=1e-4):Matrix3x2
    {
        var distribution = new Distribution();
        distribution.precision = precision;
        return Matrix3x2.fromArray(randomArray(Matrix3x2.elementCount, distribution));
    }

    private function randomMatrix3x3(precision:Float=1e-4):Matrix3x3
    {
        var distribution = new Distribution();
        distribution.precision = precision;
        return Matrix3x3.fromArray(randomArray(Matrix3x3.elementCount, distribution));
    }
    
    private function randomMatrix4x4(precision:Float=1e-4):Matrix4x4
    {
        var distribution = new Distribution();
        distribution.precision = precision;
        return Matrix4x4.fromArray(randomArray(Matrix4x4.elementCount, distribution));
    }
    
    private function randomQuaternion(precision:Float=1e-4):Quaternion
    {
        var distribution = new Distribution();
        distribution.precision = precision;
        return Quaternion.fromArray(randomArray(Quaternion.elementCount, distribution));
    }
    
    private function randomIntVector2():IntVector2
    {
        return new IntVector2(randomInt(), randomInt());
    }
    
    private function randomShortVector2():ShortVector2
    {
        return new ShortVector2(randomInt(), randomInt());
    }
    
    private function randomFrame2(precision:Float = 1e-4):Frame2
    {
        return new Frame2(randomVector2(precision), randomFloat(0.0, 1.0, precision) * Math.PI);
    }
    
    private function randomFrame3(precision:Float = 1e-4):Frame3
    {
        return new Frame3(randomVector3(precision), randomQuaternion(precision).normal);
    }
}