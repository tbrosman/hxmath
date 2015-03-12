package test;

import hxmath.frames.Frame3;
import hxmath.math.MathUtil;
import hxmath.math.Matrix3x3;
import hxmath.math.Matrix4x4;
import hxmath.math.Quaternion;
import hxmath.math.Vector3;
import hxmath.math.Vector4;

class Test3D extends MathTestCase
{
    public function testMatrixMult()
    {
        for (i in 0...10)
        {
            var a = randomMatrix3x3();
            assertTrue(Matrix3x3.identity * a == a);
        }
    }
    
    public function testAddSub()
    {
        for (i in 0...10)
        {
            var a = randomMatrix3x3();
            var b = randomMatrix3x3();
            var c = a.clone();
            assertTrue((c.addWith(b)) == (a + b));
        }
        
        for (i in 0...10)
        {
            var a = randomMatrix3x3();
            var b = randomMatrix3x3();
            var c = a.clone();
            assertTrue((c.subtractWith(b)) == (a - b));
        }
    }
    
    public function testCrossProductPrecedence()
    {
        assertTrue(Vector3.xAxis + Vector3.yAxis % Vector3.zAxis == 2.0 * Vector3.xAxis);
    }
    
    public function testAxialRotation()
    {
        var quarterRot = 90.0;
        
        // After 90 degree ccw rotation around X:
        // y -> +z
        // z -> -y
        assertApproxEquals(((Matrix3x3.rotationX(quarterRot) * Vector3.yAxis) - Vector3.zAxis).length, 0.0);
        assertApproxEquals(((Matrix3x3.rotationX(quarterRot) * Vector3.zAxis) + Vector3.yAxis).length, 0.0);
        
        // After 90 degree ccw rotation around Y:
        // z -> +x
        // x -> -z
        assertApproxEquals(((Matrix3x3.rotationY(quarterRot) * Vector3.zAxis) - Vector3.xAxis).length, 0.0);
        assertApproxEquals(((Matrix3x3.rotationY(quarterRot) * Vector3.xAxis) + Vector3.zAxis).length, 0.0);
        
        // After 90 degree ccw rotation around Z:
        // x -> +y
        // y -> -x
        assertApproxEquals(((Matrix3x3.rotationZ(quarterRot) * Vector3.xAxis) - Vector3.yAxis).length, 0.0);
        assertApproxEquals(((Matrix3x3.rotationZ(quarterRot) * Vector3.yAxis) + Vector3.xAxis).length, 0.0);
    }
    
    public function testQuaternionToMatrix()
    {
        function createMatrixPair(unitAngle:Float, axis:Int)
        {
            var axes = [Vector3.xAxis, Vector3.yAxis, Vector3.zAxis];
            var const = [Matrix3x3.rotationX, Matrix3x3.rotationY, Matrix3x3.rotationZ];
            var angle = unitAngle * 360.0;
            var q = Quaternion.fromAxisAngle(angle, axes[axis]);
            var n = q.matrix;
            var m = const[axis](angle);
            
            return { m: m, n: n }
        }
        
        for (axis in 0...3)
        {
            var unitAngle:Float = 0.0;
            
            for (i in 0...10)
            {
                unitAngle += 0.01;
                var totalLength = 0.0;
                
                for (c in 0...3)
                {
                    var pair = createMatrixPair(unitAngle, axis);
                    totalLength += (pair.n.col(c) - pair.m.col(c)).length;
                }
                
                assertApproxEquals(totalLength, 0.0);
            }
        }
    }
    
    public function testMatrixFrameInverse()
    {
        for (i in 0...10)
        {
            // Create a non-degenerate frame
            var frame = randomFrame3();
            
            // Get the inverse (the matrix should be equivalent)
            var invFrame = frame.inverse();
            
            var frameMatrix = frame.matrix;
            
            // Both methods of inverting the frame should be equivalent
            var invFrameMatrix = invFrame.matrix;
            var frameMatrixInv = frame.matrix.applyInvertFrame();
            
            // A unit tetrahedron in 3D using homogenous points
            var homogenous0 = new Vector4(0.0, 0.0, 0.0, 1.0);
            var homogenousX = new Vector4(1.0, 0.0, 0.0, 1.0);
            var homogenousY = new Vector4(0.0, 1.0, 0.0, 1.0);
            var homogenousZ = new Vector4(0.0, 0.0, 1.0, 1.0);
            
            // The tetrahedron should be transformed identically by both matrices
            assertApproxEquals(0.0, (invFrameMatrix * homogenous0 - frameMatrixInv * homogenous0).lengthSq);
            assertApproxEquals(0.0, (invFrameMatrix * homogenousX - frameMatrixInv * homogenousX).lengthSq);
            assertApproxEquals(0.0, (invFrameMatrix * homogenousY - frameMatrixInv * homogenousY).lengthSq);
            assertApproxEquals(0.0, (invFrameMatrix * homogenousZ - frameMatrixInv * homogenousZ).lengthSq);
        }
    }
    
    public function testQuaternionInverse()
    {
        for (i in 0...10)
        {
            var q = randomQuaternion().normal;
            var qInv = q.clone().applyConjugate();
            
            var p = q * qInv;
            
            assertApproxEquals(1.0, p.s);
            assertApproxEquals(0.0, p.v.length);
        }
    }
    
    public function testOrthoNormalize()
    {
        for (i in 0...10)
        {
            var u = randomVector3();
            var v = randomVector3();
            var w = randomVector3();
            
            Vector3.orthoNormalize(u, v, w);
            
            assertApproxEquals(1.0, u.length);
            assertApproxEquals(1.0, v.length);
            assertApproxEquals(1.0, w.length);
            assertApproxEquals(0.0, u * v);
            assertApproxEquals(0.0, u * w);
            assertApproxEquals(0.0, v * w);
            
            assertApproxEquals(0.0, ((u % v) % w).length);
        }
    }
    
    public function testAngles()
    {
        assertApproxEquals(Vector3.xAxis.angleWith(Vector3.yAxis), Math.PI / 2.0);
        assertApproxEquals(Vector3.xAxis.angleWith(Vector3.zAxis), Math.PI / 2.0);
        assertApproxEquals(Vector3.yAxis.angleWith(Vector3.zAxis), Math.PI / 2.0);
    }
}