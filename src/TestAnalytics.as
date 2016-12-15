/**
 * Created by IntelliJ IDEA.
 * User: cali
 * Bitbucket: https://bitbucket.org/calibrae
 * Date: 13/07/16
 * Time: 17:14
 */
package {
	import flash.display.Sprite;
	import flash.events.Event;

	import libraries.uanalytics.tracker.AppTracker;
	import libraries.uanalytics.tracker.ApplicationInfo;
	import libraries.uanalytics.utils.generateAIRAppInfo;

	public class TestAnalytics extends Sprite {
		public function TestAnalytics() {
			_tracker = new AppTracker("UA-80716865-1");
			var appinfo : ApplicationInfo = generateAIRAppInfo();
			_tracker.add(appinfo.toDictionary());

			addEventListener(Event.ENTER_FRAME, _enterFrame);
		}

		private var count : uint = 0;
		private var globalcount : uint = 0;
		private function _enterFrame(event : Event) : void {
			count++
			if (count < 10){
				return;
			}
			count = 0;
			trace("is ok? " + _tracker.event("test", "enterframe", "", globalcount ));
			globalcount++;
		}


		private var _tracker : AppTracker;
	}
}
