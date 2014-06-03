package event 
{
import flash.events.Event;
/**
 * ...俄罗斯方块事件
 * @author Kanon
 */
public class TetrisEvent extends Event 
{
	//下落完成
	public static const TETRIS_DOWN:String = "tetrisDown";
	//满行
	public static const FULL:String = "full";
	//失败
	public static const FAIL:String = "fail";
	//数据
	public var data:*;
	public function TetrisEvent(type:String, data:*=null, bubbles:Boolean = false, cancelable:Boolean = false)
	{ 
		this.data = data;
		super(type, bubbles, cancelable);
	} 
	
	public override function clone():Event 
	{ 
		return new TetrisEvent(type, bubbles, cancelable);
	} 
	
	public override function toString():String 
	{ 
		return formatToString("TetrisEvent", "type", "bubbles", "cancelable", "eventPhase"); 
	}
}
}