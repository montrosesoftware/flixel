package org.flixel.plugin.u2i
{
	import com.u2i.events.GameEvent;
	
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	
	public class FlixelState extends FlxState
	{
		public function FlixelState()
		{
			FlxG.framerate = 60;
			FlxG.flashFramerate = 60;
			super();
		}
		
		override public function create():void {
			FlxG.stage.dispatchEvent(new GameEvent(GameEvent.GAME_START));
			super.create();
		}
	}
}