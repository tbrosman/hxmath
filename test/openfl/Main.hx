package test.openfl;

import flash.display.Sprite;
import hxmath.math.Matrix2x2;
import hxmath.math.Matrix3x2;
import hxmath.math.Matrix3x3;
import hxmath.math.Matrix4x4;
import hxmath.math.Quaternion;
import hxmath.math.Vector2;
import hxmath.math.Vector3;
import hxmath.math.Vector4;

class Main extends Sprite
{
    public function new ()
    {
        super ();
        
        var v2 = Vector2.zero;
        var v3 = Vector3.zero;
        var v4 = Vector4.zero;
        
        var m22 = Matrix2x2.zero;
        var m32 = Matrix3x2.zero;
        var m33 = Matrix3x3.zero;
        var m44 = Matrix4x4.zero;
        
        var q = Quaternion.zero;
    }
}