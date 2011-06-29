package org.flixel.plugin.box2d.states {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;

	import flash.display.BitmapData;
	import flash.display.Sprite;

	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.plugin.u2i.FlixelState;

	public class State extends FlixelState
	{
		//Mouse
		protected var mouseJoints:Array = new Array();
		protected var mousePVec:b2Vec2 = new b2Vec2();

		protected var _debugMode:Boolean;
		protected var _flixelDebugSprite:FlxSprite = new FlxSprite();;
		protected var _debugSprite:Sprite = new Sprite();

		public var world:b2World;

		public function State(debugMode:Boolean = false):void
		{
			super();

			// initialize Box2D world
			this.world = new b2World(new b2Vec2(0, 9.8), true);

			// sets the debug mode
			this._debugMode = debugMode;
			if(this._debugMode) {
				this.add(this._flixelDebugSprite);
				var dbgDraw:b2DebugDraw = new b2DebugDraw();
				dbgDraw.SetSprite(this._debugSprite);
				dbgDraw.SetDrawScale(GC.RATIO);
				dbgDraw.SetAlpha(0.5);
				dbgDraw.SetFillAlpha(0.2);
				dbgDraw.SetLineThickness(1);
				dbgDraw.SetFlags(b2DebugDraw.e_shapeBit|b2DebugDraw.e_jointBit);
				this.world.SetDebugDraw(dbgDraw);
			}
		}

		override public function update():void
		{
			this.world.Step(FlxG.elapsed, 10, 10);
			this.world.ClearForces();
			if(this._debugMode) {
				this.world.DrawDebugData();
				var bitmap:BitmapData = new BitmapData(FlxG.width, FlxG.height, true, 0xFF0000);
				bitmap.draw(this._debugSprite);
				this._flixelDebugSprite.pixels = bitmap;
			}
			super.update();
		}
	}
}