package test;
import hxmath.math.Matrix3x3;
import hxmath.math.Vector2;

class TestStress extends MathTestCase
{
    public function testDotProduct()
    {
        trace("Vector2 dot product");
        var iters = 1000000;
        
        var time1Start = Sys.cpuTime();
        var sum1 = 0.0;
        for (i in 0...iters)
        {
            var a = new Vector2(i * 1.2, i * 4.3);
            var b = new Vector2(i * 1.1, i * 0.8);
            sum1 += a * b;
        }
        var time1End = Sys.cpuTime();
        
        var time2Start = Sys.cpuTime();
        var sum2 = 0.0;
        for (i in 0...iters)
        {
            var a = new Vector2Default(i * 1.2, i * 4.3);
            var b = new Vector2Default(i * 1.1, i * 0.8);
            sum2 += a.x * b.x + a.y * b.y;
        }
        var time2End = Sys.cpuTime();
        
        assertEquals(sum1, sum2);
        
        var time1 = time1End - time1Start;
        var time2 = time2End - time2Start;
        
        trace('abstracts = $time1');
        trace('direct = $time2');
        trace('abstracts / direct = ${time1 / time2}');
    }
    
    public function testMatrixProduct()
    {
        trace("Matrix3x3 matrix product");
        var iters = 100000;
        
        var time1Start = Sys.cpuTime();
        var sum1 = 0.0;
        for (i in 0...iters)
        {
            var a:Matrix3x3 = new Matrix3x3Default(
                i * 1.2, i * 4.3, i * 1.2,
                i * 4.3, i * 1.2, i * 4.3,
                i * 1.2, i * 4.3, i * 1.2);
            var b:Matrix3x3 = new Matrix3x3Default(
                i * 1.1, i * 0.8, i * 1.1,
                i * 0.8, i * 1.1, i * 0.8,
                i * 1.1, i * 0.8, i * 1.1);
            var c:Matrix3x3 = a * b;
            sum1 +=
                c.m00 + c.m10 + c.m20 +
                c.m01 + c.m11 + c.m21 +
                c.m02 + c.m12 + c.m22;
        }
        var time1End = Sys.cpuTime();
        
        var time2Start = Sys.cpuTime();
        var sum2 = 0.0;
        for (i in 0...iters)
        {
            var a = new Matrix3x3Default(
                i * 1.2, i * 4.3, i * 1.2,
                i * 4.3, i * 1.2, i * 4.3,
                i * 1.2, i * 4.3, i * 1.2);
            var b = new Matrix3x3Default(
                i * 1.1, i * 0.8, i * 1.1,
                i * 0.8, i * 1.1, i * 0.8,
                i * 1.1, i * 0.8, i * 1.1);
            var c = new Matrix3x3Default(
                a.m00 * b.m00 + a.m10 * b.m01 + a.m20 * b.m02,
                a.m00 * b.m10 + a.m10 * b.m11 + a.m20 * b.m12,
                a.m00 * b.m20 + a.m10 * b.m21 + a.m20 * b.m22,
                
                a.m01 * b.m00 + a.m11 * b.m01 + a.m21 * b.m02,
                a.m01 * b.m10 + a.m11 * b.m11 + a.m21 * b.m12,
                a.m01 * b.m20 + a.m11 * b.m21 + a.m21 * b.m22,
                
                a.m02 * b.m00 + a.m12 * b.m01 + a.m22 * b.m02,
                a.m02 * b.m10 + a.m12 * b.m11 + a.m22 * b.m12,
                a.m02 * b.m20 + a.m12 * b.m21 + a.m22 * b.m22);
            sum2 +=
                c.m00 + c.m10 + c.m20 +
                c.m01 + c.m11 + c.m21 +
                c.m02 + c.m12 + c.m22;
        }
        var time2End = Sys.cpuTime();
        
        assertEquals(sum1, sum2);
        
        var time1 = time1End - time1Start;
        var time2 = time2End - time2Start;
        
        trace('abstracts = $time1');
        trace('direct = $time2');
        trace('abstracts / direct = ${time1 / time2}');
    }
}