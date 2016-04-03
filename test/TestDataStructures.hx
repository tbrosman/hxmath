package test;
import hxmath.ds.DenseArray2;
import hxmath.ds.IArray2;
import hxmath.ds.SparseArray2;
import hxmath.math.ShortVector2;
import hxmath.math.IntVector2;

/**
 * ...
 * @author TABIV
 */
class TestDataStructures extends MathTestCase
{
    public function new() 
    {
        super();
    }
    
    public function testArray2InterfaceCast()
    {
        var dense:IArray2<Dynamic> = new DenseArray2<Dynamic>(100, 100);
        var sparse:IArray2<Dynamic> = new SparseArray2<Dynamic>();
    }
    
    public function testDenseArray2Resize()
    {
        var dense = new DenseArray2<Int>(2, 2);
        setPrimesSquare(dense);
        
        var defaultValue:Int = -1;
        dense.resize(4, 2, defaultValue);
        
        assertEquals(4, dense.width);
        assertEquals(2, dense.height);
        
        assertEquals(3, dense.get(0, 0));
        assertEquals(5, dense.get(1, 0));
        assertEquals(7, dense.get(0, 1));
        assertEquals(11, dense.get(1, 1));
        
        // The value at the border should match the default provided to resize
        assertEquals(defaultValue, dense.get(3, 1));
        
        dense.resize(2, 3, defaultValue);
        
        assertEquals(2, dense.width);
        assertEquals(3, dense.height);
        
        assertEquals(3, dense.get(0, 0));
        assertEquals(5, dense.get(1, 0));
    }
    
    public function testArray2Iterate()
    {
        var sparse = new SparseArray2<Int>();
        setPrimesSquare(sparse);
        var dense = sparse.toDenseArray();
        
        assertEquals(2, dense.width);
        assertEquals(2, dense.height);
        
        var sparseSum = Lambda.fold(sparse, function(a, b) return a + b, 0);
        var denseSum = Lambda.fold(dense, function(a, b) return a + b, 0);
        
        assertEquals(sparseSum, denseSum);
    }
    
    public function testSparseArray2KeysIterate()
    {
        var sparse = new SparseArray2<Int>();
        setPrimesSquare(sparse);
        
        var sparseSum1 = Lambda.fold(
            sparse,
            function(a, b) return a + b,
            0);
       
        var packedKeysIterable:Dynamic = { iterator: function():Iterator<Int> { return sparse.keys; } };
        
        var sparseSum2 = Lambda.fold(
            packedKeysIterable,
            function(a:Int, b:Int) return sparse.get(cast(a, ShortVector2).x, cast(a, ShortVector2).y) + b,
            0);
        
        assertEquals(sparseSum1, sparseSum2);
    }
    
    public function testSparseArray2OrderedKeysIterate()
    {
        // Create and fill a (relatively) large array
        var sparse = new SparseArray2<Int>();
        for (y in 0...100)
        {
            for (x in 0...100)
            {
                sparse.set(x, y, -1);
            }
        }
        
        var lastX:Int = -1;
        var lastY:Int = -1;
        
        // Keys should be monotonically increasing
        for (key in sparse.orderedKeys)
        {
            assertTrue(key.x > lastX || key.y > lastY);
            lastX = key.x;
            lastY = key.y;
        }
    }
    
    public function testBlit()
    {
        var sourceWidth = 3;
        var sourceHeight = 3;
        var source = new DenseArray2<Int>(sourceWidth, sourceHeight);
        source.fill(1);
        
        // Target:
        //
        // A * * * B
        // * * * * *
        // * * * * *
        // * * * * *
        // C * * * D
        //
        
        var centerOverlap = 9;
        var cornerOverlap = 4;
        var edgeOverlap = 6;
        
        var blitCases:Map<String, Dynamic> = [
            "Center" => { pos: new IntVector2(1, 1), overlap: centerOverlap },
            "A" => { pos: new IntVector2(-1, -1), overlap: cornerOverlap },
            "B" => { pos: new IntVector2(3, -1), overlap: cornerOverlap },
            "C" => { pos: new IntVector2(-1, 3), overlap: cornerOverlap },
            "D" => { pos: new IntVector2(3, 3), overlap: cornerOverlap },
            "AB" => { pos: new IntVector2(1, -1), overlap: edgeOverlap },
            "BD" => { pos: new IntVector2(3, 1), overlap: edgeOverlap },
            "AC" => { pos: new IntVector2(-1, 1), overlap: edgeOverlap },
            "CD" => { pos: new IntVector2(1, 3), overlap: edgeOverlap }
        ];
        
        for (key in blitCases.keys())
        {
            var blitCase = blitCases[key];
            
            var target = new DenseArray2<Int>(5, 5);
            target.fill(0);
            target.clippedBlit(blitCase.pos.x, blitCase.pos.y, source, 0, 0, sourceWidth, sourceHeight);
            
            var actualOverlap = sum(target);
            
            if (actualOverlap != blitCase.overlap)
            {
                trace('Broken on case $key: expected overlap = ${blitCase.overlap}, actual overlap = $actualOverlap');
                assertFalse(true);
            }
        }
    }
    
    public function testSparseArray2IndexBounds()
    {
        var min:ShortVector2 = new ShortVector2(0, 0);
        assertEquals(0, min.x);
        assertEquals(0, min.y);
        
        var max:ShortVector2 = new ShortVector2(ShortVector2.fieldMax, ShortVector2.fieldMax);
        assertEquals(ShortVector2.fieldMax, max.x);
        assertEquals(ShortVector2.fieldMax, max.y);
    }
    
    public function testDenseArray2FromNestedRectangularArray()
    {
        var rectangularArray = [
            [0, 1, 2],
            [3, 4, 5]
        ];
        
        var result = DenseArray2.fromNestedArray(rectangularArray);
        assertEquals(3, result.width);
        assertEquals(2, result.height);
        assertEquals(5, result.get(2, 1));
    }
    
    public function testGetByKey()
    {
        var denseArray = new DenseArray2<Int>(3, 3);
        denseArray.set(1, 2, 3);
        assertEquals(3, denseArray.getByKey(new ShortVector2(1, 2)));
        
        var sparseArray = new SparseArray2<Int>();
        sparseArray.set(1, 2, 3);
        assertEquals(3, sparseArray.getByKey(new ShortVector2(1, 2)));
    }
    
    public function testDenseKeysIterator()
    {
        var initialArray = [
            [0, 1, 2],
            [3, 4, 5]
        ];
        
        var denseArray = DenseArray2.fromNestedArray(initialArray, -1);
        
        for (key in denseArray.keys)
        {
            var sourceElement = initialArray[key.y][key.x];
            var targetElement = denseArray.getByKey(key);
            assertEquals(sourceElement, targetElement);
        }
    }
    
    /**
     * The following relationships should hold:
     *
     * DenseArray2  A ---to---> SparseArray2 B =>
     *      (for all (x, y) in A.keys) AND
     *      (for all (x, y) in B.keys))
     *          . A[x,y] == B[x,y]
     * That is, the domain (source) and the codomain (target) have the same elements
     * 
     * SparseArray2 C ---to---> DenseArray2  D =>
     *      for all (x, y) in C.keys
     *          . C[x,y] == D[x,y]
     * That is, the domain (source) is a subset of the codomain (target)
     */
    public function testCloneAndConvert()
    {
        var initialArray = [
            [0, 1, 2],
            [3, 4, 5]
        ];
        
        // Build a rectangular array and create a sparse copy
        var denseA = DenseArray2.fromNestedArray(initialArray);
        var sparseB = denseA.toSparseArray();
        
        // If A is an improper subset of B and B is an improper subset of A, A == B
        
        // Dense -> Sparse: Domain is a (potentially improper) subset of codomain
        for (key in denseA.keys)
        {
            assertEquals(denseA.getByKey(key), sparseB.getByKey(key));
        }
        
        // Dense -> Sparse: Codomain is a (potentially improper) subset of domain
        for (key in sparseB.keys)
        {
            assertEquals(sparseB.getByKey(key), denseA.getByKey(key));
        }
        
        // Build a non-rectangular sparse array
        // A simple example showing that the Sparse -> Dense mapping can result in a codomain being a superset of the domain:
        // - In the sparse (source) array: 3 elements
        // - In the dense (target) array:  4 elements
        var sparseC = new SparseArray2<Int>();
        sparseC.set(0, 0, 2);
        sparseC.set(1, 0, 5);
        sparseC.set(1, 1, 3);
        
        var denseD = sparseC.toDenseArray();
        
        // Sparse -> Dense: Domain is a (potentially improper) subset of codomain
        for (key in sparseC.keys)
        {
            assertEquals(sparseC.getByKey(key), denseD.getByKey(key));
        }
    }
    
    private function setPrimesSquare(array:IArray2<Int>)
    {
        array.set(0, 0, 3);
        array.set(1, 0, 5);
        array.set(0, 1, 7);
        array.set(1, 1, 11);
    }
    
    private function sum(array:IArray2<Int>)
    {
        var sum:Int = 0;
        for (value in array)
        {
            sum += value;
        }
        
        return sum;
    }
}