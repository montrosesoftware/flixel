package org.flixel.plugin.box2d.entities.base {

	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;

	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.plugin.box2d.utils.FlxB2Point;

	public class PolygonEntity extends Entity {

		public var vertices:Array = [];

		public function PolygonEntity(X:int, Y:int, Vertices:Array=null, SimpleGraphic:Class=null) {

			super(X, Y, SimpleGraphic);
			this.vertices = Vertices;

			this.setDimentions();
		}

		protected function setDimentions():void {
			var xValues:Array = [];
			var yValues:Array = [];

			for each(var vp:FlxB2Point in this.vertices) {
				xValues.push(vp.x);
				yValues.push(vp.y);
			}

			xValues.sort();
			yValues.sort();

			var minX:Number = xValues[0];
			var maxX:Number = xValues[xValues.length-1];

			var minY:Number = yValues[0];
			var maxY:Number = yValues[xValues.length-1];

			this.width = maxX - minX;
			this.height = maxY - minY;
		}


		override protected function createB2Shape():void {
			this._shape = new b2PolygonShape();

			var b2Vertices:Array = [];
			for each(var point:FlxB2Point in this.vertices) {
				b2Vertices.push(point.toB2Vec());
			}
			(this._shape as b2PolygonShape).SetAsArray(b2Vertices, b2Vertices.length);
		}

	}
}