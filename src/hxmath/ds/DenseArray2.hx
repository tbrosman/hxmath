package hxmath.ds;
import hxmath.math.MathUtil;
import hxmath.math.ShortVector2;

/**
 * An iterator allowing key iteration similar to SparseArray2.
 */
private class DenseArray2KeysIterator<T>
{
    private var array:DenseArray2<T>;
    private var currentX:Int = 0;
    private var currentY:Int = 0;
    
    public function new(array:DenseArray2<T>)
    {
        this.array = array;
    }
    
    public function hasNext():Bool
    {
        return currentX < array.width &&
            currentY < array.height;
    }
    
    public function next():ShortVector2
    {
        var currentKey = new ShortVector2(currentX, currentY);
        
        // Advance one cell in the current row
        if (currentX + 1 < array.width)
        {
            currentX++;
        }
        
        // Advance one row
        else if (currentY + 1 < array.height)
        {
            currentX = 0;
            currentY++;
        }
        
        // End of the array
        else
        {
            currentX = array.width;
            currentY = array.height;
        }
        
        return currentKey;
    }
}

/**
 * Dense 2D array stored using a 1D array.
 */
class DenseArray2<T> implements IArray2<T>
{
    // The width of the array in cells
    public var width(default, null):Int;
    
    // The height of the array in cells
    public var height(default, null):Int;
    
    // The iterator for the packed keys
    public var keys(get, never):Iterator<ShortVector2>;
    
    private var array:Array<T>;
    
    // The default value used to construct this array (needed for copying due to constructor signature)
    private var defaultValue:T;
    
    /**
     * Constructor. The underlying array will always be width*height in size and will always contain valid data.
     * 
     * @param width
     * @param height
     * @param defaultValue  Used to fill in the array initially.
     */
    public function new(width:Int, height:Int, ?defaultValue:T)
    {
        array = new Array<T>();
        this.width = width;
        this.height = height;
        this.defaultValue = defaultValue;
        
        for (i in 0...(width * height))
        {
            array[i] = defaultValue;
        }
    }
    
    /**
     * Create a DenseArray2 from a jagged array in row-major order.
     * 
     * @param source        The source array, possibly non-rectangular.
     * @param defaultValue  The default value to fill parts of the DenseArray2 not overlapped by the source (jagged) array.
     * @return              The resulting rectangular (dense) array.
     */
    public static inline function fromNestedArray<T>(source:Array<Array<T>>, ?defaultValue:T):DenseArray2<T>
    {
        var longestRowLength:Int = 0;
        
        for (row in source)
        {
            longestRowLength = MathUtil.intMax(longestRowLength, row.length);
        }
        
        var target:DenseArray2<T> = new DenseArray2<T>(longestRowLength, source.length, defaultValue);
        
        for (y in 0...target.height)
        {
            for (x in 0...target.width)
            {
                // If out of bounds ignore
                if (x < source[y].length)
                {
                    target.set(x, y, source[y][x]);
                }
            }
        }
        
        return target;
    }
    
    /**
     * Get the iterator for the underlying object.
     * 
     * @return  The iterator.
     */
    public inline function iterator():Iterator<T>
    {
        return array.iterator();
    }
    
    /**
     * Check whether or not the position is in bounds.
     * 
     * @param x
     * @param y
     * @return      True if in bounds.
     */
    public inline function inBounds(x:Int, y:Int)
    {
        return x >= 0 && x < width && y >= 0 && y < height;
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
        checkBounds(x, y);
        return array[x + y * width];
    }
    
    /**
     * Get a single cell by (x, y) key.
     * 
     * @param key   The packed (x, y) key.
     * @return      The cell at that location.
     */
    public inline function getByKey(key:ShortVector2):T
    {
        return array[key.x + key.y * width];
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
        checkBounds(x, y);
        array[x + y * width] = item;
    }
    
    /**
     * Overwrite all cells in the array with the specified item.
     * 
     * @param item
     */
    public inline function fill(item:T):Void
    {
        for (y in 0...height)
        {
            for (x in 0...width)
            {
                array[x + y * width] = item;
            }
        }
    }
    
    /**
     * Resize the array, preserving as much as possible of the old array.
     * 
     * @param newWidth      The new width.
     * @param newHeight     The new height.
     * @param defaultValue  The default value to fill into non-overlapping empty space.
     */
    public function resize(newWidth:Int, newHeight:Int, ?defaultValue:T)
    {
        var newArray = new Array<T>();
        
        // Pick the larger width/height for the write stride
        var strideY = height > newHeight ? height : newHeight;
        var strideX = width > newWidth ? width : newWidth;
        
        // Write to the end of the array first to avoid excessive array resizing
        for (reverseY in 0...strideY)
        {
            var y = strideY - 1 - reverseY;
            for (reverseX in 0...strideX)
            {
                var x = strideX - 1 - reverseX;
                
                // Are we in the intersection of the old bounds and new bounds?
                var copyOld = x < width && x < newWidth && y < height && y < newHeight;
                newArray[x + y * newWidth] = copyOld
                    ? array[x + y * width]
                    : defaultValue;
            }
        }
        
        array = newArray;
        width = newWidth;
        height = newHeight;
    }
    
    /**
     * Blit from another array onto this array. If the specified area exceeds the target array bounds, clip it to fit.
     * 
     * @param targetX       The starting X in the target.
     * @param targetY       The starting Y in the target.
     * @param source        The source array.
     * @param sourceX       The starting X in the source.
     * @param sourceY       The starting Y in the source.
     * @param copyWidth     The width of the area to copy.
     * @param copyHeight    The height of the area to copy.
     * @return              The number of pixels written.
     */
    public function clippedBlit(targetX:Int, targetY:Int, source:DenseArray2<T>, sourceX:Int, sourceY:Int, copyWidth:Int, copyHeight:Int):Int
    {
        // Target indices cannot be out of bounds (target refers to this object)
        if (targetX < 0)
        {
            sourceX += -targetX;
            targetX = 0;
        }
        
        if (targetY < 0)
        {
            sourceY += -targetY;
            targetY = 0;
        }
        
        // Clip for target rect
        if (targetX + copyWidth > width)
        {
            copyWidth = width - targetX;
        }
        
        if (targetY + copyHeight > height)
        {
            copyHeight = height - targetY;
        }
        
        // Clip for source rect
        if (sourceX + copyWidth > source.width)
        {
            copyWidth = source.width - sourceX;
        }
        
        if (sourceY + copyHeight > source.height)
        {
            copyHeight = source.height - sourceY;
        }
        
        if (copyWidth == 0
            || copyHeight == 0
            || targetX >= width
            || targetY >= height)
        {
            return 0;
        }

        return blit(targetX, targetY, source, sourceX, sourceY, copyWidth, copyHeight);
    }
    
    /**
     * Blit from another array onto this array.
     * 
     * @param targetX       The starting X in the target.
     * @param targetY       The starting Y in the target.
     * @param source        The source array.
     * @param sourceX       The starting X in the source.
     * @param sourceY       The starting Y in the source.
     * @param copyWidth     The width of the area to copy.
     * @param copyHeight    The height of the area to copy.
     * @return              The number of pixels written.
     */
    public function blit(targetX:Int, targetY:Int, source:DenseArray2<T>, sourceX:Int, sourceY:Int, copyWidth:Int, copyHeight:Int):Int
    {
        if (targetX < 0
            || targetY < 0
            || sourceX < 0
            || sourceY < 0
            || copyWidth <= 0
            || copyHeight <= 0)
        {
            throw 'Invalid parameters Target($targetX, $targetY) Source($sourceX, $sourceY) CopyWidthHeight($copyWidth, $copyHeight)';
        }
        
        if ((targetX + copyWidth > width) || (targetY + copyHeight > height))
        {
            throw 'Overlapping rect Target($targetX, $targetY) Source($sourceX, $sourceY) CopyWidthHeight($copyWidth, $copyHeight) CurrentRect($width, $height)';
        }
        
        var blitCount:Int = 0;
        
        for (y in 0...copyHeight)
        {
            for (x in 0...copyWidth)
            {
                var p = source.get(x + sourceX, y + sourceY);
                set(x + targetX, y + targetY, p);
                blitCount++;
            }
        }
        
        return blitCount;
    }
    
    /**
     * Clone.
     * 
     * @return  A shallow copy of this object.
     */
    public inline function clone():DenseArray2<T>
    {
        var copy = new DenseArray2<T>(width, height, defaultValue);
        
        for (y in 0...height)
        {
            for (x in 0...width)
            {
                copy.set(x, y, get(x, y));
            }
        }
        
        return copy;
    }
    
        
    /**
     * Create SparseArray2 copy of the data in this array.
     * 
     * @return  A DenseArray2 copy.
     */
    public function toSparseArray():SparseArray2<T>
    {
        var sparseCopy:SparseArray2<T> = new SparseArray2<T>();
        
        for (y in 0...height)
        {
            for (x in 0...width)
            {
                sparseCopy.set(x, y, get(x, y));
            }
        }
        
        return sparseCopy;
    }
    
    private inline function checkBounds(x:Int, y:Int)
    {
        if (!inBounds(x, y))
        {
            throw 'Specified (x=$x, y=$y) fields not in the ranges x: [0, $width) y: [0, $height)';
        }
    }
    
    private inline function get_keys():Iterator<ShortVector2>
    {
        return new DenseArray2KeysIterator(this);
    }
}