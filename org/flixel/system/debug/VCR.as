package org.flixel.system.debug
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	import org.flixel.system.FlxReplay;
	import org.flixel.system.replay.FrameRecord;
	import org.flixel.system.replay.MouseRecord;
	
	public class VCR extends Sprite
	{
		[Embed(source="../../data/vcr/open.png")] protected var ImgOpen:Class;
		[Embed(source="../../data/vcr/record_off.png")] protected var ImgRecordOff:Class;
		[Embed(source="../../data/vcr/record_on.png")] protected var ImgRecordOn:Class;
		[Embed(source="../../data/vcr/stop.png")] protected var ImgStop:Class;
		[Embed(source="../../data/vcr/flixel.png")] protected var ImgFlixel:Class;
		[Embed(source="../../data/vcr/restart.png")] protected var ImgRestart:Class;
		[Embed(source="../../data/vcr/pause.png")] protected var ImgPause:Class;
		[Embed(source="../../data/vcr/play.png")] protected var ImgPlay:Class;
		[Embed(source="../../data/vcr/step.png")] protected var ImgStep:Class;
		
		static protected const FILE_TYPES:Array = [new FileFilter("Flixel Game Recording", "*.fgr")];
		static protected const DEFAULT_FILE_NAME:String = "replay.fgr";
		
		public var paused:Boolean;
		public var stepRequested:Boolean;
		
		protected var _open:Bitmap;
		protected var _recordOff:Bitmap;
		protected var _recordOn:Bitmap;
		protected var _stop:Bitmap;
		protected var _flixel:Bitmap;
		protected var _restart:Bitmap;
		protected var _pause:Bitmap;
		protected var _play:Bitmap;
		protected var _step:Bitmap;
		
		protected var _overOpen:Boolean;
		protected var _overRecord:Boolean;
		protected var _overRestart:Boolean;
		protected var _overPause:Boolean;
		protected var _overStep:Boolean;
		
		protected var _pressingOpen:Boolean;
		protected var _pressingRecord:Boolean;
		protected var _pressingRestart:Boolean;
		protected var _pressingPause:Boolean;
		protected var _pressingStep:Boolean;
		
		protected var _file:FileReference;
		
		protected var _runtimeDisplay:TextField;
		protected var _runtime:uint;
		
		public function VCR()
		{
			super();
			
			var spacing:uint = 7;
			
			_open = new ImgOpen();
			addChild(_open);
			
			_recordOff = new ImgRecordOff();
			_recordOff.x = _open.x + _open.width + spacing;
			addChild(_recordOff);
			
			_recordOn = new ImgRecordOn();
			_recordOn.x = _recordOff.x;
			_recordOn.visible = false;
			addChild(_recordOn);
			
			_stop = new ImgStop();
			_stop.x = _recordOff.x;
			_stop.visible = false;
			addChild(_stop);
			
			_flixel = new ImgFlixel();
			_flixel.x = _recordOff.x + _recordOff.width + spacing;
			addChild(_flixel);
			
			_restart = new ImgRestart();
			_restart.x = _flixel.x + _flixel.width + spacing;
			addChild(_restart);
			
			_pause = new ImgPause();
			_pause.x = _restart.x + _restart.width + spacing;
			addChild(_pause);
			
			_play = new ImgPlay();
			_play.x = _pause.x;
			_play.visible = false;
			addChild(_play);
			
			_step = new ImgStep();
			_step.x = _pause.x + _pause.width + spacing;
			addChild(_step);
			
			_runtimeDisplay = new TextField();
			_runtimeDisplay.width = width;
			_runtimeDisplay.x = width;
			_runtimeDisplay.y = -2;
			_runtimeDisplay.multiline = false;
			_runtimeDisplay.wordWrap = false;
			_runtimeDisplay.selectable = false;
			_runtimeDisplay.defaultTextFormat = new TextFormat("Courier",12,0xffffff,null,null,null,null,null,"center");
			_runtimeDisplay.visible = false;
			addChild(_runtimeDisplay);
			_runtime = 0;
			
			stepRequested = false;
			_file = null;

			unpress();
			checkOver();
			updateGUI();
			
			addEventListener(Event.ENTER_FRAME,init);
		}
		
		public function destroy():void
		{
			_file = null;
			
			removeChild(_open);
			_open = null;
			removeChild(_recordOff);
			_recordOff = null;
			removeChild(_recordOn);
			_recordOn = null;
			removeChild(_stop);
			_stop = null;
			removeChild(_flixel);
			_flixel = null;
			removeChild(_restart);
			_restart = null;
			removeChild(_pause);
			_pause = null;
			removeChild(_play);
			_play = null;
			removeChild(_step);
			_step = null;
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		public function recording():void
		{
			_stop.visible = false;
			_recordOff.visible = false;
			_recordOn.visible = true;
		}
		
		public function stopped():void
		{
			_stop.visible = false;
			_recordOn.visible = false;
			_recordOff.visible = true;
		}
		
		public function playing():void
		{
			_recordOff.visible = false;
			_recordOn.visible = false;
			_stop.visible = true;
		}
		
		public function updateRuntime(Time:uint):void
		{
			_runtime += Time;
			_runtimeDisplay.text = FlxU.formatTime(_runtime/1000,true);
			if(!_runtimeDisplay.visible)
				_runtimeDisplay.visible = true;
		}
		
		//***ACTUAL BUTTON BEHAVIORS***//
		
		public function onOpen():void
		{
			_file = new FileReference();
			_file.addEventListener(Event.SELECT, onOpenSelect);
			_file.addEventListener(Event.CANCEL, onOpenCancel);
			_file.browse(FILE_TYPES);
		}
		
		protected function onOpenSelect(E:Event=null):void
		{
			_file.removeEventListener(Event.SELECT, onOpenSelect);
			_file.removeEventListener(Event.CANCEL, onOpenCancel);
			
			_file.addEventListener(Event.COMPLETE, onOpenComplete);
			_file.addEventListener(IOErrorEvent.IO_ERROR, onOpenError);
			_file.load();
		}
		
		protected function onOpenComplete(E:Event=null):void
		{
			_file.removeEventListener(Event.COMPLETE, onOpenComplete);
			_file.removeEventListener(IOErrorEvent.IO_ERROR, onOpenError);
			
			//Turn the file into a giant string
			var fileContents:String = null;
			var data:ByteArray = _file.data;
			if(data != null)
				fileContents = data.readUTFBytes(data.bytesAvailable);
			_file = null;
			if((fileContents == null) || (fileContents.length <= 0))
				return FlxG.log("ERROR: Empty flixel gameplay record.");
			
			FlxG.loadReplay(fileContents);
		}
		
		protected function onOpenCancel(E:Event=null):void
		{
			_file.removeEventListener(Event.SELECT, onOpenSelect);
			_file.removeEventListener(Event.CANCEL, onOpenCancel);
			_file = null;
		}
		
		protected function onOpenError(E:Event=null):void
		{
			_file.removeEventListener(Event.COMPLETE, onOpenComplete);
			_file.removeEventListener(IOErrorEvent.IO_ERROR, onOpenError);
			_file = null;
			FlxG.log("ERROR: Unable to open flixel gameplay record.");
		}
		
		public function onRecord(StandardMode:Boolean=false):void
		{
			if(_play.visible)
				onPlay();
			FlxG.recordReplay(StandardMode);
		}
		
		public function stopRecording():void
		{
			var data:String = FlxG.stopRecording();
			if((data != null) && (data.length > 0))
			{
				_file = new FileReference();
				_file.addEventListener(Event.COMPLETE, onSaveComplete);
				_file.addEventListener(Event.CANCEL,onSaveCancel);
				_file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
				_file.save(data, DEFAULT_FILE_NAME);
			}
		}
		
		protected function onSaveComplete(E:Event=null):void
		{
			_file.removeEventListener(Event.COMPLETE, onSaveComplete);
			_file.removeEventListener(Event.CANCEL,onSaveCancel);
			_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			_file = null;
			FlxG.log("FLIXEL: successfully saved flixel gameplay record.");
		}
		
		protected function onSaveCancel(E:Event=null):void
		{
			_file.removeEventListener(Event.COMPLETE, onSaveComplete);
			_file.removeEventListener(Event.CANCEL,onSaveCancel);
			_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			_file = null;
		}
		
		protected function onSaveError(E:Event=null):void
		{
			_file.removeEventListener(Event.COMPLETE, onSaveComplete);
			_file.removeEventListener(Event.CANCEL,onSaveCancel);
			_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			_file = null;
			FlxG.log("ERROR: problem saving flixel gameplay record.");
		}
		
		public function onStop():void
		{
			FlxG.stopReplay();
		}
		
		public function onRestart(StandardMode:Boolean=false):void
		{
			if(FlxG.reloadReplay(StandardMode))
			{
				_recordOff.visible = false;
				_recordOn.visible = false;
				_stop.visible = true;
			}
		}
		
		public function onPause():void
		{
			paused = true;
			_pause.visible = false;
			_play.visible = true;
		}
		
		public function onPlay():void
		{
			paused = false;
			_play.visible = false;
			_pause.visible = true;
		}
		
		public function onStep():void
		{
			if(!paused)
				onPause();
			stepRequested = true;
		}
		
		//***EVENT HANDLERS***//
		
		protected function init(E:Event=null):void
		{
			if(root == null)
				return;
			removeEventListener(Event.ENTER_FRAME,init);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		protected function onMouseMove(E:MouseEvent=null):void
		{
			if(!checkOver())
				unpress();
			updateGUI();
		}
		
		protected function onMouseDown(E:MouseEvent=null):void
		{
			unpress();
			if(_overOpen)
				_pressingOpen = true;
			if(_overRecord)
				_pressingRecord = true;
			if(_overRestart)
				_pressingRestart = true;
			if(_overPause)
				_pressingPause = true;
			if(_overStep)
				_pressingStep = true;
		}
		
		protected function onMouseUp(E:MouseEvent=null):void
		{
			if(_overOpen && _pressingOpen)
				onOpen();
			else if(_overRecord && _pressingRecord)
			{
				if(_stop.visible)
					onStop();
				else if(_recordOn.visible)
					stopRecording();
				else
					onRecord(!E.altKey);
			}
			else if(_overRestart && _pressingRestart)
				onRestart(!E.altKey);
			else if(_overPause && _pressingPause)
			{
				if(_play.visible)
					onPlay();
				else
					onPause();
			}
			else if(_overStep && _pressingStep)
				onStep();
			
			unpress();
			checkOver();
			updateGUI();
		}
		
		//***MISC GUI MGMT STUFF***//
		
		protected function checkOver():Boolean
		{
			_overOpen = _overRecord = _overRestart = _overPause = _overStep = false;
			if((mouseX < 0) || (mouseX > width) || (mouseY < 0) || (mouseY > 15))
				return false;
			if((mouseX >= _recordOff.x) && (mouseX <= _recordOff.x + _recordOff.width))
				_overRecord = true;
			if(!_recordOn.visible && !_overRecord)
			{
				if((mouseX >= _open.x) && (mouseX <= _open.x + _open.width))
					_overOpen = true;
				else if((mouseX >= _restart.x) && (mouseX <= _restart.x + _restart.width))
					_overRestart = true;
				else if((mouseX >= _pause.x) && (mouseX <= _pause.x + _pause.width))
					_overPause = true;
				else if((mouseX >= _step.x) && (mouseX <= _step.x + _step.width))
					_overStep = true;
			}
			return true;
		}
		
		protected function unpress():void
		{
			_pressingOpen = _pressingRecord = _pressingRestart = _pressingPause = _pressingStep = false;
		}
		
		protected function updateGUI():void
		{
			if(_recordOn.visible)
			{
				_open.alpha = _restart.alpha = _pause.alpha = _step.alpha = 0.35;
				_recordOn.alpha = 1.0;
				return;
			}
			
			if(_overOpen && (_open.alpha != 1.0))
				_open.alpha = 1.0;
			else if(!_overOpen && (_open.alpha != 0.8))
				_open.alpha = 0.8;
			
			if(_overRecord && (_recordOff.alpha != 1.0))
				_recordOff.alpha = _recordOn.alpha = _stop.alpha = 1.0;
			else if(!_overRecord && (_recordOff.alpha != 0.8))
				_recordOff.alpha = _recordOn.alpha = _stop.alpha = 0.8;
			
			if(_overRestart && (_restart.alpha != 1.0))
				_restart.alpha = 1.0;
			else if(!_overRestart && (_restart.alpha != 0.8))
				_restart.alpha = 0.8;
			
			if(_overPause && (_pause.alpha != 1.0))
				_pause.alpha = _play.alpha = 1.0;
			else if(!_overPause && (_pause.alpha != 0.8))
				_pause.alpha = _play.alpha = 0.8;
			
			if(_overStep && (_step.alpha != 1.0))
				_step.alpha = 1.0;
			else if(!_overStep && (_step.alpha != 0.8))
				_step.alpha = 0.8;
		}
	}
}