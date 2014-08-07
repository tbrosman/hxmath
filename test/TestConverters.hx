package test;

import hxmath.converters.Vector2Converter;
import hxmath.Vector2;
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
    
    public function testFlxPointConversion()
    {
        var v = new Vector2(3.0, 1.0);
        
        var p:FlxPointMock = Vector2Converter.cloneTo(v);
        assertEquals(v.x, p.x);
        assertEquals(v.y, p.y);
        
        var u:Vector2 = Vector2Converter.cloneFromFlxPoint(p);
        assertEquals(u.x, p.x);
        assertEquals(u.y, p.y);
        
        var q = new FlxPointMock();
        Vector2Converter.copyToFlxPoint(v, q);
        assertEquals(v.x, q.x);
        assertEquals(v.y, q.y);
        
        var u = new Vector2();
        Vector2Converter.copyFromFlxPoint(u, q);
        assertEquals(u.x, q.x);
        assertEquals(u.y, q.y);
    }
}