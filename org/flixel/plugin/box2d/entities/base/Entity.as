package org.flixel.plugin.box2d.entities.base {

	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;

	import org.flixel.FlxG;
	import org.flixel.FlxSprite;

	import com.u2i.games.frameworks.flixelbox2d.materials.BaseMaterial;
	import com.u2i.games.frameworks.flixelbox2d.states.State;

	public class Entity extends FlxSprite
	{
		protected var _shape:b2Shape;
		protected var _fixDef:b2FixtureDef;
		protected var _bodyDef:b2BodyDef
		protected var _obj:b2Body;
		protected var _type:uint;
		protected var _world:b2World;
		protected var _userData:Object = new Object;
		protected var _material:BaseMaterial = new BaseMaterial();

		public function Entity(X:Number=0, Y:Number=0, SimpleGraphic:Class=null)
		{
			super(X, Y, SimpleGraphic);
			this._world = (FlxG.state as State).world;
		}

		public function createBody():Entity {
			this.createB2Shape();
			this.createB2FixtureDefinition();
			this.createB2BodyDefinition();
			this.createB2Body();

			return this;
		}

		protected function createB2Shape():void {
			// please override in the descendant
		}

		protected function createB2FixtureDefinition():void {
			this._fixDef = new b2FixtureDef();
			this._fixDef.density = this._material.density;
			this._fixDef.restitution = this._material.restitution;
			this._fixDef.friction = this._material.friction;
			this._fixDef.shape = this._shape;
		}

		protected function createB2BodyDefinition():void {
			this._bodyDef = new b2BodyDef();
			this._bodyDef.position.Set((this.x + (this.width/2)) / GC.RATIO, (this.y + (this.height/2)) / GC.RATIO);
			this._bodyDef.angle = this.angle * (Math.PI / 180);
			this._bodyDef.type = this._type;
			this._bodyDef.userData = this._userData;
			this._bodyDef.userData.contactPoints = 0;
		}

		protected function createB2Body():void {
			this._obj = this._world.CreateBody(this._bodyDef);
			this._obj.CreateFixture(this._fixDef);
		}

		override public function update():void {
			if(this.x + this.width > FlxG.width ||
				this.x + this.width < 0 ||
				this.y + this.height < 0 ||
				this.y + this.height > FlxG.height) {
				trace('removed an object from the game');
			}
			super.update();
		}

		override public function kill():void {
			super.kill();
			this._world.DestroyBody(this._obj);
			this._obj = null;
		}

		public function get obj():b2Body {
			return this._obj
		}

		public function set userData(data:Object):void { this._userData = data;	}
		public function set material(material:BaseMaterial):void { this._material = material; }
	}
}