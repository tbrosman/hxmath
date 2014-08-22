package test;

import hxmath.math.Matrix3x3;
import hxmath.math.Matrix4x4;
import hxmath.math.Quaternion;
import hxmath.math.Vector3;
import hxmath.math.Vector4;

class Test3D extends MathTestCase
{
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
            assertTrue((c.addWith(b)) == (a + b));
        }
        
        for (i in 0...10)
        {
            var a = randomMatrix3x3();
            var b = randomMatrix3x3();
            var c = a.clone();
            assertTrue((c.subtractWith(b)) == (a - b));
        }
    }
    
    public function testCrossProductPrecedence()
    {
        assertTrue(Vector3.xAxis + Vector3.yAxis % Vector3.zAxis == 2.0 * Vector3.xAxis);
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
}