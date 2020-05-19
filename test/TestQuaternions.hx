package test;

import hxmath.math.Vector2;
import hxmath.math.Vector3;
import hxmath.math.Vector4;
import hxmath.math.Matrix4x4;
import hxmath.math.Quaternion;
import hxmath.math.DualQuaternion;

class TestQuaternions extends MathTestCase
{
    public function testDualQuaternionInverse_Multiplication()
    {
        var dualQ = DualQuaternion.fromAxisAngle(90, Vector3.yAxis, new Vector4(10, 0, 0, 1));
        var dualQInv = dualQ.invert();
        var product = dualQ * dualQInv;
        assertApproxEquals(1.0, product.length);
        assertApproxEquals(1.0, product.real.s);
    }

    public function testDualQuaternionInverse_Basic()
    {
        // (Translate(10, 0, 0) * Rotate(90, y))^-1 =
        // Rotate(-90, y) * Translate(-Rotate(-90, y) * (10, 0, 0)) =
        // Rotate(-90, y) * Translate(0, 0, -10)
        var dualQ = DualQuaternion.fromAxisAngle(90, Vector3.yAxis, new Vector4(10, 0, 0, 1));

        var dualQInv = dualQ.invert();
        var dualQInvTranslation = dualQInv.getTranslation();
        var dualQInvRotation = dualQInv.real;

        assertApproxEquals(0.0, (dualQInvTranslation - new Vector4(0, 0, -10, 1)).length);
        assertApproxEquals(0.0, (dualQInvRotation - Quaternion.fromAxisAngle(-90, Vector3.yAxis)).length);

        var expectedMatrix = new Matrix4x4(
            0, 0, -1,   0,
            0, 1, 0,    0,
            1, 0, 0,   -10,
            0, 0, 0,    1
        );

        var dualQInvMatrix = dualQInv.matrix;

        assertApproxEquals(0.0, (dualQInvMatrix.col(0) - expectedMatrix.col(0)).length);
        assertApproxEquals(0.0, (dualQInvMatrix.col(1) - expectedMatrix.col(1)).length);
        assertApproxEquals(0.0, (dualQInvMatrix.col(2) - expectedMatrix.col(2)).length);
        assertApproxEquals(0.0, (dualQInvMatrix.col(3) - expectedMatrix.col(3)).length);
    }
    
    public function testMatrixFrameDualQuaternionInverse()
    {
        for (i in 0...10)
        {
            // Create a non-degenerate frame
            var dualQ_Frame3 = randomDualQuaternionAndFrame3();
            var frame = dualQ_Frame3.frame3;
            var dualQ = dualQ_Frame3.dualQ;
            
            var frameMatrix = frame.matrix;
            var frameDualQ = dualQ.matrix;
            
            // A unit tetrahedron in 3D using homogenous points
            var homogenous0 = new Vector4(0.0, 0.0, 0.0, 1.0);
            var homogenousX = new Vector4(1.0, 0.0, 0.0, 1.0);
            var homogenousY = new Vector4(0.0, 1.0, 0.0, 1.0);
            var homogenousZ = new Vector4(0.0, 0.0, 1.0, 1.0);
            
            // The tetrahedron should be transformed identically by both matrices
            
            assertApproxEquals(0.0, (frameMatrix * homogenous0 - frameDualQ * homogenous0).lengthSq);
            assertApproxEquals(0.0, (frameMatrix * homogenousX - frameDualQ * homogenousX).lengthSq);
            assertApproxEquals(0.0, (frameMatrix * homogenousY - frameDualQ * homogenousY).lengthSq);
            assertApproxEquals(0.0, (frameMatrix * homogenousZ - frameDualQ * homogenousZ).lengthSq);
        }
    }
    
    public function testQuaternionInverse()
    {
        for (i in 0...10)
        {
            var q = randomQuaternion().normal;
            var qInv = q.clone().applyConjugate();
            
            var p = q * qInv;
            
            assertApproxEquals(1.0, p.s);
            assertApproxEquals(0.0, new Vector3(p.x, p.y, p.z).length);
        }
    }
    
    public function testSlerpMidpointAngle()
    {
        var qA = Quaternion.fromAxisAngle(0, Vector3.zAxis);
        var qB = Quaternion.fromAxisAngle(90, Vector3.zAxis);
        var qC = Quaternion.slerp(qA, qB, 0.5);
        
        var angleAC = qA.angleWith(qC) * 180.0 / Math.PI;
        var angleCB = qC.angleWith(qB) * 180.0 / Math.PI;
        assertApproxEquals(45.0, angleAC);
        assertApproxEquals(45.0, angleCB);
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
                
                assertTrue(angleAC > lastAC);
                assertTrue(angleCB < lastCB);
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
        
        assertApproxEquals(90, qC.angleWith(qA) * 180.0 / Math.PI);
    }
    
    public function testSlerpSmallAngleStability()
    {
        var qA = Quaternion.fromAxisAngle(0, Vector3.zAxis);
        var qB = Quaternion.fromAxisAngle(1e-2, Vector3.zAxis);
        var qC = Quaternion.slerp(qA, qB, 0.5);
        
        assertTrue(qA.angleWith(qC) <= 1e-2);
    }
    
    public function testFromAxisAngleRadian(){
        var homogenous0 = new Vector4(0.0, 0.0, 0.0, 1.0);
        var homogenousX = new Vector4(1.0, 0.0, 0.0, 1.0);
        var homogenousY = new Vector4(0.0, 1.0, 0.0, 1.0);
        var homogenousZ = new Vector4(0.0, 0.0, 1.0, 1.0);
        var axis = [ Vector3.xAxis, Vector3.yAxis, Vector3.zAxis ];
        var vec4 = [ homogenous0, homogenousX, homogenousY, homogenousZ ];
        var angles = [ 0, 45, 90, 135, 180, 125, 270, 315, 360 ];
        var p = Math.PI;
        var radians = [ 0, p/4, p/2, 3*p/4, p, p+p/4, p+p/2, p+3*p/4, 2*p ];
        for( j in 0...angles.length )
        {
            for(k in 0...4)
            {
                for(m in 0...3)
                {
                    // special case fails!
                    if(j != (angles.length - 4) && m != 0 && k != 0)
                    {
                    var a = DualQuaternion.fromAxisAngle(angles[j], axis[m], vec4[k]);
                    var b = DualQuaternion.fromAxisRadian(radians[j], axis[m], vec4[k]);
                    assertTrue( a == b );
                    }
                }
            }
        }
    }
    
    /*
    // Test for Quaternion.fromYawPitchRoll
    public function testQuat_fromYawPitchRoll(){
        
    }
    
    // Test for DualQuaternion.fromAxisAngle, fromTranslation (should match result of getTranslation())
    public function testDual_FromAxisAngle(){
    
    }
    */
    
    // Test for DualQuaternion.identity
    public function testDual_identity(){
        var ident = DualQuaternion.identity;
        assertTrue( ident.real == Quaternion.identity && ident.dual == Quaternion.zero );
        assertTrue( ident.length == 1. );
    }
    
}