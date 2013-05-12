package com.jdaydev.blitty;

//import cpp.io.File;
import nme.display.Sprite;
import nme.display.Tilesheet;
import nme.display.BitmapData;
import nme.display.Graphics;
import nme.display.BitmapInt32;
//import nme.utils.ByteArray;


class Console extends Sprite
{
	static inline var floatsPerTile = 6;
	
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
	
	// low level arrays for the Tilesheet calls
	var fgArray:Array<Float>;
	var bgArray:Array<Float>;
	
	public function new(Font:ConsoleFont, ?Columns:Int = 80, ?Rows:Int = 24)
	{
		super();

		rows = 0;
		columns = 0;
		
		font = Font;
		
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
		
		rebuildTilesheetArrays();
	}
	
	
	private function rebuildTilesheetArrays():Void {
		fgArray = [];
		bgArray = [];
		
		var stw:Float = font.tw;
		var sth:Float = font.th;
		for (y in 0 ... rows) {
			for (x in 0 ... columns) {
				var ct:Int = floatsPerTile * index(x, y);
				fgArray[ct] = x * stw;
				fgArray[ct + 1] = y * sth;
				fgArray[ct + 2] = 0; // until we actually update from the map
				fgArray[ct + 3] = 0; // until we actually update from the map
				fgArray[ct + 4] = 0; // until we actually update from the map
				fgArray[ct + 5] = 0; // until we actually update from the map
			}
		}
		
		width = stw * columns;
		height = sth * rows;
	}
	
	/*public function unproject(x:Float, y:Float, out:Coord)
	{
		var fx:Float = (x - this.x) / scaledTileWidth;
		var fy:Float = (y - this.y) / scaledTileWidth;
		
		var tx:Int = Math.floor(fx);
		var ty:Int = Math.floor(fy);
		
		fx = (fx - tx);
		fy = (fy - ty);
		
		tx -= tx1;
		ty -= ty1;
		
		while (tx < 0) tx += map.width;
		while (tx >= map.width) tx -= map.width;
		
		if (out != null) {
			if (ty < 0 || ty >= map.height) {
				out.x = tx;
				out.y = ty;
				
				out.map = null;
			} else {
				out.x = tx;
				out.y = ty;
				out.setEdge(fx, fy);
				
				out.map = map;	
			}
		}
	}*/
	
	public function draw() {
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
