package hxmath.test;

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

/**
 * ...
 * @author TABIV
 */
class Random
{
    public static function randomFloat(center:Float=0.0, width:Float = 1.0, precision:Float=1e-4)
    {
        // Generate a float in the range [center - width/2, center + width/2)
        var x = (Math.random() - 0.5) * width + center;
        
        // Round the the specified precision
        return Math.floor(x / precision) * precision;
    }
    
    public static function randomInt():Int
    {
        return Math.floor(Math.random() * 10);
    }
    
    public static function randomArray(size:Int, distribution:Distribution=null):Array<Float>
    {
        var data = new Array<Float>();
        var distribution = distribution == null ? new Distribution() : distribution;
        
        for (i in 0...size)
        {
            data.push(randomFloat(distribution.center, distribution.width, distribution.precision));
        }
        
        return data;
    }
    
    public static function randomVector2(precision:Float = 1e-4):Vector2
    {
        var distribution = new Distribution();
        distribution.precision = precision;
        return Vector2.fromArray(randomArray(Vector2.elementCount, distribution));
    }
    
    public static function randomVector3(precision:Float = 1e-4):Vector3
    {
        var distribution = new Distribution();
        distribution.precision = precision;
        return Vector3.fromArray(randomArray(Vector3.elementCount, distribution));
    }
    
    public static function randomVector4(precision:Float = 1e-4):Vector4
    {
        var distribution = new Distribution();
        distribution.precision = precision;
        return Vector4.fromArray(randomArray(Vector4.elementCount, distribution));
    }
    
    public static function randomMatrix2x2(precision:Float=1e-4):Matrix2x2
    {
        var distribution = new Distribution();
        distribution.precision = precision;
        return Matrix2x2.fromArray(randomArray(Matrix2x2.elementCount, distribution));
    }
    
    public static function randomMatrix3x2(precision:Float=1e-4):Matrix3x2
    {
        var distribution = new Distribution();
        distribution.precision = precision;
        return Matrix3x2.fromArray(randomArray(Matrix3x2.elementCount, distribution));
    }

    public static function randomMatrix3x3(precision:Float=1e-4):Matrix3x3
    {
        var distribution = new Distribution();
        distribution.precision = precision;
        return Matrix3x3.fromArray(randomArray(Matrix3x3.elementCount, distribution));
    }
    
    public static function randomMatrix4x4(precision:Float=1e-4):Matrix4x4
    {
        var distribution = new Distribution();
        distribution.precision = precision;
        return Matrix4x4.fromArray(randomArray(Matrix4x4.elementCount, distribution));
    }
    
    public static function randomQuaternion(precision:Float=1e-4):Quaternion
    {
        var distribution = new Distribution();
        distribution.precision = precision;
        return Quaternion.fromArray(randomArray(Quaternion.elementCount, distribution));
    }
    
    public static function randomIntVector2():IntVector2
    {
        return new IntVector2(randomInt(), randomInt());
    }
    
    public static function randomShortVector2():ShortVector2
    {
        return new ShortVector2(randomInt(), randomInt());
    }
    
    public static function randomFrame2(precision:Float = 1e-4):Frame2
    {
        return new Frame2(randomVector2(precision), randomFloat(0.0, 1.0, precision) * Math.PI);
    }
    
    public static function randomFrame3(precision:Float = 1e-4):Frame3
    {
        return new Frame3(randomVector3(precision), randomQuaternion(precision).normal);
    }
}

class Distribution
{
    public var center:Float = 0.0;
    public var width:Float = 1.0;
    public var precision:Float = 1e-4;
    
    public function new() 
    {
    }
}
