package org.flixel.plugin.box2d.entities {
	import Box2D.Dynamics.b2Body;

	import org.flixel.plugin.box2d.entities.base.CircleEntity;

	public class DynamicCircleEntity extends CircleEntity
	{
		public function DynamicCircleEntity(X:Number=0, Y:Number=0, Radius:Number=10, SimpleGraphic:Class=null)
		{
			this._type = b2Body.b2_dynamicBody;
			super(X, Y, Radius, SimpleGraphic);
		}

		override public function update():void {
			this.x = (this._obj.GetPosition().x * GC.RATIO) - this.width / 2;
			this.y = (this._obj.GetPosition().y * GC.RATIO) - this.height / 2;
			this.angle = this._obj.GetAngle() * (180 / Math.PI);

			super.update();
		}
	}
}