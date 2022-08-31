package hxmath.test;

import hxmath.math.IntVector2;
import hxmath.math.MathUtil;
import hxmath.math.Matrix2x2;
import hxmath.math.Matrix3x2;
import hxmath.math.Vector2;
import hxmath.math.Vector3;

class Test2D extends Test
{
    public function testDeterminant()
    {
        Assert.equals(1.0, Matrix2x2.identity.det);
    }
    
    public function testHomogenousTranslation()
    {
        var m = Matrix3x2.identity;
        m.t = new Vector2(3, -1);
        Assert.isTrue(m.t == m * Vector2.zero);
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
        Assert.isTrue(normSq < 1e-6);
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
                Assert.floatEquals(0.0, (point - center) * (pointAfter - center));
            }
        }
    }
    
    public function testLinearSubMatrix()
    {
        var m = Matrix3x2.identity;
        m.linearSubMatrix = new Matrix2x2(1.0, 2.0, 3.0, 4.0);
        Assert.isTrue(m.linearSubMatrix == new Matrix2x2(1.0, 2.0, 3.0, 4.0));
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
            Assert.floatEquals(0.0, (invFrameMatrix * homogenous0 - frameMatrixInv * homogenous0).lengthSq);
            Assert.floatEquals(0.0, (invFrameMatrix * homogenousX - frameMatrixInv * homogenousX).lengthSq);
            Assert.floatEquals(0.0, (invFrameMatrix * homogenousY - frameMatrixInv * homogenousY).lengthSq);
        }
    }
    
    public function testMatrix3x2Concat()
    {
        var a = Matrix3x2.identity;
        a.setRotate(Math.PI / 2);
        a.setTranslate(1, 2);
        
        var b = Matrix3x2.identity;
        b.setRotate(-Math.PI / 2);
        b.setTranslate(3, 4);

        // a * b
        //
        // = Translate(1, 2) * Rotate(pi/2) * Translate(3, 4) * Rotate(-pi/2)
        //
        //   [cos(pi/2) -sin(pi/2) 1] [cos(-pi/2) -sin(-pi/2) 3]
        // = [sin(pi/2)  cos(pi/2) 2] [sin(-pi/2)  cos(-pi/2) 4]
        //
        //   [0 -1 1] [ 0 1 3]
        // = [1  0 2] [-1 0 4]
        //
        //   [1 0 -3]
        // = [0 1  5]
        //
        // = Translate(-3, 5)
        var c = a * b;
        var expectedC = new Matrix3x2(1, 0, 0, 1, -3, 5);

        for (i in 0...6)
        {
            Assert.floatEquals(expectedC.getArrayElement(i), c.getArrayElement(i));
        }
    }
}