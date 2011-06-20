package org.flixel.plugin.box2d.entities {
	import Box2D.Dynamics.b2Body;
	import com.u2i.games.frameworks.flixelbox2d.entities.base.BoxEntity;

	public class StaticBoxEntity extends BoxEntity
	{
		public function StaticBoxEntity(X:int, Y:int, Width:uint, Height:uint, SimpleGraphic:Class=null)
		{
			this._type = b2Body.b2_staticBody;
			super(X, Y, Width, Height, SimpleGraphic);
		}
	}
}