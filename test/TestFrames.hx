package test;

import haxe.ds.Vector.Vector;
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
    
    public function testFrame2LinearAffineTransform()
    {
        /*
         *    test
         * 2_|.
         *   |   |
         * 1_|_ _a
         *   |
         * 0_.- - - -
         *  0|  1|
         */
        
        var originA = new Vector2(1.0, 1.0);
        var a = new Frame2(originA, 90.0);
        
        var testInA = new Vector2(1.0, 1.0);
        
        // Vector test_a -> test_world
        var testLinearInOuter = a.linearTransformFrom(testInA);
        var expectedLinearResult = new Vector2(-1.0, 1.0);
        assertApproxEquals((testLinearInOuter - expectedLinearResult).length, 0.0);
        
        // Point test_a -> test_world
        var testAffineInOuter = a.transformFrom(testInA);
        var expectedAffineResult = expectedLinearResult + originA;
        assertApproxEquals((testAffineInOuter - expectedAffineResult).length, 0.0);
        
        // Vector test_world -> test_a
        var testLinearBackToInner = a.linearTransformTo(testLinearInOuter);
        assertApproxEquals((testLinearBackToInner - testInA).length, 0.0);
        
        // Point test_world -> test_a 
        var testAffineBackToInner = a.transformTo(testAffineInOuter);
        assertApproxEquals((testAffineBackToInner - testInA).length, 0.0);
    }
    
    public function testFrame2Inverse()
    {
        var originA = new Vector2(1.0, 1.0);
        var a = new Frame2(originA, 90.0);

        var aInv = a.inverse();
        
        // The following properties must hold:
        // - Frames commute with their inverses (A^-1 * A == A * A^-1 == I, i.e. no unique left vs. right inverses)
        // - The identity for a frame is an offset of (0, 0) with a rotation of 0 degrees.
        assertApproxEquals((a.concat(aInv).offset - Vector2.zero).length, 0.0);
        assertApproxEquals((aInv.concat(a).offset - Vector2.zero).length, 0.0);
        assertApproxEquals(a.concat(aInv).angleDegrees, 0.0);
        assertApproxEquals(aInv.concat(a).angleDegrees, 0.0);
    }
}