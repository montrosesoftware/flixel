package org.flixel.plugin.u2i
{
	import com.u2i.interfaces.IGame;

	import flash.events.Event;

	import org.flixel.FlxG;
	import org.flixel.FlxGame;

	public class FlixelGame extends FlxGame implements IGame
	{
		public function FlixelGame(GameSizeX:uint, GameSizeY:uint, InitialState:Class, Zoom:Number=1, GameFramerate:uint=60, FlashFramerate:uint=30, UseSystemCursor:Boolean=false)
		{
			super(GameSizeX, GameSizeY, InitialState, Zoom, GameFramerate, FlashFramerate, UseSystemCursor);
		}

		public function restartGame():void { FlxG.resetGame(); }

		public function muteGame():void {
			FlxG.mute = true;
		}

		public function unmuteGame():void {
			FlxG.mute = false;
		}

		public function pauseGame():void {
			FlxG.paused = true;
			FlxG.pauseSounds();
		}

		public function unpauseGame():void {
			FlxG.paused = false;
			FlxG.resumeSounds();
		}

		public function destroyGame():void {
			FlxG.pauseSounds();
			this.destroyGame();
		}

		override protected function onFocus(FlashEvent:Event=null):void	{ return; }
		override protected function onFocusLost(FlashEvent:Event=null):void { return; }
	}
}