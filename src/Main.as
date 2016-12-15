package {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	import starling.core.Starling;
	import starling.events.Event;

	public class Main extends Sprite {
		public static var DisplaySize : Point;

		public function Main() {
			trace("stage is " + stage);
			if (stage) {
				trace("first stage orientation : " + stage.orientation + " device orientation : " + stage.deviceOrientation);
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
				stage.color = 0x0;
				stage.addEventListener(flash.events.Event.RESIZE, handleStageResize);
				stage.addEventListener(flash.events.Event.ENTER_FRAME, _traceStageSize);
				stage.addEventListener(MouseEvent.CLICK, _clickTest);
			}
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
			trace("stage click");
		}

		private function _traceStageSize(event : flash.events.Event) : void {
			trace('enterFrame : ' + traceStageShit);
			if (stage.stageWidth > stage.stageHeight) {
				trace(" device orientation not unknown anymore, running accelerometer");
				stage.removeEventListener(flash.events.Event.ENTER_FRAME, _traceStageSize);
				_initStarling();
			}
		}

		private function _rootCreated(event : starling.events.Event) : void {
			_starling.removeEventListener(starling.events.Event.ROOT_CREATED, _rootCreated);
			(_starling.root as Game).run(stage);
		}

		private function handleStageResize(event : flash.events.Event) : void {
			trace("stage resized : " + traceStageShit);
		}

		private var _starling : Starling;

		private function get traceStageShit() : String {
			return ("[[stage : (" + stage.stageWidth + "/" + stage.stageHeight + ") orientation : " + stage.orientation + " device : " + stage.deviceOrientation + "]]");
		}
	}
}
