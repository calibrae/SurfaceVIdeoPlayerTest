package {

	import flash.display.Stage;

	import flash.events.Event;

	import flash.events.KeyboardEvent;

	import flash.text.TextField;

	import flash.text.TextFieldAutoSize;

	import flash.text.TextFormat;

	import flash.ui.Keyboard;

	import flash.utils.Dictionary;

	import flash.utils.getTimer;

	/**

	 * Provide easy stage access for non display object classes.

	 *

	 * @author J.C. Wichman, 	Inner Drive Studios (www.innerdrivestudios.com / info@innerdrivestudios.com),

	 *

	 */

	final public class StageHelper

	{

		static private var _stage:Stage = null;

		static private var _textfield:TextField = null;

		static private var _frameBeacons:Dictionary = null;


		static public function setStage (pStage:Stage):void {

			_stage = pStage;


			if (_frameBeacons == null) {

				_frameBeacons = new Dictionary (true);

			}

		}


		static public function getStage ():Stage {

			return _stage;

		}


		static public function addFrameBeacon (pClient:Object, pBeacon:Function):void {

			if (_frameBeacons[pClient != null]) return;


			_frameBeacons[pClient] = pBeacon;

			_stage.addEventListener (Event.ENTER_FRAME, _onEnterFrame);

		}


		static public function removeFrameBeacon (pClient:Object, pBeacon:Function):void {

			_frameBeacons[pClient] = null;

			delete _frameBeacons[pClient];

		}


		static private function _onEnterFrame(e:Event):void

		{

			for (var pClient:Object in _frameBeacons) _frameBeacons[pClient]();

		}


		static public function print (pInfo:String, pNewLine:String = "\n"):void {

		_setupTextField();

		_textfield.visible = true;

		_textfield.appendText (pInfo + pNewLine);


		_textfield.scrollV = _textfield.maxScrollV;


		if (_stage.getChildIndex (_textfield) < (_stage.numChildren - 1)) {
			_stage.removeChild (_textfield);
			_stage.addChild (_textfield);
		}
	}

	static public function clear():void {
		if (_textfield != null) {
			_textfield.text = "";
			_textfield.visible = false;
		}
	}

	static private function _setupTextField():void {
		if (_textfield != null) return;

		if (_stage == null) trace ("Cannot print, stage is null in StageUtil, use setStage first");

		_textfield = new TextField();
		var tf:TextFormat = new TextFormat ("_sans");
		_textfield.defaultTextFormat = tf;
		_textfield.autoSize = TextFieldAutoSize.LEFT;
		_textfield.multiline = true;
		_textfield.wordWrap = true;
		_textfield.width = _stage.stageWidth;
		_textfield.height = 0;

		_stage.addChild (_textfield);

		_stage.addEventListener (KeyboardEvent.KEY_DOWN, StageHelper._onKeyDown);
	}

	static public function getTextfield():TextField {
		_setupTextField();
		return _textfield;
	}

	static private function _onKeyDown(pKeyEvent:KeyboardEvent):void {
		if (pKeyEvent.keyCode == Keyboard.F1) {
			_textfield.visible = !_textfield.visible;
		}

		if (pKeyEvent.keyCode == Keyboard.F2) {
			_textfield.autoSize = TextFieldAutoSize.NONE;
			_textfield.height = _stage.stageHeight / 4;
		}

		if (pKeyEvent.keyCode == Keyboard.F3) {
			_textfield.autoSize = TextFieldAutoSize.LEFT;
		}

		if (pKeyEvent.keyCode == Keyboard.F4) {
			clear();
		}

	}
}

}