package online.objects;

import flixel.FlxBasic;
import flixel.math.FlxMath;

class LoadingSprite extends FlxTypedGroup<FlxBasic> {
    var loadBar:FlxSprite;
    var tasksLength:Float = 0;

	public function new(?tasksLength:Float, ?camera:FlxCamera) {
        super();
        
        // A blank backdrop replaces the old per-loading-screen full-size bitmap copy.
        add(new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK));

        // Do not resize Paths' shared BitmapData/Image: it is used elsewhere.
        // Draw the cached texture at the intended size with the sprite scale.
        var cachedFunkay = Paths.image('funkay', null, false);
        if (cachedFunkay != null)
        {
            var funkay = new FlxSprite().loadGraphic(cachedFunkay);
            funkay.setGraphicSize(0, FlxG.height);
            funkay.updateHitbox();
            funkay.screenCenter();
            funkay.antialiasing = ClientPrefs.data.antialiasing;
            add(funkay);
        }

		loadBar = new FlxSprite(0, FlxG.height - 20).makeGraphic(FlxG.width, 10, 0xFFff16d2);
		loadBar.scale.x = 0;
		loadBar.visible = false;
		loadBar.screenCenter(X);
        add(loadBar);

		if (camera != null)
			cameras = [camera];

        this.tasksLength = (tasksLength != null && tasksLength > 0) ? tasksLength : 1;
    }

    // Called by the original FlxAsyncLoop after each completed task.
    public function addProgress(remaining:Float):Void
    {
        setProgress(1 - (remaining / tasksLength));
    }

    // remainingTasks is the number of tasks left AFTER the precache-list task.
    public function addAssetProgress(remainingTasks:Float, loaded:Int, total:Int):Void
    {
        if (total <= 0) return;
        var taskProgress = 1 - (remainingTasks / tasksLength);
        setProgress(taskProgress + (loaded / total) / tasksLength);
    }

    function setProgress(progress:Float):Void
    {
        // Monotonic progress and no NaN when the loading task list is empty.
        loadBar.scale.x = Math.max(loadBar.scale.x, FlxMath.bound(progress, 0, 1));
        loadBar.visible = true;
    }
}