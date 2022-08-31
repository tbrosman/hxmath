package hxmath.test;

import hxmath.frames.Frame3;
import hxmath.math.MathUtil;
import hxmath.math.Matrix3x3;
import hxmath.math.Matrix4x4;
import hxmath.math.Quaternion;
import hxmath.math.Vector3;
import hxmath.math.Vector4;

class Test3D extends Test
{
    public function testMatrixMult()
    {
        for (i in 0...10)
        {
            var a = randomMatrix3x3();
            Assert.isTrue(Matrix3x3.identity * a == a);
        }
    }
    
    public function testAddSub()
    {
        for (i in 0...10)
        {
            var a = randomMatrix3x3();
            var b = randomMatrix3x3();
            var c = a.clone();
            Assert.isTrue((c.addWith(b)) == (a + b));
        }
        
        for (i in 0...10)
        {
            var a = randomMatrix3x3();
            var b = randomMatrix3x3();
            var c = a.clone();
            Assert.isTrue((c.subtractWith(b)) == (a - b));
        }
    }
    
    public function testAxialRotation()
    {
        var quarterRot = 90.0;
        
        // After 90 degree ccw rotation around X:
        // y -> +z
        // z -> -y
        Assert.floatEquals(0.0, ((Matrix3x3.rotationX(quarterRot) * Vector3.yAxis) - Vector3.zAxis).length);
        Assert.floatEquals(0.0, ((Matrix3x3.rotationX(quarterRot) * Vector3.zAxis) + Vector3.yAxis).length);
        
        // After 90 degree ccw rotation around Y:
        // z -> +x
        // x -> -z
        Assert.floatEquals(0.0, ((Matrix3x3.rotationY(quarterRot) * Vector3.zAxis) - Vector3.xAxis).length);
        Assert.floatEquals(0.0, ((Matrix3x3.rotationY(quarterRot) * Vector3.xAxis) + Vector3.zAxis).length);
        
        // After 90 degree ccw rotation around Z:
        // x -> +y
        // y -> -x
        Assert.floatEquals(0.0, ((Matrix3x3.rotationZ(quarterRot) * Vector3.xAxis) - Vector3.yAxis).length);
        Assert.floatEquals(0.0, ((Matrix3x3.rotationZ(quarterRot) * Vector3.yAxis) + Vector3.xAxis).length);
    }
    
    public function testQuaternionToMatrix()
    {
        function createMatrixPair(unitAngle:Float, axis:Int)
        {
            var axes = [Vector3.xAxis, Vector3.yAxis, Vector3.zAxis];
            var const = [Matrix3x3.rotationX, Matrix3x3.rotationY, Matrix3x3.rotationZ];
            var angle = unitAngle * 360.0;
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
                var totalLength = 0.0;
                
                for (c in 0...3)
                {
                    var pair = createMatrixPair(unitAngle, axis);
                    totalLength += (pair.n.col(c) - pair.m.col(c)).length;
                }
                
                Assert.floatEquals(0.0, totalLength);
            }
        }
    }
    
    public function testMatrixFrameInverse()
    {
        for (i in 0...10)
        {
            // Create a non-degenerate frame
            var frame = randomFrame3();
            
            // Get the inverse (the matrix should be equivalent)
            var invFrame = frame.inverse();
            
            var frameMatrix = frame.matrix;
            
            // Both methods of inverting the frame should be equivalent
            var invFrameMatrix = invFrame.matrix;
            var frameMatrixInv = frame.matrix.applyInvertFrame();
            
            // A unit tetrahedron in 3D using homogenous points
            var homogenous0 = new Vector4(0.0, 0.0, 0.0, 1.0);
            var homogenousX = new Vector4(1.0, 0.0, 0.0, 1.0);
            var homogenousY = new Vector4(0.0, 1.0, 0.0, 1.0);
            var homogenousZ = new Vector4(0.0, 0.0, 1.0, 1.0);
            
            // The tetrahedron should be transformed identically by both matrices
            Assert.floatEquals(0.0, (invFrameMatrix * homogenous0 - frameMatrixInv * homogenous0).lengthSq);
            Assert.floatEquals(0.0, (invFrameMatrix * homogenousX - frameMatrixInv * homogenousX).lengthSq);
            Assert.floatEquals(0.0, (invFrameMatrix * homogenousY - frameMatrixInv * homogenousY).lengthSq);
            Assert.floatEquals(0.0, (invFrameMatrix * homogenousZ - frameMatrixInv * homogenousZ).lengthSq);
        }
    }
    
    public function testQuaternionInverse()
    {
        for (i in 0...10)
        {
            var q = randomQuaternion().normal;
            var qInv = q.clone().applyConjugate();
            
            var p = q * qInv;
            
            Assert.floatEquals(1.0, p.s);
            Assert.floatEquals(0.0, new Vector3(p.x, p.y, p.z).length);
        }
    }
    
    public function testSlerpMidpointAngle()
    {
        var qA = Quaternion.fromAxisAngle(0, Vector3.zAxis);
        var qB = Quaternion.fromAxisAngle(90, Vector3.zAxis);
        var qC = Quaternion.slerp(qA, qB, 0.5);
        
        var angleAC = qA.angleWith(qC) * 180.0 / Math.PI;
        var angleCB = qC.angleWith(qB) * 180.0 / Math.PI;
        Assert.floatEquals(45.0, angleAC);
        Assert.floatEquals(45.0, angleCB);
    }
    
    public function testSlerpMonotonicity()
    {
        for (i in 0...10)
        {
            var qA = randomQuaternion().normalize();
            var qB = randomQuaternion().normalize();
            
            var lastAC = Math.NEGATIVE_INFINITY;
            var lastCB = Math.POSITIVE_INFINITY;
            
            for (step in 1...12)
            {
                var t = step / 12;
                var qC = Quaternion.slerp(qA, qB, t);
                var angleAC = qA.angleWith(qC) * 180.0 / Math.PI;
                var angleCB = qC.angleWith(qB) * 180.0 / Math.PI;
                
                Assert.isTrue(angleAC > lastAC);
                Assert.isTrue(angleCB < lastCB);
                lastAC = angleAC;
                lastCB = angleCB;
            }
        }
    }
    
    public function testSlerpLargeAngleStability()
    {
        var qA = Quaternion.fromAxisAngle(0, Vector3.zAxis);
        var qB = Quaternion.fromAxisAngle(180, Vector3.zAxis);
        var qC = Quaternion.slerp(qA, qB, 0.5);
        
        Assert.floatEquals(90, qC.angleWith(qA) * 180.0 / Math.PI);
    }
    
    public function testSlerpSmallAngleStability()
    {
        var qA = Quaternion.fromAxisAngle(0, Vector3.zAxis);
        var qB = Quaternion.fromAxisAngle(1e-2, Vector3.zAxis);
        var qC = Quaternion.slerp(qA, qB, 0.5);
        
        Assert.isTrue(qA.angleWith(qC) <= 1e-2);
    }
}