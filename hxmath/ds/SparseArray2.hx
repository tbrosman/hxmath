package hxmath.ds;

import hxmath.math.IntVector2;

/**
 * Sparse 2D array stored using a Map.
 */
class SparseArray2<T> implements IArray2<T>
{   
    // The iterator for the packed keys
    public var packedKeys(get, never):Iterator<SparseArray2Index>;
    
    private var hash:Map<SparseArray2Index, T>;
    
    /**
     * Constructor.
     */
    public function new() 
    {
        this.hash = new Map<SparseArray2Index, T>();
    }
    
    /**
     * Get the iterator for the underlying object.
     * 
     * @return  The iterator.
     */
    public inline function iterator():Iterator<T>
    {
        return hash.iterator();
    }
    
    /**
     * Check whether or not the position is in bounds.
     * 
     * @param x
     * @param y
     * @return      True if in bounds.
     */
    public inline function inBounds(x:Int, y:Int):Bool
    {
        return SparseArray2Index.indexInBounds(x, y);
    }
    
    /**
     * Get a single cell at the specified position.
     * 
     * @param x
     * @param y
     * @return      The value.
     */
    public inline function get(x:Int, y:Int):T
    {
        return hash.get(SparseArray2Index.packIndex(x, y));
    }
    
    /**
     * Set a single cell to the specified value.
     * 
     * @param x
     * @param y
     * @param item
     */
    public inline function set(x:Int, y:Int, item:T):Void
    {
        hash.set(SparseArray2Index.packIndex(x, y), item);
    }
    
    /**
     * Check if a value exists at (x, y).
     * 
     * @param x
     * @param y
     * @return      True if the value exists.
     */
    public inline function exists(x:Int, y:Int):Bool
    {
        return hash.exists(SparseArray2Index.packIndex(x, y));
    }
    
    /**
     * Remove a value at (x, y).
     * 
     * @param x
     * @param y
     */
    public inline function remove(x:Int, y:Int)
    {
        return hash.remove(SparseArray2Index.packIndex(x, y));
    }
    
    /**
     * Clone.
     * 
     * @return  A shallow copy of this object.
     */
    public inline function clone():SparseArray2<T>
    {
        var copy = new SparseArray2<T>();
        
        for (key in hash.keys())
        {
            copy.hash.set(key, hash.get(key));
        }
        
        return copy;
    }
    
    /**
     * Create DenseArray2 copy of the data in this array.
     * 
     * @return  A DenseArray2 copy.
     */
    public inline function toDenseArray():DenseArray2<T>
    {
        // To keep indices consistent, only consider the max bounds
        var maxX:Int = -1;
        var maxY:Int = -1;
        
        // Find the max bounds for the array
        for (key in hash.keys())
        {
            var x = key.x;
            var y = key.y;
            
            if (x > maxX)
            {
                maxX = x;
            }
            
            if (y > maxY)
            {
                maxY = y;
            }
        }
        
        // In the case of an empty source array a target array of size (0, 0) will be allocated
        var denseCopy:DenseArray2<T> = new DenseArray2<T>(maxX + 1, maxY + 1);
        
        for (key in hash.keys())
        {
            denseCopy.set(key.x, key.y, hash.get(key));
        }
        
        return denseCopy;
    }
    
    private inline function get_packedKeys():Iterator<SparseArray2Index>
    {
        return hash.keys();
    }
}