package test;
import nanotest.NanoTestRunner;

/**
 * ...
 * @author TABIV
 */
class TestMain
{
    public static function main()
    {
        var runner = new NanoTestRunner();
        runner.add(new Test2D());
        runner.run();
    }
}