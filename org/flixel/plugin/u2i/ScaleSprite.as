package org.flixel.plugin.u2i {

	import org.flixel.FlxG;
	import org.flixel.FlxSprite;

	public class ScaleSprite {
		static public var startScale:Boolean = false;
		static private var counter:Number = 0;

		public static function scale(sprite:FlxSprite, scaleXTo:Number, scaleStep:Number = 0.1, OnComplete:Function = null):void {

			if(!startScale) { return; }

			if(sprite.scale.x < scaleXTo) {
				counter += FlxG.elapsed;
				if(counter > 1/FlxG.framerate) {
					counter = 0;
					sprite.scale.x += scaleStep;
					sprite.scale.y += scaleStep;
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