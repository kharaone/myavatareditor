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
	 * Generic parser for unknown avatar data.  This will analyze the data
	 * provided and determine which parser to use to parse the data. In
	 * addition, this includes a parser (parse, not write) for generic
	 * object Object instances into AvatarData.
	 */
	public class GenericData {
		
		public function GenericData() {}
		
		/**
		 * Parses data of an unknown type by identifying that data and
		 * parsing it with the appropriate parser of a collection of
		 * recognized parsers.
		 * @param	data Data to parse. This can be of any recognized format.
		 * @param	avatarData An AvatarCharacter instance for the data
		 * to be stored.  If no AvatarCharacter object is given, one is
		 * automatically created.
		 * @return The AvatarCharacter instance in which the data is stored.
		 * This will either be the instance passed or a new instance created
		 * by the function itself.  Null will be returned if the data is null
		 * or of an unrecognized type.
		 */
		public function parse(data:*, avatarData:AvatarData = null):AvatarData {
			// parse data depending on type
			if (data == null) return null;
			
			if (data is ByteArray){
				return new ConsoleBinary().parse(ByteArray(data), avatarData);
			}
				
			if (data is XML){
				return parseXML(XML(data), avatarData);
			}
				
			if (data is String) {
				
				// if xml created with no errors, parse as XML
				try {
					var xml:XML = XML(data);
					if (xml.localName() != null){
						return parseXML(xml, avatarData);
					}
					
				}catch (error:Error){ 
					// not valid XML
				}
				
				// attempt to parse as a simple HEX string
				if (isNaN(parseInt(data, 16)) == false){
					return new HexCodeString().parse(String(data), avatarData);
				}
			}
			
			if (data.toString() == "[object Object]") {
				// generic objects, such as { name:"some name", id:1 }
				return genericObjectParser(data, avatarData);
			}
			
			return null;
		}
		
		/**
		 * Parses XML into an AvatarCharacter.  In particular, this
		 * function differentiates between XML of the different formats,
		 * legacy vs current editor XML.
		 * @param	xml XML object to parse
		 * @param	avatarData AvatarCharacter the XML data is parsed into.
		 * @return AvatarCharacter whose values are defined by the xml passed.
		 */
		private function parseXML(xml:XML, avatarData:AvatarData = null):AvatarData {
			var legacyParser:LegacyEditorXML = new LegacyEditorXML();
			if (legacyParser.validate(xml)){
				return legacyParser.parse(xml, avatarData);
			}
			
			return new AvatarEditorXML().parse(xml, avatarData);
		}
		
		/**
		 * Generic object parser for Object objects.  This parser will read through
		 * the dyanmic members of a data object assigning them to the AvatarData
		 * instance provided. If avatar data is not provided, one is generated
		 * automatically
		 * @param	data	A generic object containing AvatarData properties.
		 * @param	avatarData The AvatarData instance to copy properties into. If
		 * one is not provided, one is created.
		 * @return The AvatarData with the copied object properties defined within it
		 * or null if data is null.
		 */
		private function genericObjectParser(data:Object, avatarData:AvatarData = null):AvatarData {
			if (!data) return null;
			if (!avatarData) avatarData = new AvatarData();
			
			var name:String;
			var value:*;
			for (name in data){
				if (name in avatarData){
					try {
						
						// Note: does not validate values
						avatarData[name] = data[name];
					}catch (error:Error){}
				}
			}
			
			return avatarData;
		}
	}
}