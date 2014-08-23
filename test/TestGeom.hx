package test;
import haxe.ds.Vector.Vector;
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
}