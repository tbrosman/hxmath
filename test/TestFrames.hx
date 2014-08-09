package test;

import hxmath.frames.Frame2;
import hxmath.math.Vector2;

class TestFrames extends MathTestCase
{
    public function testFrame2Concat()
    {
        var originA = new Vector2(1.0, 1.0);
        var a = new Frame2(originA, 90.0);
        var b = new Frame2(Vector2.xAxis, 90.0);
        var c = a.concat(b);
        
        // (R(90) * xAxis) + originA = yAxis + originA
        assertTrue(c.offset == Vector2.yAxis + originA);
        assertEquals(c.angleDegrees, 180.0);
        
        // Should just give the offset point
        assertTrue(c.matrix * Vector2.zero == Vector2.yAxis + originA);
    }
    
    public function testLinearAffineTransform()
    {
        /*
         * 2_|.test
         *   |   |
         * 1_|_ _a
         *   |
         * 0_.- - - -
         *  0|  1|
         */
        
        var originA = new Vector2(1.0, 1.0);
        var a = new Frame2(originA, 90.0);
        
        var testInA = new Vector2(1.0, 1.0);
        
        var testLinearInOuter = a.linearTransform(testInA);
        var expectedLinearResult = new Vector2( -1.0, 1.0);
        assertApproxEquals((testLinearInOuter - expectedLinearResult).length, 0.0);
        
        var testAffineInOuter = a.transform(testInA);
        var expectedAffineResult = expectedLinearResult + originA;
        assertApproxEquals((testAffineInOuter - expectedAffineResult).length, 0.0);
    }
}