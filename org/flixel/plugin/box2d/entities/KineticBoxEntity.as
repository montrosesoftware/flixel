package org.flixel.plugin.box2d.entities {
	import Box2D.Dynamics.b2Body;

	import org.flixel.plugin.box2d.entities.base.BoxEntity;

	public class KineticBoxEntity extends BoxEntity
	{
		public function KineticBoxEntity(X:int, Y:int, Width:uint, Height:uint, SimpleGraphic:Class=null)
		{
			this._type = b2Body.b2_kinematicBody;
			super(X, Y, Width, Height, SimpleGraphic);
		}

		override public function update():void {
			this.x = (this._obj.GetPosition().x * GC.RATIO) - this.width / 2;
			this.y = (this._obj.GetPosition().y * GC.RATIO) - this.height / 2;
			this.angle = this._obj.GetAngle() * (180 / Math.PI);

			super.update();
		}
	}
}