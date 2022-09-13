package hxmath;

import hxmath.test.*;
import utest.UTest;

class Test {
    static function main()
    {
        UTest.run([
            new TestArrays(),
            new TestCommonOperations(),
            new Test3D(),
            new TestMathUtil(),
            new TestMatrices(),
            new TestFrames(),
            new TestGeom(),
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
