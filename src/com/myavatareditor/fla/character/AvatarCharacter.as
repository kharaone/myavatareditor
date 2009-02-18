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
	
	import com.myavatareditor.data.AvatarData;
	import com.myavatareditor.data.Range;
	import com.myavatareditor.data.parsers.ConsoleBinary;
	import com.myavatareditor.geom.ColorUtils;
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * Physical avatar character class.  This represents the
	 * graphics containing all avatar characteristics.
	 */
	public class AvatarCharacter extends Sprite {
		
		// number of assets: 8+(12*8)+((12*6)-1)+((12*2)-1)+(12*4)+12+(12*2)+(9-1)+(4-1)+1+((4-1)*8) = 318
		
		private static const origin:Point				= new Point(0, 0);
		private static const HEAD_TYPE_COUNT:int		= 8;
		private static const SHADED_GLASSES_FRAME:int	= 7;
		private static const HEAD_OFFSETS:Array			= [80,77,94,86,83,77,93,96];
			// Depths
		private static const MAX_FACE_DEPTH:int			= 10; // highest depth by which hair and eye/eyebrows are based
		private static const MIN_X_BELOW_HAIR:int		= 37; // boundary for being outside hair
		private static const MAX_Y_BELOW_HAIR:int		= -67; // boundary for being outside hair
		
		/**
		 * Characteristic values in these arrays are the array indices.
		 * The values are the frames.
		 */
		public static const valueToFrameLookup:Object = {
			eyeType:		[3,7,1,43,2,25,30,37,4,17,46,14,18,27,47,10,9,6,34,15,12,21,45,19,31,22,8,11,35,42,32,33,16,13,20,24,28,29,39,5,23,26,40,44,38,41,36,48],
			eyebrowType:	[2,4,15,16,12,11,1,7,9,5,14,13,3,20,17,19,23,10,22,6,18,8,21,24],
			hairType:		[60,43,66,50,41,45,53,48,46,64,52,55,37,38,49,71,62,57,65,44,54,59,51,28,70,42,40,47,67,72,34,12,13,1,36,58,31,15,26,5,2,32,27,25,4,7,63,14,16,8,20,3,18,68,30,21,10,35,19,9,23,61,24,56,22,33,17,29,11,39,6,69],
			noseType:		[6,1,3,4,8,7,5,11,9,10,2,12],
			mouthType:		[7,2,15,17,18,6,11,13,8,14,9,20,24,12,23,19,10,16,22,3,21,4,5,1]
		};	
			
		// based on right eye from center of head (origin)
		private static const rangesGUI:Object = {
			eyeSize:			new Range(.26,  1),
			eyeX:				new Range(0,    54),
			eyeY:				new Range(-69,  35),
			eyeRotation:		new Range(-81.5, 0),
			eyebrowRotation:	new Range(-125,  0),
			eyebrowSize:		new Range(.25,   1),
			eyebrowX:			new Range(0,     52.5),
			eyebrowY:			new Range(-59,   25),
			glassesSize:		new Range(.4,    1.46),
			glassesY:			new Range(-47,   49),
			moleSize:			new Range(.4,    1.25),
			moleX:				new Range(-71,   71),
			moleY:				new Range(-60,   100),
			mouthSize:			new Range(.218,  1),
			mouthY:				new Range(-11,   89), 
			mustacheSize:		new Range(.25,   1),
			mustacheY:			new Range(0,     86), 
			noseSize:			new Range(.2,    1),
			noseY:				new Range(-10,   70)
		};
		private static const rangesData:Object = {
			gender:				new Range(0, 1),
			mingles:			new Range(0, 1),
			birthDay:			new Range(ConsoleBinary.BIRTH_DAY_MIN, ConsoleBinary.BIRTH_DAY_MAX),
			birthMonth:			new Range(ConsoleBinary.BIRTH_MONTH_MIN, ConsoleBinary.BIRTH_MONTH_MAX),
			favoriteColor:		new Range(ConsoleBinary.FAVORITE_COLOR_MIN, ConsoleBinary.FAVORITE_COLOR_MAX),
			
			height:				new Range(ConsoleBinary.HEIGHT_MIN, ConsoleBinary.HEIGHT_MAX),
			weight:				new Range(ConsoleBinary.WEIGHT_MIN, ConsoleBinary.WEIGHT_MAX),
			
			beardColor:			new Range(ConsoleBinary.BEARD_COLOR_MIN, ConsoleBinary.BEARD_COLOR_MAX),
			beardType:			new Range(ConsoleBinary.BEARD_TYPE_MIN, ConsoleBinary.BEARD_TYPE_MAX),
			eyeColor:			new Range(ConsoleBinary.EYE_COLOR_MIN, ConsoleBinary.EYE_COLOR_MAX),
			eyeRotation:		new Range(ConsoleBinary.EYE_ROTATION_MIN, ConsoleBinary.EYE_ROTATION_MAX),
			eyeSize:			new Range(ConsoleBinary.EYE_SIZE_MIN, ConsoleBinary.EYE_SIZE_MAX),
			eyeType:			new Range(ConsoleBinary.EYE_TYPE_MIN, ConsoleBinary.EYE_TYPE_MAX),
			eyeX:				new Range(ConsoleBinary.EYE_X_MIN, ConsoleBinary.EYE_X_MAX),
			eyeY:				new Range(ConsoleBinary.EYE_Y_MIN, ConsoleBinary.EYE_Y_MAX),
			eyebrowColor:		new Range(ConsoleBinary.EYEBROW_COLOR_MIN, ConsoleBinary.EYEBROW_COLOR_MAX),
			eyebrowRotation:	new Range(ConsoleBinary.EYEBROW_ROTATION_MIN, ConsoleBinary.EYEBROW_ROTATION_MAX),
			eyebrowSize:		new Range(ConsoleBinary.EYEBROW_SIZE_MIN, ConsoleBinary.EYEBROW_SIZE_MAX),
			eyebrowType:		new Range(ConsoleBinary.EYEBROW_TYPE_MIN, ConsoleBinary.EYEBROW_TYPE_MAX),
			eyebrowX:			new Range(ConsoleBinary.EYEBROW_X_MIN, ConsoleBinary.EYEBROW_X_MAX),
			eyebrowY:			new Range(ConsoleBinary.EYEBROW_Y_MIN, ConsoleBinary.EYEBROW_Y_MAX),
			faceType:			new Range(ConsoleBinary.FACE_TYPE_MIN, ConsoleBinary.FACE_TYPE_MAX),
			glassesColor:		new Range(ConsoleBinary.GLASSES_COLOR_MIN, ConsoleBinary.GLASSES_COLOR_MAX),
			glassesSize:		new Range(ConsoleBinary.GLASSES_SIZE_MIN, ConsoleBinary.GLASSES_SIZE_MAX),
			glassesType:		new Range(ConsoleBinary.GLASSES_TYPE_MIN, ConsoleBinary.GLASSES_TYPE_MAX),
			glassesY:			new Range(ConsoleBinary.GLASSES_Y_MIN, ConsoleBinary.GLASSES_Y_MAX),
			hairColor:			new Range(ConsoleBinary.HAIR_COLOR_MIN, ConsoleBinary.HAIR_COLOR_MAX),
			hairPart:			new Range(ConsoleBinary.HAIR_PART_MIN, ConsoleBinary.HAIR_PART_MAX),
			hairType:			new Range(ConsoleBinary.HAIR_TYPE_MIN, ConsoleBinary.HAIR_TYPE_MAX),
			headType:			new Range(ConsoleBinary.HEAD_TYPE_MIN, ConsoleBinary.HEAD_TYPE_MAX),
			moleSize:			new Range(ConsoleBinary.MOLE_SIZE_MIN, ConsoleBinary.MOLE_SIZE_MAX),
			moleType:			new Range(ConsoleBinary.MOLE_TYPE_MIN, ConsoleBinary.MOLE_TYPE_MAX),
			moleX:				new Range(ConsoleBinary.MOLE_X_MIN, ConsoleBinary.MOLE_X_MAX),
			moleY:				new Range(ConsoleBinary.MOLE_Y_MIN, ConsoleBinary.MOLE_Y_MAX),
			mouthColor:			new Range(ConsoleBinary.MOUTH_COLOR_MIN, ConsoleBinary.MOUTH_COLOR_MAX),
			mouthSize:			new Range(ConsoleBinary.MOUTH_SIZE_MIN, ConsoleBinary.MOUTH_SIZE_MAX),
			mouthType:			new Range(ConsoleBinary.MOUTH_TYPE_MIN, ConsoleBinary.MOUTH_TYPE_MAX),
			mouthY:				new Range(ConsoleBinary.MOUTH_Y_MIN, ConsoleBinary.MOUTH_Y_MAX), 
			mustacheSize:		new Range(ConsoleBinary.MUSTACHE_SIZE_MIN, ConsoleBinary.MUSTACHE_SIZE_MAX),
			mustacheType:		new Range(ConsoleBinary.MUSTACHE_TYPE_MIN, ConsoleBinary.MUSTACHE_TYPE_MAX),
			mustacheY:			new Range(ConsoleBinary.MUSTACHE_Y_MIN, ConsoleBinary.MUSTACHE_Y_MAX),
			noseSize:			new Range(ConsoleBinary.NOSE_SIZE_MIN, ConsoleBinary.NOSE_SIZE_MAX),
			noseType:			new Range(ConsoleBinary.NOSE_TYPE_MIN, ConsoleBinary.NOSE_TYPE_MAX),
			noseY:				new Range(ConsoleBinary.NOSE_Y_MIN, ConsoleBinary.NOSE_Y_MAX),
			skinColor:			new Range(ConsoleBinary.SKIN_COLOR_MIN, ConsoleBinary.SKIN_COLOR_MAX)
		};
		
		public static const skinColors:Array = [
			new ColorTransform(0.88, 0.85, 0.8, 1, 235, 205, 187, 0),
			new ColorTransform(-0.02, 0.23, 0.39, 1, 248, 187, 124, 0),
			new ColorTransform(0.13, 0.42, 0.44, 1, 214, 134, 71, 0),
			new ColorTransform(-0.02, 0.28, 0.38, 1, 246, 174, 136, 0),
			new ColorTransform(0.42, 0.44, 0.45, 1, 142, 73, 31, 0),
			new ColorTransform(0.44, 0.44, 0.43, 1, 72, 38, 13, 0),
		];
		public static const hairColors:Array = [
			new ColorTransform(0.43, 0.43, 0.42, 1, 15, 14, 12, 0),
			new ColorTransform(0.44, 0.44, 0.45, 1, 46, 25, 6, 0),
			new ColorTransform(0.4, 0.4, 0.39, 1, 82, 37, 14, 0),
			new ColorTransform(0.43, 0.43, 0.43, 1, 102, 56, 22, 0),
			new ColorTransform(0.43, 0.43, 0.43, 1, 105, 106, 108, 0),
			new ColorTransform(0.43, 0.42, 0.42, 1, 61, 44, 14, 0),
			new ColorTransform(0.44, 0.44, 0.44, 1, 113, 82, 25, 0),
			new ColorTransform(0.24, 0.37, 0.42, 1, 185, 149, 87, 0),
		];
		public static const eyebrowColors:Array = hairColors;
		public static const beardColors:Array = hairColors;
		public static const eyeColors:Array = [
			new ColorTransform(0, 0, 0, 1, 0, 0, 0, 0),
			new ColorTransform(0.09, 0.11, 0.1, 1, 109, 123, 124, 0), 
			new ColorTransform(0.22, 0.24, 0.25, 1, 108, 80, 65, 0), 
			new ColorTransform(0.13, 0.14, 0.22, 1, 122, 122, 40, 0),
			new ColorTransform(0.21, 0.21, 0.27, 1, 84, 110, 180, 0),
			new ColorTransform(0.16, 0.15, 0.11, 1, 48, 140, 79, 0),
		];
		public static const mouthColors:Array = [
			new ColorTransform(.7, 0.6, 0.55, 1, 180, 69, 35, 0),
			new ColorTransform(1, 0.45, 0.3, 1, 220, 51, 40, 0),
			new ColorTransform(1, 0.6, 0.6, 1, 197, 84, 86, 0),
		];
		public static const glassesColors:Array = [
			new ColorTransform(0.17, 0.18, 0.18, 1, 76, 85, 84, 0), 
			new ColorTransform(0.28, 0.31, 0.37, 1, 105, 81, 21, 0), 
			new ColorTransform(0.09, 0.37, 0.41, 1, 163, 43, 16, 0), 
			new ColorTransform(0.37, 0.31, 0.19, 1, 23, 69, 128, 0), 
			new ColorTransform(0.15, 0.19, 0.29, 1, 169, 107, 8, 0), 
			new ColorTransform(0.21, 0.22, 0.24, 1, 171, 172, 164, 0),
		];
		public static const favoriteColors:Array = [
			new ColorTransform(0.9911, 0.47, 0.51, 1, 191, 38, 2, 0),	// red
			new ColorTransform(0.05, 0.37, 0.44, 1, 240, 128, 42, 0),	// orange
			new ColorTransform(0.32, 0.47, 0.55, 1, 235, 190, 27, 0),	// yellow
			new ColorTransform(0.53, 0.52, 0.53, 1, 131, 167, 19, 0),	// light green
			new ColorTransform(0.58, 0.47, 0.47, 1, 1, 82, 28, 0),		// dark green
			new ColorTransform(0.42, 0.43, 0.22, 1, 5, 41, 151, 0),		// blue
			new ColorTransform(0.51, 0.42, 0.36, 1, 78, 142, 199, 0),	// light blue
			new ColorTransform(0.35, 0.50, 0.50, 1, 241, 96, 96, 0),	// pink
			new ColorTransform(0.38, 0.48, 0.32, 1, 93, 30, 153, 0),	// purple
			new ColorTransform(0.40, 0.42, 0.42, 1, 82, 53, 22, 0),		// brown
			new ColorTransform(0.45, 0.45, 0.45, 1, 190, 190, 190, 0),	// white
			new ColorTransform(0.8, 0.8, 0.8, 1, 5, 5, 5, 0),			// black
		];
		
		/**
		 * Assures that a value for the property of the specified name is
		 * within the allowed limits.  If not, the value is "clamped" to
		 * be within the limits and returned.
		 * @param	name
		 * @param	value
		 * @return
		 */
		public static function clampValue(name:String, value:int):int {
			if (!name) return value;
			if (name in rangesData){
				var range:Range = Range(rangesData[name]);
				return range.clamp(value);
			}
			return value;
		}
		
		/**
		 * Takes the frame of a Avatar characteristic and
		 * converts it into a Avatar data value based on 
		 * the valueToFrameLookup hash
		 */
		public static function frameToValue(name:String, frame:int):int {
			return name in AvatarCharacter.valueToFrameLookup
				? AvatarCharacter.valueToFrameLookup[name].indexOf(frame)
				: frame - 1; // values are 0-based, frames start at 1
		}
		
		/**
		 * Takes the frame of a Avatar characteristic and
		 * converts it into a Avatar data value based on 
		 * the valueToFrameLookup hash
		 */
		public static function valueToFrame(name:String, value:int):int {
			return name in AvatarCharacter.valueToFrameLookup
				? int(AvatarCharacter.valueToFrameLookup[name][value])
				: value + 1; // values are 0-based, frames start at 1
		}
		
		public static function setValueInRange(name:String, value:*, avatarData:AvatarData):void {
			if (name in avatarData == false) return;
			
			switch(name) {
				case "name":
					if (value is String){
						if (value.length > ConsoleBinary.NAME_MAX){
							value = String(value).substr(0, ConsoleBinary.NAME_MAX);
						}
					}
					break;
					
				case "creatorName":
					if (value is String){
						if (value.length > ConsoleBinary.CREATOR_NAME_MAX){
							value = String(value).substr(0, ConsoleBinary.CREATOR_NAME_MAX);
						}
					}
					break;
					
				case "id":
				case "client":
					value = (value is String) 
						? convertHexString(value)
						: uint(value);
					break;
					
				default:
					value = parseInt(value, 10);
					// if you want to exit on NaN, here is your chance
					value = clampValue(name, int(value));
					break;
			}
			
			try {
				avatarData[name] = value;
			}catch (error:Error){}
			
		}
		
		/**
		 * Converts a hexadecimal string into an uint.
		 * @param	hex
		 * @return String in its converted uint value
		 */
		public static function convertHexString(hex:String):uint {
			hex = hex.replace(/-/g, "");
			return uint(parseInt(hex, 16));
		}
		
		
		// stage instances
		public var body:MovieClip;
		public var head:MovieClip;
		public var headback:MovieClip;
		public var shadow:MovieClip;
		
		public var bodyController:AvatarBody;
		
		/**
		 * Avatar data relating to the avatar being displayed.
		 */
		public function get avatarData():AvatarData {
			return _avatarData;
		}
		public function set avatarData(value:AvatarData):void {
			_avatarData = value;
			draw();
		}
		private var _avatarData:AvatarData = new AvatarData();

		public function AvatarCharacter() {
			bodyController = new AvatarBody(this);
		}
	
		/**
		 * Updates the graphics of the current instance
		 * to match those of the AvatarData instance
		 * defined in the avatarData property.  Updates are not
		 * automatic and this method must be called to 
		 * see visually changes made in the character.
		 */
		public function draw():void {
			if (!_avatarData) return;
			
			// Body is drawn first to make sure it has its
			// feet planted in the correct position
			// the head is then positioned on to that
			bodyController.draw();
			
			var value:*;
			
			// Frames
			var frame:int;
			
			var faceFrame:int = valueToFrame("headType", _avatarData.headType);
			head.face.gotoAndStop(faceFrame);
			head.beard.gotoAndStop(_avatarData.beardType * HEAD_TYPE_COUNT + faceFrame);
			
			frame = valueToFrame("noseType", _avatarData.noseType);
			head.nose.gotoAndStop(frame);
			head.nose.skin.gotoAndStop(frame);
			frame = valueToFrame("mouthType", _avatarData.mouthType);
			head.mouth.gotoAndStop(frame);
			head.mouth.lips.gotoAndStop(frame);
			head.mustache.gotoAndStop(valueToFrame("mustacheType", _avatarData.mustacheType));
			head.mole.gotoAndStop(valueToFrame("moleType", _avatarData.moleType));
			
			value = _avatarData.faceType;
			head.features.gotoAndStop(value * HEAD_TYPE_COUNT + faceFrame);
			head.features.blendMode = (value < 3) ? BlendMode.NORMAL : BlendMode.MULTIPLY;
			
			frame = valueToFrame("hairType", _avatarData.hairType);
			head.hats.gotoAndStop(frame);
			head.hairFront.gotoAndStop(frame);
			headback.hair.gotoAndStop(frame);
			frame = valueToFrame("glassesType", _avatarData.glassesType)
			head.glasses.gotoAndStop(frame);
			head.glasses.lenses.gotoAndStop(frame);
			frame = valueToFrame("eyeType", _avatarData.eyeType);
			head.eyesRight.gotoAndStop(frame);
			head.eyesRight.eyeball.gotoAndStop(frame);
			head.eyesLeft.gotoAndStop(frame);
			head.eyesLeft.eyeball.gotoAndStop(frame);
			frame = valueToFrame("eyebrowType", _avatarData.eyebrowType);
			head.eyebrowsRight.gotoAndStop(frame);
			head.eyebrowsLeft.gotoAndStop(frame);
				
			// Colors
			var col:ColorTransform;
			
			col = getColor("skinColor");
			head.face.transform.colorTransform = col;
			head.nose.skin.transform.colorTransform = col;
			col = getColor("glassesColor");
			head.glasses.lenses.transform.colorTransform = col
			head.glasses.transform.colorTransform = (head.glasses.currentFrame < SHADED_GLASSES_FRAME)
				? col
				: new ColorTransform();
			col = getColor("favoriteColor");
			head.hats.transform.colorTransform = col;
			col = getColor("hairColor");
			head.hairFront.transform.colorTransform = col;
			headback.hair.transform.colorTransform = col;
			col = getColor("eyebrowColor");
			head.eyebrowsRight.transform.colorTransform = col;
			head.eyebrowsLeft.transform.colorTransform = col;
			col = getColor("eyeColor");
			head.eyesRight.eyeball.transform.colorTransform = col;
			head.eyesLeft.eyeball.transform.colorTransform = col;
			col = getColor("beardColor");
			head.mustache.transform.colorTransform = col;
			head.beard.transform.colorTransform = col;
			col = getColor("mouthColor");
			head.mouth.lips.transform.colorTransform = ColorUtils.reduceColor(col, .4);
			bodyController.updateColors();
			
			
			// Positioning
			var num:Number;
			
			var eyeXPos:Number		= getRangeValue("eyeX");
			head.eyesRight.x		= origin.x + eyeXPos;
			head.eyesLeft.x			= origin.x - eyeXPos;
			var eyeYPos:Number		= origin.y + getRangeValue("eyeY");
			head.eyesRight.y		= eyeYPos;
			head.eyesLeft.y			= eyeYPos;
			var eyebrowXPos:Number	= getRangeValue("eyebrowX");
			head.eyebrowsRight.x	= origin.x + eyebrowXPos;
			head.eyebrowsLeft.x		= origin.x - eyebrowXPos;
			var eyebrowYPos:Number	= origin.y + getRangeValue("eyebrowY");
			head.eyebrowsRight.y	= eyebrowYPos;
			head.eyebrowsLeft.y		= eyebrowYPos;
			head.nose.y				= origin.y + getRangeValue("noseY");
			head.mouth.y			= origin.y + getRangeValue("mouthY");
			head.glasses.y			= origin.y + getRangeValue("glassesY");
			head.mole.x				= origin.x + getRangeValue("moleX");
			head.mole.y				= origin.y + getRangeValue("moleY");
			head.mustache.y			= origin.y + getRangeValue("mustacheY");
			
			// Sizing
			num = _avatarData.hairPart;
			head.hairFront.scaleX		= (num) ? -1 : 1;
			headback.hair.scaleX		= head.hairFront.scaleX;
			head.hats.scaleX			= head.hairFront.scaleX;
			num = getRangeValue("eyeSize");
			head.eyesRight.scaleX		= num;
			head.eyesRight.scaleY		= num;
			head.eyesLeft.scaleX		= num;
			head.eyesLeft.scaleY		= num;
			num = getRangeValue("eyebrowSize");
			head.eyebrowsRight.scaleX	= num;
			head.eyebrowsRight.scaleY	= num;
			head.eyebrowsLeft.scaleX	= num;
			head.eyebrowsLeft.scaleY	= num;
			num = getRangeValue("noseSize");
			head.nose.scaleX			= num;
			head.nose.scaleY			= num;
			num = getRangeValue("mouthSize");
			head.mouth.scaleX			= num;
			head.mouth.scaleY			= num;
			num = getRangeValue("glassesSize");
			head.glasses.scaleX			= num;
			head.glasses.scaleY			= num;
			num = getRangeValue("moleSize");
			head.mole.scaleX			= num;
			head.mole.scaleY			= num;
			num = getRangeValue("mustacheSize");
			head.mustache.scaleX		= num;
			head.mustache.scaleY		= num;
			
			
			// Rotation
			num = getRangeValue("eyeRotation");
			head.eyesRight.rotation		= -num;
			head.eyesLeft.rotation		= 180+num;
			num = getRangeValue("eyebrowRotation");
			head.eyebrowsRight.rotation	= -num;
			head.eyebrowsLeft.rotation	= 180+num;
			
			
			// Eyes/Eybrows below or above hair
			// first assume hair and hats are above eyes and eyebrows
			head.setChildIndex(head.eyesLeft, MAX_FACE_DEPTH);
			head.setChildIndex(head.eyesRight, MAX_FACE_DEPTH);
			head.setChildIndex(head.eyebrowsLeft, MAX_FACE_DEPTH);
			head.setChildIndex(head.eyebrowsRight, MAX_FACE_DEPTH);
			head.setChildIndex(head.hairFront, MAX_FACE_DEPTH);
			head.setChildIndex(head.hats, MAX_FACE_DEPTH);
			
			// place above hair if beyond X out
			if (eyeXPos > MIN_X_BELOW_HAIR || eyeYPos < MAX_Y_BELOW_HAIR) {
				head.setChildIndex(head.eyesLeft, MAX_FACE_DEPTH);
				head.setChildIndex(head.eyesRight, MAX_FACE_DEPTH);
			}
			if (eyebrowXPos > MIN_X_BELOW_HAIR || eyeYPos < MAX_Y_BELOW_HAIR) {
				head.setChildIndex(head.eyebrowsLeft, MAX_FACE_DEPTH);
				head.setChildIndex(head.eyebrowsRight, MAX_FACE_DEPTH);
			}
			
			// Updates the position of the head in relationship
			// to the location of the body.
			var loc:Point	= globalToLocal(bodyController.globalNeck);
			head.y			= loc.y - HEAD_OFFSETS[head.face.currentFrame - 1];
			headback.y		= head.y;
			
			// dispatch display list event for notification
			dispatchEvent(new Event("avatarDraw", true));
		}
		
		/**
		 * Gets the "range" value related to a property
		 * by name.  If not found, 0 is returned.
		 * @param name The name of the property to retrieve.
		 */
		public function getRangeValue(name:String):Number {
			try {
				var dataRange:Range	= Range(rangesData[name]);
				var guiRange:Range	= Range(rangesGUI[name]);
				var value:int		= int(_avatarData[name]);
				return guiRange.valueAt(dataRange.percentAt(value));
			}catch(error:Error){}
			
			return 0;
		}
		
		/**
		 * Gets the color of the specified color property
		 * as a ColorTransform instance.
		 */
		public function getColor(name:String):ColorTransform {
			// black for unknown color or error
			var defaultColor:ColorTransform = new ColorTransform();
			
			try {
				var value:int		= int(avatarData[name]);
				var colorMap:Array	= AvatarCharacter[name+"s"];
				return colorMap[value] || defaultColor;
			}catch(error:Error){}
			
			return defaultColor;
		}
		
	}
}