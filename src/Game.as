/**
 * Created by IntelliJ IDEA.
 * User: cali
 * Bitbucket: https://bitbucket.org/calibrae
 * Date: 11/09/15
 * Time: 11:55
 */
package {
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class Game extends Sprite {
		public function Game() {
		}

		public function run() : void {

			var bg : Quad = new Quad(Starling.current.viewPort.width, Starling.current.viewPort.height, 0x00FF00);
			addChild(bg);

			var quad : Quad = new Quad(200, 200, 0xFF0000);

			addChild(quad);

			_batch = new QuadBatch();
			addChild(_batch);

			_quad = new Quad(10, 10, Math.random() * 0xFFFFFF);


			addEventListener(TouchEvent.TOUCH, handleTouch);

		}

		private function handleTouch(event : TouchEvent) : void {
			var touch : Touch = event.getTouch(this);
			if (touch && (touch.phase == TouchPhase.ENDED || TouchPhase.MOVED)) {
				_quad.color = Math.random() * 0xFFFFFF;
				_quad.alpha = .5 + .5 * Math.random();
				_quad.x = touch.getLocation(this).x;
				_quad.y = touch.getLocation(this).y;
				_batch.addQuad(_quad);

			}
		}

		private var _batch : QuadBatch;
		private var _quad : Quad;


	}
}

