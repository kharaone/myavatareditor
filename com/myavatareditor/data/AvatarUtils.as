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
	
	import com.myavatareditor.data.parsers.ConsoleBinary;
	
	/**
	 * Utilities methods and variables for working with avatar characters.
	 * Variables include constants for the default boy and default girl 
	 * avatars and methods include randomizing procedures.
	 */
	public class AvatarUtils {
		
		public function AvatarUtils() {}
		
		public static const DEFAULT_BOY:String	= "000000640065006600610075006c00740042006f0079404080807f5fc242899800044240318028a2088c08401448b88d008a008a25040000000000000000000000000000000000000000";
		public static const DEFAULT_GIRL:String	= "400000640065006600610075006c007400470072006c404080807f73c242899800041840018028a2106c08401448b88d008a008a25040000000000000000000000000000000000000000";

		public static const MALE_GENDER:int		= 0;
		public static const FEMALE_GENDER:int	= 1;
		public static const BEARD_NONE:int		= 0;
		public static const MUSTACHE_NONE:int	= 0;
		public static const MOLE_NONE:int		= 0;
		public static const GLASSES_NONE:int	= 0;
		
		/**
		 * Randomizes the properties of an AvatarCharacter instance. Three
		 * specific properties are not randomized: name, creatorName, and
		 * clientID. The name property is set to "Random", creatorName to "MAE"
		 * and clientID is left unchanged.
		 * @param	avatarData The avatarData to randomize.
		 */
		public static function randomize(avatarData:AvatarData):void {
			
			// predefined
			avatarData.id			= uint(Math.random() * 0xFFFFFFFF);
			avatarData.name			= "Random";
			avatarData.creatorName	= "MAE";
		
			avatarData.gender		= Math.random() < .5 ? 0 : 1;
			avatarData.favoriteColor	= randomInRange(ConsoleBinary.FAVORITE_COLOR_MIN, ConsoleBinary.FAVORITE_COLOR_MAX);
			avatarData.birthDay		= randomInRange(ConsoleBinary.BIRTH_DAY_MIN, ConsoleBinary.BIRTH_DAY_MAX);
			avatarData.birthMonth	= randomInRange(ConsoleBinary.BIRTH_MONTH_MIN, ConsoleBinary.BIRTH_MONTH_MAX);
					
			avatarData.height	= randomInRange(ConsoleBinary.HEIGHT_MIN, ConsoleBinary.HEIGHT_MAX);
			avatarData.weight	= randomInRange(ConsoleBinary.WEIGHT_MIN, ConsoleBinary.WEIGHT_MAX);
					
			avatarData.headType	= randomInRange(ConsoleBinary.HEAD_TYPE_MIN, ConsoleBinary.HEAD_TYPE_MAX);
			avatarData.skinColor	= randomInRange(ConsoleBinary.SKIN_COLOR_MIN, ConsoleBinary.SKIN_COLOR_MAX);
			avatarData.faceType	= randomInRange(ConsoleBinary.FACE_TYPE_MIN, ConsoleBinary.FACE_TYPE_MAX);
			avatarData.mingles	= Math.random() < .5 ? 0 : 1;
					
			avatarData.hairType	= randomInRange(ConsoleBinary.HAIR_TYPE_MIN, ConsoleBinary.HAIR_TYPE_MAX);
			avatarData.hairColor	= randomInRange(ConsoleBinary.HAIR_COLOR_MIN, ConsoleBinary.HAIR_COLOR_MAX);
			avatarData.hairPart	= Math.random() < .5 ? 0 : 1;
					
			avatarData.eyebrowType	= randomInRange(ConsoleBinary.EYEBROW_TYPE_MIN, ConsoleBinary.EYEBROW_TYPE_MAX);
			avatarData.eyebrowColor	= randomInRange(ConsoleBinary.EYEBROW_COLOR_MIN, ConsoleBinary.EYEBROW_COLOR_MAX);
			
			avatarData.eyebrowRotation	= randomInRange(ConsoleBinary.EYEBROW_ROTATION_MIN, ConsoleBinary.EYEBROW_ROTATION_MAX);
			avatarData.eyebrowSize	= randomInRange(ConsoleBinary.EYEBROW_SIZE_MIN, ConsoleBinary.EYEBROW_SIZE_MAX);
			avatarData.eyebrowX		= randomInRange(ConsoleBinary.EYEBROW_X_MAX, ConsoleBinary.EYEBROW_X_MAX);
			avatarData.eyebrowY		= randomInRange(ConsoleBinary.EYEBROW_Y_MIN, ConsoleBinary.EYEBROW_Y_MAX);
					
			avatarData.eyeType	= randomInRange(ConsoleBinary.EYE_TYPE_MIN, ConsoleBinary.EYE_TYPE_MAX);
			avatarData.eyeColor	= randomInRange(ConsoleBinary.EYE_COLOR_MIN, ConsoleBinary.EYE_COLOR_MAX);
			
			avatarData.eyeRotation	= randomInRange(ConsoleBinary.EYE_ROTATION_MIN, ConsoleBinary.EYE_ROTATION_MAX);
			avatarData.eyeSize	= randomInRange(ConsoleBinary.EYE_SIZE_MIN, ConsoleBinary.EYE_SIZE_MAX);
			avatarData.eyeX		= randomInRange(ConsoleBinary.EYE_X_MIN, ConsoleBinary.EYE_X_MAX);
			avatarData.eyeY		= randomInRange(ConsoleBinary.EYE_Y_MIN, ConsoleBinary.EYE_Y_MAX);
					
			avatarData.noseType	= randomInRange(ConsoleBinary.NOSE_TYPE_MIN, ConsoleBinary.NOSE_TYPE_MAX);
			avatarData.noseSize	= randomInRange(ConsoleBinary.NOSE_SIZE_MIN, ConsoleBinary.NOSE_SIZE_MAX);
			avatarData.noseY		= randomInRange(ConsoleBinary.NOSE_Y_MIN, ConsoleBinary.NOSE_Y_MAX);
					
			avatarData.mouthType		= randomInRange(ConsoleBinary.MOUTH_TYPE_MIN, ConsoleBinary.MOUTH_TYPE_MAX);
			avatarData.mouthColor	= randomInRange(ConsoleBinary.MOUTH_COLOR_MIN, ConsoleBinary.MOUTH_COLOR_MAX);
			avatarData.mouthSize		= randomInRange(ConsoleBinary.MOUTH_SIZE_MIN, ConsoleBinary.MOUTH_SIZE_MAX);
			avatarData.mouthY		= randomInRange(ConsoleBinary.MOUTH_Y_MIN, ConsoleBinary.MOUTH_Y_MAX);
					
			avatarData.glassesColor	= randomInRange(ConsoleBinary.GLASSES_COLOR_MIN, ConsoleBinary.GLASSES_COLOR_MAX);
			
			avatarData.glassesType	= randomInRange(ConsoleBinary.GLASSES_TYPE_MIN, ConsoleBinary.GLASSES_TYPE_MAX);
			avatarData.glassesSize	= randomInRange(ConsoleBinary.GLASSES_SIZE_MIN, ConsoleBinary.GLASSES_SIZE_MAX);
			avatarData.glassesY		= randomInRange(ConsoleBinary.GLASSES_Y_MIN, ConsoleBinary.GLASSES_Y_MAX);
				
			avatarData.beardColor	= randomInRange(ConsoleBinary.BEARD_COLOR_MIN, ConsoleBinary.BEARD_COLOR_MAX);
			avatarData.beardType		= randomInRange(ConsoleBinary.BEARD_TYPE_MIN, ConsoleBinary.BEARD_TYPE_MAX);
			avatarData.mustacheSize	= randomInRange(ConsoleBinary.MUSTACHE_SIZE_MIN, ConsoleBinary.MUSTACHE_SIZE_MAX);
			avatarData.mustacheType	= randomInRange(ConsoleBinary.MUSTACHE_TYPE_MIN, ConsoleBinary.MUSTACHE_TYPE_MAX);
			avatarData.mustacheY		= randomInRange(ConsoleBinary.MUSTACHE_Y_MIN, ConsoleBinary.MUSTACHE_Y_MAX);
			
			avatarData.moleType	= randomInRange(ConsoleBinary.MOLE_TYPE_MIN, ConsoleBinary.MOLE_TYPE_MAX);
			avatarData.moleSize	= randomInRange(ConsoleBinary.MOLE_SIZE_MIN, ConsoleBinary.MOLE_SIZE_MAX);
			avatarData.moleX		= randomInRange(ConsoleBinary.MOLE_Y_MIN, ConsoleBinary.MOLE_Y_MAX);
			avatarData.moleY		= randomInRange(ConsoleBinary.MOLE_Y_MIN, ConsoleBinary.MOLE_Y_MAX);
		}
		
		/**
		 * Randomizes the properties of an AvatarCharacter instance in an intelligent
		 * manner. Unlike randomize(), this form will produce more "normal. results.
		 * Three specific properties are not randomized: name, creatorName, and
		 * clientID. The name property is set to "Random", creatorName to "MAE"
		 * and clientID is left unchanged.
		 * @param	avatarData The avatarData to randomize.
		 */
		public static function smartRandomize(avatarData:AvatarData):void {
			
			var favorBy:Number;
					
			// predefined
			avatarData.id				= uint(Math.random() * 0xFFFFFFFF);
			avatarData.name				= "Random";
			avatarData.creatorName		= "MAE";
		
			// completely random
			avatarData.gender			= Math.random() < .5 ? 0 : 1;
			// completely random
			avatarData.favoriteColor	= randomInRange(ConsoleBinary.FAVORITE_COLOR_MIN, ConsoleBinary.FAVORITE_COLOR_MAX);
			// completely random + 1 on min so its not empty
			avatarData.birthDay			= randomInRange(ConsoleBinary.BIRTH_DAY_MIN + 1, ConsoleBinary.BIRTH_DAY_MAX);
			// completely random + 1 on min so its not empty
			avatarData.birthMonth		= randomInRange(ConsoleBinary.BIRTH_MONTH_MIN + 1, ConsoleBinary.BIRTH_MONTH_MAX);
					
			// completely random
			avatarData.height		= randomInRange(ConsoleBinary.HEIGHT_MIN, ConsoleBinary.HEIGHT_MAX);
			// completely random
			avatarData.weight		= randomInRange(ConsoleBinary.WEIGHT_MIN, ConsoleBinary.WEIGHT_MAX);
					
			// completely random
			avatarData.headType		= randomInRange(ConsoleBinary.HEAD_TYPE_MIN, ConsoleBinary.HEAD_TYPE_MAX);
			// completely random
			avatarData.skinColor	= randomInRange(ConsoleBinary.SKIN_COLOR_MIN, ConsoleBinary.SKIN_COLOR_MAX);
			// completely random
			avatarData.faceType		= randomInRange(ConsoleBinary.FACE_TYPE_MIN, ConsoleBinary.FACE_TYPE_MAX);
			
			// favor mingles... a little (0 = does mingle)
			avatarData.mingles		= Math.random() < .666 ? 0 : 1;
					
			// completely random
			avatarData.hairType		= randomInRange(ConsoleBinary.HAIR_TYPE_MIN, ConsoleBinary.HAIR_TYPE_MAX);
			// completely random
			avatarData.hairColor	= randomInRange(ConsoleBinary.HAIR_COLOR_MIN, ConsoleBinary.HAIR_COLOR_MAX);
			// completely random
			avatarData.hairPart	= Math.random() < .5 ? 0 : 1;
					
			// completely random
			avatarData.eyeType		= randomInRange(ConsoleBinary.EYE_TYPE_MIN, ConsoleBinary.EYE_TYPE_MAX);
			// completely random
			avatarData.eyeColor		= randomInRange(ConsoleBinary.EYE_COLOR_MIN, ConsoleBinary.EYE_COLOR_MAX);
			// keep eye rotation middle of the road
			avatarData.eyeRotation	= randomFavorArea(ConsoleBinary.EYE_ROTATION_MIN, ConsoleBinary.EYE_ROTATION_MAX, .5);
			// keep eye size middle of the road
			avatarData.eyeSize		= randomFavorArea(ConsoleBinary.EYE_SIZE_MIN+2, ConsoleBinary.EYE_SIZE_MAX-2, .5);
			// keep eye x low (inward)
			avatarData.eyeX			= randomFavorArea(ConsoleBinary.EYE_X_MIN+2, ConsoleBinary.EYE_X_MAX-5, .333);
			// keep eye y low (visually high)
			avatarData.eyeY			= randomFavorArea(ConsoleBinary.EYE_Y_MIN+3, ConsoleBinary.EYE_Y_MAX-1, .333);
					
			// completely random
			avatarData.eyebrowType		= randomInRange(ConsoleBinary.EYEBROW_TYPE_MIN, ConsoleBinary.EYEBROW_TYPE_MAX);
			// 50% chance of eyebrow color matching hair color
			favorBy						= .5;
			avatarData.eyebrowColor		= randomFavorOne(ConsoleBinary.EYEBROW_COLOR_MIN, ConsoleBinary.EYEBROW_COLOR_MAX, avatarData.hairColor, favorBy);
			// eyebrow rotation near eye rotation
			avatarData.eyebrowRotation	= randomAroundValue(ConsoleBinary.EYEBROW_ROTATION_MIN, ConsoleBinary.EYEBROW_ROTATION_MAX, avatarData.eyeRotation, 1, 4);
			// eyebrow size near eye size
			avatarData.eyebrowSize		= randomAroundValue(ConsoleBinary.EYEBROW_SIZE_MIN, ConsoleBinary.EYEBROW_SIZE_MAX, avatarData.eyeSize, 3, 3);
			// eyebrow x near eye x
			avatarData.eyebrowX			= randomAroundValue(ConsoleBinary.EYEBROW_X_MAX, ConsoleBinary.EYEBROW_X_MAX, avatarData.eyeX, 3, 3);
			// eyebrow y near eye y but not above (not visually below)
			avatarData.eyebrowY			= randomAroundValue(ConsoleBinary.EYEBROW_Y_MIN, ConsoleBinary.EYEBROW_Y_MAX, avatarData.eyeY, 6, 0);
					
			// completely random
			avatarData.noseType		= randomInRange(ConsoleBinary.NOSE_TYPE_MIN, ConsoleBinary.NOSE_TYPE_MAX);
			// keep eye size middle of the road
			avatarData.noseSize		= randomFavorArea(ConsoleBinary.NOSE_SIZE_MIN+3, ConsoleBinary.NOSE_SIZE_MAX-1, .5);
			// keep nose y low (visually high)
			avatarData.noseY		= randomFavorArea(ConsoleBinary.NOSE_Y_MIN+1, ConsoleBinary.NOSE_Y_MAX-3, .25);
					
			// completely random
			avatarData.mouthType	= randomInRange(ConsoleBinary.MOUTH_TYPE_MIN, ConsoleBinary.MOUTH_TYPE_MAX);
			// completely random
			avatarData.mouthColor	= randomInRange(ConsoleBinary.MOUTH_COLOR_MIN, ConsoleBinary.MOUTH_COLOR_MAX);
			// keep mouth size middle of the road
			avatarData.mouthSize	= randomFavorArea(ConsoleBinary.MOUTH_SIZE_MIN+1, ConsoleBinary.MOUTH_SIZE_MAX-1, .5);
			// mouth y near nose y, but not below (not visually above)
			avatarData.mouthY		= randomAroundValue(ConsoleBinary.MOUTH_Y_MIN, ConsoleBinary.MOUTH_Y_MAX, avatarData.noseY+1, 0, 5);
					
			// completely random
			avatarData.glassesColor	= randomInRange(ConsoleBinary.GLASSES_COLOR_MIN, ConsoleBinary.GLASSES_COLOR_MAX);
			// 1/3 chance of getting glasses
			favorBy					= .666; // favor no glasses
			avatarData.glassesType	= randomFavorOne(ConsoleBinary.GLASSES_TYPE_MIN, ConsoleBinary.GLASSES_TYPE_MAX, GLASSES_NONE, favorBy);
			// glasses size to mostly match eyes x, smaller ok
			avatarData.glassesSize	= randomAroundValue(ConsoleBinary.GLASSES_SIZE_MIN, ConsoleBinary.GLASSES_SIZE_MAX, int(avatarData.eyeX/2), 1, 2);
			// eyebrow y near eye y but not much below (not visually above)
			avatarData.glassesY		= randomAroundValue(ConsoleBinary.GLASSES_Y_MIN, ConsoleBinary.GLASSES_Y_MAX, avatarData.eyeY, 1, 3);
				
			// 75% chance of beard color matching hair color
			favorBy					= .75;
			avatarData.beardColor	= randomFavorOne(ConsoleBinary.BEARD_COLOR_MIN, ConsoleBinary.BEARD_COLOR_MAX, avatarData.hairColor, favorBy);
			// 25% chance of getting beard, only if boy
			favorBy					= avatarData.gender == MALE_GENDER ? .75 : 1; // favor no beard
			avatarData.beardType	= randomFavorOne(ConsoleBinary.BEARD_TYPE_MIN, ConsoleBinary.BEARD_TYPE_MAX, BEARD_NONE, favorBy);
			
			// completely random
			avatarData.mustacheSize	= randomInRange(ConsoleBinary.MUSTACHE_SIZE_MIN+1, ConsoleBinary.MUSTACHE_SIZE_MAX);
			// 25% chance of getting mustache, only if boy
			// if boy has a beard, it goes up to 50% chance
			favorBy					= avatarData.gender == MALE_GENDER ? .75 : 1; // favor no mustache
			if (avatarData.beardType != BEARD_NONE) favorBy = .5;
			avatarData.mustacheType	= randomFavorOne(ConsoleBinary.MUSTACHE_TYPE_MIN, ConsoleBinary.MUSTACHE_TYPE_MAX, MUSTACHE_NONE, favorBy);
			// close to or above nose (visually below)
			avatarData.mustacheY	= randomAroundValue(ConsoleBinary.MUSTACHE_Y_MIN, ConsoleBinary.MUSTACHE_Y_MAX, avatarData.noseY, 0, 3);
			
			// 10% likely to have a mole ("beauty mark") if male, 25% if female
			favorBy					= (avatarData.gender == MALE_GENDER) ? .9 : .75; // for no mole
			avatarData.moleType		= randomFavorOne(ConsoleBinary.MOLE_TYPE_MIN, ConsoleBinary.MOLE_TYPE_MAX, MOLE_NONE, favorBy);
			// favor smaller mole
			avatarData.moleSize		= randomFavorArea(ConsoleBinary.MOLE_SIZE_MIN, ConsoleBinary.MOLE_SIZE_MAX-2, .333);
			// keep mole x middle of the road
			avatarData.moleX		= randomFavorArea(ConsoleBinary.MOLE_X_MIN+2, ConsoleBinary.MOLE_X_MAX-2, .5);
			// keep mole y middle of the road
			avatarData.moleY		= randomFavorArea(ConsoleBinary.MOLE_Y_MIN, ConsoleBinary.MOLE_Y_MAX-3, .5);
		}
		
		public static function randomInRange(min:int, max:int):int {
			return min + int(Math.random() * (1 + max - min));
		}
		
		/**
		 * Returns a random number in a range with a particular value in that range
		 * favored over all others by a percentage of favorBy.
		 * @param	min
		 * @param	max
		 * @param	favored
		 * @param	favorBy
		 * @return
		 */
		public static function randomFavorOne(min:int, max:int, favored:int, favorBy:Number):int {
			var rand:Number = Math.random();
			
			// the higher favored by, the more favored
			// is likely to be returned
			if (rand <= favorBy){
				return favored;
			}
			
			// rand now needs to be based on the
			// unfavored portion of the random number
			rand = (1-rand)/(1-favorBy);
			
			// get random from range given new rand
			var value:int = min + int(rand * (max - min));
			
			// favored's chance has already left; if favored
			// is found, use max which was left out of
			// the random value calculation above
			return value == favored ? max : value;
		}
		
		/**
		 * Returns a random number in a range with a particular area in that range
		 * favored over others.  An area (0-1) of a low value favors the min, while
		 * an area of a high value favors the max.
		 * @param	min
		 * @param	max
		 * @param	area
		 * @return
		 */
		public static function randomFavorArea(min:int, max:int, area:Number):int {
			var rand:Number = Math.random();
			switch(area){
				case 0:
					rand *= rand;
					break;
					
				case 1:
					rand = 1 - rand;
					rand *= rand;
					rand = 1 - rand;
					break;
					
				default:
					if (rand > area){
						
						var areaExt:Number = 1 - area;
						rand -= area;
						rand /= areaExt;
						rand *= rand;
						rand = area + areaExt * rand;
						
					}else if (rand < area){
						
						rand /= area;
						rand = 1 - rand;
						rand *= rand;
						rand = 1 - rand;
						rand = area * rand;
					}
					break;
			}
			
			return min + int(rand * (1 + max - min));
		}
		
		
		/**
		 * Returns a random number in a range that is around another number
		 * within offsetLow below, or offsetHigh above.
		 * @param	min
		 * @param	max
		 * @param	around
		 * @param	tolerance
		 * @return
		 */
		public static function randomAroundValue(min:int, max:int, around:int, offsetLow:int, offsetHigh:int):int {
			var offset:Number = (Math.random() * (1 + offsetHigh - offsetLow)) - offsetLow;
			var value = around + offset;
			if (value < min) return min;
			if (value > max) return max;
			return value;
		}
	}
	
}