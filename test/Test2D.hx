package test;

import haxe.ds.Vector;
import hxmath.math.IntVector2;
import hxmath.math.Matrix2x2;
import hxmath.math.Matrix3x2;
import hxmath.math.Vector2;
import hxmath.math.Vector3;

class Test2D extends MathTestCase
{
    public function testVector2BasicOps()
    {
        assertTrue(Vector2.xAxis * Vector2.yAxis == 0.0);
        assertTrue(0.0 * Vector2.xAxis == Vector2.zero);
        
        assertTrue(IntVector2.xAxis * IntVector2.yAxis == 0);
        assertTrue(0 * IntVector2.xAxis == IntVector2.zero);
    }
    
    public function testDeterminant()
    {
        assertTrue(Matrix2x2.identity.det == 1.0);
    }
    
    public function testHomogenousTranslation()
    {
        var m = Matrix3x2.identity;
        m.t = new Vector2(3, -1);
        assertTrue(m * Vector2.zero == m.t);
    }
    
    public function testTranspose()
    {
        var m = new Matrix2x2(
            Math.random(), Math.random(),
            Math.random(), Math.random());
        
        var n = m.transpose
            .transpose;
            
        var k = (m - n);
        var normSq = k.a * k.a + k.b * k.b + k.c * k.c + k.d * k.d;
        assertTrue(normSq < 1e-6);
    }
    
    public function testRotation()
    {
        // After 90 degree ccw rotation:
        // x -> +y
        // y -> -x
        assertApproxEquals(0.0, ((Matrix2x2.rotate(Math.PI / 2.0) * Vector2.xAxis) - Vector2.yAxis).length);
        assertApproxEquals(0.0, ((Matrix2x2.rotate(Math.PI / 2.0) * Vector2.yAxis) + Vector2.xAxis).length);
    }
    
    public function testVectorRotate()
    {
        // After 90 degree ccw rotation around 0, 0:
        // x -> +y
        // y -> -x
        assertApproxEquals(0.0, ((Vector2.xAxis.rotate(Math.PI / 2.0, Vector2.zero)) - Vector2.yAxis).length);
        assertApproxEquals(0.0, ((Vector2.yAxis.rotate(Math.PI / 2.0, Vector2.zero)) + Vector2.xAxis).length);
    }
    
    public function testPolarConversion()
    {
        assertApproxEquals(0.0, (Vector2.fromPolar(Math.PI, 1.0) + Vector2.xAxis).length);
        
        // Some backends give +PI, others -PI (they are both equivalent)
        assertApproxEquals(Math.PI, Math.abs((-Vector2.xAxis).angle));
    }
    
    public function testNorms()
    {
        assertTrue(Vector2.yAxis.normal.rotatedLeft * new Vector2(-1, 0) > 0.0);
        assertTrue(Vector2.yAxis.normal.rotatedRight * new Vector2(-1, 0) < 0.0);
    }
    
    public function testAngles()
    {
        assertApproxEquals(Vector2.yAxis.signedAngleWith(new Vector2(-1, 1)), Math.PI / 4.0);
        assertApproxEquals(Vector2.yAxis.signedAngleWith(new Vector2(1, 1)), -Math.PI / 4.0);
        assertApproxEquals(Vector2.yAxis.signedAngleWith(new Vector2(-1, -1)), 3.0 * Math.PI / 4.0);
        assertApproxEquals(Vector2.yAxis.signedAngleWith(new Vector2(1, -1)), -3.0 * Math.PI / 4.0);
        
        assertApproxEquals(Vector2.yAxis.signedAngleWith(Vector2.xAxis), -Math.PI / 2.0);
        assertApproxEquals(Vector2.xAxis.signedAngleWith(Vector2.yAxis), Math.PI / 2.0);
        
        assertApproxEquals(Vector2.yAxis.angleWith(Vector2.xAxis), Math.PI / 2.0);
        assertApproxEquals(Vector2.xAxis.angleWith(Vector2.yAxis), Math.PI / 2.0);
    }
    
    public function testOrbit()
    {
        for (i in 0...5)
        {
            var center = randomVector2() + new Vector2(1, 1);
            var m:Matrix3x2 = Matrix3x2.orbit(center, Math.PI / 2);
            
            for (j in 0...5)
            {
                var point = randomVector2();
                var pointAfter = m * point;
                assertApproxEquals(0.0, (point - center) * (pointAfter - center));
            }
        }
    }
    
    public function testLinearSubMatrix()
    {
        var m = Matrix3x2.identity;
        m.linearSubMatrix = new Matrix2x2(1.0, 2.0, 3.0, 4.0);
        assertTrue(m.linearSubMatrix == new Matrix2x2(1.0, 2.0, 3.0, 4.0));
    }
    
    public function testMatrixFrameInverse()
    {
        for (i in 0...10)
        {
            // Create a non-degenerate frame
            var frame = randomFrame2();
            
            // Get the inverse (the matrix should be equivalent)
            var invFrame = frame.inverse();
            
            var frameMatrix = frame.matrix;
            
            // Both methods of inverting the frame should be equivalent
            var invFrameMatrix = invFrame.matrix;
            var frameMatrixInv = frame.matrix.applyInvertFrame();
            
            // A unit triangle in 3D using homogenous points
            var homogenous0 = new Vector2(0.0, 0.0);
            var homogenousX = new Vector2(1.0, 0.0);
            var homogenousY = new Vector2(0.0, 1.0);
            
            // The tetrahedron should be transformed identically by both matrices
            assertApproxEquals(0.0, (invFrameMatrix * homogenous0 - frameMatrixInv * homogenous0).lengthSq);
            assertApproxEquals(0.0, (invFrameMatrix * homogenousX - frameMatrixInv * homogenousX).lengthSq);
            assertApproxEquals(0.0, (invFrameMatrix * homogenousY - frameMatrixInv * homogenousY).lengthSq);
        }
    }
    
    public function testOrthoNormalize()
    {
        for (i in 0...10)
        {
            var u = randomVector2();
            var v = randomVector2();
            
            Vector2.orthoNormalize(u, v);
            
            assertApproxEquals(1.0, u.length);
            assertApproxEquals(1.0, v.length);
            assertApproxEquals(0.0, u * v);
        }
    }
    
    public function testReflect()
    {
        for (i in 0...10)
        {
            var u = randomVector2();
            var v = Vector2.reflect(u, Vector2.yAxis);
            
            assertEquals(u.x, v.x);
            assertEquals(-u.y, v.y);
        }
    }

    public function testSetVectorAngle()
    {
        for (i in 0...10)
        {
            var v = randomVector2();
            var a = randomFloat();

            v.angle = a;

            assertApproxEquals(a, v.angle);
        }
    }
}