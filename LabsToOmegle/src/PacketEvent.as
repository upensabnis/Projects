package 
{
	import flash.events.Event;
	
	public class PacketEvent extends Event
	{
		static public var PACKET:String = "packet";
		
		public var tag:String;
		public var data:String;
		
		public function PacketEvent(tag:String, data:String) {
			super(PACKET);
			
			this.tag = tag;
			this.data = data;
		}
	}
}