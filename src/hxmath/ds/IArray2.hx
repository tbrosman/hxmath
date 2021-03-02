package hxmath.ds;
import hxmath.math.ShortVector2;

/**
 * Common functionality for sparse and dense 2D arrays.
 */
interface IArray2<T>
{
    // The iterator for the packed keys
    var keys(get, never):Iterator<ShortVector2>;
    
    /**
     * Get the iterator for the underlying object.
     * 
     * @return  The iterator.
     */
    function iterator():Iterator<T>;
    
    /**
     * Check whether or not the position is in bounds.
     * 
     * @param x
     * @param y
     * @return      True if in bounds.
     */
    function inBounds(x:Int, y:Int):Bool;
    
    /**
     * Get a single cell at the specified position.
     * 
     * @param x
     * @param y
     * @return      The value.
     */
    function get(x:Int, y:Int):T;
    
    /**
     * Get a single cell by (x, y) key.
     * 
     * @param key   The packed (x, y) key.
     * @return      The cell at that location.
     */
    function getByKey(key:ShortVector2):T;
    
    /**
     * Set a single cell to the specified value.
     * 
     * @param x
     * @param y
     * @param item
     */
    function set(x:Int, y:Int, item:T):Void;
}