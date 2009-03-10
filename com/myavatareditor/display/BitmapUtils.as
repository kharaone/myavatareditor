/*
Copyright (c) 2009 Trevor McCauley

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE. 
*/
package com.myavatareditor.display {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Utility methods for working with bitmaps.
	 */
	public class BitmapUtils {
		
		/**
		 * Draws the content of a source display object centered
		 * within a target bitmap data instance.  The resulting
		 * bitmap can be scaled and offset (scale being applied
		 * prior to offset) within the target.  By default the 
		 * target bitmap is cleared first but this can be prevented
		 * by setting clearBitmap as false.
		 * @param	source
		 * @param	target
		 * @param	scale
		 * @param	offset
		 * @param	clearBitmap
		 */
		public static function drawCenteredIn(source:DisplayObject, target:BitmapData, scale:Number = 1, offset:Point = null, clearBitmap:Boolean = true):void {
			if (offset == null) offset = new Point(0, 0);
			if (clearBitmap) target.fillRect(target.rect, 0);
			var bounds:Rectangle = source.getBounds(source);
			target.draw(source, new Matrix(scale, 0, 0, scale,
				offset.x + target.width/2 - scale*(bounds.left + source.width/2),
				offset.y + target.height/2 - scale*(bounds.top + source.height/2)
			));
		}
		
		/**
		 * Creates and returns bitmap of the provided size and then
		 * uses drawCenteredIn to draw the source display object
		 * within the new bitmap.
		 * @param	source
		 * @param	width
		 * @param	height
		 * @param	scale
		 * @param	offset
		 * @param	transparent
		 * @param	backgroundColor
		 * @return	A BitmapData object of the size provided.
		 */
		public static function createCenteredBitmapData(source:DisplayObject, width:Number, height:Number, scale:Number = 1, offset:Point = null, transparent:Boolean = true, backgroundColor:uint = 0):BitmapData {
			var data:BitmapData = new BitmapData(width, height, transparent, backgroundColor);
			drawCenteredIn(source, data, scale, offset, false);
			return data;
		}
	}
}