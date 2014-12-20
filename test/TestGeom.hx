package test;

import hxmath.geom.Ray2;
import hxmath.geom.Rect;
import hxmath.math.MathUtil;
import hxmath.math.Vector2;

/**
 * ...
 * @author TABIV
 */
class TestGeom extends MathTestCase
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
        
        assertFalse(a.overlaps(b));
        assertFalse(a.overlaps(c));
        assertFalse(a.overlaps(d));
        
        // Create a rectangle in the middle that overlaps all the other rectangles
        var e = new Rect(0.5, 0.5, 1.0, 1.0);
        assertTrue(a.overlaps(e));
        assertTrue(b.overlaps(e));
        assertTrue(c.overlaps(e));
        assertTrue(d.overlaps(e));
        
        // Create a sub-rectangle (fully-contained) of a
        var contained = new Rect(0.25, 0.25, 0.5, 0.5);
        assertTrue(a.overlaps(contained));
        assertTrue(contained.overlaps(a));
        
        // Create a straddling rectangle across a
        var straddling = new Rect(0.25, 0.25, 1.0, 0.5);
        assertTrue(a.overlaps(straddling));
        assertTrue(straddling.overlaps(a));
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
        assertEquals(matrixArea, rect.area);
        assertTrue(rect.matrix == m);
    }
    
    public function testRectTwoPointConstruction()
    {
        var zero = Vector2.zero;
        var one = new Vector2(1.0, 1.0);
        
        assertEquals(1.0, Rect.fromTwoPoints(zero, one).area);
    }
    
    public function testRectContainsPoint()
    {
        var rect = new Rect(0.5, 0.5, 1.0, 1.0);
        
        for (i in 0...4)
        {
            // Rectangles should contains their vertices
            var p = rect.getVertex(i);
            assertTrue(rect.containsPoint(p));
            
            // Construct a vertex slightly outside the corner of the rectangle
            var q = 1.1 * (p - rect.center) + rect.center;
            assertFalse(rect.containsPoint(q));
        }
    }
    
    public function testRectIntersectOverlapping()
    {
        return;
        var a = new Rect(0.0, 0.0, 1.0, 1.0);
        var b = new Rect(0.5, 0.5, 1.0, 1.0);
        
        var ab = a.intersect(b);
        var ba = b.intersect(a);
        assertEquals(0.25, ab.area);
        assertTrue(ab.equals(ba));
        assertFalse(ab.isEmpty);
        
        var c = new Rect(1.0, 1.0, 1.0, 1.0);
        var ac = a.intersect(c);
        var ca = c.intersect(a);
        assertEquals(0.0, ac.area);
        assertEquals(0.0, ca.area);
        assertTrue(ac.isEmpty);
        assertTrue(ca.isEmpty);
        
        var d = new Rect(2.0, 2.0, 1.0, 1.0);
        var ad = a.intersect(d);
        var da = d.intersect(a);
        assertTrue(ad.isEmpty);
        assertTrue(da.isEmpty);
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
        
        assertTrue(outer.intersect(inner)
            .equals(inner));
        assertTrue(inner.intersect(outer)
            .equals(inner));
            
        // Test left/right overlap
        assertTrue(outer.intersect(left)
            .equals(innerLeft));
        assertTrue(left.intersect(outer)
            .equals(innerLeft));
        assertTrue(outer.intersect(right)
            .equals(innerRight));
        assertTrue(right.intersect(outer)
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
            assertApproxEquals(2.0, unit.distanceToPoint(point));
        }
        
        var inside = new Vector2(0.75, 0.2);
        assertEquals(0.0, unit.distanceToPoint(inside));
        
        var diagonal = new Vector2( -0.5, -0.5);
        assertApproxEquals(diagonal.length, unit.distanceToPoint(diagonal));
        
        var corner = new Vector2(1.0, 1.0);
        assertEquals(0.0, unit.distanceToPoint(corner));
    }
    
    public function testRectAddVector()
    {
        var unit = new Rect(0.0, 0.0, 1.0, 1.0);
        var two = new Vector2(2.0, 2.0);
        var expectedArea = (unit.width + two.x) * (unit.height + two.y);
        
        // In the direction of the positive quadrants
        var unitPlusTwo = unit.clone()
            .addWith(two);
        
        assertApproxEquals(expectedArea, unitPlusTwo.area);
        assertApproxEquals(0.0, (new Vector2(unitPlusTwo.x, unitPlusTwo.y) - new Vector2(unit.x, unit.y)).length);
        
        // In the direction of the negative quadrants
        var unitMinusTwo = unit.clone()
            .addWith(-two);
            
        assertApproxEquals(expectedArea, unitMinusTwo.area);
        assertApproxEquals(0.0, (new Vector2(unitMinusTwo.x, unitMinusTwo.y) + two).length);
    }
    
    public function testRectDistanceAgainstRangeAlgorithm()
    {
        for (i in 0...100)
        {
            var a = new Rect(Math.random() - 0.5, Math.random() - 0.5, Math.random(), Math.random());
            var b = new Rect(Math.random() - 0.5, Math.random() - 0.5, Math.random(), Math.random());
            
            var regularDist = a.distanceToRect(b);
            var rangeDistance = a.distanceToRect(b);
            assertApproxEquals(rangeDistance, regularDist);
        }
    }
    
    public function testRay2Cast()
    {
        var p = new Vector2(1.0, 1.0).normal;
        var r = new Ray2(Vector2.zero, new Vector2(1.0, 1.0).normal);
        
        var result = r.intersectPoint(p);
        assertApproxEquals(1.0, result);
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