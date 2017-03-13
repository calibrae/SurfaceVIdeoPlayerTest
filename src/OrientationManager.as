package {

	import flash.display.Screen;
	import flash.display.Stage;
	import flash.display.StageAspectRatio;
	import flash.display.StageOrientation;
	import flash.events.TimerEvent;
	import flash.system.Capabilities;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	/**

	 * OrientationManager provides an alternative to two solutions:

	 * a) the preventDefault solution to prevent certain orientations -> no longer works for iOS6

	 * b) the setAspectRatio functionality in air 3.3 and higher -> does not work reliably on Android 2.2

	 *

	 * The preventDefault was awkward anyway since DEFAULT orientation is LANDSCAPE on device a and PORTRAIT on device B.

	 *

	 * This manager tries to provide some more control over the orientation by allowing you to specify all

	 * allowed orientations in code, matching them against the deviceOrientation and the supportedOrientations.

	 *

	 * You can still listen for stage orientation changes through events as usual.

	 *

	 * Usage:

	 * on startup of your app do something like this in the constructor:

	 * – OrientationManager.initialize (stage, OrientationManager.LANDSCAPE_NORMAL_AND_FLIPPED);

	 *

	 * Feedback, coffee, a giveaway car? Contact me at info@innerdrivestudios.com

	 * Comes without any guarantee.

	 *

	 * @author J.C. Wichman

	 * @version 1.1

	 */

	public class OrientationManager {

		//allowed orientations

		static public var LANDSCAPE_NORMAL : int = 1;

		static public var LANDSCAPE_NORMAL_AND_FLIPPED : int = 3;

		static public var PORTRAIT_NORMAL : int = 4;

		static public var PORTRAIT_NORMAL_AND_FLIPPED : int = 12;

		static public var ANY : int = 15;
		static public var debug : Boolean = true;

		static public function initialize(pStage : Stage, pAllowedOrientations : int, pCheckInterval : int = 500) : void {

			_stage = pStage;

			_allowedOrientationFlag = pAllowedOrientations;


			//we handle all orientation stuff, so turn of any automatic behaviour and restrictions

			_stage.setAspectRatio(StageAspectRatio.ANY);

			//if all orientations are allowed, we are done, simply turn autoorient on and exit

			_stage.autoOrients = pAllowedOrientations == ANY;


			if (_allowedOrientationFlag == ANY) return;


			//otherwise build list of allowed orientations based on given flags

			_isLandscapeDevice =

					(_stage.orientation == StageOrientation.DEFAULT || _stage.orientation == StageOrientation.UPSIDE_DOWN) &&

					Capabilities.screenResolutionX > Capabilities.screenResolutionY;


			_updateAllowedOrientations(LANDSCAPE_NORMAL, _isLandscapeDevice ? StageOrientation.DEFAULT : StageOrientation.ROTATED_RIGHT);

			_updateAllowedOrientations(LANDSCAPE_NORMAL_AND_FLIPPED, _isLandscapeDevice ? StageOrientation.UPSIDE_DOWN : StageOrientation.ROTATED_LEFT);

			_updateAllowedOrientations(PORTRAIT_NORMAL, _isLandscapeDevice ? StageOrientation.ROTATED_RIGHT : StageOrientation.DEFAULT);

			_updateAllowedOrientations(PORTRAIT_NORMAL_AND_FLIPPED, _isLandscapeDevice ? StageOrientation.ROTATED_LEFT : StageOrientation.UPSIDE_DOWN);


			//make sure at least one orientation is allowed

			if (_allowedOrientations.length == 0) _allowedOrientations.push(StageOrientation.DEFAULT);


			/*

			 A note on weirdness on older Android devices:

			 – if you turn autoorient off: you can detect that the stage is upside down, either in landscape or portrait BUT you cannot programmatically set this orientation using setOrientation

			 – if you turn autoorient on: the stage rotates to accomodate any orientation EXCEPT upside_down. It does do rotated_left, rotated_right BUT the device might have trouble reporting this value correctly (eg it might mix up rotated_left, rotated_right).

			 */


			//setup up periodic check since iOs6 no longer handles preventDefault

			_timer = new Timer(pCheckInterval, 0);

			_timer.addEventListener(TimerEvent.TIMER, _onTimerEvent);

			_timer.start();


			//trigger of immediate stage evaluation to see if current orientation is supported/allowed

			_doOrientationCheck();

		}

		static public function deinitialize() : void {

			_timer.removeEventListener(TimerEvent.TIMER, _onTimerEvent);

			_timer = null;

			_stage = null;

		}

		static private function _updateAllowedOrientations(pOrientationFlag : int, pOrientationString : String) : void {

			var supportedOrientations :Vector.<String> = _stage.supportedOrientations;
			if (

					((pOrientationFlag & _allowedOrientationFlag) == pOrientationFlag) &&

					supportedOrientations.indexOf(pOrientationString) > -1) {

				_allowedOrientations.push(pOrientationString);

			}

		}

		static private function _doOrientationCheck() : void {

			//skip if nothing changed

			if (_stage.deviceOrientation == _lastDeviceOrientation) return;

			_lastDeviceOrientation = _stage.deviceOrientation;


			//basically we wish to conform to the device orientation

			var lDesiredOrientation : String = _translate(_stage.deviceOrientation);

			//if its not allowed, check if we are in an allowed position and keep it that way

			if (_allowedOrientations.indexOf(lDesiredOrientation) == -1) lDesiredOrientation = _stage.orientation;

			//if that is not allowed either, get the first allowed position

			if (_allowedOrientations.indexOf(lDesiredOrientation) == -1) lDesiredOrientation = _allowedOrientations[0];


			if (debug) {

				StageHelper.clear();

				_debug("Device orientation detected:" + _stage.deviceOrientation);

				_debug("Current stage orientation:" + _stage.orientation);

				_debug("Desired/resulting orientation:" + lDesiredOrientation);

				_debug("Timestamp:" + getTimer());


				_debug("Cap:" + [Capabilities.screenResolutionX, Capabilities.screenResolutionY]);

				_debug("Screen:" + [Screen.mainScreen.bounds.width, Screen.mainScreen.bounds.height]);

				_debug("Screen vis:" + [Screen.mainScreen.visibleBounds.width, Screen.mainScreen.visibleBounds.height]);

				_debug("Stage stagewidth:" + [_stage.stageWidth, _stage.stageHeight]);

				_debug("Stage fullscreen:" + [_stage.fullScreenWidth, _stage.fullScreenHeight]);

			}


			if (_stage.orientation != lDesiredOrientation) _stage.setOrientation(lDesiredOrientation);

		}

		/**

		 * If the device turns left, the stage has to turn right. But no no wait, it gets better!

		 * If the device is upside down, the stage has to …. be upside down as well! \^^\/oo\/^^/

		 *

		 * @param    pDeviceOrientation

		 * @return  the stage orientation required to view the content upright

		 *

		 * Note to self: this will fail if your head is upside down snorting coffee through your nose

		 */

		static public function _translate(pDeviceOrientation : String) : String {

//			_debug("Translating:" + pDeviceOrientation);


			switch (pDeviceOrientation) {

				case StageOrientation.UNKNOWN:
				case StageOrientation.DEFAULT:
					return StageOrientation.DEFAULT;

				case StageOrientation.UPSIDE_DOWN:
					return StageOrientation.UPSIDE_DOWN;

				case StageOrientation.ROTATED_LEFT:
					return StageOrientation.ROTATED_RIGHT;

				case StageOrientation.ROTATED_RIGHT:
					return StageOrientation.ROTATED_LEFT;

			}

			return null;

		}

		static private function _debug(pInfo : String) : void {

			if (debug) StageHelper.print(pInfo);

		}

		public function OrientationManager() {
		}

		static private function _onTimerEvent(e : TimerEvent) : void {

			_doOrientationCheck();

		}
		static private var _lastDeviceOrientation : String = null;
		static private var _isLandscapeDevice : Boolean = false;
		static private var _allowedOrientationFlag : int = 0;
		static private var _allowedOrientations : Array = [];
		static private var _timer : Timer = null;
		static private var _stage : Stage = null;


	}


}
