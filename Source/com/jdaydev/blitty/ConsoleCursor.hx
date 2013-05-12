package com.jdaydev.blitty;
import nme.display.BitmapInt32;
using StringTools;

class ConsoleCursor 
{
	private var tty:Console;
	
	private var x1:Int;
	private var y1:Int;
	
	public var width(default, null):Int;
	public var height(default, null):Int;
	public var x(default, null):Int;
	public var y(default, null):Int;
	
	private var idx:Int;
	private var cursorfg:BitmapInt32;
	
	public function new(console:Console) {
		tty = console;
		x = 0;
		y = 0;
		x1 = 0;
		y1 = 0;
		width = console.columns;
		height = console.rows;
	}
	
	public function at(X:Int, Y:Int):ConsoleCursor {
		x = X;
		y = Y;
		
		idx = x1 + x + (y1 + y) * tty.columns;
		
		return this;
	}
	
	public function put(Glyph:Int):ConsoleCursor {
		if (x > 0 && x < width && y > 0 && y < height) {
			tty.lowlevelplot(idx, Glyph, cursorfg);
		}
		
		x++;
		idx++;
		return this;
	}
	
	public function print(msg:String):ConsoleCursor {
		// todo : use lowlevelplot directly
		for (i in 0 ... msg.length) {
			put(msg.fastCodeAt(i));
		}
		
		return this;
	}
	
	public function bs():ConsoleCursor {
		x--;
		idx--;
		return this;
	}
	
	public function skip(columns:Int):ConsoleCursor {
		x += columns;
		idx += columns;
		return this;
	}
	
	public function column(X:Int):ConsoleCursor {
		idx += x - X;
		x = X;
		
		return this;
	}
	
	public function cr():ConsoleCursor {
		x = 0;
		y++;
		
		idx = (y1 + y) * tty.columns;
		return this;
	}
	
	public function fill():ConsoleCursor {
		return this;
	}
	
	public function wipe():ConsoleCursor {
		at(0, 0);
		
		var rowidx = idx;
		for (cy in 0 ... height) {
			for (cx in 0 ... width) {
				tty.lowlevelplot(rowidx + cx, 0, cursorfg);
			}
			
			rowidx += tty.columns;
		}
		
		return at(0, 0);
	}
	
	public function fg(Color:Int, ?Alpha:Int = 255) : ConsoleCursor {
		// todo: use proper RGBA function
		cursorfg = (Color & 0xffffff) | ((Alpha & 0xff) << 24);
		return this;
	}
	
	public function rgb(R:Int, G:Int, B:Int, ?A:Int = 255):ConsoleCursor {
		// todo: use proper RGBA function
		cursorfg = ((A & 0xff) << 24) | ((R & 0xff) << 16) | ((G & 0xff) << 8) | ((B & 0xff));
		return this;
	}
	
	public function clip(X1:Int, Y1:Int, Width:Int, Height:Int):ConsoleCursor {
		var sub = new ConsoleCursor(tty);
		sub.x1 = x1 + X1;
		sub.y1 = y1 + Y1;
		
		if (sub.x1 + Width > width) Width = width - sub.x1;
		if (sub.y1 + Height > height) Height = height - sub.y1;
		
		sub.width = Width;
		sub.height = Height;
		
		if (sub.x1 < 0) {
			sub.width += sub.x1;
			sub.x1 = 0;
		}
		if (sub.y1 < 0) {
			sub.height += sub.y1;
			sub.y1 = 0;
		}
		
		sub.cursorfg = cursorfg;
		
		return sub;
	}
}
