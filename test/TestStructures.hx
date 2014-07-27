package test;
import hxmath.Matrix2x2;
import hxmath.Matrix3x2;
import hxmath.Matrix3x3;
import hxmath.Matrix4x4;
import hxmath.Quaternion;
import hxmath.Vector2;
import hxmath.Vector3;
import hxmath.Vector4;

/**
 * ...
 * @author TABIV
 */
class TestStructures extends MathTestCase
{
    public function testDefaultConstructors()
    {
        assertTrue(new Matrix2x2() == Matrix2x2.identity);
        assertTrue(new Matrix3x2() == Matrix3x2.identity);
        assertTrue(new Matrix4x4() == Matrix4x4.identity);
        
        assertTrue(new Vector2() == Vector2.zero);
        assertTrue(new Vector3() == Vector3.zero);
        assertTrue(new Vector4() == Vector4.zero);
        
        assertTrue(new Quaternion() == Quaternion.identity);
    }
    
    public function testEquals()
    {
        assertTrue(Matrix2x2.identity == Matrix2x2.identity);
        assertTrue(Matrix2x2.identity != Matrix2x2.zero);
        assertTrue(Matrix3x2.identity == Matrix3x2.identity);
        assertTrue(Matrix3x2.identity != Matrix3x2.zero);
        assertTrue(Matrix3x3.identity == Matrix3x3.identity);
        assertTrue(Matrix3x3.identity != Matrix3x3.zero);
        assertTrue(Matrix4x4.identity == Matrix4x4.identity);
        assertTrue(Matrix4x4.identity != Matrix4x4.zero);
        
        assertTrue(Vector2.yAxis == Vector2.yAxis);
        assertTrue(Vector2.yAxis != Vector2.xAxis);
        assertTrue(Vector3.zAxis == Vector3.zAxis);
        assertTrue(Vector3.zAxis != Vector3.xAxis);
        assertTrue(Vector4.zAxis == Vector4.zAxis);
        assertTrue(Vector4.zAxis != Vector4.xAxis);
        
        assertTrue(Quaternion.identity == Quaternion.identity);
        assertTrue(Quaternion.identity != Quaternion.zero);
    }
    
    public function testClone()
    {
        assertTrue(Matrix2x2.identity.clone() == Matrix2x2.identity);
        assertTrue(Matrix3x2.identity.clone() == Matrix3x2.identity);
        assertTrue(Matrix3x3.identity.clone() == Matrix3x3.identity);
        assertTrue(Matrix4x4.identity.clone() == Matrix4x4.identity);
        
        assertTrue(Vector2.zero.clone() == Vector2.zero);
        assertTrue(Vector3.zero.clone() == Vector3.zero);
        assertTrue(Vector4.zero.clone() == Vector4.zero);
        
        assertTrue(Quaternion.identity.clone() == Quaternion.identity);
    }
}