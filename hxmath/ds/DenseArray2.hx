package hxmath.ds;

/**
 * Dense 2D array stored using a 1D array.
 */
class DenseArray2<T> implements IArray2<T>
{
    // The width of the array in cells
    public var width(default, null):Int;
    
    // The height of the array in cells
    public var height(default, null):Int;
    
    private var array:Array<T>;
    
    /**
     * Constructor.
     * 
     * @param width
     * @param height
     */
    public function new(width:Int, height:Int)
    {
        array = new Array<T>();
        this.width = width;
        this.height = height;
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
     * Resize the array, preserving as much as possible of the old array.
     * 
     * @param newWidth      The new width.
     * @param newHeight     The new height.
     */
    public function resize(newWidth:Int, newHeight:Int)
    {
        var newArray = new Array<T>();
        
        // Pick the smaller width/height for the write stride
        var strideWidth = height < newHeight ? height : newHeight;
        var strideHeight = width < newWidth ? width : newWidth;
        
        // Write to the end of the array first to avoid excessive array resizing
        for (reverseY in 0...strideHeight)
        {
            var y = strideHeight - 1 - reverseY;
            for (reverseX in 0...strideWidth)
            {
                var x = strideWidth - 1 - reverseX;
                newArray[x + y * newWidth] = array[x + y * width];
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
    
    private inline function checkBounds(x:Int, y:Int)
    {
        if (!inBounds(x, y))
        {
            throw 'Specified (x=$x, y=$y) fields not in the ranges x: [0, $width) y: [0, $height)';
        }
    }
}