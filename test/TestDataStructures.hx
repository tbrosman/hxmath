package test;
import hxmath.ds.DenseArray2;
import hxmath.ds.IArray2;
import hxmath.ds.SparseArray2;

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
        
        dense.resize(4, 2);
        
        assertEquals(4, dense.width);
        assertEquals(2, dense.height);
        
        assertEquals(3, dense.get(0, 0));
        assertEquals(5, dense.get(1, 0));
        assertEquals(7, dense.get(0, 1));
        assertEquals(11, dense.get(1, 1));
        
        dense.resize(2, 3);
        
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
       
        var packedKeysIterable:Dynamic = { iterator: function():Iterator<Int> { return sparse.packedKeys; } };
        
        var sparseSum2 = Lambda.fold(
            packedKeysIterable,
            function(a:Int, b:Int) return sparse.get(SparseArray2.unpackX(a), SparseArray2.unpackY(a)) + b,
            0);
        
        assertEquals(sparseSum1, sparseSum2);
    }
    
    private function setPrimesSquare(array:IArray2<Int>)
    {
        array.set(0, 0, 3);
        array.set(1, 0, 5);
        array.set(0, 1, 7);
        array.set(1, 1, 11);
    }
}