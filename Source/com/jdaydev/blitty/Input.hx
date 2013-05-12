package com.jdaydev.blitty;

import nme.display.Stage;

import nme.events.Event;
import nme.events.KeyboardEvent;
import nme.events.MouseEvent;
import nme.events.TouchEvent;
import nme.events.JoystickEvent;

import nme.events.MouseEvent;
import nme.ui.Mouse;




class Input {
	public static var keys:IoKeyboard;	
	public static var mouse:IoMouse;	
	
	public static function start(stage:Stage) {
		keys = new IoKeyboard();
		mouse = new IoMouse();
		
		stage.addEventListener(KeyboardEvent.KEY_DOWN, keys.keyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, keys.keyUp);
		
		stage.addEventListener(MouseEvent.MOUSE_MOVE, mouse.mouseMove);
		stage.addEventListener(MouseEvent.MOUSE_DOWN, mouse.mouseDown);
		stage.addEventListener(MouseEvent.MOUSE_UP, mouse.mouseUp);
		
		
		stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, mouse.rightMouseDown);
		stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, mouse.rightMouseUp);
		
		stage.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, mouse.middleMouseDown);
		stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, mouse.middleMouseUp);
		
		stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouse.mouseWheel);
		
		//stage.addEventListener(MouseEvent.MOUSE_OUT, Engine.mouse.mouseUp);
		//stage.addEventListener(MouseEvent.MOUSE_OVER, Engine.mouse.mouseOver);
		
		stage.focus = stage;
	}	
	
	public static function update() {
		keys.update();
		mouse.update();
	}
}

class IoKeyboard  {
	public var ESCAPE:Bool;
	public var F1:Bool;
	public var F2:Bool;
	public var F3:Bool;
	public var F4:Bool;
	public var F5:Bool;
	public var F6:Bool;
	public var F7:Bool;
	public var F8:Bool;
	public var F9:Bool;
	public var F10:Bool;
	public var F11:Bool;
	public var F12:Bool;
	public var ONE:Bool;
	public var TWO:Bool;
	public var THREE:Bool;
	public var FOUR:Bool;
	public var FIVE:Bool;
	public var SIX:Bool;
	public var SEVEN:Bool;
	public var EIGHT:Bool;
	public var NINE:Bool;
	public var ZERO:Bool;
	public var MINUS:Bool;
	public var PLUS:Bool;
	public var DELETE:Bool;
	public var BACKSPACE:Bool;
	public var Q:Bool;
	public var W:Bool;
	public var E:Bool;
	public var R:Bool;
	public var T:Bool;
	public var Y:Bool;
	public var U:Bool;
	public var I:Bool;
	public var O:Bool;
	public var P:Bool;
	public var LBRACKET:Bool;
	public var RBRACKET:Bool;
	public var BACKSLASH:Bool;
	public var CAPSLOCK:Bool;
	public var A:Bool;
	public var S:Bool;
	public var D:Bool;
	public var F:Bool;
	public var G:Bool;
	public var H:Bool;
	public var J:Bool;
	public var K:Bool;
	public var L:Bool;
	public var SEMICOLON:Bool;
	public var QUOTE:Bool;
	public var ENTER:Bool;
	public var SHIFT:Bool;
	public var Z:Bool;
	public var X:Bool;
	public var C:Bool;
	public var V:Bool;
	public var B:Bool;
	public var N:Bool;
	public var M:Bool;
	public var COMMA:Bool;
	public var PERIOD:Bool;
	public var SLASH:Bool;
	public var CONTROL:Bool;
	public var ALT:Bool;
	public var SPACE:Bool;
	public var UP:Bool;
	public var DOWN:Bool;
	public var LEFT:Bool;
	public var RIGHT:Bool;
	public var NONUMLOCK_5:Bool;
	public var TAB:Bool;
	
	/**
	 * @private
	 */
	var _lookup:Dynamic;
	/**
	 * @private
	 */
	var _map:Array<Dynamic>;
	/**
	 * @private
	 */
	var _t:Int ;

	/**
	 * Constructor
	 */
	public function new() {
		//BASIC STORAGE & TRACKING
		
		_t = 256;
		var i:Int = 0;
		_lookup = {};
		_map = new Array();
		for (i in 0 ... _t ) {
			_map.push(null);
		}
		
		//LETTERS
		var letterKeyRange:Int = 26;
		#if flash9
		var letterKeyStart:Int = 65;
		#elseif iphone
		var letterKeyStart:Int = 97; //NOTE: these key inputs are kinda pointless for iphone
		#elseif cpp
		var letterKeyStart:Int = 97;
		#end
		for (i in letterKeyStart ... letterKeyStart + letterKeyRange) {
			addKey(String.fromCharCode(i).toUpperCase(),i);
		}
		//NUMBERS
		i = 48;
		addKey("ZERO",i++);
		addKey("ONE",i++);
		addKey("TWO",i++);
		addKey("THREE",i++);
		addKey("FOUR",i++);
		addKey("FIVE",i++);
		addKey("SIX",i++);
		addKey("SEVEN",i++);
		addKey("EIGHT",i++);
		addKey("NINE",i++);
		
		//FUNCTION KEYS
		for (i in 1 ... 13) {
			addKey("F"+i,111+i);
		}
		
		//SPECIAL KEYS + PUNCTUATION
		addKey("ESCAPE",27);
		addKey("MINUS",189);
		addKey("PLUS",187);
		addKey("DELETE",46);
		addKey("BACKSPACE",8);
		addKey("LBRACKET",219);
		addKey("RBRACKET",221);
		addKey("BACKSLASH",220);
		addKey("CAPSLOCK",20);
		addKey("SEMICOLON",186);
		addKey("QUOTE",222);
		addKey("ENTER",13);
		addKey("SHIFT",16);
		addKey("COMMA",188);
		addKey("PERIOD",190);
		addKey("SLASH",191);
		addKey("CONTROL",17);
		addKey("ALT",18);
		addKey("SPACE",32);
		addKey("UP",38);
		addKey("DOWN",40);
		addKey("LEFT",37);
		addKey("RIGHT",39);
		addKey("NONUMLOCK_5",12);
		addKey("TAB",9);
	}

	public function update() {
		for (i in 0..._t) {
			if (_map[i] == null) continue;
			var o:Dynamic = _map[i];
			if ((o.last == -1) && (o.current == -1)) {
				o.current = 0;
			} else if ((o.last == 2) && (o.current == 2)) {
				o.current = 1;
			}
			o.last = o.current;
		}
	}

	public function reset() {
		for (i in 0..._t) {
			if (_map[i] == null) continue;
			var o:Dynamic = _map[i];
			Reflect.setField(this, o.name, false);
			o.current = 0;
			o.last = 0;
		}
	}

	public function pressed(Key:String):Bool { return Reflect.field(this, Key); }
	
	public function justPressed(Key:String):Bool { return _map[Reflect.field(_lookup, Key)].current == 2; }
	
	public function justReleased(Key:String):Bool { return _map[Reflect.field(_lookup, Key)].current == -1; }

	public function keyDown(event:KeyboardEvent) {
		//trace("event.keyCode: " + event.keyCode);
		var o:Dynamic = _map[event.keyCode];
		if (o == null) return;
		if (o.current > 0) {
			o.current = 1;
		} else {
			o.current = 2;
		}
		Reflect.setField(this, o.name, true);
		
	}

		
	
	public function keyUp(event:KeyboardEvent) {
		var o:Dynamic = _map[event.keyCode];
		if (o == null) return;
		if (o.current > 0) {
			o.current = -1;
		} else {
			o.current = 0;
		}
		Reflect.setField(this, o.name, false);
		
		#if android
		if (event.keyCode == 27) {
			// handle the back button!
			event.stopImmediatePropagation ();
			Lib.exit ();
		}
		#end
	}
	
	function addKey(KeyName:String,KeyCode:Int) {
		Reflect.setField(_lookup, KeyName, KeyCode);
		_map[KeyCode] = { name: KeyName, current: 0, last: 0 };
	}
}

class IoMouse 
{
	public var x:Float;
	public var y:Float;
	public var dx:Float;
	public var dy:Float;
	
	public var wheel:Float;
	
	public var left:Int;
	public var middle:Int;
	public var right:Int;

	public function new()  {
		x = 0;
		y = 0;
		
		dx = 0;
		dy = 0;
		
		left = 0;
		middle = 0;
		right = 0;
		
		wheel = 0;
	}
	
	public function update() {
		if (left == -1) left = 0;
		else if (left == 2) left = 1;
		
		if (middle == -1) middle = 0;
		else if (middle == 2) middle = 1;
		
		if (right == -1) right = 0;
		else if (right == 2) right = 1;
		
		dx = 0;
		dy = 0;
		
		wheel = 0;
	}
	
	public function mouseWheel(event:MouseEvent) {
		wheel += event.delta;
	}
	
	public function mouseMove(event:MouseEvent) {
		dx += event.stageX - x;
		dy += event.stageY - y;
		
		x = event.stageX;
		y = event.stageY;
	}
	
	public function mouseDown(event:MouseEvent) {
		if (left > 0) {
			left = 1;
		} else {
			left = 2;
		}
	}

	public function mouseUp(event:MouseEvent) {
		if (left > 0) {
			left = -1;
		} else {
			left = 0;
		}
	}
	

	
	public function middleMouseDown(event:MouseEvent) {
		if (middle > 0) {
			middle = 1;
		} else {
			middle = 2;
		}
	}

	public function middleMouseUp(event:MouseEvent) {
		if (middle > 0) {
			middle = -1;
		} else {
			middle = 0;
		}
	}	

	
	
	public function rightMouseDown(event:MouseEvent) {
		if (right > 0) {
			right = 1;
		} else {
			right = 2;
		}
	}

	public function rightMouseUp(event:MouseEvent) {
		if (right > 0) {
			right = -1;
		} else {
			right = 0;
		}
	}	
}