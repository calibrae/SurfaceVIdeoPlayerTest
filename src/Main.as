package {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StageOrientationEvent;
	import flash.geom.Point;
	import flash.text.TextField;

	import starling.core.Starling;
	import starling.events.Event;

	public class Main extends Sprite {
		public static var DisplaySize : Point;

		public function Main() {
			_log("stage is " + stage);
			if (stage) {
				_log("first stage orientation : " + stage.orientation + " device orientation : " + stage.deviceOrientation);
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
				stage.color = 0x0;
				stage.addEventListener(flash.events.Event.RESIZE, handleStageResize);
				stage.addEventListener(flash.events.Event.ENTER_FRAME, __logStageSize);
				stage.addEventListener(flash.events.Event.ENTER_FRAME, _logStageShit);
				stage.addEventListener(flash.events.StageOrientationEvent.ORIENTATION_CHANGE, _orientationChange);
				stage.addEventListener(MouseEvent.CLICK, _clickTest);
			}
		}

		private function _orientationChange(event : StageOrientationEvent) : void {
			_log("orientation change");
			_log(_logStageShit());
		}

		private function _initStarling() : void {
			DisplaySize = new Point(stage.stageWidth, stage.stageHeight);

			Starling.handleLostContext = true;
			_starling = new Starling(Game, stage);
			_starling.addEventListener(starling.events.Event.ROOT_CREATED, _rootCreated);
			_starling.start();
		}

		// waiting for the stage to get a correct size

		private function _clickTest(event : MouseEvent) : void {
			_log("stage click");
		}

		private function __logStageSize(event : flash.events.Event) : void {
			_log('enterFrame : ' + _logStageShit());
			if (stage.stageWidth > stage.stageHeight) {
				_log(" device orientation not unknown anymore, running accelerometer");

				_tf.multiline = true;
				_tf.wordWrap = true;
				_tf.width = stage.stageWidth;
				_tf.height = stage.stageHeight;
				_tf.mouseEnabled = false;
				stage.addChild(_tf);

				stage.removeEventListener(flash.events.Event.ENTER_FRAME, __logStageSize);
				_initStarling();
			}
		}

		private function _rootCreated(event : starling.events.Event) : void {
			_starling.removeEventListener(starling.events.Event.ROOT_CREATED, _rootCreated);
			(_starling.root as Game).run(stage);
		}

		private function handleStageResize(event : flash.events.Event) : void {
			_log("stage resized : " + _logStageShit());
		}

		private var _starling : Starling;

		private function _logStageShit(event:flash.events.Event = null) : String {
			return ("[[stage : (" + stage.stageWidth + "/" + stage.stageHeight + ") orientation : " + stage.orientation + " device : " + stage.deviceOrientation + "]]");
		}

		private function _log(message : String) : void {
			_tf.text = message + "\n"+_tf.text;
			trace(message);
		}
		private var _tf : TextField = new TextField();
	}
}
