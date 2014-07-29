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
    
    public function testAddSub()
    {
        var mat22 = Matrix2x2.zero;
        assertTrue(mat22 + Matrix2x2.identity == Matrix2x2.identity);
        mat22 += Matrix2x2.identity;
        assertTrue(mat22 == Matrix2x2.identity);
        assertTrue(mat22 - Matrix2x2.identity == Matrix2x2.zero);
        mat22 -= Matrix2x2.identity;
        assertTrue(mat22 == Matrix2x2.zero);
        
        var mat32 = Matrix3x2.zero;
        assertTrue(mat32 + Matrix3x2.identity == Matrix3x2.identity);
        mat32 += Matrix3x2.identity;
        assertTrue(mat32 == Matrix3x2.identity);
        assertTrue(mat32 - Matrix3x2.identity == Matrix3x2.zero);
        mat32 -= Matrix3x2.identity;
        assertTrue(mat32 == Matrix3x2.zero);
        
        var mat33 = Matrix3x3.zero;
        assertTrue(mat33 + Matrix3x3.identity == Matrix3x3.identity);
        mat33 += Matrix3x3.identity;
        assertTrue(mat33 == Matrix3x3.identity);
        assertTrue(mat33 - Matrix3x3.identity == Matrix3x3.zero);
        mat33 -= Matrix3x3.identity;
        assertTrue(mat33 == Matrix3x3.zero);
        
        var mat44 = Matrix4x4.zero;
        assertTrue(mat44 + Matrix4x4.identity == Matrix4x4.identity);
        mat44 += Matrix4x4.identity;
        assertTrue(mat44 == Matrix4x4.identity);
        assertTrue(mat44 - Matrix4x4.identity == Matrix4x4.zero);
        mat44 -= Matrix4x4.identity;
        assertTrue(mat44 == Matrix4x4.zero);
        
        var vec2 = Vector2.zero;
        assertTrue(vec2 + Vector2.xAxis == Vector2.xAxis);
        vec2 += Vector2.xAxis;
        assertTrue(vec2 == Vector2.xAxis);
        assertTrue(vec2 - Vector2.xAxis == Vector2.zero);
        vec2 -= Vector2.xAxis;
        assertTrue(vec2 == Vector2.zero);
        
        var vec3 = Vector3.zero;
        assertTrue(vec3 + Vector3.xAxis == Vector3.xAxis);
        vec3 += Vector3.xAxis;
        assertTrue(vec3 == Vector3.xAxis);
        assertTrue(vec3 - Vector3.xAxis == Vector3.zero);
        vec3 -= Vector3.xAxis;
        assertTrue(vec3 == Vector3.zero);
        
        var vec4 = Vector4.zero;
        assertTrue(vec4 + Vector4.xAxis == Vector4.xAxis);
        vec4 += Vector4.xAxis;
        assertTrue(vec4 == Vector4.xAxis);
        assertTrue(vec4 - Vector4.xAxis == Vector4.zero);
        vec4 -= Vector4.xAxis;
        assertTrue(vec4 == Vector4.zero);
        
        var q = Quaternion.zero;
        assertTrue(q + Quaternion.identity == Quaternion.identity);
        q += Quaternion.identity;
        assertTrue(q == Quaternion.identity);
        assertTrue(q - Quaternion.identity == Quaternion.zero);
        q -= Quaternion.identity;
        assertTrue(q == Quaternion.zero);
    }
    
    public function testDeterminant()
    {
        assertEquals(Matrix2x2.zero.det, 0.0);
        assertEquals(Matrix2x2.identity.det, 1.0);
        
        for (i in 0...10)
        {
            var a = randomMatrix2x2();
            var b = randomMatrix2x2();
            assertApproxEquals((a * b).det, a.det * b.det);
        }
        
        assertEquals(Matrix3x3.zero.det, 0.0);
        assertEquals(Matrix3x3.identity.det, 1.0);
        
        for (i in 0...10)
        {
            var a = randomMatrix3x3();
            var b = randomMatrix3x3();
            assertApproxEquals((a * b).det, a.det * b.det);
        }
        
        assertEquals(Matrix4x4.zero.det, 0.0);
        assertEquals(Matrix4x4.identity.det, 1.0);
        
        for (i in 0...1)
        {
            var a = randomMatrix4x4();
            var b = randomMatrix4x4();
            assertApproxEquals((a * b).det, a.det * b.det);
        }
    }
    
    public function testAddSubInPlace()
    {
        assertObjectIsSameAfter(
            Vector2.xAxis,
            function(original)
            {
                var vec2:Vector2 = original;
                return vec2.addWith(Vector2.xAxis);
            });
    }
    
    public function testArrayAccess()
    {
        var vec2 = Vector2.zero;
        vec2[1] = 1.0;
        assertEquals(1.0, vec2.y);
        assertEquals(1.0, vec2[1]);
        
        var vec3 = Vector3.zero;
        vec3[1] = 1.0;
        assertEquals(1.0, vec3.y);
        assertEquals(1.0, vec3[1]);
        
        var vec4 = Vector4.zero;
        vec4[1] = 1.0;
        assertEquals(1.0, vec4.y);
        assertEquals(1.0, vec4[1]);
        
        var mat2x2 = Matrix2x2.zero;
        mat2x2[2] = 1.0;
        assertEquals(1.0, mat2x2.c);
        assertEquals(1.0, mat2x2[2]);
        assertEquals(1.0, mat2x2.getElement(0, 1));
        
        var mat3x2 = Matrix3x2.zero;
        mat3x2[3] = 1.0;
        assertEquals(1.0, mat3x2.c);
        assertEquals(1.0, mat3x2[3]);
        assertEquals(1.0, mat3x2.getElement(0, 1));
        
        var mat3x3 = Matrix3x3.zero;
        mat3x3[5] = 1.0;
        assertEquals(1.0, mat3x3.m21);
        assertEquals(1.0, mat3x3[5]);
        assertEquals(1.0, mat3x3.getElement(2, 1));
        
        var mat4x4 = Matrix4x4.zero;
        mat4x4[5] = 1.0;
        assertEquals(1.0, mat4x4.m11);
        assertEquals(1.0, mat4x4[5]);
        assertEquals(1.0, mat4x4.getElement(1, 1));
        
        var quat = Quaternion.zero;
        quat[2] = 1.0;
        assertEquals(1.0, quat.v.y);
        assertEquals(1.0, quat[2]);
    }
    
    private function assertObjectIsSameAfter(original:Dynamic, transform:Dynamic->Dynamic)
    {
        original.tag = "original";
        var after:Dynamic = transform(original);
        assertEquals(original, after);
    }
}