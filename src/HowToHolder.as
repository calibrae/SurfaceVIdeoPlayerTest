/**
 * Created by IntelliJ IDEA.
 * User: cali
 * Bitbucket: https://bitbucket.org/calibrae
 * Date: 07/12/15
 * Time: 15:36
 */
package {
	import flash.geom.Point;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class HowToHolder extends Sprite implements IStreamDelegate {

		public function init() : void {
			_stream.init();
			_empty = Texture.empty(1, 1)
			_size = Starling.current.viewPort.bottomRight;
			_quad = new Quad(_size.x, _size.y, 0x00FF00);
			_quad.touchable = false;
			_quad.alpha = 0;
			_image = new VideoImage(_empty);
			addChild(_quad);
			addChild(_image);
			_stream.delegate = this;
			_quad.addEventListener(TouchEvent.TOUCH, _quadTouch);
		}

		public function play(video : IJamesVideoUrl) : void {
			trace("playing HowTO : " + video.url);
			_texture = Texture.fromNetStream(_stream.ns, 1, _textureReady);
			_video = video;

			_stream.play(video.url);
			trace("play");

			_appearTween = new Tween(_quad, .5, Transitions.EASE_IN);
			_appearTween.fadeTo(.6);
			Starling.juggler.add(_appearTween);

			_quad.touchable = true;

		}

		public function complete() : void {

			trace("Howto complete call");

//			_stream.seek(_stream.maxTime);
			_stream.pause();
			var tween : Tween = new Tween(_image, 1, Transitions.EASE_IN_OUT);
			tween.scaleTo(0);
			tween.onUpdate = function () : void {
				EHudPosition.CENTER.setPosition(_image, _size);
			};
			tween.onComplete = function () : void {
				trace("end tween complete");
				_quad.alpha = 0;
				stop();
				_stream.stop();

				dispatchEventWith("COMPLETE");
			}

			Starling.juggler.add(tween);

			_quad.touchable = false;


		}

		public function stop() : void {
			trace("how to holder stop ");
			if (_texture) {
				trace("texture dispose");
				_texture.dispose();
				trace ("texture disposed");
				_texture = null;
			}
			_image.texture = _empty;
			_quad.touchable = false;
		}

		[PreDestroy]
		public function tearDown() : void {
			_quad.dispose();
			_stream.stop();
			_empty.dispose();
			_image.dispose();
			_size = null;
			_image = null;
			_empty = null;
		}

		private function _textureReady() : void {
			trace("texture ready");
			_image.texture = _texture;
			_image.readjustSize();

			_stream.pause();

			_image.scaleX = _image.scaleY = 0;
			EHudPosition.CENTER.setPosition(_image, _size);
			_scaleTween = new Tween(_image, 2, Transitions.EASE_IN_OUT);
			_scaleTween.scaleTo(1);
			_scaleTween.onComplete = function () : void {
				_stream.resume();

			};
			_scaleTween.onUpdate = function () : void {
				EHudPosition.CENTER.setPosition(_image, _size);
			};
			Starling.juggler.add(_scaleTween);

		}

		private function _quadTouch(event : TouchEvent) : void {
			var touch : Touch = event.getTouch(_quad, TouchPhase.ENDED);
			if (touch) {
				Starling.juggler.remove(_appearTween);
				Starling.juggler.remove(_scaleTween);
				_stream.seek(_stream.maxTime);
				_stream.pause();
				_quad.alpha = 0;
				stop();
				_stream.stop();
			}
		}

		private var _appearTween : Tween;
		private var _scaleTween : Tween;
		private var _empty : Texture;
		private var _image : VideoImage;
		private var _video : IJamesVideoUrl;
		private var _texture : Texture;
		private var _size : Point;
		private var _quad : Quad;

		public var _stream : IVideoStreamProvider = new VideoStreamProvider();
	}
}

import starling.display.Image;
import starling.textures.Texture;

internal class VideoImage extends Image {
	public function VideoImage(texture : Texture) {
		super(texture);
	}

	override public function readjustSize() : void {
		super.readjustSize();
	}
}
