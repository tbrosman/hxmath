package hxmath.test;

import hxmath.converters.flixel.Vector2Converter;
import hxmath.math.IntVector2;
import hxmath.math.MathUtil;
import hxmath.math.ShortVector2;
import hxmath.math.Vector2;
import hxmath.math.Vector3;
import hxmath.math.Vector4;

class TestVectors extends Test {
    public function testAngles()
    {
		// 2D
        Assert.floatEquals(Math.PI / 4.0, Vector2.yAxis.signedAngleWith(new Vector2(-1, 1)));
        Assert.floatEquals(-Math.PI / 4.0, Vector2.yAxis.signedAngleWith(new Vector2(1, 1)));
        Assert.floatEquals(3.0 * Math.PI / 4.0, Vector2.yAxis.signedAngleWith(new Vector2(-1, -1)));
        Assert.floatEquals(-3.0 * Math.PI / 4.0, Vector2.yAxis.signedAngleWith(new Vector2(1, -1)));
        
        Assert.floatEquals(-Math.PI / 2.0, Vector2.yAxis.signedAngleWith(Vector2.xAxis));
        Assert.floatEquals(Math.PI / 2.0, Vector2.xAxis.signedAngleWith(Vector2.yAxis));
        
        Assert.floatEquals(Math.PI / 2.0, Vector2.yAxis.angleWith(Vector2.xAxis));
        Assert.floatEquals(Math.PI / 2.0, Vector2.xAxis.angleWith(Vector2.yAxis));
		
		// 3D
        Assert.floatEquals(Math.PI / 2.0, Vector3.xAxis.angleWith(Vector3.yAxis));
        Assert.floatEquals(Math.PI / 2.0, Vector3.xAxis.angleWith(Vector3.zAxis));
        Assert.floatEquals(Math.PI / 2.0, Vector3.yAxis.angleWith(Vector3.zAxis));
		
		// 4D (not implemented yet)
        /* Assert.floatEquals(Math.PI / 2.0, Vector4.xAxis.angleWith(Vector4.yAxis));
        Assert.floatEquals(Math.PI / 2.0, Vector4.xAxis.angleWith(Vector4.zAxis));
        Assert.floatEquals(Math.PI / 2.0, Vector4.yAxis.angleWith(Vector4.zAxis)); */
    }
    
    public function testCrossProductPrecedence()
    {
        Assert.isTrue(2.0 * Vector3.xAxis == Vector3.xAxis + Vector3.yAxis % Vector3.zAxis);
    }
	
    public function testFlxPointConversion()
    {
        var v = new Vector2(3.0, 1.0);
        
        var q = new FlxPointMock();
        Vector2Converter.copyToFlxPoint(v, q);
        Assert.equals(v.x, q.x);
        Assert.equals(v.y, q.y);
        
        var u = Vector2.zero;
        Vector2Converter.copyFromFlxPoint(u, q);
        Assert.equals(q.x, u.x);
        Assert.equals(q.y, u.y);
    }
    
    public function specIntVector2Conversion()
    {
        new IntVector2(1, 2) == new Vector2(1.1, 2.1).toIntVector2();
        new IntVector2(2, 3) == new Vector2(1.1, 2.1).toIntVector2(Math.ceil);
        
        new Vector2(1.0, 2.0) == new IntVector2(1, 2).toVector2();
        
        new Vector2(1.0, 2.0) == new ShortVector2(1, 2).toVector2();
    }
	
    public function specMultiplyByZero()
    {
        0.0 == Vector2.xAxis * Vector2.yAxis;
        Vector2.zero == 0.0 * Vector2.xAxis;
        
        0.0 == Vector3.xAxis * Vector3.yAxis;
        Vector3.zero == 0.0 * Vector3.xAxis;
        
        0.0 == Vector4.xAxis * Vector4.yAxis;
        Vector4.zero == 0.0 * Vector4.xAxis;
        
        0 == IntVector2.xAxis * IntVector2.yAxis;
        IntVector2.zero == 0 * IntVector2.xAxis;
    }
    
    public function testNormalize()
    {
        Assert.isTrue(Vector2.yAxis == new Vector2(0, 300).normal);
        Assert.floatEquals(1.0, new Vector2(20, 20).normal.length);
        Assert.floatEquals(1.1, new Vector2(20, 20).normalizeTo(1.1).length);
		
		// TODO: implement Vector3.normal and Vector4.normal
        Assert.isTrue(Vector3.yAxis == new Vector3(0, 300, 0).normalize());
        Assert.floatEquals(1.0, new Vector3(20, 20, 20).normalize().length);
        Assert.floatEquals(1.1, new Vector3(20, 20, 20).normalizeTo(1.1).length);
		
        Assert.isTrue(Vector4.yAxis == new Vector4(0, 300, 0, 0).normalize());
        Assert.floatEquals(1.0, new Vector4(20, 20, 20, 20).normalize().length);
        Assert.floatEquals(1.1, new Vector4(20, 20, 20, 20).normalizeTo(1.1).length);
    }
    
    public function testOrthoNormalize()
    {
        for (i in 0...10)
        {
            var u = randomVector2();
            var v = randomVector2();
            
            Vector2.orthoNormalize(u, v);
            
            Assert.floatEquals(1.0, u.length);
            Assert.floatEquals(1.0, v.length);
            Assert.floatEquals(0.0, u * v);
        }
		
        for (i in 0...10)
        {
            var u = randomVector3();
            var v = randomVector3();
            var w = randomVector3();
            
            Vector3.orthoNormalize(u, v, w);
            
            Assert.floatEquals(1.0, u.length);
            Assert.floatEquals(1.0, v.length);
            Assert.floatEquals(1.0, w.length);
            Assert.floatEquals(0.0, u * v);
            Assert.floatEquals(0.0, u * w);
            Assert.floatEquals(0.0, v * w);
        }
		
		// Not implemented for Vector4 yet
        /* for (i in 0...10)
        {
            var u = randomVector4();
            var v = randomVector4();
            var w = randomVector4();
            var x = randomVector4();
            
            Vector4.orthoNormalize(u, v, w, x);
            
            Assert.floatEquals(1.0, u.length);
            Assert.floatEquals(1.0, v.length);
            Assert.floatEquals(1.0, w.length);
            Assert.floatEquals(1.0, x.length);
            Assert.floatEquals(0.0, u * v);
            Assert.floatEquals(0.0, u * w);
            Assert.floatEquals(0.0, u * x);
            Assert.floatEquals(0.0, v * w);
            Assert.floatEquals(0.0, v * x);
            Assert.floatEquals(0.0, w * x);
        } */
    }
    
    public function testPolarCoordinates()
    {
        MathAssert.floatEquals(Vector2.fromPolar(Math.PI * 0.5, 1.0), Vector2.yAxis);
        MathAssert.floatEquals(Vector2.fromPolar(Math.PI * 1.0, 1.0), -Vector2.xAxis);
        MathAssert.floatEquals(Vector2.fromPolar(Math.PI * 1.5, 1.0), -Vector2.yAxis);
        
        // Some backends give +PI, others -PI (they are both equivalent)
        Assert.floatEquals(Math.PI, Math.abs((-Vector2.xAxis).angle));
		
        var v = new Vector2(1,0);
        var iterations = 8;
        
        for (i in 0...iterations)
        {
            // Get incremental radian based on number of iterations
            var a = (2 * Math.PI) * (i / iterations); 
            
            // Set vector2's angle
            v.angle = a;
            
            // Wrap the the vector's angle output, as Math.atan2 (used in Vector2.angle) may return a negative value
            var va = MathUtil.wrap(v.angle, 2 * Math.PI);
            
            Assert.floatEquals(a, va);
        }
	}
	
    public function testProject()
    {
		Assert.isTrue(new Vector2(1, 0) == new Vector2(1, 2).projectOnto(Vector2.xAxis));
		Assert.isTrue(new Vector2(0, 2) == new Vector2(1, 2).projectOnto(Vector2.yAxis));
		
		Assert.isTrue(new Vector3(1, 0, 0) == new Vector3(1, 2, 3).projectOnto(Vector3.xAxis));
		Assert.isTrue(new Vector3(0, 2, 0) == new Vector3(1, 2, 3).projectOnto(Vector3.yAxis));
		Assert.isTrue(new Vector3(0, 0, 3) == new Vector3(1, 2, 3).projectOnto(Vector3.zAxis));
		
		Assert.isTrue(new Vector3(0, 2, 3) == new Vector3(1, 2, 3).projectOntoPlane(Vector3.xAxis));
		Assert.isTrue(new Vector3(1, 0, 3) == new Vector3(1, 2, 3).projectOntoPlane(Vector3.yAxis));
		Assert.isTrue(new Vector3(1, 2, 0) == new Vector3(1, 2, 3).projectOntoPlane(Vector3.zAxis));
		
		Assert.isTrue(new Vector4(1, 0, 0, 0) == new Vector4(1, 2, 3, 4).projectOnto(Vector4.xAxis));
		Assert.isTrue(new Vector4(0, 2, 0, 0) == new Vector4(1, 2, 3, 4).projectOnto(Vector4.yAxis));
		Assert.isTrue(new Vector4(0, 0, 3, 0) == new Vector4(1, 2, 3, 4).projectOnto(Vector4.zAxis));
		Assert.isTrue(new Vector4(0, 0, 0, 4) == new Vector4(1, 2, 3, 4).projectOnto(Vector4.wAxis));
    }
    
    public function testReflect()
    {
        for (i in 0...10)
        {
            var u = randomVector2();
            var v = Vector2.reflect(u, Vector2.yAxis);
            
            Assert.equals(u.x, v.x);
            Assert.equals(-u.y, v.y);
        }
		
        for (i in 0...10)
        {
            var u = randomVector3();
            var v = Vector3.reflect(u, Vector3.zAxis);
            
            Assert.equals(u.x, v.x);
            Assert.equals(u.y, v.y);
            Assert.equals(-u.z, v.z);
        }
		
		// Not implemented for Vector4 yet
        /* for (i in 0...10)
        {
            var u = randomVector4();
            var v = Vector4.reflect(u, Vector4.wAxis);
            
            Assert.equals(u.x, v.x);
            Assert.equals(u.y, v.y);
            Assert.equals(u.z, v.z);
            Assert.equals(-u.w, v.w);
        } */
    }
	
    public function testRotate()
    {
        Assert.isTrue(Vector2.yAxis == Vector2.xAxis.rotateLeft());
		MathAssert.floatEquals(Vector2.yAxis, Vector2.xAxis.rotate(Math.PI / 2.0, Vector2.zero));
		MathAssert.floatEquals(new Vector2(0, 2), Vector2.zero.rotate(Math.PI, Vector2.yAxis));
		MathAssert.floatEquals(new Vector2(2, 2), new Vector2(0, 2).rotate(Math.PI, new Vector2(1, 2)));
		
        Assert.isTrue(-Vector2.xAxis == Vector2.yAxis.rotateLeft());
		MathAssert.floatEquals((-Vector2.xAxis), Vector2.yAxis.rotate(Math.PI / 2.0, Vector2.zero));
    }
}

class FlxPointMock
{
    public var x(default, set):Float = 0.0;
    public var y(default, set):Float = 0.0;
    
    public function new(X:Float = 0.0, Y:Float = 0.0)
    {
        this.x = X;
        this.y = Y;
    }
    
    private function set_x(value:Float):Float
    {
        return this.x = value;
    }
    
    private function set_y(value:Float):Float
    {
        return this.y = value;
    }
    
    public function toString():String
    {
        return '$x, $y';
    }
}
