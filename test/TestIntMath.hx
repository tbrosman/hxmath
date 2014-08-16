package test;
import hxmath.math.IntVector2;
import hxmath.math.Vector2;

/**
 * ...
 * @author TABIV
 */
class TestIntMath extends MathTestCase
{
    public function testIntVector2Conversion()
    {
        // IntVector2 => Vector2 conversion
        var v = new IntVector2(1, 2);
        var u:Vector2 = v;
        var expectedU = new Vector2(1.0, 2.0);
        assertApproxEquals((u - expectedU).length, 0.0);
        
        // Vector2 => IntVector2 conversion. Test the default rounding/truncating func and a custom one (ceil).
        var eps = new Vector2(0.1, 0.1);
        var one = new Vector2(1.0, 1.0);
        var flooredVec = (u + eps).toIntVector2();
        var cieldVec = (u + eps).toIntVector2(Math.ceil);
        assertApproxEquals((flooredVec - u).length, 0.0);
        assertApproxEquals((cieldVec - (u + one)).length, 0.0);
    }
}