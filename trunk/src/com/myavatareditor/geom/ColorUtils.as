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
package com.myavatareditor.geom {
	
	import flash.geom.ColorTransform;
	
	/**
	 * Utilities relating to color.
	 */
	public class ColorUtils {
		
		/**
		 * Reduces the effects of a color transform
		 * by specified amount (0-1).
		 */
		public static function reduceColor(col:ColorTransform, amount:Number):ColorTransform {
			if (col == null) return new ColorTransform();
			amount = 1 - amount;
			return new ColorTransform(
				col.redMultiplier   - (col.redMultiplier   - 1) *amount,
				col.greenMultiplier - (col.greenMultiplier - 1) *amount,
				col.blueMultiplier  - (col.blueMultiplier  - 1) *amount,
				col.alphaMultiplier - (col.alphaMultiplier - 1) *amount,
				col.redOffset   *amount,
				col.greenOffset *amount,
				col.blueOffset  *amount,
				col.alphaOffset *amount
			);
		}
	}
	
}