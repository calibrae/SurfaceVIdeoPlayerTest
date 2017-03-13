/**
 * Created by IntelliJ IDEA.
 * User: cali
 * Bitbucket: https://bitbucket.org/calibrae
 * Date: 13/03/2017
 * Time: 14:30
 */
package {
	import flash.display.Stage;

	import starling.core.Starling;
	import starling.events.Event;

	public class StarlingInitializer {
		public function initialize(stage : Stage) : void {
			Starling.handleLostContext = true;
			_starling = new Starling(Game, stage);
			_starling.addEventListener(Event.ROOT_CREATED, _rootCreated);
			_starling.start();
		}

		private function _rootCreated(event : Event) : void {
			_starling.removeEventListener(Event.ROOT_CREATED, _rootCreated);
			(_starling.root as Game).run();
		}

		private var _starling : Starling;
	}
}
