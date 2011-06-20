package org.flixel.plugin.box2d.entities.base {

	import Box2D.Collision.Shapes.b2CircleShape;

	import org.flixel.FlxG;
	import org.flixel.FlxSprite;

	public class CircleEntity extends Entity
	{
		protected var radius:Number;

		public function CircleEntity(X:Number=0, Y:Number=0, Radius:Number=10, SimpleGraphic:Class=null)
		{
			super(X, Y, SimpleGraphic);

			this.radius = Radius;
			this.width = this.height = this.radius * 2;
		}

		override protected function createB2Shape():void {
			this._shape = new b2CircleShape(this.radius / GC.RATIO);
		}
	}
}