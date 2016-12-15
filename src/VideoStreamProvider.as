/**
 * Created by IntelliJ IDEA.
 * User: cali
 * Bitbucket: https://bitbucket.org/calibrae
 * Date: 09/12/15
 * Time: 00:53
 */
package {
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	public class VideoStreamProvider implements IVideoStreamProvider {
		private static function ns_onMetaData(item : Object) : void {
			trace(item);
		}

		private static function ns_onCuePoint(item : Object) : void {
			trace("cuePoint");
			trace(item.name + "\t" + item.time);
		}

		public function set delegate(delegate : IStreamDelegate) : void {
			_delegate = delegate;

		}

		public function get ns() : NetStream {
			_nc = new NetConnection();
			_nc.connect(null);
			_ns = new NetStream(_nc);
			_ns.addEventListener(NetStatusEvent.NET_STATUS, _onNetStatus);
			_ns.client = {
				"onMetaData": ns_onMetaData,
				"onCuePoint": ns_onCuePoint,
				"onPlayStatus": _onPlayStatus
			};
			return _ns;
		}

		public function get maxTime() : Number {
			return _maxtime;
		}

		public function init() : void {
//			_nc = new NetConnection();
//			_nc.addEventListener(NetStatusEvent.NET_STATUS, _onNetStatus);
//			_nc.connect(null);
//			_ns = new NetStream(_nc);
//			_ns.addEventListener(NetStatusEvent.NET_STATUS, _onNetStatus);
//			_ns.client = {
//				"onMetaData": ns_onMetaData,
//				"onCuePoint": ns_onCuePoint,
//				"onPlayStatus": _onPlayStatus
//			};
		}

		[PreDestroy]
		public function tearDown() : void {
		}

		public function pause() : void {
			if (_ns) {
				_ns.pause();
			}
		}

		public function resume() : void {
			if (_ns) {
				_ns.resume();
			}
		}

		public function stop() : void {

			trace("stream stop");
			if (!_ns) {
				trace("no ns, returning");
				return;
			}

			trace("nc closing");
			_nc.close();
			trace("nc closed");
			trace("ns closing");
			_ns.close();
			trace("ns closed");
			_ns.removeEventListener(NetStatusEvent.NET_STATUS, _onNetStatus);
			_ns = null;

			trace("stream stopped");

		}

		public function play(url : String) : void {

			_complete = false;
			_url = url;
			_ns.play(url);
		}

		public function seek(time : Number) : void {
			if (_ns) {
				_ns.seek(time);
			}
		}

		private function _onPlayStatus(item : Object) : void {
			trace("playstatus : " + item.code);
//			if (item.code == "NetStream.Play.Complete" && !_complete) {
//				_complete = true;
//				_notifyComplete();
//			}
		}

		private function _notifyComplete() : void {
			trace("notifyComplete");
			_maxtime = _ns.time;
			if (_delegate) {
				_delegate.complete();
			}
		}

		private function _onNetStatus(event : NetStatusEvent) : void {
			trace("netStatus : " + event.info.code);
			switch (event.info.code) {
				case "NetStream.Play.StreamNotFound":
					trace("could not play video " + _url);
					_notifyComplete();
					break;
				case "NetStream.Play.Failed":
					trace("failed to play video " + _url);
					for (var str : String in event.info) {
						trace("-- info[" + str + "]=" + event.info[str]);
					}
					_notifyComplete();
					break;
				case "NetStream.Play.Stop":
					if (!_complete) {
						_complete = true;
						_notifyComplete();
					}
			}
		}

		private var _url : String;
		private var _complete : Boolean;
		private var _maxtime : Number;
		private var _delegate : IStreamDelegate;
		private var _nc : NetConnection;
		private var _ns : NetStream;
	}
}
