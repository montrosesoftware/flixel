package org.flixel.plugin.u2i {

	import org.flixel.FlxG;
	import org.flixel.FlxSprite;

	public class ScaleSprite {
		static public var startScale:Boolean = false;
		static private var counter:Number = 0;

		public static function scale(sprite:FlxSprite, scaleTo:Number, scaleStep:Number = 0.1, OnComplete:Function = null):void {

			if(!startScale) { return; }

			if(sprite.scale.x < scaleTo) {
				counter += FlxG.elapsed;
				if(counter > 1/FlxG.framerate) {
					counter = 0;
					sprite.scale.x += scaleStep;
					sprite.scale.y = sprite.scale.x;
				}
			} else {
				if(OnComplete != null){
					startScale = false;
					OnComplete();

				}
			}
		}
	}
}