package {

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.system.System;


	import starling.core.Starling;
	import starling.events.Event;

	public class Main extends Sprite {
		public static var DisplaySize : Point;

		public function Main() {
			addEventListener(flash.events.Event.ADDED_TO_STAGE, _preinit);
		}

		private function _preinit(event : flash.events.Event) : void {
			removeEventListener(flash.events.Event.ADDED_TO_STAGE, _preinit);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.color = 0x0;
			_count = 0;
			addEventListener(flash.events.Event.ENTER_FRAME, _enterFrame);

			var shape : Shape = new Shape();
			shape.graphics.beginFill(0xFF0000);
			shape.graphics.drawRect(0,0,100,50);
			shape.graphics.endFill();
			addChild(shape);

			_runVideo = new RunVideo();
			_runVideo.stage = stage;

			trace("pre init ended");
			trace ("framerate: "+stage.frameRate+" fps");
		}

		private var _runVideo : RunVideo;

		private function _enterFrame(event : flash.events.Event) : void {

			if (_count < 240) {
				if (_count % 10 == 0){
					trace("count : "+_count);
				}
				_count++;
				return;
			}
			trace("waited for 30 frames");

			removeEventListener(flash.events.Event.ENTER_FRAME, _enterFrame);

			DisplaySize = new Point(stage.stageWidth, stage.stageHeight);



			_runVideo.runSurface();

			return;
			_starling = new Starling(Game, stage);
			_starling.addEventListener(starling.events.Event.ROOT_CREATED, _rootCreated);
			_starling.start();
		}

		private function _rootCreated(event : starling.events.Event) : void {
			(_starling.root as Game).run(stage);

		}

		private var _count : int;
		private var _starling : Starling;
	}
}
