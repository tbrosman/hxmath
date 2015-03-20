package hxmath.ds;

import hxmath.math.IntVector2;

/**
 * ...
 * @author TABIV
 */
class SparseArray2<T> implements IArray2<T>
{
    public static inline var bitsPerField = 15;
    public static inline var fieldMax:Int = 0x7fff;
    
    public var packedKeys(get, never):Iterator<Int>;
    
    private var hash:Map<Int, T>;
    
    public function new() 
    {
        this.hash = new Map<Int, T>();
    }
    
    public static inline function unpackX(index:Int):Int
    {
        return index & fieldMax;
    }
    
    public static inline function unpackY(index:Int):Int
    {
        return (index >> bitsPerField) & fieldMax;
    }
    
    private static inline function packIndex(x:Int, y:Int):Int
    {
        if (!indexInBounds(x, y))
        {
            throw 'Specified (x=$x, y=$y) fields not in the range [0, $fieldMax]';
        }
        
        return (y << bitsPerField) | x;
    }
    
    public inline static function indexInBounds(x:Int, y:Int)
    {
        return x >= 0 && y >= 0 && x <= fieldMax && y <= fieldMax;
    }
    
    public inline function iterator():Iterator<T>
    {
        return hash.iterator();
    }
    
    public inline function inBounds(x:Int, y:Int):Bool
    {
        return indexInBounds(x, y);
    }
    
    public inline function get(x:Int, y:Int):T
    {
        return hash.get(packIndex(x, y));
    }
    
    public inline function set(x:Int, y:Int, item:T):Void
    {
        hash.set(packIndex(x, y), item);
    }
    
    public inline function exists(x:Int, y:Int):Bool
    {
        return hash.exists(packIndex(x, y));
    }
    
    public inline function remove(x:Int, y:Int)
    {
        return hash.remove(packIndex(x, y));
    }
    
    public inline function clone():SparseArray2<T>
    {
        var copy = new SparseArray2<T>();
        
        for (key in hash.keys())
        {
            copy.hash.set(key, hash.get(key));
        }
        
        return copy;
    }
    
    public inline function toDenseArray():DenseArray2<T>
    {
        // To keep indices consistent, only consider the max bounds
        var maxX:Int = -1;
        var maxY:Int = -1;
        
        // Find the max bounds for the array
        for (key in hash.keys())
        {
            var x = unpackX(key);
            var y = unpackY(key);
            
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
            denseCopy.set(unpackX(key), unpackY(key), hash.get(key));
        }
        
        return denseCopy;
    }
    
    private inline function get_packedKeys():Iterator<Int>
    {
        return hash.keys();
    }
}