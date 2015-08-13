package test;
import haxe.rtti.Meta;
import hxmath.math.IntVector2;
import hxmath.math.Matrix2x2;
import hxmath.math.Matrix3x2;
import hxmath.math.Matrix3x3;
import hxmath.math.Matrix4x4;
import hxmath.math.Quaternion;
import hxmath.math.ShortVector2;
import hxmath.math.Vector2;
import hxmath.math.Vector3;
import hxmath.math.Vector4;

/**
 * ...
 * @author TABIV
 */
class TestStructures extends MathTestCase
{
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
        
        assertTrue(IntVector2.yAxis == IntVector2.yAxis);
        assertTrue(IntVector2.yAxis != IntVector2.xAxis);
        
        assertTrue(ShortVector2.yAxis == ShortVector2.yAxis);
        assertTrue(ShortVector2.yAxis != ShortVector2.xAxis);
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
        
        assertTrue(IntVector2.zero.clone() == IntVector2.zero);
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
        
        var intVec2 = IntVector2.zero;
        assertTrue(intVec2 + IntVector2.xAxis == IntVector2.xAxis);
        intVec2 += IntVector2.xAxis;
        assertTrue(intVec2 == IntVector2.xAxis);
        assertTrue(intVec2 - IntVector2.xAxis == IntVector2.zero);
        intVec2 -= IntVector2.xAxis;
        assertTrue(intVec2 == IntVector2.zero);
        
        var shortVec2 = ShortVector2.zero;
        assertTrue(shortVec2 + ShortVector2.xAxis == ShortVector2.xAxis);
        shortVec2 += ShortVector2.xAxis;
        assertTrue(shortVec2 == ShortVector2.xAxis);
        assertTrue(shortVec2 - ShortVector2.xAxis == ShortVector2.zero);
        shortVec2 -= ShortVector2.xAxis;
        assertTrue(shortVec2 == ShortVector2.zero);
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
        assertEquals(1.0, quat.y);
        assertEquals(1.0, quat[2]);
        
        var intVec2 = IntVector2.zero;
        intVec2[1] = 1;
        assertEquals(1, intVec2.y);
        assertEquals(1, intVec2[1]);
        
        // Read-only access
        var shortVec2 = new ShortVector2(0, 1);
        assertEquals(1, shortVec2.y);
        assertEquals(1, shortVec2[1]);
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
    
    public function testIntApplyScalarFunc()
    {
        var testData:Array<Dynamic> = [
            {
                f:     IntVector2.applyScalarFunc,
                zero:  IntVector2.zero,
                count: IntVector2.elementCount,
                get:   IntVector2.getArrayElement,
                set:   IntVector2.setArrayElement
            }];
            
        for (data in testData)
        {
            var v = data.zero;
            data.set(v, 1, 1);
            data.f(v, function(x:Int):Int return 2*x);
            
            var sum:Int = 0;
            for (i in 0...data.count)
            {
                sum += data.get(v, i);
            }
            
            assertEquals(2, sum);
        }
    }
    
    public function testCopyToFrom()
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
        
        var intVec2a = randomIntVector2();
        var intVec2b = IntVector2.zero;
        intVec2a.copyTo(intVec2b);
        assertTrue(intVec2a == intVec2b);
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
    
    /**
     * Test for the fix to issue #14.
     */
    public function testEqualsNullShouldNotThrow()
    {
        assertTrue(Vector2.zero != null);
        assertTrue(Vector3.zero != null);
        assertTrue(Vector4.zero != null);
        assertTrue(Matrix2x2.zero != null);
        assertTrue(Matrix3x2.zero != null);
        assertTrue(Matrix3x3.zero != null);
        assertTrue(Matrix4x4.zero != null);
        assertTrue(Quaternion.zero != null);
        assertTrue(IntVector2.zero != null);
    }
    
    public function testHasToString()
    {
        var structures:Array<Dynamic> = [
            new Vector2(0, 23),
            new Vector3(0, 23, 0),
            new Vector4(0, 23, 0, 0),
            new Matrix2x2(0, 0, 23, 0),
            new Matrix3x2(0, 0, 23, 0, 0, 0),
            new Matrix3x3(0, 0, 23, 0, 0, 0, 0, 0, 0),
            new Matrix4x4(0, 0, 23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
            new Quaternion(1, 0, 23, 0),
            new IntVector2(0, 23)];
        
        for (x in structures)
        {
            if ('$x'.indexOf("23") == -1)
            {
                trace(x);
                assertTrue(false);
            }
        }
    }
    
    public function testVectorMinMax()
    {
        var v2Axes = [Vector2.xAxis, Vector2.yAxis];
        var v2AxesMax = Lambda.fold(v2Axes, Vector2.max, Vector2.xAxis);
        var v2AxesMin = Lambda.fold(v2Axes, Vector2.min, Vector2.xAxis);
        var v2AxesSum = Lambda.fold(v2Axes, Vector2.add, Vector2.zero);
            
        assertTrue(v2AxesMax == v2AxesSum);
        assertTrue(v2AxesMin == Vector2.zero);
        
        var v3Axes = [Vector3.xAxis, Vector3.yAxis, Vector3.zAxis];
        var v3AxesMax = Lambda.fold(v3Axes, Vector3.max, Vector3.xAxis);
        var v3AxesMin = Lambda.fold(v3Axes, Vector3.min, Vector3.xAxis);
        var v3AxesSum = Lambda.fold(v3Axes, Vector3.add, Vector3.zero);
            
        assertTrue(v3AxesMax == v3AxesSum);
        assertTrue(v3AxesMin == Vector3.zero);
        
        var v4Axes = [Vector4.xAxis, Vector4.yAxis, Vector4.zAxis, Vector4.wAxis];
        var v4AxesMax = Lambda.fold(v4Axes, Vector4.max, Vector4.xAxis);
        var v4AxesMin = Lambda.fold(v4Axes, Vector4.min, Vector4.xAxis);
        var v4AxesSum = Lambda.fold(v4Axes, Vector4.add, Vector4.zero);
        
        assertTrue(v4AxesMax == v4AxesSum);
        assertTrue(v4AxesMin == Vector4.zero);
        
        var v2iAxes = [IntVector2.xAxis, IntVector2.yAxis];
        var v2iAxesMax = Lambda.fold(v2iAxes, IntVector2.max, IntVector2.xAxis);
        var v2iAxesMin = Lambda.fold(v2iAxes, IntVector2.min, IntVector2.xAxis);
        var v2iAxesSum = Lambda.fold(v2iAxes, IntVector2.add, IntVector2.zero);
            
        assertTrue(v2iAxesMax == v2iAxesSum);
        assertTrue(v2iAxesMin == IntVector2.zero);
        
        var v2sAxes = [ShortVector2.xAxis, ShortVector2.yAxis];
        var v2sAxesMax = Lambda.fold(v2sAxes, ShortVector2.max, ShortVector2.xAxis);
        var v2sAxesMin = Lambda.fold(v2sAxes, ShortVector2.min, ShortVector2.xAxis);
        var v2sAxesSum = Lambda.fold(v2sAxes, ShortVector2.add, ShortVector2.zero);
        
        assertTrue(v2sAxesMax == v2sAxesSum);
        assertTrue(v2sAxesMin == ShortVector2.zero);
    }
    
    public function testVectorProj()
    {
        var v2AxesProj1 = Vector2.project(Vector2.xAxis, Vector2.yAxis);
        
        assertTrue(v2AxesProj1 == Vector2.zero);
        
        var v2Mid = new Vector2(0.5, 0.5);
        var v2Axes = [Vector2.xAxis, Vector2.yAxis];
        var v2MidProjOntoAxes = Lambda.map(v2Axes, function(a) return Vector2.project(v2Mid, a));
        
        for (v in v2MidProjOntoAxes)
        {
            assertApproxEquals(0.5, v.length);
        }
        
        var v3AxesProj = [
            Vector3.project(Vector3.xAxis, Vector3.yAxis),
            Vector3.project(Vector3.xAxis, Vector3.zAxis),
            Vector3.project(Vector3.yAxis, Vector3.zAxis)
        ];
        
        for (v in v3AxesProj)
        {
            assertTrue(v == Vector3.zero);
        }
        
        var v3Mid = new Vector3(0.5, 0.5, 0.5);
        var v3Axes = [Vector3.xAxis, Vector3.yAxis, Vector3.zAxis];
        var v3MidProjOntoAxes = Lambda.map(v3Axes, function(a) return Vector3.project(v3Mid, a));
        
        for (v in v3MidProjOntoAxes)
        {
            assertApproxEquals(0.5, v.length);
        }
        
        var v4AxesProj = [
            Vector4.project(Vector4.xAxis, Vector4.yAxis),
            Vector4.project(Vector4.xAxis, Vector4.zAxis),
            Vector4.project(Vector4.xAxis, Vector4.wAxis),
            Vector4.project(Vector4.yAxis, Vector4.zAxis),
            Vector4.project(Vector4.yAxis, Vector4.wAxis),
            Vector4.project(Vector4.zAxis, Vector4.wAxis)
        ];
        
        for (v in v4AxesProj)
        {
            assertTrue(v == Vector4.zero);
        }
        
        var v4Mid = new Vector4(0.5, 0.5, 0.5, 0.5);
        var v4Axes = [Vector4.xAxis, Vector4.yAxis, Vector4.zAxis, Vector4.wAxis];
        var v4MidProjOntoAxes = Lambda.map(v4Axes, function(a) return Vector4.project(v4Mid, a));
        
        for (v in v4MidProjOntoAxes)
        {
            assertApproxEquals(0.5, v.length);
        }
    }
    
    public function testNormalizeTo()
    {
        for (i in 0...30)
        {
            var v = randomVector2();
            var newLength = Math.abs(randomFloat());
            assertApproxEquals(newLength, v.normalizeTo(newLength).length);
        }
        
        for (i in 0...30)
        {
            var v = randomVector3();
            var newLength = Math.abs(randomFloat());
            assertApproxEquals(newLength, v.normalizeTo(newLength).length);
        }
        
        for (i in 0...30)
        {
            var v = randomVector4();
            var newLength = Math.abs(randomFloat());
            assertApproxEquals(newLength, v.normalizeTo(newLength).length);
        }
    }
    
    public function testClamp()
    {
        for (i in 0...30)
        {
            var v = 10.0 * randomVector2();
            
            var lowerBound = 3.0;
            var upperBound = 7.0;
            
            var clamped = v.clamp(lowerBound, upperBound);
            
            assertTrue(clamped.length >= lowerBound - 1e-6);
            assertTrue(clamped.length <= upperBound + 1e-6);
        }
        
        for (i in 0...30)
        {
            var v = 10.0 * randomVector3();
            
            var lowerBound = 3.0;
            var upperBound = 7.0;
            
            var clamped = v.clamp(lowerBound, upperBound);
            
            assertTrue(clamped.length >= lowerBound - 1e-6);
            assertTrue(clamped.length <= upperBound + 1e-6);
        }
        
        for (i in 0...30)
        {
            var v = 10.0 * randomVector4();
            
            var lowerBound = 3.0;
            var upperBound = 7.0;
            
            var clamped = v.clamp(lowerBound, upperBound);
            
            assertTrue(clamped.length >= lowerBound - 1e-6);
            assertTrue(clamped.length <= upperBound + 1e-6);
        }
    }
    
    public function testDistanceTo()
    {
        assertApproxEquals(1.0, Vector2.zero.distanceTo(Vector2.xAxis));
        assertApproxEquals(1.0, Vector3.zero.distanceTo(Vector3.xAxis));
        assertApproxEquals(1.0, Vector4.zero.distanceTo(Vector4.xAxis));
    }
}