package hxmath.test;

import hxmath.math.Matrix2x2;
import hxmath.math.Matrix3x2;
import hxmath.math.Matrix3x3;
import hxmath.math.Matrix4x4;
import hxmath.math.Vector2;
import hxmath.math.Vector3;
import hxmath.math.Vector4;

class TestMatrices extends Test {
    public function testAddSubtract()
    {
		var a = randomMatrix2x2();
		var b = randomMatrix2x2();
		var sum = a + b;
		var difference = a - b;
		
		for(j in 0...4) {
			Assert.isTrue(a[j] + b[j] == sum[j]);
			Assert.isTrue(a[j] - b[j] == difference[j]);
		}
		
		var a = randomMatrix3x2();
		var b = randomMatrix3x2();
		var sum = a + b;
		var difference = a - b;
		
		for(j in 0...6) {
			Assert.isTrue(a[j] + b[j] == sum[j]);
			Assert.isTrue(a[j] - b[j] == difference[j]);
		}
		
		var a = randomMatrix3x3();
		var b = randomMatrix3x3();
		var sum = a + b;
		var difference = a - b;
		
		for(j in 0...9) {
			Assert.isTrue(a[j] + b[j] == sum[j]);
			Assert.isTrue(a[j] - b[j] == difference[j]);
		}
		
		var a = randomMatrix4x4();
		var b = randomMatrix4x4();
		var sum = a + b;
		var difference = a - b;
		
		for(j in 0...16) {
			Assert.isTrue(a[j] + b[j] == sum[j]);
			Assert.isTrue(a[j] - b[j] == difference[j]);
		}
    }
	
    public function specDeterminant()
    {
        1.0 == Matrix2x2.identity.det;
        1.0 == Matrix3x3.identity.det;
        1.0 == Matrix4x4.identity.det;
		
		0.0 == new Matrix2x2(1, 2, 3, 6).det;
		0.0 == new Matrix3x3(1, 2, 3, 4, 5, 6, 7, 8, 9).det;
		0.0 == new Matrix4x4(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16).det;
    }
    
    public function specLinearSubMatrix()
    {
        var m = Matrix3x2.identity;
        m.linearSubMatrix = new Matrix2x2(1.0, 2.0, 3.0, 4.0);
        m.linearSubMatrix == new Matrix2x2(1.0, 2.0, 3.0, 4.0);
        m == new Matrix3x2(1.0, 2.0, 3.0, 4.0, 0.0, 0.0);
    }
    
    public function specMultiply()
    {
		// Matrix2x2 is column-major
		// [1 3] * [0 -1] = [3 -1]
		// [2 4]   [1  0]   [4 -2]
		new Matrix2x2(1, 2, 3, 4) * new Matrix2x2(0, 1, -1, 0)
			== new Matrix2x2(3, 4, -1, -2);
		
		// Matrix3x2 is column-major
        // [1 3 5] * [0 -1 1] = [3 -1  9]
        // [2 4 6]   [1  0 1]   [4 -2 12]
        new Matrix3x2(1, 2, 3, 4, 5, 6) * new Matrix3x2(0, 1, -1, 0, 1, 1)
			== new Matrix3x2(3, 4, -1, -2, 9, 12);
		
		// Matrix3x3 is row-major
        // [1 2 3]   [0 -1 1]   [2 -1  6]
        // [4 5 6] * [1  0 1] = [5 -4 15]
        // [0 0 1]   [0  0 1]   [0  0  1]
		new Matrix3x3(1, 2, 3, 4, 5, 6, 0, 0, 1)
			* new Matrix3x3(0, -1, 1, 1, 0, 1, 0, 0, 1)
			== new Matrix3x3(2, -1, 6, 5, -4, 15, 0, 0, 1);
		
		// Matrix4x4 is row-major
        // [1  2  3  4]   [0 -1 0 1]   [ 2 -1  3 10]
        // [5  6  7  8] * [1  0 0 1] = [ 6 -5  7 26]
        // [9 10 11 12]   [0  0 1 1]   [10 -9 11 42]
        // [0  0  0  1]   [0  0 0 1]   [ 0  0  0  1]
		new Matrix4x4(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 0, 0, 0, 1)
			* new Matrix4x4(0, -1, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1)
			== new Matrix4x4(2, -1, 3, 10, 6, -5, 7, 26, 10, -9, 11, 42, 0, 0, 0, 1);
    }
	
    public function testOrbit()
    {
        for (i in 0...5)
        {
            var center = randomVector2() + new Vector2(1, 1);
			var angle = Math.random() * Math.PI;
			var m:Matrix3x2 = Matrix3x2.orbit(center, angle);
            
            for (j in 0...5)
            {
                var point = randomVector2();
                
				var orbitPoint = m * point;
				var rotatePoint = point.rotate(angle, center);
				
                Assert.floatEquals(0.0, (orbitPoint - rotatePoint).length);
            }
        }
    }
    
    public function testRotation()
    {
        // After 90 degree ccw rotation around X:
        // y -> +z
        // z -> -y
        Assert.floatEquals(0.0, ((Matrix3x3.rotationX(90.0) * Vector3.yAxis) - Vector3.zAxis).length);
        Assert.floatEquals(0.0, ((Matrix3x3.rotationX(90.0) * Vector3.zAxis) + Vector3.yAxis).length);
        
        // After 90 degree ccw rotation around Y:
        // z -> +x
        // x -> -z
        Assert.floatEquals(0.0, ((Matrix3x3.rotationY(90.0) * Vector3.zAxis) - Vector3.xAxis).length);
        Assert.floatEquals(0.0, ((Matrix3x3.rotationY(90.0) * Vector3.xAxis) + Vector3.zAxis).length);
        
        // After 90 degree ccw rotation around Z:
        // x -> +y
        // y -> -x
        Assert.floatEquals(0.0, ((Matrix3x3.rotationZ(90.0) * Vector3.xAxis) - Vector3.yAxis).length);
        Assert.floatEquals(0.0, ((Matrix3x3.rotationZ(90.0) * Vector3.yAxis) + Vector3.xAxis).length);
    }
    
    public function specTranslation()
    {
        var m = Matrix3x2.identity;
        m.t = new Vector2(3, -1);
        m.t == m * Vector2.zero;
    }
	
    public function specTranspose()
    {
        var m2 = randomMatrix2x2();
        m2 == m2.transpose.transpose;
		
        var m3 = randomMatrix3x3();
        m3 == m3.transpose.transpose;
		
        var m4 = randomMatrix4x4();
        m4 == m4.transpose.transpose;
    }
}
