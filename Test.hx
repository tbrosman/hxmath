import test.TestMain;

class Test {
    static function main() {
        var passed = TestMain.main();
        
        #if (sys && !EXIT_ON_FINISH)
        Sys.stdin().readLine();
        #else
        Sys.exit(passed ? 0 : -1);
        #end
    }
}