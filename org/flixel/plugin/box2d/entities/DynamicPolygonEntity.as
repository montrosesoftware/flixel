package org.flixel.plugin.box2d.entities {

	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;

	import org.flixel.FlxPoint;
	import org.flixel.plugin.box2d.entities.base.Entity;
	import org.flixel.plugin.box2d.entities.base.PolygonEntity;

	public class DynamicPolygonEntity extends PolygonEntity {

		public function DynamicPolygonEntity(X:int, Y:int, Vertices:Array=null, SimpleGraphic:Class=null) {
			this._type = b2Body.b2_dynamicBody;
			super(X, Y, Vertices, SimpleGraphic);
		}

		override public function update():void {
			this.x = (this._obj.GetPosition().x * GC.RATIO);
			this.y = (this._obj.GetPosition().y * GC.RATIO);
			this.angle = this._obj.GetAngle() * (180 / Math.PI);
			super.update();
		}
	}
}