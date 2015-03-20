package hxmath.ds;

/**
 * ...
 * @author TABIV
 */
interface IArray2<T>
{
    function iterator():Iterator<T>;
    function inBounds(x:Int, y:Int):Bool;
    function get(x:Int, y:Int):T;
    function set(x:Int, y:Int, item:T):Void;
}