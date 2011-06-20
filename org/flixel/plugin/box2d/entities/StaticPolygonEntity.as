package org.flixel.plugin.box2d.entities {

	import Box2D.Dynamics.b2Body;

	import com.u2i.games.frameworks.flixelbox2d.entities.base.PolygonEntity;

	public class StaticPolygonEntity extends PolygonEntity {

		public function StaticPolygonEntity(X:int, Y:int, Vertices:Array=null, SimpleGraphic:Class=null) {
			this._type = b2Body.b2_staticBody;
			super(X, Y, Vertices, SimpleGraphic);
		}
	}
}