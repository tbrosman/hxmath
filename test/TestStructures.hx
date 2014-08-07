package test;
import hxmath.math.Matrix2x2;
import hxmath.math.Matrix3x2;
import hxmath.math.Matrix3x3;
import hxmath.math.Matrix4x4;
import hxmath.math.Quaternion;
import hxmath.math.Vector2;
import hxmath.math.Vector3;
import hxmath.math.Vector4;

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
    
    public function testApplyScalarFunc()
    {
        var testData:Array<Dynamic> = [
            {
                f:     Vector2.applyScalarFunc,
                zero:  Vector2.zero,
                count: Vector2.elementCount,
                get:   Vector2.getArrayElement,
                set:   Vector2.setArrayElement
            },
            {
                f:     Vector3.applyScalarFunc,
                zero:  Vector3.zero,
                count: Vector3.elementCount,
                get:   Vector3.getArrayElement,
                set:   Vector3.setArrayElement
            },
            {
                f:     Vector4.applyScalarFunc,
                zero:  Vector4.zero,
                count: Vector4.elementCount,
                get:   Vector4.getArrayElement,
                set:   Vector4.setArrayElement
            },
            {
                f:     Matrix2x2.applyScalarFunc,
                zero:  Matrix2x2.zero,
                count: Matrix2x2.elementCount,
                get:   Matrix2x2.getArrayElement,
                set:   Matrix2x2.setArrayElement
            },
            {
                f:     Matrix3x2.applyScalarFunc,
                zero:  Matrix3x2.zero,
                count: Matrix3x2.elementCount,
                get:   Matrix3x2.getArrayElement,
                set:   Matrix3x2.setArrayElement
            },
            {
                f:     Matrix3x3.applyScalarFunc,
                zero:  Matrix3x3.zero,
                count: Matrix3x3.elementCount,
                get:   Matrix3x3.getArrayElement,
                set:   Matrix3x3.setArrayElement
            },
            {
                f:     Matrix4x4.applyScalarFunc,
                zero:  Matrix4x4.zero,
                count: Matrix4x4.elementCount,
                get:   Matrix4x4.getArrayElement,
                set:   Matrix4x4.setArrayElement
            },
            {
                f:     Quaternion.applyScalarFunc,
                zero:  Quaternion.zero,
                count: Quaternion.elementCount,
                get:   Quaternion.getArrayElement,
                set:   Quaternion.setArrayElement
            }];
        
        for (data in testData)
        {
            var v = data.zero;
            data.set(v, 1, 0.1);
            data.f(v, Math.ceil);
            
            var sum = 0.0;
            for (i in 0...data.count)
            {
                sum += data.get(v, i);
            }
            
            assertEquals(1.0, sum);
        }
        
    }
    
    private function testCopyToFrom()
    {
        var vec2a = randomVector2();
        var vec2b = Vector2.zero;
        vec2a.copyTo(vec2b);
        assertTrue(vec2a == vec2b);
        
        var vec3a = randomVector3();
        var vec3b = Vector3.zero;
        vec3a.copyTo(vec3b);
        assertTrue(vec3a == vec3b);
        
        var vec4a = randomVector4();
        var vec4b = Vector4.zero;
        vec4a.copyTo(vec4b);
        assertTrue(vec4a == vec4b);
        
        var mat2x2a = randomMatrix2x2();
        var mat2x2b = Matrix2x2.zero;
        mat2x2a.copyTo(mat2x2b);
        assertTrue(mat2x2a == mat2x2b);
        
        var mat3x2a = randomMatrix3x2();
        var mat3x2b = Matrix3x2.zero;
        mat3x2a.copyTo(mat3x2b);
        assertTrue(mat3x2a == mat3x2b);
        
        var mat3x3a = randomMatrix3x3();
        var mat3x3b = Matrix3x3.zero;
        mat3x3a.copyTo(mat3x3b);
        assertTrue(mat3x3a == mat3x3b);
        
        var mat4x4a = randomMatrix4x4();
        var mat4x4b = Matrix4x4.zero;
        mat4x4a.copyTo(mat4x4b);
        assertTrue(mat4x4a == mat4x4b);
        
        var quatA = randomQuaternion();
        var quatB = Quaternion.zero;
        quatA.copyTo(quatB);
        assertTrue(quatA == quatB);
    }
    
    public function testRowColAccessors()
    {
        var basis2 = [Vector2.xAxis, Vector2.yAxis];
        
        for (i in 0...2)
        {
            assertTrue(Matrix2x2.identity.col(i) == basis2[i]);
            assertTrue(Matrix2x2.identity.row(i) == basis2[i]);
        }
        
        var basis32Rows = [Vector3.xAxis, Vector3.yAxis];
        var basis32Cols = [Vector2.xAxis, Vector2.yAxis, Vector2.zero];
        
        for (i in 0...2)
        {
            assertTrue(Matrix3x2.identity.row(i) == basis32Rows[i]);
        }
        
        for (i in 0...3)
        {
            assertTrue(Matrix3x2.identity.col(i) == basis32Cols[i]);
        }
        
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
    
    private function assertObjectIsSameAfter(original:Dynamic, transform:Dynamic->Dynamic)
    {
        original.tag = "original";
        var after:Dynamic = transform(original);
        assertEquals(original, after);
    }
}