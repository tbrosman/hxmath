package hxmath.test;

import hxmath.frames.adapters.FlxSpriteFrame2;
import hxmath.frames.Frame2;
import hxmath.frames.Frame2Default;
import hxmath.frames.Frame3;
import hxmath.math.Quaternion;
import hxmath.math.Vector2;
import hxmath.math.Vector3;

class FlxObjectMock
{
    public var x(default, set):Float;
    public var y(default, set):Float;
    public var angle(default, set):Float;
    
    public function new()
    {
    }
    
    private function set_x(x:Float):Float
    {
        return this.x = x;
    }
    
    private function set_y(y:Float):Float
    {
        return this.y = y;
    }
    
    private function set_angle(angle:Float):Float
    {
        return this.angle = angle;
    }
}

class TestFrames extends Test
{
    public function testFrame2Concat()
    {
        // T(1, 1) * R(90 degrees)
        // [ 0 -1 | 1 ]
        // [ 1  0 | 1 ]
        var originA = new Vector2(1.0, 1.0);
        var a = new Frame2(originA, 90.0);

        // T(1, 0) * R(90 degrees)
        // [ 0 -1 | 1 ]
        // [ 1  0 | 0 ]
        var originB = new Vector2(1.0, 0.0);
        var b = new Frame2(originB, 90.0);

        // T(1, 2) * R(180 degrees)
        // [ -1  0  | 1 ]
        // [  0  -1 | 2 ]
        var c = a.concat(b);
        
        // (R(90) * (1, 0)) + originA = (0, 1) + originA
        var bOffsetInA = new Vector2(1.0, 2.0);
        Assert.isTrue(bOffsetInA == a.transformFrom(b.offset));
        Assert.isTrue(bOffsetInA == c.offset);
        Assert.equals(180.0, c.angleDegrees);
        
        // Should just give the offset point
        Assert.isTrue(bOffsetInA == c.matrix * Vector2.zero);
    }
    
    public function testFrame3Concat()
    {
        var originA = new Vector3(1.0, 1.0, 0.0);
        var a = new Frame3(originA, Quaternion.fromAxisAngle(90.0, Vector3.zAxis));
        var b = new Frame3(Vector3.xAxis, Quaternion.fromAxisAngle(90.0, Vector3.zAxis));
        var c = a.concat(b);
        
        Assert.floatEquals(0.0, (a.transformFrom(b.offset) - (Vector3.yAxis + originA)).length);
        
        // (R(90) * xAxis) + originA = yAxis + originA
        Assert.floatEquals(0.0, (c.offset - (Vector3.yAxis + originA)).length);
        
        // R(90, z) * R(90, z) should be orthogonal to identity
        Assert.floatEquals(0.0, Quaternion.dot(c.orientation, Quaternion.identity));
        
        // Should just give the offset point
        Assert.floatEquals(0.0, (c.transformFrom(Vector3.zero) - (Vector3.yAxis + originA)).length);
    }
    
    public function testFrame2LinearAffineTransform()
    {
        /*
         *    test
         * 2_|.
         *   |   |
         * 1_|_ _a
         *   |
         * 0_.- - - -
         *  0|  1|
         */
        
        var originA = new Vector2(1.0, 1.0);
        var a = new Frame2(originA, 90.0);
        
        var testInA = new Vector2(1.0, 1.0);
        
        // Vector test_a -> test_world
        var testLinearInOuter = a.linearTransformFrom(testInA);
        var expectedLinearResult = new Vector2(-1.0, 1.0);
        MathAssert.floatEquals(testLinearInOuter, expectedLinearResult);
        
        // Point test_a -> test_world
        var testAffineInOuter = a.transformFrom(testInA);
        var expectedAffineResult = expectedLinearResult + originA;
        MathAssert.floatEquals(testAffineInOuter, expectedAffineResult);
        
        // Vector test_world -> test_a
        var testLinearBackToInner = a.linearTransformTo(testLinearInOuter);
        MathAssert.floatEquals(testLinearBackToInner, testInA);
        
        // Point test_world -> test_a 
        var testAffineBackToInner = a.transformTo(testAffineInOuter);
        MathAssert.floatEquals(testAffineBackToInner, testInA);
    }
    
    public function testFrame2Inverse()
    {
        var originA = new Vector2(1.0, 1.0);
        var a = new Frame2(originA, 90.0);

        var aInv = a.inverse();
        
        // The following properties must hold:
        // - Frames commute with their inverses (A^-1 * A == A * A^-1 == I, i.e. no unique left vs. right inverses)
        // - The identity for a frame is an offset of (0, 0) with a rotation of 0 degrees.
        Assert.floatEquals(0.0, (a.concat(aInv).offset - Vector2.zero).length);
        Assert.floatEquals(0.0, (aInv.concat(a).offset - Vector2.zero).length);
        Assert.floatEquals(0.0, a.concat(aInv).angleDegrees);
        Assert.floatEquals(0.0, aInv.concat(a).angleDegrees);
    }
    
    public function testFlxSpriteFrame2()
    {
        var dummySprite = new FlxObjectMock();
        var frame:Frame2 = new FlxSpriteFrame2(dummySprite);
        frame.offset = Vector2.zero;
        frame.angleDegrees = 90;
        
        Assert.equals(dummySprite.x, frame.offset.x);
        Assert.equals(dummySprite.y, frame.offset.y);
        Assert.equals(dummySprite.angle, frame.angleDegrees);
    }
    
    public function testLerpFrame2()
    {
        var frameA = new Frame2(new Vector2(1.0, 0.0), 330.0);
        var frameB = new Frame2(new Vector2(0.0, 1.0), 60.0);
        
        // Lerping from either direction should be equivalent at t = 0.5
        var frameC = Frame2.lerp(frameA, frameB, 0.5);
        var frameC2 = Frame2.lerp(frameB, frameA, 0.5);
        MathAssert.floatEquals(frameC.offset, new Vector2(0.5, 0.5));
        Assert.floatEquals(15.0, frameC.angleDegrees);
        MathAssert.floatEquals(frameC2.offset, new Vector2(0.5, 0.5));
        Assert.floatEquals(15.0, frameC2.angleDegrees);
        
        var frameD = Frame2.lerp(frameA, frameB, 1.0 / 3.0);
        var frameD2 = Frame2.lerp(frameB, frameA, 2.0 / 3.0);
        MathAssert.floatEquals(frameD.offset, new Vector2(2.0 / 3.0, 1.0 / 3.0));
        Assert.floatEquals(0.0, frameD.angleDegrees);
        MathAssert.floatEquals(frameD2.offset, new Vector2(2.0 / 3.0, 1.0 / 3.0));
        Assert.floatEquals(0.0, frameD2.angleDegrees);
        
        var frameE = Frame2.lerp(frameA, frameB, 2.0 / 3.0);
        var frameE2 = Frame2.lerp(frameB, frameA, 1.0 / 3.0);
        MathAssert.floatEquals(frameE.offset, new Vector2(1.0 / 3.0, 2.0 / 3.0));
        Assert.floatEquals(30.0, frameE.angleDegrees);
        MathAssert.floatEquals(frameE2.offset, new Vector2(1.0 / 3.0, 2.0 / 3.0));
        Assert.floatEquals(30.0, frameE2.angleDegrees);
    }
    
    public function testFramesHaveToString()
    {
        var frame2 = new Frame2(new Vector2(23.0, 0.0), 42.0);
        Assert.isTrue('$frame2'.indexOf("23") != -1);
        Assert.isTrue('$frame2'.indexOf("42") != -1);
        
        var frame3 = new Frame3(new Vector3(23.0, 0.0, 0.0), new Quaternion(42.0, 0.0, 0.0, 0.0));
        Assert.isTrue('$frame3'.indexOf("23") != -1);
        Assert.isTrue('$frame3'.indexOf("42") != -1);
    }
}