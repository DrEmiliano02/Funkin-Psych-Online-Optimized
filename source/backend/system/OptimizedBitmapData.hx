package backend.system;

import flixel.FlxG;
import openfl.display.BitmapData;

@:access(openfl.display.BitmapData)
class OptimizedBitmapData
{
    public static var enabled:Bool = true;

    public static var releaseCPUCopy:Bool = false;

    public static function optimize(bitmap:BitmapData, ?allowGPU:Bool = true):Void
    {
        #if (cpp && !mobile)
        if (!enabled || !allowGPU || bitmap == null || !bitmap.readable)
            return;

        if (FlxG.stage == null || FlxG.stage.context3D == null)
            return;

        try
        {
            var texture = bitmap.getTexture(FlxG.stage.context3D);
            if (texture == null) return;

            if (releaseCPUCopy)
            {
                bitmap.disposeImage();
                bitmap.__surface = null;
                bitmap.image = null;
            }
        }
        catch (e:Dynamic)
        {
            #if debug
            trace('OptimizedBitmapData.optimize(): ' + Std.string(e));
            #end
        }
        #end
    }
}
