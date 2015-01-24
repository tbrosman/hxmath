package hxmath.geom;

import hxmath.math.MathUtil;
import hxmath.math.Matrix2x2;
import hxmath.math.Vector2;

/**
 * A 2D ray.
 */
class Ray2
{
    public var origin:Vector2;
    public var normal:Vector2;
    
    /**
     * Constructor.
     * 
     * @param origin    The origin of the ray ("eye point").
     * @param normal    The normal of the ray ("look direction").    
     */
    public function new(origin:Vector2, normal:Vector2) 
    {
        this.origin = origin;
        this.normal = normal;
    }
    
    /**
     * Evaluate the ray for a given t.
     * 
     * @param t     The distance along the ray.
     * @return      The point at t.
     */
    public inline function eval(t:Float):Vector2
    {
        return t * normal + origin;
    }
    
    /**
     * Intersect a point against the ray using the specified tolerance.
     * 
     * @param point         The point to test.
     * @param tolerance     The thickness of the ray.
     * @return              If there was a hit, the t value for the hit. Otherwise, -Inf.
     */
    public function intersectPoint(point:Vector2, tolerance:Float=1e-6):Float
    {
        // TODO cache this/make it faster (or just use det2x2)
        var perpNorm = normal.rotatedLeft;
        
        // Check the perpendicular distance from the line defining the ray
        var d = (point - origin) * perpNorm;
        if (d < tolerance)
        {
            // Test the distance along the ray
            var t = (point - origin) * normal;

            if (t >= 0.0)
            {
                return t;
            }
        }
        
        return Math.NEGATIVE_INFINITY;
    }
    
    /**
     * Given a set of points find the closest point the the beginning of the ray using the given tolerance to test containment.
     * 
     * @param points        The set of points to test.
     * @param tolerance     The "thickness" of the ray (the cylinder around the ray to test for containmnet).
     * @return              The closest hit. -1 if there was none.
     */
    public inline function getClosestPoint(points:Array<Vector2>, tolerance:Float=1e-6):Int
    {
        var closestHit:Float = Math.NEGATIVE_INFINITY;
        var hitIndex = -1;
        var perpNorm = normal.rotatedLeft;
        
        for (i in 0...points.length)
        {
            var t = intersectPoint(points[i], tolerance);
            if (t > 0.0 &&
                (hitIndex == -1 || (t < closestHit && t >= 0.0)))
            {
                hitIndex = i;
                closestHit = t;
            }
        }
        
        return hitIndex;
    }
}