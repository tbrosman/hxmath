package hxmath.test;

import hxmath.geom.Ray2;
import hxmath.geom.Rect;
import hxmath.math.MathUtil;
import hxmath.math.Vector2;

/**
 * ...
 * @author TABIV
 */
class TestGeom extends Test
{
    public function testRectIntersect()
    {
        /**
         * Create a grid of unit rectangles:
         *
         * |c|d|
         * |a|b|
         * 
         * They should not overlap (open-ranges are used to test overlap).
         */
        var a = new Rect(0.0, 0.0, 1.0, 1.0);
        var b = new Rect(1.0, 0.0, 1.0, 1.0);
        var c = new Rect(0.0, 1.0, 1.0, 1.0);
        var d = new Rect(1.0, 1.0, 1.0, 1.0);
        
        Assert.isFalse(a.overlaps(b));
        Assert.isFalse(a.overlaps(c));
        Assert.isFalse(a.overlaps(d));
        
        // Create a rectangle in the middle that overlaps all the other rectangles
        var e = new Rect(0.5, 0.5, 1.0, 1.0);
        Assert.isTrue(a.overlaps(e));
        Assert.isTrue(b.overlaps(e));
        Assert.isTrue(c.overlaps(e));
        Assert.isTrue(d.overlaps(e));
        
        // Create a sub-rectangle (fully-contained) of a
        var contained = new Rect(0.25, 0.25, 0.5, 0.5);
        Assert.isTrue(a.overlaps(contained));
        Assert.isTrue(contained.overlaps(a));
        
        // Create a straddling rectangle across a
        var straddling = new Rect(0.25, 0.25, 1.0, 0.5);
        Assert.isTrue(a.overlaps(straddling));
        Assert.isTrue(straddling.overlaps(a));
    }
    
    public function testRectMatrixConversion()
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
        
        // Get the area from the determinant of the linear portion
        var matrixArea = m.linearSubMatrix.det;
        
        var rect = Rect.fromMatrix(m);
        Assert.equals(matrixArea, rect.area);
        Assert.isTrue(rect.matrix == m);
    }
    
    public function testRectTwoPointConstruction()
    {
        var zero = Vector2.zero;
        var one = new Vector2(1.0, 1.0);
        
        Assert.equals(1.0, Rect.fromTwoPoints(zero, one).area);
    }
    
    public function testRectContainsPoint()
    {
        var rect = new Rect(0.5, 0.5, 1.0, 1.0);
        
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
    
    public function testRectIntersectOverlapping()
    {
        var a = new Rect(0.0, 0.0, 1.0, 1.0);
        var b = new Rect(0.5, 0.5, 1.0, 1.0);
        
        var ab = a.intersect(b);
        var ba = b.intersect(a);
        Assert.equals(0.25, ab.area);
        Assert.isTrue(ab.equals(ba));
        Assert.isFalse(ab.isEmpty);
        
        var c = new Rect(1.0, 1.0, 1.0, 1.0);
        var ac = a.intersect(c);
        var ca = c.intersect(a);
        Assert.equals(0.0, ac.area);
        Assert.equals(0.0, ca.area);
        Assert.isTrue(ac.isEmpty);
        Assert.isTrue(ca.isEmpty);
        
        var d = new Rect(2.0, 2.0, 1.0, 1.0);
        var ad = a.intersect(d);
        var da = d.intersect(a);
        Assert.isTrue(ad.isEmpty);
        Assert.isTrue(da.isEmpty);
    }
    
    public function testRectIntersectContaining()
    {
        /**
         *     ___________
         *    |           |
         * |--|--|-----|--|--|
         * |  |L |  I  | R|  |
         *    |___________|
         * 
         */
        var outer = new Rect(0.0, 0.0, 1.0, 1.0);
        
        var inner = new Rect(0.25, 0.25, 0.5, 0.5);
        var innerLeft = new Rect(0.0, 0.25, 0.25, 0.5);
        var innerRight = new Rect(0.75, 0.25, 0.25, 0.5);
        
        var left = new Rect(-0.25, 0.25, 0.5, 0.5);
        var right = new Rect(0.75, 0.25, 0.5, 0.5);
        
        Assert.isTrue(outer.intersect(inner)
            .equals(inner));
        Assert.isTrue(inner.intersect(outer)
            .equals(inner));
            
        // Test left/right overlap
        Assert.isTrue(outer.intersect(left)
            .equals(innerLeft));
        Assert.isTrue(left.intersect(outer)
            .equals(innerLeft));
        Assert.isTrue(outer.intersect(right)
            .equals(innerRight));
        Assert.isTrue(right.intersect(outer)
            .equals(innerRight));
    }
    
    /**
     * Find the distance between a unit rectangle and points inside/outside/on the rectangle boundary.
     */
    public function testRectToPointDistance()
    {
        var unit = new Rect(0.0, 0.0, 1.0, 1.0);
        var distanceOfTwo = [new Vector2(-2.0, 0.5), new Vector2(3.0, 0.5), new Vector2(0.5, -2.0), new Vector2(0.5, 3.0)];
        
        for (point in distanceOfTwo)
        {
            Assert.floatEquals(2.0, unit.distanceToPoint(point));
        }
        
        var inside = new Vector2(0.75, 0.2);
        Assert.equals(0.0, unit.distanceToPoint(inside));
        
        var diagonal = new Vector2( -0.5, -0.5);
        Assert.floatEquals(diagonal.length, unit.distanceToPoint(diagonal));
        
        var corner = new Vector2(1.0, 1.0);
        Assert.equals(0.0, unit.distanceToPoint(corner));
    }
    
    public function testRectAddVector()
    {
        var unit = new Rect(0.0, 0.0, 1.0, 1.0);
        var two = new Vector2(2.0, 2.0);
        var expectedArea = (unit.width + two.x) * (unit.height + two.y);
        
        // In the direction of the positive quadrants
        var unitPlusTwo = unit.clone()
            .addWith(two);
        
        Assert.floatEquals(expectedArea, unitPlusTwo.area);
        Assert.floatEquals(0.0, (new Vector2(unitPlusTwo.x, unitPlusTwo.y) - new Vector2(unit.x, unit.y)).length);
        
        // In the direction of the negative quadrants
        var unitMinusTwo = unit.clone()
            .addWith(-two);
            
        Assert.floatEquals(expectedArea, unitMinusTwo.area);
        Assert.floatEquals(0.0, (new Vector2(unitMinusTwo.x, unitMinusTwo.y) + two).length);
    }
    
    public function testRay2Cast()
    {
        var p = new Vector2(1.0, 1.0).normal;
        var r = new Ray2(Vector2.zero, new Vector2(1.0, 1.0).normal);
        
        var result = r.intersectPoint(p);
        Assert.floatEquals(1.0, result);
    }
    
    private function rangeRectDistance(a:Rect, b:Rect)
    {
        // Find the minimum distance along each axis
        var minX = MathUtil.rangeDistance(a.x, a.width, b.x, b.width);
        var minY = MathUtil.rangeDistance(a.y, a.height, b.y, b.height);
        
        // If both minimums are non-zero, the closest features on both rectangles are vertices
        // If only one minimum is non-zero the closest features on both rectangles are edges
        // In both cases, the length of the minimum vector gives the minimum distance
        return Math.sqrt(minX * minX + minY * minY);
    }
}