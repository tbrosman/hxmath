package test;

import vtgmath.Matrix3x3;

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
    
    private function randomMatrix3x3()
    {
        return new Matrix3x3(randomArray(9));
    }
}