package org.flixel.plugin.box2d.entities.base {
	import Box2D.Collision.Shapes.b2PolygonShape;

	import org.flixel.FlxG;
	import org.flixel.FlxSprite;

	public class BoxEntity extends Entity
	{
		public function BoxEntity(X:int, Y:int, Width:uint, Height:uint, SimpleGraphic:Class=null)
		{
			super(X, Y, SimpleGraphic);

			this.width = Width;
			this.height = Height;
		}

		override protected function createB2Shape():void {
			this._shape = new b2PolygonShape();
			(this._shape as b2PolygonShape).SetAsBox((this.width/2) / GC.RATIO, (this.height/2) / GC.RATIO);
		}

	}
}