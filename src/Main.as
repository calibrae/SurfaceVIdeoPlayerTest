package {


	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageAspectRatio;
	import flash.display.StageOrientation;
	import flash.display.StageScaleMode;
	import flash.events.AccelerometerEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StageOrientationEvent;
	import flash.geom.Point;
	import flash.sensors.Accelerometer;

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
//				stage.setAspectRatio(StageAspectRatio.LANDSCAPE);
//				stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, orientationChangeListener);
				stage.addEventListener(flash.events.Event.RESIZE, handleStageResize);
				stage.addEventListener(flash.events.Event.ENTER_FRAME, _traceStageSize);
			}

		}

		private function _startAccelerometer() : void {
			if (Accelerometer.isSupported) {
				trace("starting accelerometer");
				_accelerometer = new Accelerometer();
				_accelerometer.setRequestedUpdateInterval(200);
				_accelerometer.addEventListener(AccelerometerEvent.UPDATE, accUpdateHandler);
			}
		}

		private function _traceStageSize(event : flash.events.Event) : void {
			trace('enterFrame : ' + traceStageShit);
			if (stage.stageWidth > stage.stageHeight){
				trace(" device orientation not unknown anymore, running accelerometer");
				stage.removeEventListener(flash.events.Event.ENTER_FRAME, _traceStageSize);
//				_startAccelerometer();
				_enterFrame();
			}
		}

		private function accUpdateHandler(event : AccelerometerEvent) : void {
			trace("accel  x " + event.accelerationX + " y: " + event.accelerationY + " z:" + event.accelerationZ + traceStageShit);

			if (_firstRotation) {
				if (stage.deviceOrientation == StageOrientation.ROTATED_LEFT || stage.deviceOrientation == StageOrientation.ROTATED_RIGHT) {
					stage.setOrientation(stage.deviceOrientation);
				} else {
					stage.setOrientation(Math.random() > .5 ? StageOrientation.ROTATED_LEFT : StageOrientation.ROTATED_RIGHT);
				}
				_firstRotation = false;
				_enterFrame();
				return;
			}
			if (_count > 0) {
				trace("Blockrotation : " + _count);
				_count--;
				return;
			}
//
			if (event.accelerationY < -.8) {
				stage.setOrientation(stage.orientation == StageOrientation.ROTATED_RIGHT ? StageOrientation.ROTATED_LEFT : StageOrientation.ROTATED_RIGHT);
				_count = 10;
			}
		}

		private function _deactivate(event : flash.events.Event) : void {
			trace("deactivate");
		}

		private function _activate(event : flash.events.Event) : void {
			trace("activate");
		}

		private function _click(event : MouseEvent) : void {
			trace("click");
		}

		private function _enterFrame(event : flash.events.Event = null) : void {

//			if (_count < 3) {
//				_count++;
//				return;
//			}
			trace("waited for 30 frames");

//			removeEventListener(flash.events.Event.ENTER_FRAME, _enterFrame);

			DisplaySize = new Point(stage.stageWidth, stage.stageHeight);

//			var shape : Shape = new Shape();
//			shape.graphics.beginFill(0xFFFFFF);
//			shape.graphics.drawRect(0, 0, DisplaySize.x, DisplaySize.y);
//			shape.graphics.endFill();
//			addChild(shape);

			Starling.handleLostContext = true;
			_starling = new Starling(Game, stage);
			_starling.addEventListener(starling.events.Event.ROOT_CREATED, _rootCreated);
			_starling.start();
		}

		private function orientationChangeListener(event : StageOrientationEvent) : void {


			trace("orientation change after : " + event.afterOrientation + " before : " + event.beforeOrientation + traceStageShit);
//			if (stage.stageWidth < stage.stageHeight) {
//				trace("forcing orientation ");
//				stage.setOrientation(stage.orientation == StageOrientation.ROTATED_LEFT ? StageOrientation.ROTATED_RIGHT : StageOrientation.ROTATED_LEFT);
//			}
		}

		private function _rootCreated(event : starling.events.Event) : void {
			_starling.removeEventListener(starling.events.Event.ROOT_CREATED, _rootCreated);
			(_starling.root as Game).run(stage);
		}

//

		private function handleStageResize(event : flash.events.Event) : void {
			trace("stage resized : " + traceStageShit);
		}

//
		private var _firstRotation : Boolean = true;
		private var _accelerometer : Accelerometer;

//
//		private function orientationChangingListener(e : StageOrientationEvent) : void {
////			e.preventDefault();
//			trace("orientation changing after : " + e.afterOrientation + " before : " + e.beforeOrientation);
//			traceStageShit();
//
//			if (e.afterOrientation == StageOrientation.DEFAULT || e.afterOrientation == StageOrientation.UPSIDE_DOWN) {
//				e.preventDefault();
//			}
//		}
		private var _startOrientation : String;
		private var _count : int;
		private var _starling : Starling;

		private function get traceStageShit() : String {
			return ("[[stage : (" + stage.stageWidth + "/" + stage.stageHeight + ") orientation : " + stage.orientation + " device : " + stage.deviceOrientation + "]]");
		}
	}
}
