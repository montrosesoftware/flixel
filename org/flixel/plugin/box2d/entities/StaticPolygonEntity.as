package org.flixel.plugin.box2d.entities {

	import Box2D.Dynamics.b2Body;

	import org.flixel.plugin.box2d.entities.base.PolygonEntity;

	public class StaticPolygonEntity extends PolygonEntity {

		public function StaticPolygonEntity(X:int, Y:int, Vertices:Array=null, SimpleGraphic:Class=null) {
			this._type = b2Body.b2_staticBody;
			super(X, Y, Vertices, SimpleGraphic);
		}
	}
}