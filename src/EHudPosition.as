/**
 * Created by IntelliJ IDEA.
 * User: cali
 * Bitbucket: https://bitbucket.org/calibrae
 * Date: 27/07/15
 * Time: 20:31
 */
package {
	import flash.geom.Point;

	import starling.core.Starling;

	public class EHudPosition {

		public static const TOP : EHudPosition = new EHudPosition("EHudPosition_TOP");
		public static const TOPLEFT : EHudPosition = new EHudPosition("EHudPosition_TOPLEFT");
		public static const LEFT : EHudPosition = new EHudPosition("EHudPosition_LEFT");
		public static const BOTTOMLEFT : EHudPosition = new EHudPosition("EHudPosition_BOTTOMLEFT");
		public static const BOTTOM : EHudPosition = new EHudPosition("EHudPosition_BOTTOM");
		public static const BOTTOMRIGHT : EHudPosition = new EHudPosition("EHudPosition_BOTTOMRIGHT");
		public static const RIGHT : EHudPosition = new EHudPosition("EHudPosition_RIGHT");
		public static const TOPRIGHT : EHudPosition = new EHudPosition("EHudPosition_TOPRIGHT");
		public static const CENTER : EHudPosition = new EHudPosition("EHudPosition_CENTER");

		public function EHudPosition(name : String) {
		}

		public function setPosition(disp : *, displaySize : Point = null, delta : uint = 0) : void {
			displaySize ||= Starling.current.viewPort.bottomRight;
			switch (this) {
				case TOP:
					disp.y = 0 + delta;
					disp.x = (displaySize.x - disp.width) >> 1;
					return;
				case TOPLEFT:
					disp.x = 0 + delta;
					disp.y = 0 + delta;
					return;

				case LEFT:
					disp.x = 0 + delta;
					disp.y = (displaySize.y - disp.height) >> 1;
					return;
				case BOTTOMLEFT:
					disp.x = 0 + delta
					disp.y = displaySize.y - disp.height - delta;
					return
				case BOTTOM:
					disp.x = (displaySize.x - disp.width) >> 1;
					disp.y = displaySize.y - disp.height - delta;
					return;
				case BOTTOMRIGHT:
					disp.x = displaySize.x - disp.width - delta;
					disp.y = displaySize.y - disp.height - delta;
					return;
				case RIGHT:
					disp.x = displaySize.x - disp.width - delta;
					disp.y = (displaySize.y - disp.height) >> 1;
					return;
				case TOPRIGHT:
					disp.x = displaySize.x - disp.width - delta;
					disp.y = 0 + delta;
					return;
				case CENTER:
					disp.x = (displaySize.x - disp.width) >> 1;
					disp.y = (displaySize.y - disp.height) >> 1;

			}
		}
	}
}
