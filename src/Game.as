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

	import starling.display.Quad;
	import starling.display.Sprite;

	public class Game extends Sprite {
		public function Game() {
		}

		public function run(stage : Stage) : void {
			var quad : Quad = new Quad(50, 100, 0x00FF00);
			addChild(quad);
			runSurface(stage);
		}

		public function runSurface(stage : Stage) : void {

			trace("runSurface");

			_surfacePlayer = new SurfacePlayer(stage);
			_surfacePlayer.addEventListener(SurfacePlayerEvent.ON_BACK_CLICKED, onBackClickedWhenSurfacePlayerIsAvailable);
			_surfacePlayer.addEventListener(SurfacePlayerEvent.ON_COMPLETION_LISTENER, onVideoPlaybackCompleted);
			_surfacePlayer.addEventListener(SurfacePlayerEvent.ON_FILE_AVAILABILITY, onTargetVideoAvailability);
			_surfacePlayer.addEventListener(SurfacePlayerEvent.ON_MEDIA_STATUS_CHANGED, onMediaStatusChanged);

			_surfacePlayer.init(0, 0, 400, 200, false);

			var copy : File = _handleFile();
			_surfacePlayer.attachVideo(copy, SurfaceVideoLocation.ON_SD_CARD);

//			_surfacePlayer.play();


		}

//
//		public function runExtension() : void {
//			_ext = new VideoPlayer();
//
//			var copy : File = _handleFile();
////			_ext.play(copy.nativePath, VideoType.ON_SD_CARD);
//			_ext.play("http://myflashlabs.com/showcase/Bully_Scholarship_Edition_Trailer.mp4", VideoType.ON_LINE);
//
//		}


		private function _handleFile() : File {

			var file : File = File.applicationDirectory.resolvePath("testVideoPlayerSurface.mp4");
			var f : File;
			for each (f  in File.applicationDirectory.getDirectoryListing()) {
				trace("applicationDirectory");
				trace(f.nativePath + " :: " + f.size + "\n");
			}
			if (!file.exists) {
				trace("File doesn't exist");
				return null;
			}
			var copy : File = File.applicationStorageDirectory.resolvePath("testVideoPlayerSurface.mp4");
			file.copyTo(copy, true);

			for each (f  in File.applicationStorageDirectory.getDirectoryListing()) {
				trace("applicationStorageDirectory");
				trace(f.nativePath + " :: " + f.size + "\n");
			}

			trace("file exists");

			return copy;
		}

		private function onMediaStatusChanged(event : SurfacePlayerEvent) : void {
			trace("media status ");
		}

		private function onTargetVideoAvailability(event : SurfacePlayerEvent) : void {
			trace("video availability");
			_surfacePlayer.play();

//			Starling.current.stage3D.visible = false;

		}

		private function onVideoPlaybackCompleted(event : SurfacePlayerEvent) : void {
			trace("video complete");

		}

		private function onBackClickedWhenSurfacePlayerIsAvailable(event : SurfacePlayerEvent) : void {
			trace("back clicked");

		}

//		private var _ext : VideoPlayer;
		private var _surfacePlayer : SurfacePlayer;

	}
}
