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
package com.myavatareditor.fla.editor {
	
	import com.myavatareditor.fla.character.AvatarSWF;
	import com.myavatareditor.fla.dialogs.Alert;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	
	public class CharacteristicsLoader extends AbstractCharacteristicsGUI {
		
		public var characterAssetsURL:String = "myavatarcharacter.swf";
		public var characterLoader:Loader = new Loader();

		public function CharacteristicsLoader(editor:EditorSWF){
			super(editor);
		}

		public override function init():void {
			super.init();
			characterLoader.contentLoaderInfo.addEventListener(Event.INIT, graphicsLoaded, false, 0, true);
			characterLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, graphicsLoaded, false, 0, true);
			characterLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, graphicsLoaded, false, 0, true);
			
			var url:String = characterAssetsURL;
			try {
				if (editor.loaderInfo.url.indexOf("http") == 0){
					url += "?" + editor.version;
				}
			}catch (error:Error){}
			
			characterLoader.load(new URLRequest(url), new LoaderContext(false, ApplicationDomain.currentDomain));
		}
		
		public override function fini():void {
			characterLoader.contentLoaderInfo.removeEventListener(Event.INIT, graphicsLoaded, false);
			characterLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, graphicsLoaded, false);
			characterLoader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, graphicsLoaded, false);
		}
		
		private function graphicsLoaded(event:Event):void {
			if (event is ErrorEvent){
				MovieClip(editor.root).addChild(new Alert("Error: Could not load Avatar Character."));
			}else{
				editor.avatarSWF = characterLoader.content as AvatarSWF;
				if (!editor.avatarSWF){
					MovieClip(editor.root).addChild(new Alert("Error: Problem identifying Avatar Character."));
				}
			}
			editor.nextFrame();
			editor.loadInit();
		}
	}
}