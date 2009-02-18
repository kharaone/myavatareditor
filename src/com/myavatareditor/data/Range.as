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
package com.myavatareditor.data {
	
	/**
	 * Defines a numeric rannge by which a number
	 * can be constrained between a min and max value.
	 */
	public class Range {
		
		protected var _min:Number;
		protected var _max:Number;
		public var span:Number;
			
		public function get min():Number {
			return _min;
		}
		public function set min(n:Number):void {
			_min = n;
			updateSpan();
		}
		
		public function get max():Number {
			return _max;
		}
		public function set max(n:Number):void {
			_max = n;
			updateSpan();
		}
		
		public function Range(min:Number = 0, max:Number = 0) {
			_min = min;
			_max = max;
			updateSpan();
		}
		
		public function toString():String {
			return "[Range "+_min+", "+_max+"]";
		}
		
		/**
		 * In the case where min is greater than max,
		 * normalize will reverse those values to ensure
		 * min is, in fact, smaller.
		 */
		public function normalize():void {
			if (_min > _max) {
				var temp:Number = _min;
				_min = _max;
				_max = temp;
				updateSpan();
			}
		}
		
		/**
		 * Returns the passed value clamped within
		 * the range of the Range min and max values.
		 * If the value passed is greater than max, 
		 * max is returned. If the value is less than
		 * min, min is returned.  If the value is between
		 * min and max, the original value is returned.
		 */
		public function clamp(value:Number):Number {
			if (value < _min) return _min;
			if (value > _max) return _max;
			return value;
		}
		
		/**
		 * Returns the value within the range at the
		 * passed percent within the range.
		 */
		public function valueAt(percent:Number, useWholeNumbers:Boolean = false):Number {
			return useWholeNumbers
				? clamp(_min + Math.floor((span + 1) * percent))
				: clamp(_min + span * percent);
		}
		
		/**
		 * Returns the percent within the range that the
		 * passed value exists within the range.
		 */
		public function percentAt(value:Number):Number {
			if (span == 0) return 0;
			value = clamp(value);
			return (value - _min)/span;
		}
		
		/**
		 * Returns the step value of the value passed
		 * within the range or the value closest to the
		 * division with the range divided steps times.
		 */
		public function stepValue(value:Number, steps:int):Number {
			var clamped:Number = clamp(value);
			if (value != clamped) return clamped;
				
			if (steps < 2) {
				steps = 2;
			}
				
			var div:Number = span/(steps-1);
			var pos:Number = Math.round((value - _min)/div);
			return _min + pos * div;
		}
		
		private function updateSpan():void {
			span = _max - _min;
		}
	}
}