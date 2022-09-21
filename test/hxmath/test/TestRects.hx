package hxmath.test;

import hxmath.geom.Rect;
import hxmath.math.MathUtil;
import hxmath.math.Vector2;

/**
 * ...
 * @author TABIV
 */
class TestRects extends Test
{
    public function testAddVector()
    {
        var unitRect = new Rect(0, 0, 1, 1);
        var two = new Vector2(2.0, 2.0);
        
        var unitPlusTwo = unitRect.clone().addWith(two);
        Assert.floatEquals(9, unitPlusTwo.area);
        MathAssert.floatEquals(unitRect.getVertex(0), unitPlusTwo.getVertex(0));
        
        var unitMinusTwo = unitRect.clone().addWith(-two);
        Assert.floatEquals(9, unitMinusTwo.area);
        MathAssert.floatEquals(-two, unitMinusTwo.getVertex(0));
    }
    
    public function testContainsPoint()
    {
        var rect = new Rect(0.5, 0.5, 1.0, 1.0);
        
        Assert.isTrue(rect.containsPoint(rect.center));
        
        for (i in 0...4)
        {
            // Rectangles should contains their vertices
            var p = rect.getVertex(i);
            Assert.isTrue(rect.containsPoint(p));
            
            // Construct a vertex slightly outside the corner of the rectangle
            var q = 1.1 * (p - rect.center) + rect.center;
            Assert.isFalse(rect.containsPoint(q));
        }
    }
    
    public function testDistanceToPoint()
    {
        var unitRect = new Rect(0.0, 0.0, 1.0, 1.0);
        
        // Test points inside
        Assert.equals(0, unitRect.distanceToPoint(unitRect.center));
        for (i in 0...4)
        {
            Assert.floatEquals(0, unitRect.distanceToPoint(unitRect.getVertex(i)));
        }
        
        // Test points in the cardinal directions
        Assert.floatEquals(1, unitRect.distanceToPoint(new Vector2(-1, 0)));
        Assert.floatEquals(1, unitRect.distanceToPoint(new Vector2(2, 0)));
        Assert.floatEquals(1, unitRect.distanceToPoint(new Vector2(0, -1)));
        Assert.floatEquals(1, unitRect.distanceToPoint(new Vector2(0, 2)));
        
        // Test diagonal points
        var sqrt2 = Math.sqrt(2);
        Assert.floatEquals(sqrt2, unitRect.distanceToPoint(new Vector2(-1, -1)));
        Assert.floatEquals(sqrt2, unitRect.distanceToPoint(new Vector2(2, -1)));
        Assert.floatEquals(sqrt2, unitRect.distanceToPoint(new Vector2(2, 2)));
        Assert.floatEquals(sqrt2, unitRect.distanceToPoint(new Vector2(-1, 2)));
    }
    
    public function testIntersect()
    {
        var a = new Rect(0, 0, 1, 1);
        var b = new Rect(0.5, 0.5, 0.5, 0.5);
        
        Assert.isTrue(a.intersect(b).equals(b));
        Assert.isTrue(b.intersect(a).equals(b));
        
        Assert.isTrue(a.intersect(new Rect(0.5, 0.5, 20, 20)).equals(b));
        
        var c = new Rect(1, 1, 1, 1);
        Assert.equals(0, a.intersect(c).area);
        Assert.equals(0, c.intersect(a).area);
    }
    
    public function testOverlaps()
    {
        var unitRect = new Rect(0, 0, 1, 1);
        
        Assert.isTrue(unitRect.overlaps(new Rect(0, 0.5, 1, 1)));
        Assert.isTrue(unitRect.overlaps(new Rect(0.5, 0, 1, 1)));
        Assert.isTrue(unitRect.overlaps(new Rect(0.5, 0.5, 0, 0)));
        Assert.isTrue(unitRect.overlaps(new Rect(-10, -10, 20, 20)));
        
        Assert.isFalse(unitRect.overlaps(new Rect(0, 1, 1, 1)));
        Assert.isFalse(unitRect.overlaps(new Rect(1, 0, 1, 1)));
        Assert.isFalse(unitRect.overlaps(new Rect(-1, 0, 1, 1)));
        Assert.isFalse(unitRect.overlaps(new Rect(0, -1, 1, 1)));
    }
    
    public function testMatrixConversion()
    {
        var m = randomMatrix3x2();
        
        // Discard off-diagonals
        m.a = Math.abs(m.a);
        m.b = 0.0;
        m.c = 0.0;
        m.d = Math.abs(m.d);
        
        // "Fix" the matrix just in case the diagonals are 0
        if (m.a < MathUtil.eps)
        {
            m.a += 1.0;
        }
        
        if (m.d < MathUtil.eps)
        {
            m.d += 1.0;
        }
        
        var rect = Rect.fromMatrix(m);
        Assert.equals(m.linearSubMatrix.det, rect.area);
        Assert.isTrue(rect.matrix == m);
    }
    
    public function testTwoPointConstruction()
    {
        var unitRect = new Rect(0, 0, 1, 1);
        
        Assert.isTrue(Rect.fromTwoPoints(Vector2.zero, new Vector2(1, 1)).equals(unitRect));
        Assert.isTrue(Rect.fromTwoPoints(new Vector2(0, 1), new Vector2(1, 0)).equals(unitRect));
        Assert.isTrue(Rect.fromTwoPoints(new Vector2(1, 0), new Vector2(0, 1)).equals(unitRect));
    }
}