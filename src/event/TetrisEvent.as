package event 
{
import flash.events.Event;
/**
 * ...俄罗斯方块事件
 * @author Kanon
 */
public class TetrisEvent extends Event 
{
	public static const TETRIS_DOWN:String = "tetrisDown";
	public function TetrisEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
	{ 
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