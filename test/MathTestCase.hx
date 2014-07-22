package test;
import haxe.PosInfos;
import nanotest.NanoTestCase;

/**
 * ...
 * @author TABIV
 */
class MathTestCase extends NanoTestCase
{
    private function randomArray(size:Int, center:Float=0.0, width:Float=1.0):Array<Float>
    {
        var data = new Array<Float>();
        
        for (i in 0...size)
        {
            data.push((Math.random() - 0.5) * width + center);
        }
        
        return data;
    }
    
    private function assertApproxEquals(expected:Float, actual:Float, tolerance:Float=1e-6, ?p:PosInfos)
    {
        if (Math.abs(expected - actual) < tolerance)
        {
            success(p);
        }
        else
        {
            fail('expected $expected +-$tolerance but was $actual');
        }
    }
}