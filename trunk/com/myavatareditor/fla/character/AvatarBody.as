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
package com.myavatareditor.fla.character {
	
	import com.myavatareditor.data.Range;
	import com.myavatareditor.data.parsers.ConsoleBinary;
	import com.myavatareditor.fla.character.AvatarCharacter;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
	/**
	 * Manages the scaling of the Avatar body
	 */
	public class AvatarBody {
	
		/**
		 * global location of "neck" of an character 
		 * character, or where the head fits to the
		 * body.
		 */
		public function get globalNeck():Point {
			return shirt.torso.localToGlobal(bodyToNeckPt);
		}
		
		// Point locations used to position body
		// parts in relation to others as the
		// Avatar body changes in height and weight
			
		// body to head
		private var bodyToNeckPt:Point			= new Point(0, -75);
		
		// Upper body (based on right appendage)
		private var upperArmToTorsoPt:Point		= new Point(20, -64);
		private var lowerArmToUpperArmPt:Point	= new Point(50, 0);
		private var handToLowerArmPt:Point		= new Point(48, -1);
			
		// Lower body (based on right appendage)
		private var legToTorsoPt:Point			= new Point(20, 3);
		private var footToLegPt:Point			= new Point(-2, 95);

		// Scales for limits of sizing
		// for characteristics
		private var heightRange:Range			= new Range(.40, 1);
		private var weightRange:Range			= new Range(.45, 1);
		private var heightToWeightRange:Range	= new Range(.60, 1);
			
		// Colors
		private var favoriteColor:ColorTransform	= new ColorTransform(.28, .22, .22, 1, 110, 10, 10, 0);
		private var specialColor:ColorTransform		= new ColorTransform(.5, .5, .4, 1, 190, 155, 30, 0); // gold
		private var foreignColor:ColorTransform		= new ColorTransform(.4, .42, .48, 1, 50, 60, 120, 0); // blue
		private var normalColor:ColorTransform		= new ColorTransform(.4, .41, .44, 1, 40, 42, 50, 0); // same
		
		public var character:AvatarCharacter;
		public var shirt:MovieClip;
		public var pants:MovieClip;
		
		/**
		 * Constructor called within AvatarCharacter.
		 */
		public function AvatarBody(character:AvatarCharacter){
			this.character	= character;
			this.shirt		= character.body.shirt;
			this.pants		= character.body.pants;
		}
		
		/**
		 * Renders the body based on a hieght
		 * and weight.
		 */
		public function draw():void {
			updateScale(); // scale before position
			updatePosition();
		}
		
		/**
		 * Updates the colors of the pants and
		 * shirt to reflect the favorite color
		 * and whether or not the character is
		 * mingling (changes pants).  There is
		 * no consideration for special pants.
		 */
		public function updateColors():void {
			// get colors from favorite colors
			shirt.transform.colorTransform = character.getColor("favoriteColor"); // favorite
			
			// pants based on David Hawley's observations
			var pantsColor:ColorTransform;
			var characterID:Number;
			try {
				var id:uint = character.avatarData.id;
				
				// get first (left-most) hex pair
				characterID = id >>> 24;
				
				if (characterID >= 0xC0 && characterID <= 0xDF){
					pantsColor = foreignColor;
				}else if (characterID <= 0x1F || (characterID >= 0x40 && characterID <= 0x5F)){
					pantsColor = specialColor;
				}else{
					pantsColor = normalColor;
				}
				pants.transform.colorTransform = pantsColor;
				
			}catch (error:Error){}
		}
			
		private var scaleRatioH:Number;
		private var scaleRatioW:Number;
			
		public function updateScale():void {
			var scaleRatioHFactor:Number = character.avatarData.height/ConsoleBinary.HEIGHT_MAX;
			scaleRatioH = heightRange.valueAt(scaleRatioHFactor);
			scaleRatioW = weightRange.valueAt(character.avatarData.weight/ConsoleBinary.WEIGHT_MAX) * heightToWeightRange.valueAt(scaleRatioHFactor);
			
			// Shirt
			shirt.torso.scaleX = scaleRatioW;
			shirt.torso.scaleY = scaleRatioH;
			shirt.lowerarm_left.scaleX	= scaleRatioH;
			shirt.lowerarm_left.scaleY	= scaleRatioW;
			shirt.lowerarm_right.scaleX	= scaleRatioH;
			shirt.lowerarm_right.scaleY	= scaleRatioW;
			
			shirt.upperarm_left.scaleX	= scaleRatioH;
			shirt.upperarm_left.scaleY	= scaleRatioW;
			shirt.upperarm_right.scaleX	= scaleRatioH;
			shirt.upperarm_right.scaleY	= scaleRatioW;
			
			shirt.hand_left.scaleX	= scaleRatioW;
			shirt.hand_left.scaleY	= scaleRatioW;
			shirt.hand_right.scaleX	= scaleRatioW;
			shirt.hand_right.scaleY	= scaleRatioW;
			
			// Pants
			pants.torso.scaleX = scaleRatioW;
			pants.torso.scaleY = scaleRatioH;
			
			pants.leg_left.scaleX	= scaleRatioW;
			pants.leg_left.scaleY	= scaleRatioH;
			pants.leg_right.scaleX	= scaleRatioW;
			pants.leg_right.scaleY	= scaleRatioH;

			pants.foot_left.scaleX	= scaleRatioW;
			pants.foot_left.scaleY	= scaleRatioW;
			pants.foot_right.scaleX	= scaleRatioW;
			pants.foot_right.scaleY	= scaleRatioW;
		}
		
		public function updatePosition():void {
			var loc:Point;
			
			// Shirt
			// upper arms
			loc = shirt.globalToLocal(shirt.torso.localToGlobal(upperArmToTorsoPt));
			shirt.upperarm_left.x	= -loc.x;
			shirt.upperarm_right.x	= loc.x;
			shirt.upperarm_left.y	= loc.y;
			shirt.upperarm_right.y	= loc.y;
			
			// lower arms
			loc = shirt.globalToLocal(shirt.upperarm_right.localToGlobal(lowerArmToUpperArmPt));
			shirt.lowerarm_left.x	= -loc.x;
			shirt.lowerarm_right.x	= loc.x;
			shirt.lowerarm_left.y	= loc.y;
			shirt.lowerarm_right.y	= loc.y;
			
			// hands
			loc = shirt.globalToLocal(shirt.lowerarm_right.localToGlobal(handToLowerArmPt));
			shirt.hand_left.x	= -loc.x;
			shirt.hand_right.x	= loc.x;
			shirt.hand_left.y	= loc.y;
			shirt.hand_right.y	= loc.y;
			
			// shirt or dress
			var frame:Number = AvatarCharacter.valueToFrame("gender", character.avatarData.gender);
			shirt.torso.gotoAndStop(frame);
			
			// Pants
			// legs
			loc = pants.globalToLocal(pants.torso.localToGlobal(legToTorsoPt));
			pants.leg_left.x	= -loc.x;
			pants.leg_right.x	= loc.x;
			pants.leg_left.y	= loc.y;
			pants.leg_right.y	= loc.y;
			
			// feet
			loc = pants.globalToLocal(pants.leg_right.localToGlobal(footToLegPt));
			pants.foot_left.x	= -loc.x;
			pants.foot_right.x	= loc.x;
			pants.foot_left.y	= loc.y;
			pants.foot_right.y	= loc.y;
			
			// set body to reset on base footing (0,0)
			var bodyRect:Rectangle = character.body.getBounds(character);
			character.body.y -= bodyRect.bottom;
		}
	}
}