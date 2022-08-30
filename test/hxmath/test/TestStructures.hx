package hxmath.test;

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
class TestStructures extends Test
{
    public function specEquals()
    {
        Matrix2x2.identity == Matrix2x2.identity;
        Matrix2x2.identity != Matrix2x2.zero;
        Matrix3x2.identity == Matrix3x2.identity;
        Matrix3x2.identity != Matrix3x2.zero;
        Matrix3x3.identity == Matrix3x3.identity;
        Matrix3x3.identity != Matrix3x3.zero;
        Matrix4x4.identity == Matrix4x4.identity;
        Matrix4x4.identity != Matrix4x4.zero;
        
        Vector2.yAxis == Vector2.yAxis;
        Vector2.yAxis != Vector2.xAxis;
        Vector3.zAxis == Vector3.zAxis;
        Vector3.zAxis != Vector3.xAxis;
        Vector4.zAxis == Vector4.zAxis;
        Vector4.zAxis != Vector4.xAxis;
        
        Quaternion.identity == Quaternion.identity;
        Quaternion.identity != Quaternion.zero;
        
        IntVector2.yAxis == IntVector2.yAxis;
        IntVector2.yAxis != IntVector2.xAxis;
        
        ShortVector2.yAxis == ShortVector2.yAxis;
        ShortVector2.yAxis != ShortVector2.xAxis;
    }
    
    public function specClone()
    {
        Matrix2x2.identity.clone() == Matrix2x2.identity;
        Matrix3x2.identity.clone() == Matrix3x2.identity;
        Matrix3x3.identity.clone() == Matrix3x3.identity;
        Matrix4x4.identity.clone() == Matrix4x4.identity;
        
        Vector2.zero.clone() == Vector2.zero;
        Vector3.zero.clone() == Vector3.zero;
        Vector4.zero.clone() == Vector4.zero;
        
        Quaternion.identity.clone() == Quaternion.identity;
        
        IntVector2.zero.clone() == IntVector2.zero;
    }
    
    public function testAddSub()
    {
        var mat22 = Matrix2x2.zero;
        Assert.isTrue(mat22 + Matrix2x2.identity == Matrix2x2.identity);
        mat22 += Matrix2x2.identity;
        Assert.isTrue(mat22 == Matrix2x2.identity);
        Assert.isTrue(mat22 - Matrix2x2.identity == Matrix2x2.zero);
        mat22 -= Matrix2x2.identity;
        Assert.isTrue(mat22 == Matrix2x2.zero);
        
        var mat32 = Matrix3x2.zero;
        Assert.isTrue(mat32 + Matrix3x2.identity == Matrix3x2.identity);
        mat32 += Matrix3x2.identity;
        Assert.isTrue(mat32 == Matrix3x2.identity);
        Assert.isTrue(mat32 - Matrix3x2.identity == Matrix3x2.zero);
        mat32 -= Matrix3x2.identity;
        Assert.isTrue(mat32 == Matrix3x2.zero);
        
        var mat33 = Matrix3x3.zero;
        Assert.isTrue(mat33 + Matrix3x3.identity == Matrix3x3.identity);
        mat33 += Matrix3x3.identity;
        Assert.isTrue(mat33 == Matrix3x3.identity);
        Assert.isTrue(mat33 - Matrix3x3.identity == Matrix3x3.zero);
        mat33 -= Matrix3x3.identity;
        Assert.isTrue(mat33 == Matrix3x3.zero);
        
        var mat44 = Matrix4x4.zero;
        Assert.isTrue(mat44 + Matrix4x4.identity == Matrix4x4.identity);
        mat44 += Matrix4x4.identity;
        Assert.isTrue(mat44 == Matrix4x4.identity);
        Assert.isTrue(mat44 - Matrix4x4.identity == Matrix4x4.zero);
        mat44 -= Matrix4x4.identity;
        Assert.isTrue(mat44 == Matrix4x4.zero);
        
        var vec2 = Vector2.zero;
        Assert.isTrue(vec2 + Vector2.xAxis == Vector2.xAxis);
        vec2 += Vector2.xAxis;
        Assert.isTrue(vec2 == Vector2.xAxis);
        Assert.isTrue(vec2 - Vector2.xAxis == Vector2.zero);
        vec2 -= Vector2.xAxis;
        Assert.isTrue(vec2 == Vector2.zero);
        
        var vec3 = Vector3.zero;
        Assert.isTrue(vec3 + Vector3.xAxis == Vector3.xAxis);
        vec3 += Vector3.xAxis;
        Assert.isTrue(vec3 == Vector3.xAxis);
        Assert.isTrue(vec3 - Vector3.xAxis == Vector3.zero);
        vec3 -= Vector3.xAxis;
        Assert.isTrue(vec3 == Vector3.zero);
        
        var vec4 = Vector4.zero;
        Assert.isTrue(vec4 + Vector4.xAxis == Vector4.xAxis);
        vec4 += Vector4.xAxis;
        Assert.isTrue(vec4 == Vector4.xAxis);
        Assert.isTrue(vec4 - Vector4.xAxis == Vector4.zero);
        vec4 -= Vector4.xAxis;
        Assert.isTrue(vec4 == Vector4.zero);
        
        var q = Quaternion.zero;
        Assert.isTrue(q + Quaternion.identity == Quaternion.identity);
        q += Quaternion.identity;
        Assert.isTrue(q == Quaternion.identity);
        Assert.isTrue(q - Quaternion.identity == Quaternion.zero);
        q -= Quaternion.identity;
        Assert.isTrue(q == Quaternion.zero);
        
        var intVec2 = IntVector2.zero;
        Assert.isTrue(intVec2 + IntVector2.xAxis == IntVector2.xAxis);
        intVec2 += IntVector2.xAxis;
        Assert.isTrue(intVec2 == IntVector2.xAxis);
        Assert.isTrue(intVec2 - IntVector2.xAxis == IntVector2.zero);
        intVec2 -= IntVector2.xAxis;
        Assert.isTrue(intVec2 == IntVector2.zero);
        
        var shortVec2 = ShortVector2.zero;
        Assert.isTrue(shortVec2 + ShortVector2.xAxis == ShortVector2.xAxis);
        shortVec2 += ShortVector2.xAxis;
        Assert.isTrue(shortVec2 == ShortVector2.xAxis);
        Assert.isTrue(shortVec2 - ShortVector2.xAxis == ShortVector2.zero);
        shortVec2 -= ShortVector2.xAxis;
        Assert.isTrue(shortVec2 == ShortVector2.zero);
    }
    
    public function testDeterminant()
    {
        Assert.equals(Matrix2x2.zero.det, 0.0);
        Assert.equals(Matrix2x2.identity.det, 1.0);
        
        for (i in 0...10)
        {
            var a = randomMatrix2x2();
            var b = randomMatrix2x2();
            Assert.floatEquals((a * b).det, a.det * b.det);
        }
        
        Assert.equals(Matrix3x3.zero.det, 0.0);
        Assert.equals(Matrix3x3.identity.det, 1.0);
        
        for (i in 0...10)
        {
            var a = randomMatrix3x3();
            var b = randomMatrix3x3();
            Assert.floatEquals((a * b).det, a.det * b.det);
        }
        
        Assert.equals(Matrix4x4.zero.det, 0.0);
        Assert.equals(Matrix4x4.identity.det, 1.0);
        
        for (i in 0...1)
        {
            var a = randomMatrix4x4();
            var b = randomMatrix4x4();
            Assert.floatEquals((a * b).det, a.det * b.det);
        }
    }
    
    public function testArrayAccess()
    {
        var vec2 = Vector2.zero;
        vec2[1] = 1.0;
        Assert.equals(1.0, vec2.y);
        Assert.equals(1.0, vec2[1]);
        
        var vec3 = Vector3.zero;
        vec3[1] = 1.0;
        Assert.equals(1.0, vec3.y);
        Assert.equals(1.0, vec3[1]);
        
        var vec4 = Vector4.zero;
        vec4[1] = 1.0;
        Assert.equals(1.0, vec4.y);
        Assert.equals(1.0, vec4[1]);
        
        var mat2x2 = Matrix2x2.zero;
        mat2x2[2] = 1.0;
        Assert.equals(1.0, mat2x2.c);
        Assert.equals(1.0, mat2x2[2]);
        Assert.equals(1.0, mat2x2.getElement(0, 1));
        
        var mat3x2 = Matrix3x2.zero;
        mat3x2[3] = 1.0;
        Assert.equals(1.0, mat3x2.c);
        Assert.equals(1.0, mat3x2[3]);
        Assert.equals(1.0, mat3x2.getElement(0, 1));
        
        var mat3x3 = Matrix3x3.zero;
        mat3x3[5] = 1.0;
        Assert.equals(1.0, mat3x3.m21);
        Assert.equals(1.0, mat3x3[5]);
        Assert.equals(1.0, mat3x3.getElement(2, 1));
        
        var mat4x4 = Matrix4x4.zero;
        mat4x4[5] = 1.0;
        Assert.equals(1.0, mat4x4.m11);
        Assert.equals(1.0, mat4x4[5]);
        Assert.equals(1.0, mat4x4.getElement(1, 1));
        
        var quat = Quaternion.zero;
        quat[2] = 1.0;
        Assert.equals(1.0, quat.y);
        Assert.equals(1.0, quat[2]);
        
        var intVec2 = IntVector2.zero;
        intVec2[1] = 1;
        Assert.equals(1, intVec2.y);
        Assert.equals(1, intVec2[1]);
        
        // Read-only access
        var shortVec2 = new ShortVector2(0, 1);
        Assert.equals(1, shortVec2.y);
        Assert.equals(1, shortVec2[1]);
    }
    
    public function testCopyToFrom()
    {
        var vec2a = randomVector2();
        var vec2b = Vector2.zero;
        vec2a.copyTo(vec2b);
        Assert.isTrue(vec2a == vec2b);
        
        var vec3a = randomVector3();
        var vec3b = Vector3.zero;
        vec3a.copyTo(vec3b);
        Assert.isTrue(vec3a == vec3b);
        
        var vec4a = randomVector4();
        var vec4b = Vector4.zero;
        vec4a.copyTo(vec4b);
        Assert.isTrue(vec4a == vec4b);
        
        var mat2x2a = randomMatrix2x2();
        var mat2x2b = Matrix2x2.zero;
        mat2x2a.copyTo(mat2x2b);
        Assert.isTrue(mat2x2a == mat2x2b);
        
        var mat3x2a = randomMatrix3x2();
        var mat3x2b = Matrix3x2.zero;
        mat3x2a.copyTo(mat3x2b);
        Assert.isTrue(mat3x2a == mat3x2b);
        
        var mat3x3a = randomMatrix3x3();
        var mat3x3b = Matrix3x3.zero;
        mat3x3a.copyTo(mat3x3b);
        Assert.isTrue(mat3x3a == mat3x3b);
        
        var mat4x4a = randomMatrix4x4();
        var mat4x4b = Matrix4x4.zero;
        mat4x4a.copyTo(mat4x4b);
        Assert.isTrue(mat4x4a == mat4x4b);
        
        var quatA = randomQuaternion();
        var quatB = Quaternion.zero;
        quatA.copyTo(quatB);
        Assert.isTrue(quatA == quatB);
        
        var intVec2a = randomIntVector2();
        var intVec2b = IntVector2.zero;
        intVec2a.copyTo(intVec2b);
        Assert.isTrue(intVec2a == intVec2b);
    }
    
    public function testRowColAccessors()
    {
        var basis2 = [Vector2.xAxis, Vector2.yAxis];
        
        for (i in 0...2)
        {
            Assert.isTrue(Matrix2x2.identity.col(i) == basis2[i]);
            Assert.isTrue(Matrix2x2.identity.row(i) == basis2[i]);
        }
        
        var basis32Rows = [Vector3.xAxis, Vector3.yAxis];
        var basis32Cols = [Vector2.xAxis, Vector2.yAxis, Vector2.zero];
        
        for (i in 0...2)
        {
            Assert.isTrue(Matrix3x2.identity.row(i) == basis32Rows[i]);
        }
        
        for (i in 0...3)
        {
            Assert.isTrue(Matrix3x2.identity.col(i) == basis32Cols[i]);
        }
        
        var basis3 = [Vector3.xAxis, Vector3.yAxis, Vector3.zAxis];
        
        for (i in 0...3)
        {
            Assert.isTrue(Matrix3x3.identity.col(i) == basis3[i]);
            Assert.isTrue(Matrix3x3.identity.row(i) == basis3[i]);
        }
        
        var basis4 = [Vector4.xAxis, Vector4.yAxis, Vector4.zAxis, Vector4.wAxis];
        
        for (i in 0...4)
        {
            Assert.isTrue(Matrix4x4.identity.col(i) == basis4[i]);
            Assert.isTrue(Matrix4x4.identity.row(i) == basis4[i]);
        }
    }
    
    /**
     * Test for the fix to issue #14.
     */
    public function testEqualsNullShouldNotThrow()
    {
        Assert.isTrue(Vector2.zero != null);
        Assert.isTrue(Vector3.zero != null);
        Assert.isTrue(Vector4.zero != null);
        Assert.isTrue(Matrix2x2.zero != null);
        Assert.isTrue(Matrix3x2.zero != null);
        Assert.isTrue(Matrix3x3.zero != null);
        Assert.isTrue(Matrix4x4.zero != null);
        Assert.isTrue(Quaternion.zero != null);
        Assert.isTrue(IntVector2.zero != null);
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
            Assert.notEquals(-1, '$x'.indexOf("23"), '$x should contain "23"');
        }
    }
    
    public function testVectorMinMax()
    {
        var v2Axes = [Vector2.xAxis, Vector2.yAxis];
        var v2AxesMax = Lambda.fold(v2Axes, Vector2.max, Vector2.xAxis);
        var v2AxesMin = Lambda.fold(v2Axes, Vector2.min, Vector2.xAxis);
        var v2AxesSum = Lambda.fold(v2Axes, Vector2.add, Vector2.zero);
            
        Assert.isTrue(v2AxesMax == v2AxesSum);
        Assert.isTrue(v2AxesMin == Vector2.zero);
        
        var v3Axes = [Vector3.xAxis, Vector3.yAxis, Vector3.zAxis];
        var v3AxesMax = Lambda.fold(v3Axes, Vector3.max, Vector3.xAxis);
        var v3AxesMin = Lambda.fold(v3Axes, Vector3.min, Vector3.xAxis);
        var v3AxesSum = Lambda.fold(v3Axes, Vector3.add, Vector3.zero);
            
        Assert.isTrue(v3AxesMax == v3AxesSum);
        Assert.isTrue(v3AxesMin == Vector3.zero);
        
        var v4Axes = [Vector4.xAxis, Vector4.yAxis, Vector4.zAxis, Vector4.wAxis];
        var v4AxesMax = Lambda.fold(v4Axes, Vector4.max, Vector4.xAxis);
        var v4AxesMin = Lambda.fold(v4Axes, Vector4.min, Vector4.xAxis);
        var v4AxesSum = Lambda.fold(v4Axes, Vector4.add, Vector4.zero);
        
        Assert.isTrue(v4AxesMax == v4AxesSum);
        Assert.isTrue(v4AxesMin == Vector4.zero);
        
        var v2iAxes = [IntVector2.xAxis, IntVector2.yAxis];
        var v2iAxesMax = Lambda.fold(v2iAxes, IntVector2.max, IntVector2.xAxis);
        var v2iAxesMin = Lambda.fold(v2iAxes, IntVector2.min, IntVector2.xAxis);
        var v2iAxesSum = Lambda.fold(v2iAxes, IntVector2.add, IntVector2.zero);
            
        Assert.isTrue(v2iAxesMax == v2iAxesSum);
        Assert.isTrue(v2iAxesMin == IntVector2.zero);
        
        var v2sAxes = [ShortVector2.xAxis, ShortVector2.yAxis];
        var v2sAxesMax = Lambda.fold(v2sAxes, ShortVector2.max, ShortVector2.xAxis);
        var v2sAxesMin = Lambda.fold(v2sAxes, ShortVector2.min, ShortVector2.xAxis);
        var v2sAxesSum = Lambda.fold(v2sAxes, ShortVector2.add, ShortVector2.zero);
        
        Assert.isTrue(v2sAxesMax == v2sAxesSum);
        Assert.isTrue(v2sAxesMin == ShortVector2.zero);
    }
    
    public function testVectorProj()
    {
        var v2AxesProj1 = Vector2.project(Vector2.xAxis, Vector2.yAxis);
        
        Assert.isTrue(v2AxesProj1 == Vector2.zero);
        
        var v2Mid = new Vector2(0.5, 0.5);
        var v2Axes = [Vector2.xAxis, Vector2.yAxis];
        var v2MidProjOntoAxes = Lambda.map(v2Axes, function(a) return Vector2.project(v2Mid, a));
        
        for (v in v2MidProjOntoAxes)
        {
            Assert.floatEquals(0.5, v.length);
        }
        
        var v3AxesProj = [
            Vector3.project(Vector3.xAxis, Vector3.yAxis),
            Vector3.project(Vector3.xAxis, Vector3.zAxis),
            Vector3.project(Vector3.yAxis, Vector3.zAxis)
        ];
        
        for (v in v3AxesProj)
        {
            Assert.isTrue(v == Vector3.zero);
        }
        
        var v3Mid = new Vector3(0.5, 0.5, 0.5);
        var v3Axes = [Vector3.xAxis, Vector3.yAxis, Vector3.zAxis];
        var v3MidProjOntoAxes = Lambda.map(v3Axes, function(a) return Vector3.project(v3Mid, a));
        
        for (v in v3MidProjOntoAxes)
        {
            Assert.floatEquals(0.5, v.length);
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
            Assert.isTrue(v == Vector4.zero);
        }
        
        var v4Mid = new Vector4(0.5, 0.5, 0.5, 0.5);
        var v4Axes = [Vector4.xAxis, Vector4.yAxis, Vector4.zAxis, Vector4.wAxis];
        var v4MidProjOntoAxes = Lambda.map(v4Axes, function(a) return Vector4.project(v4Mid, a));
        
        for (v in v4MidProjOntoAxes)
        {
            Assert.floatEquals(0.5, v.length);
        }
    }
    
    public function testNormalizeTo()
    {
        for (i in 0...30)
        {
            var v = randomVector2();
            var newLength = Math.abs(randomFloat());
            Assert.floatEquals(newLength, v.normalizeTo(newLength).length);
        }
        
        for (i in 0...30)
        {
            var v = randomVector3();
            var newLength = Math.abs(randomFloat());
            Assert.floatEquals(newLength, v.normalizeTo(newLength).length);
        }
        
        for (i in 0...30)
        {
            var v = randomVector4();
            var newLength = Math.abs(randomFloat());
            Assert.floatEquals(newLength, v.normalizeTo(newLength).length);
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
            
            Assert.isTrue(clamped.length >= lowerBound - 1e-6);
            Assert.isTrue(clamped.length <= upperBound + 1e-6);
        }
        
        for (i in 0...30)
        {
            var v = 10.0 * randomVector3();
            
            var lowerBound = 3.0;
            var upperBound = 7.0;
            
            var clamped = v.clamp(lowerBound, upperBound);
            
            Assert.isTrue(clamped.length >= lowerBound - 1e-6);
            Assert.isTrue(clamped.length <= upperBound + 1e-6);
        }
        
        for (i in 0...30)
        {
            var v = 10.0 * randomVector4();
            
            var lowerBound = 3.0;
            var upperBound = 7.0;
            
            var clamped = v.clamp(lowerBound, upperBound);
            
            Assert.isTrue(clamped.length >= lowerBound - 1e-6);
            Assert.isTrue(clamped.length <= upperBound + 1e-6);
        }
    }
    
    public function testDistanceTo()
    {
        Assert.floatEquals(1.0, Vector2.zero.distanceTo(Vector2.xAxis));
        Assert.floatEquals(1.0, Vector3.zero.distanceTo(Vector3.xAxis));
        Assert.floatEquals(1.0, Vector4.zero.distanceTo(Vector4.xAxis));
    }
    
    public function testSetAllFields()
    {
        var v2 = Vector2.zero.set(23, 0);
        Assert.equals(23.0, v2.x);
        
        var v3 = Vector3.zero.set(23, 0, 0);
        Assert.equals(23.0, v3.x);
        
        var v4 = Vector4.zero.set(23, 0, 0, 0);
        Assert.equals(23.0, v4.x);
        
        var iv2 = IntVector2.zero.set(23, 0);
        Assert.equals(23, iv2.x);
        
        var q = Quaternion.zero.set(23, 0, 0, 0);
        Assert.equals(23.0, q.s);
        
        var m22 = Matrix2x2.zero.set(23, 0, 0, 0);
        Assert.equals(23.0, m22.a);
        
        var m32 = Matrix3x2.zero.set(23, 0, 0, 0, 0, 0);
        Assert.equals(23.0, m32.a);
        
        var m33 = Matrix3x3.zero.set(23, 0, 0, 0, 0, 0, 0, 0, 0);
        Assert.equals(23.0, m33.m00);
        
        var m44 = Matrix4x4.zero.set(23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        Assert.equals(23.0, m44.m00);
    }
}