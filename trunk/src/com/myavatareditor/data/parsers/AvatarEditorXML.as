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
	
	/**
	 * Parser for the My Avatar Editor XML file format.  This format
	 * specifies values almost directly in line with those in the
	 * binary file format.
	 */
	public class AvatarEditorXML {
			
		/**
		 * Namespace for XML objects.
		 */
		public var avatarNS:Namespace = new Namespace("http://www.myavatareditor.com/xml/avatar/1"); // version 1
		
		/**
		 * Constructor for new AvatarEditorXML instances.
		 */
		public function AvatarEditorXML(){}
		
		/**
		 * Parse method for reading XML and assigning its defined
		 * values to an AvatarData instance. The XML to parse may
		 * be an Avatar node or an avatar-collection node.  For
		 * avatar-collections, the first Avatar node, if present,
		 * will be used for the resulting AvatarData.
		 * @param	xml XML to parse.
		 * @param	avatarData AvatarData instance to parse the XML
		 * data into.  If not provided or null, one is created for you.
		 * @return The resulting AvatarData instance with the XML
		 * values defined in it. If an AvatarData was passed into the
		 * parse call, the return value will be the same instance.
		 */
		public function parse(xml:XML, avatarData:AvatarData = null):AvatarData {
			
			if (!xml) return null;
			if (!avatarData) avatarData = new AvatarData();
			
			default xml namespace = avatarNS;
			switch(xml.localName()){
				
				case "avatar-collection":
					// find first avatar in collection and parse that
					var avatarNodes:XMLList = xml.Avatar;
					return avatarNodes ? parse(avatarNodes[0], avatarData) : null;
					break;
					
				case "Avatar":
					// valid; continue
					break;
				
				default:
					// invalid avatarData XML
					return null;
					break;
			}
			
			
			// check for child elements
			if (!xml.elements()){
				
				// for XML lacking child elements, fallback to 
				// the avatar hex value if available.
				var hex:String = xml.@code;
				if (hex) return new HexCodeString().parse(hex, avatarData);
				
				// no elements and no hex equals no avatarData
				return null;
			}
			
			
			// XML lists are saved to a temporary variable 
			// to prevent a double E4X lookup for both checking
			// existence and getting value
			var node:XMLList;
			
			node = xml.id;
			if (node.length())
				avatarData.id = uint(parseInt(node, 16));
			node = xml.clientID;
			if (node.length())
				avatarData.clientID = uint(parseInt(node, 16));
			
			node = xml.name;
			if (node.length())
				avatarData.name = String(node);
			node = xml.creatorName;
			if (node.length())
				avatarData.creatorName = String(node);
				
			node = xml.birthDay;
			if (node.length())
				avatarData.birthDay = int(node);
			node = xml.birthMonth;
			if (node.length())
				avatarData.birthMonth = int(node);
			
			node = xml.gender;
			if (xml.gender.length())
				avatarData.gender = int(node);
			node = xml.mingles;
			if (xml.mingles.length())
				avatarData.mingles = int(node);
			
			node = xml.Body.height;
			if (xml.Body.height.length())
				avatarData.height = int(node);
			node = xml.Body.weight;
			if (xml.Body.weight.length())
				avatarData.weight = int(node);
				
			node = xml.Beard.type;
			if (node.length())
				avatarData.beardType = int(node);
			node = xml.Beard.color;
			if (node.length())
				avatarData.beardColor = getColorValue(String(node));

			node = xml.Eye.type;
			if (node.length())
				avatarData.eyeType = int(node);
			node = xml.Eye.rotation;
			if (node.length())
				avatarData.eyeRotation = int(node);
			node = xml.Eye.color;
			if (node.length())
				avatarData.eyeColor = getColorValue(String(node));
			node = xml.Eye.size;
			if (node.length())
				avatarData.eyeSize = int(node);
			node = xml.Eye.x;
			if (node.length())
				avatarData.eyeX = int(node);
			node = xml.Eye.y;
			if (node.length())
				avatarData.eyeY = int(node);

			node = xml.Eyebrow.type;
			if (node.length())
				avatarData.eyebrowType = int(node);
			node = xml.Eyebrow.rotation;
			if (node.length())
				avatarData.eyebrowRotation = int(node);
			node = xml.Eyebrow.color;
			if (node.length())
				avatarData.eyebrowColor = getColorValue(String(node));
			node = xml.Eyebrow.size;
			if (node.length())
				avatarData.eyebrowSize = int(node);
			node = xml.Eyebrow.x;
			if (node.length())
				avatarData.eyebrowX = int(node);
			node = xml.Eyebrow.y;
			if (node.length())
				avatarData.eyebrowY = int(node);
				
			node = xml.Face.type;
			if (node.length())
				avatarData.faceType = int(node);

			node = xml.Glasses.type;
			if (node.length())
				avatarData.glassesType = int(node);
			node = xml.Glasses.color;
			if (node.length())
				avatarData.glassesColor = getColorValue(String(node));
			node = xml.Glasses.size;
			if (node.length())
				avatarData.glassesSize = int(node);
			node = xml.Glasses.y;
			if (node.length())
				avatarData.glassesY = int(node);

			node = xml.Hair.type;
			if (node.length())
				avatarData.hairType = int(node);
			node = xml.Hair.color;
			if (node.length())
				avatarData.hairColor = getColorValue(String(node));
			node = xml.Hair.part;
			if (node.length())
				avatarData.hairPart = int(node);
			
			node = xml.Head.type;
			if (node.length())
				avatarData.headType = int(node);

			node = xml.Mole.type;
			if (node.length())
				avatarData.moleType = int(node);
			node = xml.Mole.size;
			if (node.length())
				avatarData.moleSize = int(node);
			node = xml.Mole.x;
			if (node.length())
				avatarData.moleX = int(node);
			node = xml.Mole.y;
			if (node.length())
				avatarData.moleY = int(node);

			node = xml.Mouth.type;
			if (node.length())
				avatarData.mouthType = int(node);
			node = xml.Mouth.color;
			if (node.length())
				avatarData.mouthColor = getColorValue(String(node));
			node = xml.Mouth.size;
			if (node.length())
				avatarData.mouthSize = int(node);
			node = xml.Mouth.y;
			if (node.length())
				avatarData.mouthY = int(node);

			node = xml.Mustache.type;
			if (node.length())
				avatarData.mustacheType = int(node);
			node = xml.Mustache.size;
			if (node.length())
				avatarData.mustacheSize = int(node);
			node = xml.Mustache.y;
			if (node.length())
				avatarData.mustacheY = int(node);

			node = xml.Nose.type;
			if (node.length())
				avatarData.noseType = int(node);
			node = xml.Nose.size;
			if (node.length())
				avatarData.noseSize = int(node);
			node = xml.Nose.y;
			if (node.length())
				avatarData.noseY = int(node);
			
			node = xml.Shirt.color;
			if (node.length())
				avatarData.favoriteColor = getColorValue(String(node));
				
			node = xml.Skin.color;
			if (node.length())
				avatarData.skinColor = getColorValue(String(node));
				
			return avatarData;
		}
		
		/**
		 * Creates and returns an XML representation of an AvatarData
		 * object.  This XML can be restored to an AvatarData using
		 * the parse() method.
		 * @param	avatarData The AvatarData to create XML for
		 * @param	xml An optional XML node to write the generated XML
		 * into.  The generated XML is added as a child of thix XML node
		 * if provided.
		 * @param	codeAttribute When true, adds an XML attribute named
		 * code to the root Avatar node in the generated XML. This value
		 * is the hexadecimal representation of the AvatarData object. It
		 * can be used in place of having the data in XML nodes.
		 * @return The XML generated.
		 */
		public function write(avatarData:AvatarData, xml:XML = null, codeAttribute:Boolean = false):XML {
			if (!avatarData) return null;
			
			var avatarXML:XML = <Avatar xmlns={avatarNS.uri}>

				<id>{avatarData.id.toString(16).toUpperCase()}</id>
				<clientID>{avatarData.clientID.toString(16).toUpperCase()}</clientID>
				
				<name>{avatarData.name}</name>
				<creatorName> {avatarData.creatorName}</creatorName>
				
				<birthDay>{avatarData.birthDay}</birthDay>
				<birthMonth>{avatarData.birthMonth}</birthMonth>
				
				<gender>{avatarData.gender}</gender>
				<mingles> {avatarData.mingles}</mingles>
				
				<Beard>
					<type>{avatarData.beardType}</type>
					<color>{avatarData.beardColor}</color>
				</Beard>
				<Body>
					<height>{avatarData.height}</height>
					<weight>{avatarData.weight}</weight>
				</Body>
				<Eye>
					<type>{avatarData.eyeType}</type>
					<color>{avatarData.eyeColor}</color>
					<x>{avatarData.eyeX}</x>
					<y>{avatarData.eyeY}</y>
					<size>{avatarData.eyeSize}</size>
					<rotation>{avatarData.eyeRotation}</rotation>
				</Eye>
				<Eyebrow>
					<type>{avatarData.eyebrowType}</type>
					<color>{avatarData.eyebrowColor}</color>
					<x>{avatarData.eyebrowX}</x>
					<y>{avatarData.eyebrowY}</y>
					<size>{avatarData.eyebrowSize}</size>
					<rotation>{avatarData.eyebrowRotation}</rotation>
				</Eyebrow>
				<Face>
					<type>{avatarData.faceType}</type>
				</Face>
				<Glasses>
					<type>{avatarData.glassesType}</type>
					<color>{avatarData.glassesColor}</color>
					<y>{avatarData.glassesY}</y>
					<size>{avatarData.glassesSize}</size>
				</Glasses>
				<Hair>
					<type>{avatarData.hairType}</type>
					<color>{avatarData.hairColor}</color>
					<part>{avatarData.hairPart}</part>
				</Hair>
				<Head>
					<type>{avatarData.headType}</type>
				</Head>
				<Mole>
					<type>{avatarData.moleType}</type>
					<x>{avatarData.moleX}</x>
					<y>{avatarData.moleY}</y>
					<size>{avatarData.moleSize}</size>
				</Mole>
				<Mouth>
					<type>{avatarData.mouthType}</type>
					<color>{avatarData.mouthColor}</color>
					<y>{avatarData.mouthY}</y>
					<size>{avatarData.mouthSize}</size>
				</Mouth>
				<Mustache>
					<type>{avatarData.mustacheType}</type>
					<y>{avatarData.mustacheY}</y>
					<size>{avatarData.mustacheSize}</size>
				</Mustache>
				<Nose>
					<type>{avatarData.noseType}</type>
					<y>{avatarData.noseY}</y>
					<size>{avatarData.noseSize}</size>
				</Nose>
				<Shirt>
					<color>{avatarData.favoriteColor}</color>
				</Shirt>
				<Skin>
					<color>{avatarData.skinColor}</color>
				</Skin>
			</Avatar>;
			
			// add code attribute if specified
			if (codeAttribute){
				avatarXML.@code = new HexCodeString().write(avatarData);
			}
			
			// if xml is provided, add the generated XML
			// as a child of that XML.
			if (xml){
				xml.appendChild(avatarXML);
			}
			
			return avatarXML;
		}
		
		/**
		 * Gets an avatar color ID from a string value defined in an
		 * XML node.
		 * @param	str Color value defined in an XML node.
		 * @return The color ID for an avatar characteristic.
		 */
		public function getColorValue(str:String):uint {
			// check for a small value which would not be used
			// for a hex color and would instead be used to
			// represent a avatarData ID
			if (str.length <= 2){
				// avatarData ID, return direct value
				return uint(parseInt(str, 10));
			}
			
			// force determines if we should take the true
			// value of the str as a hex over attempting to parse
			// it as a shorthand 3-avatarData hex if it's 3
			// avatarDatas long
			var forceValue:Boolean = false;
			
			// remove any 0x prefix
			if (str.indexOf("0x") == 0){
				str = str.substr(2);
				// a 0x prefix will force the value
				forceValue = true;
			}
			
			// remove any # prefix
			if (str.indexOf("#") == 0){
				str = str.substr(1);
			}
			
			// force uppercase
			str = str.toUpperCase();
			
			// parse 3-avatarData shorhand hex as 6
			// (i.e. F39 as FF3399)
			if (!forceValue && str.length == 3){
				var char:String, temp:String;
				char	=  str.charAt(0);
				temp	=  char + char;
				char	=  str.charAt(1);
				temp	+= char + char;
				char	=  str.charAt(2);
				str		=  temp + char + char;
			}
			
			// if full hex colors were supported, their
			// values wouldn't be parsed to ints as done
			// below
			return uint(parseInt(str, 16));
		}
	}
}