package test;

import hxmath.Matrix3x3;
import hxmath.Matrix4x4;
import hxmath.Quaternion;
import hxmath.Vector3;
import hxmath.Vector4;

class Test3D extends MathTestCase
{
    public function testDeterminant()
    {
        assertEquals(Matrix3x3.zero.det, 0.0);
        assertEquals(Matrix3x3.identity.det, 1.0);
        
        for (i in 0...10)
        {
            var a = randomMatrix3x3();
            var b = randomMatrix3x3();
            assertApproxEquals((a * b).det, a.det * b.det);
        }
    }
    
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
            assertTrue((c += b) == (a + b));
        }
        
        for (i in 0...10)
        {
            var a = randomMatrix3x3();
            var b = randomMatrix3x3();
            var c = a.clone();
            assertTrue((c -= b) == (a - b));
        }
    }
    
    public function testEquals()
    {
        assertTrue(Matrix3x3.identity == Matrix3x3.identity);
        assertTrue(Matrix3x3.identity != Matrix3x3.zero);
        assertTrue(Matrix4x4.identity == Matrix4x4.identity);
        assertTrue(Matrix4x4.identity != Matrix4x4.zero);
        
        assertTrue(Vector3.zAxis == Vector3.zAxis);
        assertTrue(Vector3.zAxis != Vector3.xAxis);
        assertTrue(Vector4.zAxis == Vector4.zAxis);
        assertTrue(Vector4.zAxis != Vector4.xAxis);
        
        assertTrue(Quaternion.identity == Quaternion.identity);
        assertTrue(Quaternion.identity != Quaternion.zero);
    }
    
    public function testRowColAccessors()
    {
        var basis3 = [Vector3.xAxis, Vector3.yAxis, Vector3.zAxis];
        
        for (i in 0...3)
        {
            assertTrue(Matrix3x3.identity.col(i) == basis3[i]);
            assertTrue(Matrix3x3.identity.row(i) == basis3[i]);
        }
        
        var basis4 = [Vector4.xAxis, Vector4.yAxis, Vector4.zAxis, Vector4.wAxis];
        
        for (i in 0...4)
        {
            assertTrue(Matrix4x4.identity.col(i) == basis4[i]);
            assertTrue(Matrix4x4.identity.row(i) == basis4[i]);
        }
    }
    
    public function testAxialRotation()
    {
        // After 90 degree ccw rotation around X:
        // y -> +z
        // z -> -y
        assertApproxEquals(((Matrix3x3.rotationX(Math.PI / 2.0) * Vector3.yAxis) - Vector3.zAxis).length, 0.0);
        assertApproxEquals(((Matrix3x3.rotationX(Math.PI / 2.0) * Vector3.zAxis) + Vector3.yAxis).length, 0.0);
        
        // After 90 degree ccw rotation around Y:
        // z -> +x
        // x -> -z
        assertApproxEquals(((Matrix3x3.rotationY(Math.PI / 2.0) * Vector3.zAxis) - Vector3.xAxis).length, 0.0);
        assertApproxEquals(((Matrix3x3.rotationY(Math.PI / 2.0) * Vector3.xAxis) + Vector3.zAxis).length, 0.0);
        
        // After 90 degree ccw rotation around Z:
        // x -> +y
        // y -> -x
        assertApproxEquals(((Matrix3x3.rotationZ(Math.PI / 2.0) * Vector3.xAxis) - Vector3.yAxis).length, 0.0);
        assertApproxEquals(((Matrix3x3.rotationZ(Math.PI / 2.0) * Vector3.yAxis) + Vector3.xAxis).length, 0.0);
    }
    
    public function testQuaternionToMatrix()
    {
        function createMatrixPair(unitAngle:Float, axis:Int)
        {
            var axes = [Vector3.xAxis, Vector3.yAxis, Vector3.zAxis];
            var const = [Matrix3x3.rotationX, Matrix3x3.rotationY, Matrix3x3.rotationZ];
            var angle = unitAngle * Math.PI * 2.0;
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
                for (c in 0...3)
                {
                    var pair = createMatrixPair(unitAngle, axis);
                    assertApproxEquals((pair.n.col(c) - pair.m.col(c)).length, 0.0);
                }
            }
        }
    }
    
    private function randomMatrix3x3()
    {
        return new Matrix3x3(randomArray(9));
    }
    
    private function randomMatrix4x4()
    {
        return new Matrix4x4(randomArray(16));
    }
}