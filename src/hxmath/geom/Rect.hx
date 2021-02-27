package hxmath.geom;

import hxmath.math.MathUtil;
import hxmath.math.Matrix3x2;
import hxmath.math.Vector2;

/**
 * A shape used for converting/copying back to Rect-like objects from other libraries.
 */
typedef RectShape =
{
    var x:Float;
    var y:Float;
    var width:Float;
    var height:Float;
}

/**
 * A 2D rectangle.
 */
class Rect
{
    public var x:Float;
    public var y:Float;
    public var width:Float;
    public var height:Float;
    
    // Get the center of the rectangle
    public var center(get, never):Vector2;
    
    // Get an affine matrix with a basis/translation equivalent to this rectangle
    public var matrix(get, never):Matrix3x2;
    
    // Get the area
    public var area(get, never):Float;
    
    // True if the rect is empty
    public var isEmpty(get, never):Bool;
    
    /**
     * Constructor.
     * 
     * @param x
     * @param y
     * @param width
     * @param height
     */
    public function new(x:Float, y:Float, width:Float, height:Float) 
    {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }
    
    /**
     * Create a rectangle using two points as opposite vertices.
     * Note: the resulting rectangle may be degenerate if the points are the same/colinear with the same axis.
     * 
     * @param pointA
     * @param pointB
     * @return          A rectangle created from the two points.
     */
    public inline static function fromTwoPoints(pointA:Vector2, pointB:Vector2):Rect
    {
        return new Rect(
            Math.min(pointA.x, pointB.x),
            Math.min(pointA.y, pointB.y),
            Math.abs(pointB.x - pointA.x),
            Math.abs(pointB.y - pointA.y));
    }
    
    /**
     * Convert a Rect-like object from another library to a Rect by shape.
     * 
     * @param r     The Rect-shaped object.
     * @return      The equivalent Rect.
     */
    public inline static function fromRectShape(r:RectShape):Rect
    {
        return new Rect(r.x, r.y, r.width, r.height);
    }
    
    /**
     * Discard off-diagonals and treat the diagonals/translation of an affine frame as a rectangle.
     * 
     * @param m     The matrix to use.
     * @return      The equivalent Rect.
     */
    public inline static function fromMatrix(m:Matrix3x2):Rect
    {
        return new Rect(m.tx, m.ty, m.a, m.d);
    }
    
    /**
     * Equals.
     * 
     * @param r
     * @return      True if this == r.
     */
    public inline function equals(r:Rect):Bool
    {
        return r != null &&
            x == r.x &&
            y == r.y &&
            width == r.width &&
            height == r.height;
    }
    
    /**
     * Clone.
     * 
     * @return  The cloned object.
     */
    public inline function clone():Rect
    {
        return new Rect(x, y, width, height);
    }
    
    /**
     * Copy to a Rect-shaped object from another library.
     * 
     * @param r     The Rect-shaped object.
     */
    public inline function copyTo(r:RectShape):Void
    {
        r.x = x;
        r.y = y;
        r.width = width;
        r.height = height;
    }
    
    /**
     * Checks whether another rectangle overlaps this one.
     * All coordinate ranges are treated as open (e.g. if you have a grid of rectangles with edges
     * on top of eachother, they should not overlap).
     * 
     * @param r
     * @return      True if the rectangle overlaps.    
     */
    public inline function overlaps(r:Rect):Bool
    {
        return MathUtil.openRangesIntersect(x, width, r.x, r.width)
            && MathUtil.openRangesIntersect(y, height, r.y, r.height);
    }
    
    /**
     * Intersect two rectangles yielding a (potentially degenerate) rectangle.
     * 
     * @param r     The rectangle to intersect.
     * @return      The resulting rectangle.
     */
    public inline function intersect(r:Rect):Rect
    {
        return clone()
            .intersectWith(r);
    }
    
    /**
     * Set this rectangle to the intersection of this and another rectangle by clipping each edge.
     * 
     * @param r     The rectangle to intersect.
     * @return      This.
     */
    public inline function intersectWith(r:Rect):Rect
    {
        // Clip left edge
        if (x < r.x)
        {
            width -= (r.x - x);
            x = r.x;
        }

        // Clip bottom edge
        if (y < r.y)
        {
            height -= (r.y - y);
            y = r.y;
        }
        
        // Clip right edge
        if (x + width > r.x + r.width)
        {
            width -= (x + width) - (r.x + r.width);
        }
        
        // Clip top edge
        if (y + height > r.y + r.height)
        {
            height -= (y + height) - (r.y + r.height);
        }
        
        return this;
    }
    
    /**
     * Checks whether a point is in this rectangle.
     * All coordinate ranges are treated as closed.
     * 
     * @param    p    The point to test.
     * @return        True if the point is contained.
     */
    public inline function containsPoint(p:Vector2):Bool
    {
        return MathUtil.closedRangeContains(x, width, p.x)
            && MathUtil.closedRangeContains(y, height, p.y);
    }
    
    /**
     * Find the closest distance to a point.
     * 
     * @param p     The point.
     * @return      The closest distance (0 if the point is contained).
     */
    public inline function distanceToPoint(p:Vector2):Float
    {
        var dx = Math.max(Math.abs(p.x - (x + 0.5 * width)) - 0.5 * width, 0);
        var dy = Math.max(Math.abs(p.y - (y + 0.5 * height)) - 0.5 * height, 0);
        return Math.sqrt(dx * dx + dy * dy);
    }
    
    /**
     * Find the closest distance to a rect.
     * 
     * @param r     The rect to test against.
     * @return      The minimum distance (0 if intersecting).
     */
    public inline function distanceToRect(r:Rect):Float
    {
        var dx = Math.max(Math.abs((r.x + 0.5 * r.width) - (x + 0.5 * width)) - 0.5 * (width + r.width), 0);
        var dy = Math.max(Math.abs((r.y + 0.5 * r.height) - (y + 0.5 * height)) - 0.5 * (height + r.height), 0);
        return Math.sqrt(dx * dx + dy * dy);
    }
    
    /**
     * Inflate this rectangle directionally by adding it with a vector.
     * 
     * @param v     The vector to add where the signs of the components give which corner is moved.
     * @return      This.
     */
    public inline function addWith(v:Vector2):Rect
    {
        if (v.x < 0.0)
        {
            x += v.x;
            width -= v.x;
        }
        else
        {
            width += v.x;
        }

        if (v.y < 0.0)
        {
            y += v.y;
            height -= v.y;
        }
        else
        {
            height += v.y;
        }

        return this;
    }
    
    /**
     * Get a vertex by index. Vertices are ordered counter-clockwise with the origin as 0.
     * 
     * @param index     The index of the vertex.
     * @return          The vertex.
     */
    public inline function getVertex(index:Int):Vector2
    {
        var v = new Vector2(x, y);
        
        switch (index)
        {
            case 0:
            case 1:
                v.x += width;
            case 2:
                v.x += width;
                v.y += height;
            case 3:
                v.y += height;
            default:
                throw "Invalid vertex index.";
        }
        
        return v;
    }
    
    private inline function get_center():Vector2
    {
        return new Vector2(
            x + 0.5 * width,
            y + 0.5 * height);
    }
    
    private inline function get_matrix():Matrix3x2
    {
        return new Matrix3x2(width, 0.0, 0.0, height, x, y);
    }
    
    private inline function get_area():Float
    {
        return width * height;
    }
    
    private inline function get_isEmpty():Bool
    {
        return width <= 0.0 || height <= 0.0;
    }
}