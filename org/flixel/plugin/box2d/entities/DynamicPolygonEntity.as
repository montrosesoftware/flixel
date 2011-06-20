package org.flixel.plugin.box2d.entities {

	import Box2D.Dynamics.b2Body;

	import com.u2i.games.frameworks.flixelbox2d.entities.base.PolygonEntity;

	public class DynamicPolygonEntity extends PolygonEntity {

		public function DynamicPolygonEntity(X:int, Y:int, Vertices:Array=null, SimpleGraphic:Class=null) {
			this._type = b2Body.b2_dynamicBody;
			super(X, Y, Vertices, SimpleGraphic);
		}

		override public function update():void {
			this.x = (this._obj.GetPosition().x * GC.RATIO) - this.width / 2;
			this.y = (this._obj.GetPosition().y * GC.RATIO) - this.height / 2;
			this.angle = this._obj.GetAngle() * (180 / Math.PI);

			super.update();
		}
	}
}