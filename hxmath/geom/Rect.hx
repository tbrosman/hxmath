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
     * @return
     */
    public inline function overlaps(r:Rect):Bool
    {
        return MathUtil.openRangeOverlaps(x, width, r.x, r.width)
            && MathUtil.openRangeOverlaps(y, height, r.y, r.height);
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
}