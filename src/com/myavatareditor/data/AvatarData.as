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
	 * Structure for storing characteristics of an avatar character.
	 */
	public class AvatarData {
					
		public var id:uint;
		public var clientID:uint;
					
		public var name:String = "";
		public var creatorName:String = "MAE";
		
		public var gender:int; // bool
		public var mingles:int; // bool
		public var favoriteColor:int;
		public var birthDay:int;
		public var birthMonth:int;
					
		public var height:int;
		public var weight:int;
					
		public var headType:int;
		public var skinColor:int;
		public var faceType:int;
					
		public var hairType:int;
		public var hairColor:int;
		public var hairPart:int;
					
		public var eyebrowType:int;
		public var eyebrowRotation:int;
		public var eyebrowColor:int;
		public var eyebrowSize:int;
		public var eyebrowX:int;
		public var eyebrowY:int = 3; // min is 3 in the binary
					
		public var eyeType:int;
		public var eyeRotation:int;
		public var eyeColor:int;
		public var eyeSize:int;
		public var eyeX:int;
		public var eyeY:int;
					
		public var noseType:int;
		public var noseSize:int;
		public var noseY:int;
					
		public var mouthType:int;
		public var mouthColor:int;
		public var mouthSize:int;
		public var mouthY:int;
					
		public var glassesType:int;
		public var glassesColor:int;
		public var glassesSize:int;
		public var glassesY:int;
					
		public var beardType:int;
		public var beardColor:int;
		public var mustacheSize:int;
		public var mustacheType:int;
		public var mustacheY:int;
					
		public var moleType:int;
		public var moleSize:int;
		public var moleX:int;
		public var moleY:int;
		
		public function AvatarData() {}
		
	}
}