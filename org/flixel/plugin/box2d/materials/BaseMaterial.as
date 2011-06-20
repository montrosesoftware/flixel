package org.flixel.plugin.box2d.materials {
	public class BaseMaterial
	{
		public var density:Number;
		public var friction:Number;
		public var restitution:Number;

		public function BaseMaterial(Density:Number = 0.9, Friction:Number = 0.5, Restitution:Number = 0.3)
		{
			this.density = Density;
			this.friction = Friction;
			this.restitution = Restitution;
		}
	}
}