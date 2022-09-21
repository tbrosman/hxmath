package hxmath.test;

import hxmath.geom.Ray2;
import hxmath.math.Vector2;

class TestRays extends Test {
    public function testEval()
    {
        var r = new Ray2(Vector2.zero, new Vector2(1, 1).normal);
        MathAssert.floatEquals(new Vector2(-1, -1), r.eval(-Math.sqrt(2)));
        MathAssert.floatEquals(new Vector2(0, 0), r.eval(0));
        MathAssert.floatEquals(new Vector2(1, 1), r.eval(Math.sqrt(2)));
        MathAssert.floatEquals(new Vector2(2, 2), r.eval(Math.sqrt(8)));
        
        var r = new Ray2(new Vector2(10, 10), -Vector2.xAxis);
        MathAssert.floatEquals(new Vector2(5, 10), r.eval(5));
        MathAssert.floatEquals(new Vector2(20, 10), r.eval(-10));
    }
    
    public function testIntersect()
    {
        var r = new Ray2(Vector2.zero, new Vector2(1, 1).normal);
        
        Assert.floatEquals(1, r.intersectPoint(new Vector2(1, 1).normal));
        Assert.equals(Math.NEGATIVE_INFINITY, r.intersectPoint(new Vector2(0, 1)));
        
        // Fails because `intersectPoint()` doesn't call `Math.abs(d)`:
        // Assert.equals(Math.NEGATIVE_INFINITY, r.intersectPoint(new Vector2(1, 0)));
    }
    
    public function testGetClosestPoint()
    {
        var r = new Ray2(Vector2.zero, new Vector2(1, 1).normal);
        
        // Fails because `getClosestPoint()` requires `t > 0.0`:
        // MathAssert.isTrue(0 == r.getClosestPoint([ new Vector2(0, 0) ]));
        
        MathAssert.isTrue(1 == r.getClosestPoint([
            new Vector2(-1, -1),
            new Vector2(1, 1),
            new Vector2(2, 2)
        ]));
        
        MathAssert.isTrue(0 == r.getClosestPoint([
            new Vector2(200, 200),
            // Fails because `intersectPoint()` doesn't call `Math.abs(d)`:
            // new Vector2(1, 0),
            new Vector2(0, 1)
        ]));
    }
}