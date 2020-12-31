package test;

import hxmath.math.Vector2;
import hxmath.math.Complex;

class TestComplex extends MathTestCase
{
    public function testString(){
        var c0: Complex = '1 + 2i';
        var c: Complex = { real: 1., i: 2. };
        assertTrue( c == c0 );
        var c1 = new Complex( 1., 2.);
        assertTrue( c0 == c1 ); 
        var s: String = c;
        // js seems to remove the .'s from the numbers not sure on other targets
        assertTrue( s == '1. + 2. i' || s == '1 + 2 i');
    }
    
    public function testSimples(){
        var a = new Complex(1., 2.);
        assertTrue(a.real == 1.);
        assertTrue(a.i == 2.);
        assertTrue(Complex.negPosTau == new Complex(-Math.PI*2, Math.PI*2));
        assertTrue(Complex.posNegTau == new Complex(Math.PI*2, -Math.PI*2));
        assertTrue(Complex.minusTau == new Complex(-Math.PI*2, 0.));
        assertTrue(Complex.iMinusTau == new Complex(0., -Math.PI*2));
        assertTrue(Complex.unitMinusTau == new Complex(-Math.PI*2,-Math.PI*2));
        assertTrue(Complex.unitTau == new Complex(Math.PI*2, Math.PI*2));
        assertTrue(Complex.iTau == new Complex(0. , Math.PI*2));
        assertTrue(Complex.realTau == new Complex(Math.PI*2, 0.));
        assertTrue(Complex.negPosPi == new Complex(-Math.PI, Math.PI)); 
        assertTrue(Complex.posNegPi == new Complex(Math.PI, -Math.PI));
        assertTrue(Complex.minusPi == new Complex(-Math.PI, 0.)); 
        assertTrue(Complex.iMinusPi == new Complex(0., -Math.PI)); 
        assertTrue(Complex.unitMinusPi == new Complex(-Math.PI, -Math.PI)); 
        assertTrue(Complex.unitPi == new Complex(Math.PI, Math.PI));
        assertTrue(Complex.iPi == new Complex(0., Math.PI));
        assertTrue(Complex.realPi == new Complex(Math.PI, 0.)); 
        assertTrue(Complex.negPosInfinity == new Complex(Math.NEGATIVE_INFINITY, Math.POSITIVE_INFINITY));
        assertTrue(Complex.posNegInfinity == new Complex(Math.POSITIVE_INFINITY, Math.NEGATIVE_INFINITY)); 
        assertTrue(Complex.iMinusInfinity == new Complex(0., Math.NEGATIVE_INFINITY)); 
        assertTrue(Complex.iInfinity == new Complex(0., Math.POSITIVE_INFINITY)); 
        assertTrue(Complex.minusInfinity == new Complex(Math.NEGATIVE_INFINITY, 0.)); 
        assertTrue(Complex.realInfinity == new Complex(Math.POSITIVE_INFINITY, 0.)); 
        assertTrue(Complex.unitMinusInfinity == new Complex(Math.NEGATIVE_INFINITY, Math.NEGATIVE_INFINITY)); 
        assertTrue(Complex.unitInfinity == new Complex(Math.POSITIVE_INFINITY, Math.POSITIVE_INFINITY));
        assertTrue(Complex.minusUnit == new Complex( -1.,  -1.));
        assertTrue(Complex.iMinus1 == new Complex( 0., -1.)); 
        assertTrue(Complex.i1 == new Complex( 0., 1.));
        assertTrue(Complex.unit == new Complex( 1., 1.));
        assertTrue(Complex.minus1 == new Complex( -1., 0.));
        assertTrue(Complex.one == new Complex(1., 0.));
        assertTrue(Complex.zero == new Complex(0., 0.)); 
    }
    
    public function testClone(){
        var a = new Complex(1., 2.);
        assertTrue(a.clone() == a);
    }
    
    public function testSwap(){
        var a = new Complex(1., 2.);
        var b = new Complex(2., 1.);
        assertTrue(a.swap() == b);
    }
    
    public function testInequality(){
        // == and !=
        var a = new Complex(1., 2. );
        var b = new Complex(1., 1. );
        assertTrue((a!= b));
        b = new Complex(1., 2.);
        assertTrue((a==b));
    }
    
    public function testAddition(){
        var a = Complex.unit;
        assertTrue(a + a == new Complex(2., 2.)); 
    }
    
    public function testSubtract(){
        var a = Complex.unit;
        assertTrue(a - a == Complex.zero); 
    }
    
    public function testScale(){
        var a = 10.;
        var b = new Complex(1., 7.);
        assertTrue(a * b == new Complex(10, 70.));
    }
    
    public function testMultiply(){
        var a = new Complex(3.,  2.);
        var b = new Complex(1.,  7.);
        assertTrue(a * b == new Complex(-11., 23.));
    }
    
    public function testAddExponents(){
        var a = new Complex(3., 2.);
        assertTrue(a.addExponents() == 5);
    }
    
    public function testConjugate(){
        var a = new Complex(1.,  2.);
        var b = ~a;
        assertTrue(b == new Complex(1., -2.));
        
    }
    
    public function testDivide(){
        var a = new Complex(1., -3.);
        var b = new Complex(1., 2.);
        assertTrue((a / b) == new Complex(-1, -1));
    }
    
    public function testNegate(){
        var a = new Complex(1., 2.);
        var b = -a;
        assertTrue(b == new Complex(-1., -2.));
    }
    
    public function testMagnitudeSquared(){
        var a = new Complex( 2., 4.);
        assertTrue(a.magnitudeSquared() == (4. + 16.));
    }
    
    public function testLength(){
        var a = new Complex(3, 4);
        assertTrue(a.length == 5.);
    }
    
    public function testIsReal(){
        var a = Complex.one;
        assertTrue(a.isReal() == true);
    }
    
    public function testIsImaginary(){
        var a = Complex.i1;
        assertTrue(a.isImaginary() == true);
    }
    
    public function testCis(){
        var r = 12;
        var theta = Math.PI/4;
        var cis = Complex.cis;
        var square = Complex.square;
        assertTrue(square(r*cis( theta )) == r*r*cis( 2*theta ));
    }
    
    public function testFromCircle(){
        var r = 12;
        var theta = Math.PI/4;
        var cis = Complex.cis;
        var square = Complex.square;
        var fromCircle = Complex.fromCircle;
        assertTrue(square(fromCircle(r,theta)) == fromCircle(r*r,2*theta));
    }
    
    public function testSquare(){
        var r = 12;
        var theta = Math.PI/4;
        var cis = Complex.cis;
        var square = Complex.square;
        var fromCircle = Complex.fromCircle;
        assertTrue(square(fromCircle(r,theta))==fromCircle(r*r,2*theta));
    }
    
    public function testExp(){
        var r = 12;
        var theta = Math.PI/4;
        var cis = Complex.cis;
        var fromCircle = Complex.fromCircle;
        var exp = Complex.exp;
        assertTrue(fromCircle(r,theta)==r*exp(new Complex(0,theta)));
    }
    
    public function testln(){
        var a = new Complex(3, 4);
        var b = new Complex(6, 8);
        var ln = Complex.ln;
        assertTrue(ln(a*b)==ln(a)+ln(b));
    }
    
    public function testArg()
    {
        var a = new Complex(3, 4);
        var b = new Complex(6, 8);
        var arg = Complex.arg;
        assertTrue(arg(a*b)==arg(a)+arg(b));
    }
}