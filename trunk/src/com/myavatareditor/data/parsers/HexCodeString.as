﻿/*
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
	 * Parser for reading from and generating AvatarData as a
	 * hexadecimal string.  This string is simply the binary
	 * data defined by ConsoleBinary as hex.
	 */
	public class HexCodeString {
		
		/**
		 * Creates a new HexCodeString instance.
		 */
		public function HexCodeString() {}
		
		
		/**
		 * Parses a hexadecimal string saving its data into the provided
		 * AvatarCharacter object.
		 * @param	hex A string representation of the binary for an avatar.
		 * @param	avatarData An AvatarCharacter instance for the hex data
		 * to be stored.  If no AvatarCharacter object is given, one is
		 * automatically created.
		 * @return The AvatarCharacter instance in which the data from hex
		 * is stored.  This will either be the instance passed or a new instance
		 * created by the function itself.  Null will be returned if hex is null.
		 */
		public function parse(hex:String, avatarData:AvatarData = null):AvatarData {
			if (!hex) return null;
			var bytes:ByteArray = new ByteArray();
			
			var parts:Array	= hex.match(/[0-9a-fA-F]{1,2}/g); // hex bytes
			var max:int		= parts.length; // hex bytes in string
			
			var i:int, n:int = ConsoleBinary.AVATAR_FILE_SIZE;
			for (i=0; i<n; i++) {
				
				// if beyond the hex bytes defined in the string
				// fill the remaining bytes with 0 (up to AVATAR_FILE_SIZE)
				bytes.writeByte(i < max ? parseInt(String(parts[i]), 16) : 0);
			}
			
			return new ConsoleBinary().parse(bytes, avatarData);
		}
		
		/**
		 * Generates a hexadecimal string representation of an AvatarData
		 * instance.  The string created is a string representation of the
		 * bytes generated by the ConsoleBinary parser.
		 * @param	avatarData The AvatarCharacter to create a string for.
		 * @return The hexadecimal string representation of the AvatarData
		 * provided.
		 */
		public function write(avatarData:AvatarData):String {
			if (!avatarData) return null;
			var bytes:ByteArray = new ConsoleBinary().write(avatarData);
			return byteArrayAsString(bytes);
		}
		
		/**
		 * Converts a byte array into a string of hexadecimal characters.
		 * @param	bytes The ByteArray instance to convert to a string.
		 * @return A string representation of the ByteArray instance provided.
		 */
		public static function byteArrayAsString(bytes:ByteArray):String {
			
			var hex:String		= "";
			var hexByte:String	= "";
			
			var i:int, n:int = bytes.length;
			for (i=0; i<n; i++) {
				hexByte = int(bytes[i]).toString(16);
				
				// make sure hex strings are at least 2-characters
				// long (prefixing with "0")
				while (hexByte.length < 2) hexByte = "0" + hexByte;
				
				hex += hexByte;
			}
			
			return hex;
		}
	}
}