package hxmath.test;

import hxmath.math.MathUtil;
import hxmath.frames.adapters.FlxSpriteFrame2;
import hxmath.frames.Frame2;
import hxmath.frames.Frame3;
import hxmath.math.Quaternion;
import hxmath.math.Vector2;
import hxmath.math.Vector3;
import hxmath.math.Vector4;

class TestFrames extends Test
{
    public function testAdapters()
    {
        var dummySprite = new FlxObjectMock();
        var frame:Frame2 = new FlxSpriteFrame2(dummySprite);
        frame.offset = randomVector2();
        frame.angleDegrees = randomFloat(90, 180);
        
        Assert.equals(dummySprite.x, frame.offset.x);
        Assert.equals(dummySprite.y, frame.offset.y);
        Assert.equals(dummySprite.angle, frame.angleDegrees);
    }
    
    public function testConcat()
    {
        // 2D
        var combined = new Frame2(new Vector2(1, 1), 90).concat(
            new Frame2(new Vector2(1, 1), -90));
        Assert.floatEquals(0, combined.offset.x);
        Assert.floatEquals(2, combined.offset.y);
        Assert.equals(0, combined.angleDegrees);
        
        MathAssert.floatEquals(new Vector2(0, 2), combined.transformFrom(Vector2.zero));
        MathAssert.floatEquals(new Vector2(1, 2), combined.transformFrom(Vector2.xAxis));
        MathAssert.floatEquals(new Vector2(0, 3), combined.transformFrom(Vector2.yAxis));
        
        // 3D
        var combined = new Frame3(new Vector3(1, 1, 0), Quaternion.fromAxisAngle(90, Vector3.zAxis))
            .concat(new Frame3(new Vector3(1, 1, 0), Quaternion.fromAxisAngle(-90, Vector3.zAxis)));
        Assert.floatEquals(0, combined.offset.x);
        Assert.floatEquals(2, combined.offset.y);
        Assert.floatEquals(0, combined.offset.z);
        
        MathAssert.floatEquals(new Vector3(0, 2, 0), combined.transformFrom(Vector3.zero));
        MathAssert.floatEquals(new Vector3(1, 2, 0), combined.transformFrom(Vector3.xAxis));
        MathAssert.floatEquals(new Vector3(0, 3, 0), combined.transformFrom(Vector3.yAxis));
    }
    
    public function testInverse()
    {
        // 2D
        for (i in 0...10)
        {
            var frame = randomFrame2();
            var inverse = frame.inverse();
            var samplePoint = new Vector2(1, 1);
            
            var results = [
                MathAssert.floatEquals(Vector2.zero, frame.concat(inverse).offset),
                Assert.floatEquals(0.0, frame.concat(inverse).angleDegrees),
                MathAssert.floatEquals(frame.matrix.applyInvertFrame() * samplePoint,
                    inverse.matrix * samplePoint)
            ];
            
            if (results.contains(false))
            {
                trace('Iteration #$i: $frame');
            }
        }
        
        // 3D
        for (i in 0...10)
        {
            var frame = randomFrame3();
            var inverse = frame.inverse();
            var samplePoint = new Vector4(1, 1, 1, 1);
            
            var results = [
                MathAssert.floatEquals(Vector3.zero, frame.concat(inverse).offset),
                MathAssert.floatEquals(Quaternion.identity, frame.concat(inverse).orientation),
                MathAssert.floatEquals(frame.matrix.applyInvertFrame() * samplePoint,
                        inverse.matrix * samplePoint)
            ];
            
            if (results.contains(false))
            {
                trace('Iteration #$i: $frame');
            }
        }
    }
    
    public function testLerp()
    {
        var cos30 = Math.cos(Math.PI / 6);
        var sin30 = Math.sin(Math.PI / 6);
        
        // 2D
        var frameA = new Frame2(new Vector2(0, 0), 330);
        var frameB = new Frame2(new Vector2(8, 4), 90);
        
        MathAssert.floatEquals(new Vector2(2 + 1, 1 + 0),
            Frame2.lerp(frameA, frameB, 0.25).transformFrom(Vector2.xAxis));
        MathAssert.floatEquals(new Vector2(4 + cos30, 2 + sin30),
            Frame2.lerp(frameA, frameB, 0.5).transformFrom(Vector2.xAxis));
        
        // 3D
        var frameA = new Frame3(new Vector3(0, 0, 0), Quaternion.fromAxisAngle(-30, Vector3.zAxis));
        var frameB = new Frame3(new Vector3(8, 4, 0), Quaternion.fromAxisAngle(90, Vector3.zAxis));
        frameA.orientation.normalize();
        frameB.orientation.normalize();
        
        // Allow for error in `Quaternion.lerp()`.
        MathAssert.floatEquals(new Vector3(2 + 1, 1 + 0, 0),
            Frame3.lerp(frameA, frameB, 0.25).transformFrom(Vector3.xAxis),
            0.3);
        MathAssert.floatEquals(new Vector3(4 + cos30, 2 + sin30, 0),
            Frame3.lerp(frameA, frameB, 0.5).transformFrom(Vector3.xAxis),
            0.3);
    }
    
    public function testLinearTransform()
    {
        var frame = new Frame2(new Vector2(1.0, 1.0), 90.0);
        var point = new Vector2(1.0, 2.0);
        
        MathAssert.floatEquals(new Vector2(-2.0, 1.0), frame.linearTransformFrom(point));
        MathAssert.floatEquals(new Vector2(-1.0, 2.0), frame.transformFrom(point));
        
        MathAssert.floatEquals(new Vector2(2.0, -1.0), frame.linearTransformTo(point));
        MathAssert.floatEquals(new Vector2(1.0, 0.0), frame.transformTo(point));
    }
    
    public function testToString()
    {
        // 2D
        var frame2 = new Frame2(new Vector2(23.0, 0.0), 42.0);
        Assert.isTrue('$frame2'.indexOf("23") != -1);
        Assert.isTrue('$frame2'.indexOf("42") != -1);
        
        // 3D
        var frame3 = new Frame3(new Vector3(23.0, 0.0, 0.0), new Quaternion(42.0, 0.0, 0.0, 0.0));
        Assert.isTrue('$frame3'.indexOf("23") != -1);
        Assert.isTrue('$frame3'.indexOf("42") != -1);
    }
}

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
