package org.flixel.plugin.box2d.entities {

	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;

	import org.flixel.plugin.box2d.entities.base.Entity;
	import org.flixel.plugin.box2d.entities.base.PolygonEntity;

	public class StaticPolygonEntity extends PolygonEntity {

		public function StaticPolygonEntity(X:int, Y:int, Vertices:Array=null, SimpleGraphic:Class=null) {
			this._type = b2Body.b2_staticBody;
			super(X, Y, Vertices, SimpleGraphic);
		}

		override public function createBody():Entity {
			super.createBody();

			this._obj.SetPosition(new b2Vec2(this.x / GC.RATIO, this.y / GC.RATIO));

			return this;
		}
	}
}