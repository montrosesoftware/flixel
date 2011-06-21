package org.flixel.plugin.box2d.entities {
	import Box2D.Dynamics.b2Body;

	import org.flixel.plugin.box2d.entities.base.CircleEntity;

	public class StaticCircleEntity extends CircleEntity
	{
		public function StaticCircleEntity(X:Number=0, Y:Number=0, Radius:Number=10, SimpleGraphic:Class=null)
		{
			this._type = b2Body.b2_staticBody;
			super(X, Y, Radius, SimpleGraphic);
		}
	}
}