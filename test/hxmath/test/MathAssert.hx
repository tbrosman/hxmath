package hxmath.test;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.MacroStringTools;
import haxe.macro.Printer;
import utest.utils.TestBuilder;

class MathAssert
{
    /**
     * As `Assert.isTrue()`, but prints more information when a binary operation
     * fails. For instance, if `a < b` fails, it will print both `a` and `b`.
     */
    @:access(utest.utils.TestBuilder)
    public static macro function isTrue(expr:ExprOf<Bool>, ?msg:ExprOf<String>):ExprOf<Bool>
    {
        var result = TestBuilder.prepareSpec(macro $b{[expr]});
        var printer = new Printer();
        
        if (printer.printExpr(expr) == printer.printExpr(result))
        {
            //If `prepareSpec()` didn't call an `Assert` function, fall back to
            //`Assert.isTrue()`.
            return macro utest.Assert.isTrue($expr, $msg);
        }
        else
        {
            //If `prepareSpec()` made changes, it will have included an
            //appropriate message.
            switch (msg.expr)
            {
                case null, EConst(CIdent("null")):
                    //Ok.
                default:
                    Context.warning("Custom message will be ignored.", msg.pos);
            }
            
            return result;
        }
    }
    
    /**
     * As `Assert.floatEquals()`, except tested element-wise. This can accept
     * any structure that defines `elementCount` and allows array access, such
     * as the structures in the `hxmath.math` package.
     */
    public static macro function floatEquals(a:Expr, b:Expr, ?approx:ExprOf<Float>, ?msg:ExprOf<String>):ExprOf<Bool>
    {
        switch (approx.expr)
        {
            case null, EConst(CIdent("null")):
                approx = macro 1e-5;
            default:
        }
        
        switch (msg.expr)
        {
            case null, EConst(CIdent("null")):
                msg = macro 'expected $__a but it is $__b';
            default:
        }
        
        var type = Context.follow(Context.typeof(a));
        if (!Context.unify(Context.typeof(b), type))
        {
            return Context.error('Inputs must be the same type; got $type and ${Context.typeof(b)}.', Context.currentPos());
        }
        var elementCount:Expr;
        switch (type)
        {
            case TAbstract(_.get() => tAbstract, _) if (tAbstract.array != null && tAbstract.array.length > 0):
                elementCount = MacroStringTools.toFieldExpr(tAbstract.pack.concat([tAbstract.name, "elementCount"]), Context.currentPos());
            default:
                return Context.error('$type does not allow array access.', Context.currentPos());
        }
        
        return macro @:pos(Context.currentPos()) {
            var __a = $a;
            var __b = $b;
            var __result = true;
            for (i in 0...$elementCount)
            {
                if (Math.abs(__a[i] - __b[i]) > $approx)
                {
                    __result = false;
                    break;
                }
            }
            
            utest.Assert.isTrue(__result, $msg);
        };
    }
}
