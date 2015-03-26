package test;

import hxmath.converters.flixel.Vector2Converter;
import hxmath.math.Vector2;
import hxmath.math.Vector3;
import hxmath.math.Vector3.Vector3Shape;
import test.TestConverters.FlxPointMock;
    
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

/**
 * ...
 * @author TABIV
 */
class TestConverters extends MathTestCase
{
    public function new() 
    {
        super();
    }
    
    public function testShapeSimilarConversion()
    {
        var v2a = randomVector2();
        var v2b = { x: 0.0, y: 0.0 }
        var v2c = randomVector2();
        v2a.copyToShape(v2b);
        v2c.copyFromShape(v2b);
        assertTrue(v2a == v2c);
        
        var v3a = randomVector3();
        var v3b = { x: 0.0, y: 0.0, z: 0.0 };
        var v3c = randomVector3();
        v3a.copyToShape(v3b);
        v3c.copyFromShape(v3b);
        assertTrue(v3a == v3c);
        
        var v4a = randomVector4();
        var v4b = { x: 0.0, y: 0.0, z: 0.0, w: 0.0 };
        var v4c = randomVector4();
        v4a.copyToShape(v4b);
        v4c.copyFromShape(v4b);
        assertTrue(v4a == v4c);
        
        var m22a = randomMatrix2x2();
        var m22b = {
            a: 0.0, b: 0.0,
            c: 0.0, d: 0.0
        };
        var m22c = randomMatrix2x2();
        m22a.copyToShape(m22b);
        m22c.copyFromShape(m22b);
        assertTrue(m22a == m22c);
        
        var m32a = randomMatrix3x2();
        var m32b = {
            a: 0.0, b: 0.0,
            c: 0.0, d: 0.0,
            tx: 0.0, ty: 0.0
        };
        var m32c = randomMatrix3x2();
        m32a.copyToShape(m32b);
        m32c.copyFromShape(m32b);
        assertTrue(m32a == m32c);
        
        var m33a = randomMatrix3x3();
        var m33b = {
            m00: 0.0, m01: 0.0, m02: 0.0,
            m10: 0.0, m11: 0.0, m12: 0.0,
            m20: 0.0, m21: 0.0, m22: 0.0
        };
        var m33c = randomMatrix3x3();
        m33a.copyToShape(m33b);
        m33c.copyFromShape(m33b);
        assertTrue(m33a == m33c);
        
        var m44a = randomMatrix4x4();
        var m44b = {
            m00: 0.0, m01: 0.0, m02: 0.0, m03: 0.0,
            m10: 0.0, m11: 0.0, m12: 0.0, m13: 0.0,
            m20: 0.0, m21: 0.0, m22: 0.0, m23: 0.0,
            m30: 0.0, m31: 0.0, m32: 0.0, m33: 0.0
        };
        var m44c = randomMatrix4x4();
        m44a.copyToShape(m44b);
        m44c.copyFromShape(m44b);
        assertTrue(m44a == m44c);
        
        var qa = randomQuaternion();
        var qb = { s: 0.0, x: 0.0, y: 0.0, z: 0.0 };
        var qc = randomQuaternion();
        qa.copyToShape(qb);
        qc.copyFromShape(qb);
        assertTrue(qa == qc);
    }
    
    public function testFlxPointConversion()
    {
        var v = new Vector2(3.0, 1.0);
        
        var q = new FlxPointMock();
        Vector2Converter.copyToFlxPoint(v, q);
        assertEquals(v.x, q.x);
        assertEquals(v.y, q.y);
        
        var u = Vector2.zero;
        Vector2Converter.copyFromFlxPoint(u, q);
        assertEquals(u.x, q.x);
        assertEquals(u.y, q.y);
    }
}