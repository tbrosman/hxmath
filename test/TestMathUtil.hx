package test;
import hxmath.math.MathUtil;
import hxmath.math.Vector2;

class TestMathUtil extends MathTestCase
{
    public function testOrient2D()
    {
        /*
         *    b
         * c  |  d
         *    a
         *    
         *    e
         */
        var a = new Vector2(0.0, 0.0);
        var b = new Vector2(0.0, 1.0);
        var c = new Vector2(-0.5, 0.5);
        var d = new Vector2(0.5, 0.5);
        var e = new Vector2(0.0, -1.0);
        
        assertEquals(MathUtil.orient2d(a, b, c), Orient2DResult.Left);
        assertEquals(MathUtil.orient2d(a, b, d), Orient2DResult.Right);
        assertEquals(MathUtil.orient2d(a, b, e), Orient2DResult.Colinear);
    }
}