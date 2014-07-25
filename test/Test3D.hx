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
    
    private function randomMatrix3x3()
    {
        return new Matrix3x3(randomArray(9));
    }
    
    private function randomMatrix4x4()
    {
        return new Matrix4x4(randomArray(16));
    }
}