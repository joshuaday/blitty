package com.jdaydev.blitty;

import nme.display.Sprite;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.Lib;
import nme.Assets;
import nme.display.Bitmap;
import nme.utils.Timer;

import nme.events.Event;

import com.jdaydev.blitty.Input;

/**
 * @author 
 */
class TtyDemo extends Sprite {
	public function new () {
		super ();
		initialize ();
	}
	
	var tv:Console;
	var lastFrameTime:Float;
	private function initialize ():Void {
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
	
		tv = new Console(ConsoleFont.fromAssetTransparentBlack("assets/fonts/monaco-brogue-8.png", 16, 16), 80, 24);
		
		addChild(tv);
		
		addEventListener (Event.ENTER_FRAME, this_onEnterFrame);
		
		Input.start(Lib.current.stage);
		
		lastFrameTime = haxe.Timer.stamp();
	}
	
	
	private function this_onEnterFrame (event:Event):Void {
		var thisFrameTime:Float = haxe.Timer.stamp();
		var delta:Float = thisFrameTime - lastFrameTime;
		
		lastFrameTime = thisFrameTime;
		
		var animleft = 5; // Std.int(10 + 10 * Math.sin(thisFrameTime));
		var animtop = Std.int(3 + 3 * Math.cos(3.5 * thisFrameTime));
		
		tv.tty
			.wipe().clip(animleft, animtop, 35, 25)
				.rgb(255, 0, 0).at(3, 3).print("Time elapsed:").skip(1).print(Std.string(lastFrameTime))
				.rgb(80, 190, 255).at(4, 5).print("(Some more text)");
		
		tv.draw();
		
	
		
		
		
		Input.update();
	}

	
	// Entry point
	public static function main () {		
		Lib.current.addChild (new TtyDemo ());
	}
}
