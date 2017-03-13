package {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageOrientation;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StageOrientationEvent;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class Main extends Sprite {

		public function Main() {
			_log("initializing ");
			addEventListener(Event.ADDED_TO_STAGE, _firstAdd);

		}

		private function _initStarling() : void {
			new StarlingInitializer().initialize(stage);
		}

		private function _log(message : String) : void {
			_initTf();
			_tf.text = message + "\n" + _tf.text;
			trace(message);
		}

		private function _initTf() : void {
			if (!stage.contains(_tf)) {
				var tfo : TextFormat = new TextFormat(null, 25);
				_tf.defaultTextFormat = tfo;
				_tf.multiline = true;
				_tf.wordWrap = true;
				_tf.width = Capabilities.screenResolutionX > Capabilities.screenResolutionY ? Capabilities.screenResolutionX : Capabilities.screenResolutionY;
				_tf.height = Capabilities.screenResolutionX < Capabilities.screenResolutionY ? Capabilities.screenResolutionX : Capabilities.screenResolutionY;
				_tf.mouseEnabled = false;
				stage.addChild(_tf);
			}
		}

		private function _firstAdd(event : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, _firstAdd);

			addEventListener(Event.ENTER_FRAME, _waitFewFrames);
			_log("stage is " + stage);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.color = 0x333333;
		}

		private var _count : uint = 10;
		private function _waitFewFrames(event : Event) : void {
			_log("wait few frames "+_logStageShit);
			_count --;

			if (_count <= 0){
				removeEventListener(Event.ENTER_FRAME, _waitFewFrames);
				_log("first stage orientation : " + stage.orientation + " device orientation : " + stage.deviceOrientation);

				stage.addEventListener(Event.RESIZE, handleStageResize);
//				stage.addEventListener(Event.ENTER_FRAME, __logStageSize);
				stage.addEventListener(MouseEvent.CLICK, _clickTest);

				stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, _changeOrientation);
//				stage.addEventListener(Event.ENTER_FRAME, _permanentEnterFrame);

				var quad : Shape = new Shape();
				quad.graphics.beginFill(0x0000FF);
				quad.graphics.drawRect(0, 0, 100, 200);
				quad.graphics.endFill();
				addChild(quad);

//				_initStarling();


				_changeOrientation();
			}
		}

		// waiting for the stage to get a correct size

		private function _permanentEnterFrame(event : Event) : void {
			_log("ENTER FRAME!!! : " + _logStageShit);
			stage.setOrientation(OrientationManager._translate(stage.deviceOrientation));
		}

		private function _changeOrientation(event : StageOrientationEvent = null) : void {
			_log("ORIENTATION !!! : " + _logStageShit);
			if (stage.stageWidth < stage.stageHeight) {

				stage.setOrientation(nextOrientation);
			} else {
				_initStarling();
			}
		}

		private function _clickTest(event : MouseEvent) : void {
			_log("stage click");
		}

		private function __logStageSize(event : Event) : void {
			_log('enterFrame : ' + _logStageShit);
			if (stage.stageWidth > stage.stageHeight) {
				_log(" device orientation not unknown anymore, running accelerometer");

				stage.removeEventListener(Event.ENTER_FRAME, __logStageSize);
				_initStarling();
			}
		}

		private function handleStageResize(event : Event) : void {
			_log("stage resized : " + _logStageShit);
		}

		private var _tf : TextField = new TextField();

		private function get nextOrientation() : String {
			switch (stage.orientation) {
				case StageOrientation.DEFAULT:
				case StageOrientation.UNKNOWN:
					return StageOrientation.ROTATED_LEFT;
				case StageOrientation.ROTATED_LEFT:
					return StageOrientation.UPSIDE_DOWN;
				case StageOrientation.ROTATED_RIGHT:
					return StageOrientation.DEFAULT;
				case StageOrientation.UPSIDE_DOWN:
					return StageOrientation.ROTATED_RIGHT;
			}
			return StageOrientation.DEFAULT;
		}

		private function get _logStageShit() : String {
			return ("///////////////////////\nstage : (" + stage.stageWidth + "/" + stage.stageHeight + ") orientation : " + stage.orientation + " device : " + stage.deviceOrientation + "\n Capa.x : " + Capabilities.screenResolutionX + " Capa.y : " + Capabilities.screenResolutionY + "\n////////////////////////////");
		}
	}
}
