package com.jdaydev.blitty;
import nme.display.BitmapInt32;
import nme.geom.Rectangle;
import nme.Assets;
import nme.display.Tilesheet;
import nme.display.BitmapData;
import nme.Lib;

class ConsoleFont 
{
	public var tw:Int;
	public var th:Int;
	public var numGlyphs:Int;
	
	public var sheet:Tilesheet;
	private var bmp:BitmapData;
	
	private var glyph_by_name:Hash<Int>;
	
	
	private function new(Bmp:BitmapData, Columns:Int, Rows:Int)
	{
		bmp = Bmp;
		sheet = splitBmp(bmp, Columns, Rows);
		
		glyph_by_name = new Hash<Int>();
	}
	
	public static function fromAsset(FontName:String, Columns:Int, Rows:Int) :ConsoleFont {
		return new ConsoleFont(Assets.getBitmapData(FontName), Columns, Rows);
	}
	
	public static function fromAssetTransparentBlack(FontName:String, Columns:Int, Rows:Int) :ConsoleFont {
		var asset:BitmapData = Assets.getBitmapData(FontName);
		var pixels:BitmapData = new BitmapData(asset.width, asset.height, true, 0xffffffff);
		
		// speed up with copyChannel, but lose flexibility?
		
		for (y in 0 ... pixels.height) {
			for (x in 0 ... pixels.width) {
				var p:BitmapInt32 = asset.getPixel(x, y);
			
				var r = ((p >> 16) & 0xff);
				var g = ((p >> 8) & 0xff);
				var b = ((p) & 0xff);
				
				var bright = Std.int((r + g + b) * (1 / 3));
				
				// todo: use standard RGBA
				pixels.setPixel32(x, y, (0xffffff) | (bright << 24));
			}
		}
		
		return new ConsoleFont(pixels, Columns, Rows);
	}
	
	private function splitBmp(bmp:BitmapData, w:Int, h:Int):Tilesheet {
		var tilesheet:Tilesheet = new Tilesheet(bmp);
		
		tw = Math.floor(bmp.width / w);
		th = Math.floor(bmp.height / h);
		
		for (y in 0 ... h) {
			for (x in 0 ... w) {
				tilesheet.addTileRect(new Rectangle(x * tw, y * th, tw, th));
			}
		}
		
		numGlyphs = w * h;
		
		return tilesheet;
	}
	
	private function averageColor(bmp:BitmapData, x1:Int, y1:Int):Int {
		var red:Float = 0.0;
		var green:Float = 0.0;
		var blue:Float = 0.0;
		
		for (y in 0 ... tw) {
			for (x in 0 ... tw) {
				var color = bmp.getPixel(x + x1, y + y1);
				
				red += (color & 0xff0000) >> 16;
				green += (color & 0x00ff00) >> 8;
				blue += (color & 0x0000ff);
			}
		}
		
		var area:Float = tw * tw;
		red /= area;
		green /= area;
		blue /=  area;
		
		return rgb(red, green, blue);
	}
	
	private function rgb(Red:Float, Green:Float, Blue:Float):Int {
		var r:Int = Math.floor(Red);
		var g:Int = Math.floor(Green);
		var b:Int = Math.floor(Blue);
		
		if (r < 0) r = 0;
		if (r > 255) r = 255;
		if (g < 0) g = 0;
		if (g > 255) g = 255;
		if (b < 0) b = 0;
		if (b > 255) b = 255;
		
		return (r << 16) | (g << 8) | (b);
	}
}