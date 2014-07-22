package test;

import vtgmath.Matrix2x2;
import vtgmath.Matrix3x2;
import vtgmath.Vector2;

class Test2D extends MathTestCase
{
    public function testVector2BasicOps()
    {
        assertTrue(Vector2.xAxis * Vector2.yAxis == 0.0);
        assertTrue(0.0 * Vector2.xAxis == Vector2.zero);
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
    
    public function testMatrixAccessors()
    {
        var m = new Matrix2x2();
        
        assertTrue(m.col(0) == Vector2.xAxis);
        assertTrue(m.col(1) == Vector2.yAxis);
        assertTrue(m.row(0) == Vector2.xAxis);
        assertTrue(m.row(1) == Vector2.yAxis);
        
        assertTrue(m.element(0, 0) == m.element(1, 1));
    }
}