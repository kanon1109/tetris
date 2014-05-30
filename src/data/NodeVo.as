package data 
{
/**
 * ...地图节点
 * @author Kanon
 */
public class NodeVo 
{
	//空状态
	public static const EMPTY:int = 0;
	//不稳定可擦除状态
	public static const UNSTABLE:int = 1;
	//稳定状态不可擦除
	public static const STABLE:int = 2;
	//颜色
	public var color:uint = 0;
	//状态0白色无状态，1每帧可擦除状态，2固定状态
	public var status:int = 0;
	//行号
	private var row:int;
	//列号
	private var column:int;
	//透明度
	public var alpha:Number = 1;
	public function NodeVo(row:int, column:int)
	{
		this.row = row;
		this.column = column;
	}
	
	/**
	 * 格式化字符串形式
	 * @return
	 */
	public function toString():String
	{
		return "row:" + row + " column:" + column;
	}
}
}