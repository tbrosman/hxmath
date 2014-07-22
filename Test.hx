import test.TestMain;

class Test {
    static function main() {
        TestMain.main();
        
        #if sys
        Sys.stdin().readLine();
        #end
        return;
    }
}