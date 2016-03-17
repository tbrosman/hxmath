package hxmath.math;

/**
 * The default underlying type.
 */
class IntVector2Default
{
    public var x:Int;
    public var y:Int;
    
    public function new(x:Int, y:Int)
    {
        this.x = x;
        this.y = y;
    }
    
    public function toString():String
    {
        return '($x, $y)';
    }
}

/**
 * A 2D vector with integer values. Used primarily for indexing into 2D grids.
 */
@:forward(x, y)
abstract IntVector2(IntVector2Default) from IntVector2Default to IntVector2Default
{
    // The number of elements in this structure
    public static inline var elementCount:Int = 2;
    
    // Zero vector (v + 0 = v)
    public static var zero(get, never):IntVector2;
    
    // X axis (1, 0)
    public static var xAxis(get, never):IntVector2;
    
    // Y axis (0, 1)
    public static var yAxis(get, never):IntVector2;
    
    // Vector dotted with itself
    public var lengthSq(get, never):Int;
    
    // 90 degree rotation to the left
    public var rotatedLeft(get, never):IntVector2;
    
    // 90 degree rotation to the right
    public var rotatedRight(get, never):IntVector2;
        
    /**
     * Constructor.
     * 
     * @param x
     * @param y
     */
    public function new(x:Int, y:Int)
    {
        this = new IntVector2Default(x, y);
    }
    
    /**
     * Construct a IntVector2 from an array.
     * 
     * @param rawData   The input array.
     * @return          The constructed structure.
     */
    public static inline function fromArray(rawData:Array<Int>):IntVector2
    {
        if (rawData.length != IntVector2.elementCount)
        {
            throw "Invalid rawData.";
        }
        
        return new IntVector2(rawData[0], rawData[1]);
    }
    
    /**
     * Convert to a IntVector2.
     * 
     * @return  The equivalent IntVector2.
     */
    public inline function toVector2():Vector2 
    {
        var self:IntVector2 = this;
        return new Vector2(self.x, self.y);
    }
    
    /**
     * Dot product.
     * 
     * @param a
     * @param b
     * @return      sum_i (a_i * b_i)
     */
    @:op(A * B)
    public static inline function dot(a:IntVector2, b:IntVector2):Int
    {
        return
            a.x * b.x +
            a.y * b.y;
    }
    
    /**
     * Multiply a scalar with a vector.
     * 
     * @param a
     * @param s
     * @return      s * a
     */
    @:op(A * B)
    @:commutative
    public static inline function multiply(a:IntVector2, s:Int):IntVector2
    {
        return a.clone()
            .multiplyWith(s);
    }
    
    /**
     * Add two vectors.
     * 
     * @param a
     * @param b
     * @return      a + b
     */
    @:op(A + B)
    public static inline function add(a:IntVector2, b:IntVector2):IntVector2
    {
        return a.clone()
            .addWith(b);
    }
    
    /**
     * Subtract one vector from another.
     * 
     * @param a
     * @param b
     * @return      a - b
     */
    @:op(A - B)
    public static inline function subtract(a:IntVector2, b:IntVector2):IntVector2
    {
        return a.clone()
            .subtractWith(b);
    }
    
    /**
     * Create a negated copy of a vector.
     * 
     * @param a
     * @return      -a
     */
    @:op(-A)
    public static inline function negate(a:IntVector2):IntVector2
    {
        return new IntVector2(
            -a.x,
            -a.y);
    }
    
    /**
     * Test element-wise equality between two vectors.
     * False if one of the inputs is null and the other is not.
     * 
     * @param a
     * @param b
     * @return     a_i == b_i
     */
    @:op(A == B)
    public static inline function equals(a:IntVector2, b:IntVector2):Bool
    {
        return (a == null && b == null) ||
            a != null &&
            b != null &&
            a.x == b.x &&
            a.y == b.y;
    }
    
    /**
     * Returns a vector built from the componentwise max of the input vectors.
     * 
     * @param a
     * @param b
     * @return      max(a_i, b_i)
     */
    public static inline function max(a:IntVector2, b:IntVector2):IntVector2
    {
        return a.clone()
            .maxWith(b);
    }
    
    /**
     * Returns a vector built from the componentwise min of the input vectors.
     * 
     * @param a
     * @param b
     * @return      min(a_i, b_i)
     */
    public static inline function min(a:IntVector2, b:IntVector2):IntVector2
    {
        return a.clone()
            .minWith(b);
    }
    
    /**
     * Sets all the fields of this structure without allocation.
     * 
     * @param x
     * @param y
     * @return self
     */
    public inline function set(x:Int, y:Int):IntVector2
    {
        var self:IntVector2 = this;
        
        self.x = x;
        self.y = y;
        
        return self;
    }
    
    /**
     * Multiply a vector with a scalar in place.
     * Note: *= operator on Haxe abstracts does not behave this way (a new object is returned).
     * 
     * @param a
     * @return      self_i *= s
     */
    public inline function multiplyWith(s:Int):IntVector2
    {
        var self:IntVector2 = this;
        
        self.x *= s;
        self.y *= s;
        
        return self;
    }
    
    /**
     * Add a vector in place.
     * Note: += operator on Haxe abstracts does not behave this way (a new object is returned).
     * 
     * @param a
     * @return      self_i += a_i
     */
    public inline function addWith(a:IntVector2):IntVector2
    {
        var self:IntVector2 = this;
        
        self.x += a.x;
        self.y += a.y;
        
        return self;
    }
    
    /**
     * Subtract a vector in place.
     * Note: -= operator on Haxe abstracts does not behave this way (a new object is returned).
     * 
     * @param a
     * @return      self_i -= a_i
     */
    public inline function subtractWith(a:IntVector2):IntVector2
    {
        var self:IntVector2 = this;
        
        self.x -= a.x;
        self.y -= a.y;
        
        return self;
    }
    
    /**
     * Returns a vector built from the componentwise max of this vector and another.
     * 
     * @param a
     * @param b
     * @return      self_i = max(self_i, a_i)
     */
    public inline function maxWith(a:IntVector2):IntVector2
    {
        var self:IntVector2 = this;
        
        self.x = MathUtil.intMax(self.x, a.x);
        self.y = MathUtil.intMax(self.y, a.y);
        
        return self;
    }
    
    /**
     * Returns a vector built from the componentwise min of this vector and another.
     * 
     * @param a
     * @param b
     * @return      self_i = min(self_i, a_i)
     */
    public inline function minWith(a:IntVector2):IntVector2
    {
        var self:IntVector2 = this;
        
        self.x = MathUtil.intMin(self.x, a.x);
        self.y = MathUtil.intMin(self.y, a.y);
        
        return self;
    }
    
    /**
     * Copy the contents of this structure to another.
     * Faster than copyToShape for static platforms (C++, etc) but requires the target to have the exact same inner type.
     * 
     * @param target    The target structure.
     */
    public inline function copyTo(target:IntVector2):Void
    {
        var self:IntVector2 = this;
        
        for (i in 0...IntVector2.elementCount)
        {
            target[i] = self[i];
        }
    }
    
    /**
     * Clone.
     * 
     * @return  The cloned object.
     */
    public inline function clone():IntVector2
    {
        var self:IntVector2 = this;
        return new IntVector2(self.x, self.y);
    }

    /**
     * Get an element by position.
     * 
     * @param i         The element index.
     * @return          The element.
     */
    @:arrayAccess
    public inline function getArrayElement(i:Int):Int
    {
        var self:IntVector2 = this;
        switch (i)
        {
            case 0:
                return self.x;
            case 1:
                return self.y;
            default:
                throw "Invalid element";
        }
    }
    
    /**
     * Set an element by position.
     * 
     * @param i         The element index.
     * @param value     The new value.
     * @return          The updated element.
     */
    @:arrayAccess
    public inline function setArrayElement(i:Int, value:Int):Int
    {
        var self:IntVector2 = this;
        switch (i)
        {
            case 0:
                return self.x = value;
            case 1:
                return self.y = value;
            default:
                throw "Invalid element";
        }
    }
    
    /**
     * Negate vector in-place.
     * 
     * @return  The modified object.
     */
    public inline function applyNegate():IntVector2
    {
        var self:IntVector2 = this;
        
        self.x = -self.x;
        self.y = -self.y;
        
        return self;
    }
    
    /**
     * Apply a scalar function to each element.
     * 
     * @param func  The function to apply.
     * @return      The modified object.
     */
    public inline function applyScalarFunc(func:Int->Int):IntVector2
    {
        var self:IntVector2 = this;
        
        for (i in 0...elementCount)
        {
            self[i] = func(self[i]);
        }
        
        return self;
    }
    
    /**
     * Rotate this vector by 90 degrees to the left/counterclockwise.
     * 
     * @return  The modified object. (-y, x)
     */
    public inline function rotateLeft():IntVector2
    {
        var self:IntVector2 = this;
        
        var newX = -self.y;
        self.y = self.x;
        self.x = newX;
        
        return self;
    }
    
    /**
     * Rotate this vector by 90 degrees to the right/clockwise.
     * 
     * @return  The modified object. (y, -x)
     */
    public inline function rotateRight():IntVector2
    {
        var self:IntVector2 = this;
        
        var newX = self.y;
        self.y = -self.x;
        self.x = newX;
        
        return self;
    }
    
    private static inline function get_zero():IntVector2
    {
        return new IntVector2(0, 0);
    }
    
    private static inline function get_xAxis():IntVector2
    {
        return new IntVector2(1, 0);
    }
    
    private static inline function get_yAxis():IntVector2
    {
        return new IntVector2(0, 1);
    }
    
    private inline function get_lengthSq():Int
    {
        var self:IntVector2 = this;
        return
            self.x * self.x +
            self.y * self.y;
    }
    
    private inline function get_rotatedLeft():IntVector2
    {
        var self:IntVector2 = this;
        return self.clone()
            .rotateLeft();
    }
    
    private inline function get_rotatedRight():IntVector2
    {
        var self:IntVector2 = this;
        return self.clone()
            .rotateRight();
    }
}