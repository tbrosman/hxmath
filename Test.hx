import test.TestMain;

class Test {
    static function main() {
        var failed = TestMain.main();
        
        #if (sys && !EXIT_ON_FINISH)
        Sys.stdin().readLine();
        #else
        Sys.exit(failed ? -1 : 0);
        #end
    }
}