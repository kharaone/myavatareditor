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
	import com.myavatareditor.fla.character.AvatarCharacter;
	
	public class LegacyEditorXML {
		
		public function LegacyEditorXML(){}
		
		/**
		 * Returns true if the XML provided is of the legacy format
		 * recognized by this parser.  This looks for two avatarDataistics:
		 * Either a value attribute in the avatar node, or one or more
		 * data elements within the avatar node
		 * @return True if the xml is legacy XML, false if not.
		 */
		public function validate(xml:XML):Boolean {
			xml = getAvatarNode(xml);
			if (!xml) return false;
			
			if (xml.@value || xml.data){
				return true;
			}
			
			return false;
		}
		
		public function parse(xml:XML, avatarData:AvatarData = null):AvatarData {
						
			xml = getAvatarNode(xml);
			if (!xml) return null;
			if (!avatarData) avatarData = new AvatarData();
			
			
			// check for child elements
			if (!xml.elements()){
				
				// for XML lacking child elements, fallback to 
				// the avatar hex value if available.
				var hex:String = xml.@value;
				if (hex) return new HexCodeString().parse(hex, avatarData);
				
				// no elements and no hex equals no avatarData
				return null;
			}
			
			// text values
			if (xml.name) {
				avatarData.name = xml.name.text();
			}
			if (xml.creator) {
				avatarData.creatorName = xml.creator.text();
			}
			
			var name:String;
			var data:XML;
			for each(data in xml.data) {
				name = data.@name;
				
				// if not a valid value, continue
				if (data.@value.length() == 0){
					continue;
				}
				
				// special cases
				switch(name) {
					
					// flip y values
					case "eyeY":
						avatarData.eyeY = ConsoleBinary.EYE_Y_MAX - int(data.@value);
						break;
					
					case "glassesY":
						avatarData.glassesY = ConsoleBinary.GLASSES_Y_MAX - int(data.@value);
						break;
					
					case "moleY":
						avatarData.moleY = ConsoleBinary.MOLE_Y_MAX - int(data.@value);
						break;
					
					case "mouthY":
						avatarData.mouthY = ConsoleBinary.MOUTH_Y_MAX - int(data.@value);
						break;
					
					case "mustacheY":
						avatarData.mustacheY = ConsoleBinary.MUSTACHE_Y_MAX - int(data.@value);
						break;
					
					case "noseY":
						avatarData.noseY = ConsoleBinary.NOSE_Y_MAX - int(data.@value);
						break;
					
						
					// flip and offset
					case "eyebrowY":
						avatarData.eyebrowY = ConsoleBinary.EYEBROW_Y_MIN + (ConsoleBinary.EYEBROW_Y_MAX - int(data.@value));
						break;
						
						
					// reverse
					case "mingles":
						avatarData.mingles = (int(data.@value) == 0) ? 1 : 0;
						break;
						
						
					// hex to uint
					case "id":
						avatarData.id = AvatarCharacter.convertHexString(data.@value);
						break;
					
					case "wii":
					case "client": // name change? (not sure; but just in case)
						avatarData.clientID = AvatarCharacter.convertHexString(data.@value);
						break;
						
						
					// name change
					case "birthDate":
						avatarData.birthDay = int(data.@value);
						break;
						
					case "facialFeaturesType":
						avatarData.faceType = int(data.@value);
						break;
						
					case "facialHairColor":
						avatarData.beardColor = int(data.@value);
						break;
						
						
					// convert from frame to id value
					case "eyeType":		
					case "eyebrowType":	
					case "hairType":
					case "noseType":
					case "mouthType":
						var frame:int = int(data.@value) + 1;
						avatarData[name] = AvatarCharacter.frameToValue(name, frame);
						break;
						
					// normal, direct value
					default:
						// make sure name is in avatarData
						if (name in avatarData)
							avatarData[name] = int(data.@value);
						break;
				}
			}
			
			return avatarData;
		}
		
		public function write(avatarData:AvatarData, xml:XML = null):XML {
			throw new Error("Error: Writing to legacy XML is not supported.");
			return null;
		}
		
		private function getAvatarNode(xml:XML):XML {
			if (!xml) return null;
			
			switch(xml.localName()){
				
				case "mii-collection":
				case "avatar-collection":
					// find first avatar in collection and parse that
					var avatarNodes:XMLList = xml.avatar + xml.mii;
					return avatarNodes ? avatarNodes[0] : null;
					break;
					
				case "avatar":
				case "mii":
					return xml;
					break;
				
				default:
					// invalid avatarData XML
					break;
			}
			
			return null;
		}
	}
}