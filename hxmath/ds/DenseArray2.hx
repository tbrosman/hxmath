package hxmath.ds;

/**
 * ...
 * @author TABIV
 */
class DenseArray2<T> implements IArray2<T>
{
    public var width(default, null):Int;
    public var height(default, null):Int;
    
    private var array:Array<T>;
    
    public function new(width:Int, height:Int)
    {
        array = new Array<T>();
        this.width = width;
        this.height = height;
    }
    
    public inline function iterator():Iterator<T>
    {
        return array.iterator();
    }
    
    public inline function inBounds(x:Int, y:Int)
    {
        return x >= 0 && x < width && y >= 0 && y < height;
    }
    
    public inline function get(x:Int, y:Int):T
    {
        checkBounds(x, y);
        return array[x + y * width];
    }
    
    public inline function set(x:Int, y:Int, item:T):Void
    {
        checkBounds(x, y);
        array[x + y * width] = item;
    }
    
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