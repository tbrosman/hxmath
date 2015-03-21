package hxmath.ds;

/**
 * Common functionality for sparse and dense 2D arrays.
 */
interface IArray2<T>
{
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
     * Set a single cell to the specified value.
     * 
     * @param x
     * @param y
     * @param item
     */
    function set(x:Int, y:Int, item:T):Void;
}