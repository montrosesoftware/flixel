package org.flixel.plugin.box2d.utils {

	import Box2D.Common.Math.b2Vec2;

	import org.flixel.FlxPoint;

	public class FlxB2Point extends FlxPoint {

		public function FlxB2Point(X:Number=0, Y:Number=0) {
			super(X, Y);
		}

		public function toB2Vec():b2Vec2 {
			return new b2Vec2(this.x / GC.RATIO, this.y / GC.RATIO);
		}
	}
}