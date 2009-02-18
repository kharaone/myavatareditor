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
package com.myavatareditor.data.parsers {
	
	import com.myavatareditor.data.AvatarData;
	import flash.utils.ByteArray;
	
	/**
	 * Parser for reading from and writing to binary avatarData
	 * files as defined by a popular entertainment console whose 
	 * name rhymes with 'Tea'.
	 */
	public class ConsoleBinary {
		
		/**
		 * The expected length in bytes of a binary file that
		 * is understood by this parser.
		 */
		public static const AVATAR_FILE_SIZE:int	= 0x4A;		// 74 bytes (37 blocks * 2 bytes)
		
		
		public static const NAME_MAX:int			= 10;
		public static const CREATOR_NAME_MAX:int	= 10;
		
		public static const BIRTH_DAY_MIN:int		= 0;
		public static const BIRTH_DAY_MAX:int		= 31;
		public static const BIRTH_MONTH_MIN:int		= 0;
		public static const BIRTH_MONTH_MAX:int		= 12;
		
		public static const FAVORITE_COLOR_MIN:int	= 0;
		public static const FAVORITE_COLOR_MAX:int	= 11;

		public static const HEIGHT_MIN:int			= 0;
		public static const HEIGHT_MAX:int			= 127;
		public static const WEIGHT_MIN:int			= 0;
		public static const WEIGHT_MAX:int			= 127;
		
		public static const BEARD_COLOR_MIN:int		= 0;
		public static const BEARD_COLOR_MAX:int		= 7;
		public static const BEARD_TYPE_MIN:int		= 0;
		public static const BEARD_TYPE_MAX:int		= 3;
		
		public static const EYE_COLOR_MIN:int		= 0;
		public static const EYE_COLOR_MAX:int		= 5;
		public static const EYE_ROTATION_MIN:int	= 0;
		public static const EYE_ROTATION_MAX:int	= 7;
		public static const EYE_SIZE_MIN:int		= 0;
		public static const EYE_SIZE_MAX:int		= 7;
		public static const EYE_TYPE_MIN:int		= 0;
		public static const EYE_TYPE_MAX:int		= 47;
		public static const EYE_X_MIN:int			= 0;
		public static const EYE_X_MAX:int			= 12;
		public static const EYE_Y_MIN:int			= 0;
		public static const EYE_Y_MAX:int			= 18;
		
		public static const EYEBROW_COLOR_MIN:int		= 0;
		public static const EYEBROW_COLOR_MAX:int		= 7;
		public static const EYEBROW_ROTATION_MIN:int	= 0;
		public static const EYEBROW_ROTATION_MAX:int	= 11;
		public static const EYEBROW_SIZE_MIN:int		= 0;
		public static const EYEBROW_SIZE_MAX:int		= 8;
		public static const EYEBROW_TYPE_MIN:int		= 0;
		public static const EYEBROW_TYPE_MAX:int		= 23;
		public static const EYEBROW_X_MIN:int			= 0;
		public static const EYEBROW_X_MAX:int			= 12;
		public static const EYEBROW_Y_MIN:int			= 3;
		public static const EYEBROW_Y_MAX:int			= 18;
		
		public static const FACE_TYPE_MIN:int		= 0;
		public static const FACE_TYPE_MAX:int		= 11;
		
		public static const GLASSES_COLOR_MIN:int	= 0;
		public static const GLASSES_COLOR_MAX:int	= 5;
		public static const GLASSES_SIZE_MIN:int	= 0;
		public static const GLASSES_SIZE_MAX:int	= 7;
		public static const GLASSES_TYPE_MIN:int	= 0;
		public static const GLASSES_TYPE_MAX:int	= 8;
		public static const GLASSES_Y_MIN:int		= 0;
		public static const GLASSES_Y_MAX:int		= 20;
		
		public static const HAIR_COLOR_MIN:int		= 0;
		public static const HAIR_COLOR_MAX:int		= 7;
		public static const HAIR_PART_MIN:int		= 0;
		public static const HAIR_PART_MAX:int		= 1;
		public static const HAIR_TYPE_MIN:int		= 0;
		public static const HAIR_TYPE_MAX:int		= 71;
		
		public static const HEAD_TYPE_MIN:int		= 0;
		public static const HEAD_TYPE_MAX:int		= 7;
		
		public static const MOLE_SIZE_MIN:int		= 0;
		public static const MOLE_SIZE_MAX:int		= 8;
		public static const MOLE_TYPE_MIN:int		= 0;
		public static const MOLE_TYPE_MAX:int		= 1;
		public static const MOLE_X_MIN:int			= 0;
		public static const MOLE_X_MAX:int			= 16;
		public static const MOLE_Y_MIN:int			= 0;
		public static const MOLE_Y_MAX:int			= 30;
		
		public static const MOUTH_COLOR_MIN:int		= 0;
		public static const MOUTH_COLOR_MAX:int		= 2;
		public static const MOUTH_SIZE_MIN:int		= 0;
		public static const MOUTH_SIZE_MAX:int		= 8;
		public static const MOUTH_TYPE_MIN:int		= 0;
		public static const MOUTH_TYPE_MAX:int		= 23;
		public static const MOUTH_Y_MIN:int			= 0;
		public static const MOUTH_Y_MAX:int			= 18;
		
		public static const MUSTACHE_SIZE_MIN:int	= 0;
		public static const MUSTACHE_SIZE_MAX:int	= 8;
		public static const MUSTACHE_TYPE_MIN:int	= 0;
		public static const MUSTACHE_TYPE_MAX:int	= 3;
		public static const MUSTACHE_Y_MIN:int		= 0;
		public static const MUSTACHE_Y_MAX:int		= 16;
		
		public static const NOSE_SIZE_MIN:int		= 0;
		public static const NOSE_SIZE_MAX:int		= 8;
		public static const NOSE_TYPE_MIN:int		= 0;
		public static const NOSE_TYPE_MAX:int		= 11;
		public static const NOSE_Y_MIN:int			= 0;
		public static const NOSE_Y_MAX:int			= 18;
		
		public static const SKIN_COLOR_MIN:int		= 0;
		public static const SKIN_COLOR_MAX:int		= 5;
		
		public function ConsoleBinary() {}
		
		/**
		 * Returns true if the byte array provided is likely an avatar binary.
		 * This simply checks the size of the bytes to see if it matches
		 * ConsoleBinary.AVATAR_FILE_SIZE.
		 * @param	bytes The byte array to check validity against.
		 * @return True if the byte array is likely an avatar avatarData, false
		 * if likely not or bytes is null.
		 */
		public function validate(bytes:ByteArray):Boolean {
			return Boolean(bytes && bytes.length == AVATAR_FILE_SIZE);
		}
		
		/**
		 * Parses a avatarData binary saving its data into the provided
		 * AvatarCharacter object.
		 * @param	bytes A byte array of the binary for an avatar.
		 * @param	avatarData An AvatarCharacter instance for the binary data
		 * to be stored.  If no AvatarCharacter object is given, one is
		 * automatically created.
		 * @throws Error If the byte array provided has a length other than
		 * ConsoleBinary.AVATAR_FILE_SIZE.
		 * @return The AvatarCharacter instance in which the data from bytes
		 * is stored.  This will either be the instance passed or a new instance
		 * created by the function itself.  Null will be returned if bytes is null.
		 */
		public function parse(bytes:ByteArray, avatarData:AvatarData = null):AvatarData {
			if (!bytes) return null;
			if (!validate(bytes)){
				throw new Error("Parse Error: Incorrect size for binary. Expected " + AVATAR_FILE_SIZE + " bytes.");
			}
			bytes.position = 0;
			
			if (!avatarData) avatarData = new AvatarData();
			
			// clamping not performed on values obtained from a binary
			// when parsing; they're assumed correct
			
			var block:int; // double-byte (short)
			
			// block 0: basic information
			block = bytes.readShort();
			avatarData.favoriteColor	= (block >>> 1)		& 0xF;
			avatarData.birthDay			= (block >>> 5)		& 0x1F;
			avatarData.birthMonth		= (block >>> 10)	& 0xF;
			avatarData.gender			= (block >>> 14)	& 0x1;
			
			// block 1-10: avatar avatarData name
			avatarData.name = readString16(bytes, 10); // 10 double-byte avatarDatas

			// block 11: size
			block = bytes.readShort();
			avatarData.weight	= (block) 		& 0x7F
			avatarData.height	= (block >>> 8)	& 0x7F;

			// block 12-13: avatar avatarData id
			avatarData.id = bytes.readUnsignedInt();

			// block 14-15: client id
			avatarData.clientID = bytes.readUnsignedInt();

			// block 16: face
			block = bytes.readShort();
			avatarData.mingles		= (block >>> 2)		& 0x1;
			avatarData.faceType		= (block >>> 6)		& 0xF;
			avatarData.skinColor	= (block >>> 10)	& 0x7;
			avatarData.headType		= (block >>> 13)	& 0x7;

			// block 17: hair
			block = bytes.readShort();
			avatarData.hairPart		= (block >>> 5)	& 0x1;
			avatarData.hairColor	= (block >>> 6)	& 0x7;
			avatarData.hairType		= (block >>> 9)	& 0x7F;

			// block 18: eyebrows part 1
			block = bytes.readShort();
			avatarData.eyebrowRotation	= (block >>> 6)		& 0xF;
			avatarData.eyebrowType		= (block >>> 11)	& 0x1F;

			// block 19: eyebrows part 2
			block = bytes.readShort();
			avatarData.eyebrowX		= (block)			& 0xF;
			avatarData.eyebrowY		= (block >>> 4)		& 0x1F;
			avatarData.eyebrowSize	= (block >>> 9)		& 0xF;
			avatarData.eyebrowColor	= (block >>> 13)	& 0x7;

			// block 20: eyes part 1
			block = bytes.readShort();
			avatarData.eyeY			= (block)			& 0x1F;
			avatarData.eyeRotation	= (block >>> 5)		& 0x7;
			avatarData.eyeType		= (block >>> 10)	& 0x3F;

			// block 21: eyes part 2
			block = bytes.readShort();
			avatarData.eyeX		= (block >>> 5)		& 0xF;
			avatarData.eyeSize	= (block >>> 9)		& 0x7;
			avatarData.eyeColor	= (block >>> 13)	& 0x7;

			// block 22: nose
			block = bytes.readShort();
			avatarData.noseY	= (block >>> 3)		& 0x1F;
			avatarData.noseSize	= (block >>> 8)		& 0xF;
			avatarData.noseType	= (block >>> 12)	& 0xF;

			// block 23: mouth
			block = bytes.readShort();
			avatarData.mouthY		= (block)			& 0x1F;
			avatarData.mouthSize	= (block >>> 5)		& 0xF;
			avatarData.mouthColor	= (block >>> 9)		& 0x3;
			avatarData.mouthType	= (block >>> 11)	& 0x1F;

			// block 24: glasses
			block = bytes.readShort();
			avatarData.glassesY		= (block)			& 0x1F;
			avatarData.glassesSize	= (block >>> 5)		& 0x7;
			avatarData.glassesColor	= (block >>> 9)		& 0x7;
			avatarData.glassesType	= (block >>> 12)	& 0xF;

			// block 25: facial hair
			block = bytes.readShort();
			avatarData.mustacheY		= (block)			& 0x1F;
			avatarData.mustacheSize		= (block >>> 5)		& 0xF;
			avatarData.beardColor		= (block >>> 9)		& 0x7;
			avatarData.beardType		= (block >>> 12)	& 0x3;
			avatarData.mustacheType		= (block >>> 14)	& 0x3;

			// block 26: mole
			block = bytes.readShort();
			avatarData.moleX		= (block >>> 1)		& 0x1F;
			avatarData.moleY		= (block >>> 6)		& 0x1F;
			avatarData.moleSize		= (block >>> 11)	& 0xF;
			avatarData.moleType		= (block >>> 15)	& 0x1;

			// block 27-36: avatar avatarData name
			avatarData.creatorName = readString16(bytes, 10); // 10 double-byte avatarDatas
			
			return avatarData
		}
		
		/**
		 * Writes data from a AvatarCharacter into a byte array.
		 * @param	avatarData The AvatarCharacter to write to a byte array.
		 * @param	bytes The byte array for save the avatarData binary. If
		 * one is not provided, one is created automatically.  Data is written
		 * from the current position in the byte array. If you want the provided
		 * byte array to contain only the character data, set its position to 0
		 * and its length fo AVATAR_FILE_SIZE.
		 * @return A ByteArray object containing the AvatarCharacter as
		 * an avatar binary. Null will be returned if avatarData is null. If a
		 * byte array is passed for the bytes parameter, that byte array is not
		 * returned, rather, a separate byte array with the character data.
		 */
		public function write(avatarData:AvatarData, bytes:ByteArray = null):ByteArray {
			if (!avatarData) return null;
			
			var avaBytes:ByteArray	= new ByteArray();
			avaBytes.length			= AVATAR_FILE_SIZE;
			avaBytes.position		= 0;
			
			
			
			var block:int; // double-byte (short)

			// Yeah... I could have used the constants in these
			// clamp calls, but the formatting is just so much
			// nicer with the short literal values ;)
			
			// block 0: basic information
			block = ((clamp(avatarData.favoriteColor,	0, 11)	& 0xF)  << 1)
			      + ((clamp(avatarData.birthDay,		0, 31)	& 0x1F) << 5)
			      + ((clamp(avatarData.birthMonth,		0, 12)	& 0xF)  << 10)
				  + ((avatarData.gender							& 0x1)  << 14);
			avaBytes.writeShort(block);
			
			// block 1-10: avatar avatarData name
			writeString16(avaBytes, avatarData.name, 10); // 10 double-byte avatarDatas
			
			// block 11: size
			block = ((avatarData.weight	& 0x7F))
			      + ((avatarData.height	& 0x7F)  << 8);
			avaBytes.writeShort(block);
			
			// block 12-13: avatar avatarData id
			avaBytes.writeUnsignedInt(avatarData.id);
			
			// block 14-15: client id
			avaBytes.writeUnsignedInt(avatarData.clientID);
			
			// block 16: face
			block = ((avatarData.mingles					& 0x1)  << 2)
			      + ((clamp(avatarData.faceType,	0, 11)	& 0xF)  << 6)
			      + ((clamp(avatarData.skinColor,	0, 5)	& 0x7)  << 10)
				  + ((clamp(avatarData.headType,	0, 7)	& 0x7)  << 13);
			avaBytes.writeShort(block);
			
			// block 17: hair
			block = ((avatarData.hairPart					& 0x1)  << 5)
			      + ((clamp(avatarData.hairColor,	0, 7)	& 0x7)  << 6)
			      + ((clamp(avatarData.hairType,	0, 71)	& 0x7F) << 9);
			avaBytes.writeShort(block);
			
			// block 18: eyebrows part 1
			block = ((clamp(avatarData.eyebrowRotation,	0, 11)	& 0xF)  << 6)
			      + ((clamp(avatarData.eyebrowType,		0, 23)	& 0x1F) << 11);
			avaBytes.writeShort(block);
			
			// block 19: eyebrows part 2
			block = ((clamp(avatarData.eyebrowX,	0, 12)	& 0xF))
			      + ((clamp(avatarData.eyebrowY,	3, 18)	& 0x1F) << 4)
			      + ((clamp(avatarData.eyebrowSize,	0, 8)	& 0xF)  << 9)
			      + ((avatarData.eyebrowColor				& 0x7)  << 13);
			avaBytes.writeShort(block);
			
			// block 20: eyes part 1
			block = ((clamp(avatarData.eyeY,		0, 18)	& 0x1F))
			      + ((avatarData.eyeRotation				& 0x7)  << 5)
			      + ((clamp(avatarData.eyeType,		0, 47)	& 0x3F) << 10);
			avaBytes.writeShort(block);
			
			// block 21: eyes part 2
			block = ((clamp(avatarData.eyeX,		0, 12)	& 0xF)  << 5)
			      + ((clamp(avatarData.eyeSize,		0, 7)	& 0x7)  << 9)
			      + ((clamp(avatarData.eyeColor,	0, 5)	& 0x7)  << 13);
			avaBytes.writeShort(block);
			
			// block 22: nose
			block = ((clamp(avatarData.noseY,		0, 18)	& 0x1F) << 3)
			      + ((clamp(avatarData.noseSize,	0, 8)	& 0xF)  << 8)
			      + ((clamp(avatarData.noseType,	0, 11)	& 0xF)  << 12);
			avaBytes.writeShort(block);
			
			// block 23: mouth
			block = ((clamp(avatarData.mouthY,		0, 18)	& 0x1F))
			      + ((clamp(avatarData.mouthSize,	0, 8)	& 0xF)  << 5)
			      + ((clamp(avatarData.mouthColor,	0, 2)	& 0x3)  << 9)
			      + ((clamp(avatarData.mouthType,	0, 23)	& 0x1F) << 11);
			avaBytes.writeShort(block);
			
			// block 24: glasses
			block = ((clamp(avatarData.glassesY,		0, 20)	& 0x1F))
			      + ((clamp(avatarData.glassesSize,		0, 7)	& 0x7)  << 5)
			      + ((clamp(avatarData.glassesColor,	0, 5)	& 0x7)  << 9)
			      + ((clamp(avatarData.glassesType,		0, 8)	& 0xF)  << 12);
			avaBytes.writeShort(block);
			
			// block 25: facial hair
			block = ((clamp(avatarData.mustacheY,		0, 16)	& 0x1F))
			      + ((clamp(avatarData.mustacheSize,	0, 8)	& 0xF)  << 5)
			      + ((avatarData.beardColor						& 0x7)  << 9)
			      + ((avatarData.beardType						& 0x3)  << 12)
			      + ((avatarData.mustacheType					& 0x3)  << 14);
			avaBytes.writeShort(block);
			
			// block 26: mole
			block = ((clamp(avatarData.moleX,		0, 16)	& 0x1F) << 1)
			      + ((clamp(avatarData.moleY,		0, 30)	& 0x1F) << 6)
			      + ((clamp(avatarData.moleSize,	0, 8)	& 0xF)  << 11)
			      + ((avatarData.moleType					& 0x1)  << 15);
			avaBytes.writeShort(block);
			
			// block 27-36: avatar avatarData name
			writeString16(avaBytes, avatarData.creatorName, 10); // 10 double-byte avatarDatas
			
			// write in passed bytes
			if (bytes){
				bytes.writeBytes(avaBytes);
			}
			
			return avaBytes;
		}

		/**
		 * Writes a double-byte string to the current position of a byte array.
		 * @param	bytes The byte array to write a string to.
		 * @param	data The string to write.
		 * @param	doubleByteCount The number of double-byte avatarDatas
		 * to write to the byte array.  If the string provided consists of more
		 * avatarDatas, only doubleByteCount avatarDatas will be written. If the
		 * string is less than doubleByteCount, the remaining avatarDatas are 
		 * filled with null avatarDatas (0).
		 */
		private function writeString16(bytes:ByteArray, data:String, doubleByteCount:uint):void {
			var i:int;
			var len:int = data.length;
			for (i = 0; i < doubleByteCount; i++){
				bytes.writeShort(i < len ? data.charCodeAt(i) : 0);
			}
		}
		/**
		 * Reads a double-byte string from the current position of a byte array.
		 * @param	bytes The byte array to read a string from.
		 * @param	doubleByteCount The number of double-byte avatarDatas
		 * to read from the byte array.
		 * @return	The string of no greater than doubleByteCount avatarDatas
		 * that was read from the byte array.  Fewer avatarDatas will be 
		 * retuned if a null (0) avatarData is encountered.
		 */
		private function readString16(bytes:ByteArray, doubleByteCount:uint):String {
			var data:String = "";
			var terminated:Boolean = false;
			var block:int;
			var i:int;
			for (i = 0; i < doubleByteCount; i++){
				block = bytes.readShort();
				
				if (!terminated){
					// stop adding to string if null is encountered
					if (block == 0) terminated = true;
					else data += String.fromCharCode(block);
				}
			}
			return data;
		}
		
		/**
		 * Clamps a value between a minimum and maximum value.  The original
		 * value is not modified; a clamped version of that value is returned.
		 * @param	value	The value to be clamped between min and max.
		 * @param	min		The minimum value to be returned.
		 * @param	max		The maximum value to be returned.
		 * @return The value if it is betwen min and max, the min if the value
		 * is below min, and max if the value is above max.
		 */
		private function clamp(value:int, min:int = 0, max:int = 1):int {
			if (value < min) return min;
			if (value > max) return max;
			return value;
		}
	}
}