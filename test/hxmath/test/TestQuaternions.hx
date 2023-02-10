package hxmath.test;

import hxmath.math.Matrix3x3;
import hxmath.math.Quaternion;
import hxmath.math.Vector3;

class TestQuaternions extends Test
{
    public function testMatrixConversion()
    {
        for (i in 1...10)
        {
            var angleDegrees = i * 25.0;
            MathAssert.floatEquals(
                Matrix3x3.rotationX(angleDegrees),
                Quaternion.fromAxisAngle(angleDegrees, Vector3.xAxis).matrix);
            MathAssert.floatEquals(
                Matrix3x3.rotationY(angleDegrees),
                Quaternion.fromAxisAngle(angleDegrees, Vector3.yAxis).matrix);
            MathAssert.floatEquals(
                Matrix3x3.rotationZ(angleDegrees),
                Quaternion.fromAxisAngle(angleDegrees, Vector3.zAxis).matrix);
        }
    }
    
    public function testQuaternionInverse()
    {
        for (i in 0...10)
        {
            var q = randomQuaternion().normal;
            var qInv = q.clone().applyConjugate();
            
            var p = q * qInv;
            if (p.s < 0)
            {
                p.multiplyWithScalar(-1);
            }
            
            MathAssert.floatEquals(Quaternion.identity, p);
        }
    }
    
    public function testSlerp()
    {
        // Small angles should be stable
        var qA = Quaternion.fromAxisAngle(0, Vector3.zAxis);
        var qB = Quaternion.fromAxisAngle(1e-2, Vector3.zAxis);
        var qC = Quaternion.slerp(qA, qB, 0.5);
        
        Assert.isTrue(qA.angleWith(qC) <= 1e-2);
        
        // Large angles should be stable
        var qA = Quaternion.fromAxisAngle(0, Vector3.zAxis);
        var qB = Quaternion.fromAxisAngle(180, Vector3.zAxis);
        var qC = Quaternion.slerp(qA, qB, 0.5);
        
        Assert.floatEquals(90, qC.angleWith(qA) * 180.0 / Math.PI);
        Assert.floatEquals(90, qC.angleWith(qB) * 180.0 / Math.PI);
        
        // Should be monotonic
        var qA = new Quaternion(1, 2, 3, 4).normalize();
        var qB = new Quaternion(4, 3, 2, 1).normalize();
        
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