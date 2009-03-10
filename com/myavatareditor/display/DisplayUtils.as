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
	
	import flash.display.DisplayObject
	
	/**
	 * A collection of utilities for working with display objects.
	 */
	public class DisplayUtils {
		
	
		/**
		 * Finds an display object ancestor (parent) of
		 * the specified type.  If the start object is
		 * of the specified type, it is returned, otherwise
		 * its parents are recursively checked.  The first
		 * match found will be returned.
		 * @param	type The type of object to find in the
		 * ancestor hierarchy.
		 * @param	start The starting display object to 
		 * begin searching for an object of the specified type.
		 * @return A display object reference in the parent
		 * hierarchy that matches the specified type. If no
		 * match was found, null is returned.
		 */
		public static function findAncestorByType(type:Class, start:DisplayObject):DisplayObject {
			while (start) {
				if (start is type) return start;
				start = start.parent;
			}
			return null;
		}
		
	}
	
}