/**
 * Created by IntelliJ IDEA.
 * User: cali
 * Bitbucket: https://bitbucket.org/calibrae
 * Date: 11/09/15
 * Time: 11:55
 */
package {
	import com.myflashlab.air.extensions.player.surface.SurfacePlayer;
	import com.myflashlab.air.extensions.player.surface.SurfacePlayerEvent;
	import com.myflashlab.air.extensions.player.surface.SurfaceVideoLocation;

	import flash.display.Stage;
	import flash.filesystem.File;

	import starling.core.Starling;

	import starling.display.Quad;
	import starling.display.Sprite;

	public class Game extends Sprite {
		public function Game() {
		}

		public function run(stage : Stage) : void {
			var quad : Quad = new Quad(50, 100, 0x00FF00);
			addChild(quad);

			var run : RunVideo = new RunVideo();
			run.stage = stage;

			Starling.current.juggler.delayCall(run.runSurface, 10);
		}



	}
}
