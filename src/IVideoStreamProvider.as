/**
 * Created by IntelliJ IDEA.
 * User: cali
 * Bitbucket: https://bitbucket.org/calibrae
 * Date: 09/12/15
 * Time: 01:02
 */
package {
	import flash.net.NetStream;

	public interface IVideoStreamProvider {
		function play(url : String) : void;

		function stop() : void;

		function seek(time : Number) : void;

		function pause() : void;

		function resume() : void;

		function init() : void;

		function get maxTime() : Number;

		function get ns() : NetStream;

		function set delegate(delegate : IStreamDelegate) : void;
	}
}
