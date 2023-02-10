package hxmath;

import hxmath.test.*;
import utest.UTest;

class Test {
    static function main()
    {
        UTest.run([
            new TestArrays(),
            new TestCommonOperations(),
            new TestFrames(),
            new TestMathUtil(),
            new TestMatrices(),
            new TestQuaternions(),
            new TestRays(),
            new TestRects(),
            new TestVectors()
            #if STRESS_TESTS
            , new TestStress()
            #end
        ]);
        
        #if (sys && !EXIT_ON_FINISH)
        Sys.stdin().readLine();
        #end
    }
}
