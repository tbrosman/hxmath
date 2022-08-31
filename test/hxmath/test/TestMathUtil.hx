package hxmath.test;

import hxmath.math.MathUtil;
import hxmath.math.Vector2;

class TestMathUtil extends Test
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
        
        Assert.equals(Orient2DResult.Left, MathUtil.orient2d(a, b, c));
        Assert.equals(Orient2DResult.Right, MathUtil.orient2d(a, b, d));
        Assert.equals(Orient2DResult.Colinear, MathUtil.orient2d(a, b, e));
    }
    
    public function testWrapAngle()
    {
        Assert.equals(0.0, MathUtil.wrap(0.0, 360.0));
        Assert.equals(0.0, MathUtil.wrap(360.0, 360.0));
        Assert.equals(360.0 - MathUtil.eps, MathUtil.wrap(360.0 - MathUtil.eps, 360));
        
        // Incorrect wrap implementations may return 171 depending on the language's sign convention
        Assert.equals(189.0, MathUtil.wrap(-531.0, 360.0));
    }
}