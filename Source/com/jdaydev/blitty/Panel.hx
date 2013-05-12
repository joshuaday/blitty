package com.jdaydev.blitty;
import nme.display.Graphics;

/**
 * ...
 * @author 
 */

class Panel 
{
	public var rows(default, null):Int;
	public var cells(default, null):Int;	
	public var columns(default, null):Int;
	
	public var font(default, null):ConsoleFont;
	
	// cursor properties
	public var tty(default, null):ConsoleCursor;
	
	// high level arrays for cell contents
	var glyph:Array<Int>;
	var fg:Array<BitmapInt32>;
	var bg:Array<BitmapInt32>;
	
	public function new(?Columns:Int = 80, ?Rows:Int = 24)
	{
		rows = 0;
		columns = 0;
		
		resize(Columns, Rows);
		
		tty = new ConsoleCursor(this);
	}
	
	private inline function index(x:Int, y:Int) {
		return (x + y * columns); // no clipping (todo -- need clipping?)
	}
	
	public function lowlevelplot(idx:Int, Glyph:Int, Color:Int):Void {
		glyph[idx] = Glyph;
		fg[idx] = Color;
	}
	
	public function resize(w:Int, h:Int) {
		var _glyph = glyph;
		var _fg = fg;
		var _bg = bg;
		
		cells = w * h;
		glyph = [];
		fg = [];
		bg = [];
		
		if (_glyph != null) {
			// transfer over the old console content, if there was one
			for (y in 0 ... (rows < h ? rows : h)) {
				for (x in 0 ... (columns < w ? columns : w)) {
					glyph[x + y * w] = _glyph[x + y * columns];
					fg[x + y * w] = _fg[x + y * columns];
					bg[x + y * h] = _bg[x + y * columns];
				}
			}
		}
		
		columns = w;
		rows = h;
	}
	
	public function draw(graphics:Graphics, font:ConsoleFont) {
		graphics.clear();
	
		for (x in 0 ... columns) {
			for (y in 0 ... rows) {
				var idx:Int = index(x, y);
				var ct:Int = floatsPerTile * idx;
				
				var g = glyph[idx];
				var c = fg[idx];
				
				fgArray[ct + 2] = g;
				
				// todo: use standard RGBA
				fgArray[ct + 3] = ((c >> 16) & 0xff) * (1 / 255);
				fgArray[ct + 4] = ((c >> 8) & 0xff) * (1 / 255);
				fgArray[ct + 5] = (c & 0xff) * (1 / 255);
			}
		}		
		
		font.sheet.drawTiles(graphics, fgArray, false, Tilesheet.TILE_RGB);
	}
}