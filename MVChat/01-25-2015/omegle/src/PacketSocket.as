package 
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	public class PacketSocket extends Socket
	{
		private var state:String;
		private var nextLen:int;
		private var tempTag:String;
		
		public function PacketSocket() {
			super();
			
			state = 'taglen';
			nextLen = 1;
			
			addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}
		
		private function socketDataHandler(event:ProgressEvent):void {
			//trace("GGGG");
			while (bytesAvailable >= nextLen) {
				switch (state) {
					case 'taglen':
						state = 'tag';
						nextLen = readByte();
						//trace("tagLen:"+nextLen);
						break;
					case 'tag':
						tempTag = readUTFBytes(nextLen);
						//trace("tag:"+tempTag);
						state = 'datalen';
						nextLen = 2;
						break;
					case 'datalen':
						state = 'data';
						nextLen = readUnsignedShort();
						//trace("datalen:"+nextLen);
						break;
					case 'data':
						var data:String = readUTFBytes(nextLen);
						//trace("data:"+data);
						dispatchEvent(new PacketEvent(tempTag, data));
						//trace("&&&&&&&"+tempTag);
						/*if(tempTag == 'c'){
							dispatchEvent(new VideoIDEvent(data));
							trace("EEEEEEE");
						}*/
						tempTag = null;
						state = 'taglen';
						nextLen = 1;
						break;
				}
			}
		}
		
		public function removeListener(){
			//trace(hasEventListener(removeEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler)));
			removeEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
			//trace(hasEventListener(removeEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler)));
		}
		
		public function writePacket(tag:String, data:String):void {
			trace(tag+" : "+data);
			writeByte(tag.length);
			writeUTFBytes(tag);
			writeUTF(data);
			flush();
		}
	}
}