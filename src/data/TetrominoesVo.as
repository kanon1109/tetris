package data 
{
/**
 * ...基础图形数据
 * @author Kanon
 */
public class TetrominoesVo 
{
	//横向索引（用于左右移动）
	public var posX:int;
	//纵向索引（用于上下自由落体）
	public var posY:int;
	//宽度（横向最大格子数量）
	public var width:int;
	//高度（纵向最大格子数量）
	public var height:int;
	//左边第一个有格子的位置
	public var left:int;
	//当前方块类型
	public var type:int;
	//当前方向
	private var _dir:int;
	//方块地图数组
	private var tetrominoesAry:Array;
	//当前方块地图数组
	private var map:Array;
	public function TetrominoesVo() 
	{
		this.tetrominoesAry = [];
		//长形2个方向
		this.tetrominoesAry[0] = [
								[[0, 0, 0, 0], [1, 1, 1, 1], [0, 0, 0, 0], [0, 0, 0, 0]], 
								[[0, 1, 0, 0], [0, 1, 0, 0], [0, 1, 0, 0], [0, 1, 0, 0]]
								];
		//凸字形4个方向
		this.tetrominoesAry[1] = [
								[[0, 0, 0, 0], [1, 1, 1, 0], [0, 1, 0, 0], [0, 0, 0, 0]], 
								[[0, 1, 0, 0], [1, 1, 0, 0], [0, 1, 0, 0], [0, 0, 0, 0]],
								[[0, 1, 0, 0], [1, 1, 1, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
								[[0, 1, 0, 0], [0, 1, 1, 0], [0, 1, 0, 0], [0, 0, 0, 0]]
								];
		//L字形4个方向
		this.tetrominoesAry[2] = [
								[[0, 0, 0, 0], [1, 1, 1, 0], [1, 0, 0, 0], [0, 0, 0, 0]], 
								[[1, 1, 0, 0], [0, 1, 0, 0], [0, 1, 0, 0], [0, 0, 0, 0]], 
								[[0, 0, 1, 0], [1, 1, 1, 0], [0, 0, 0, 0], [0, 0, 0, 0]], 
								[[0, 0, 1, 0], [0, 1, 0, 0], [0, 1, 1, 0], [0, 0, 0, 0]]
								]
		//反向L字形4个方向						
		this.tetrominoesAry[3] = [
								[[1, 0, 0, 0], [1, 1, 1, 0], [0, 0, 0, 0], [0, 0, 0, 0]], 
								[[0, 1, 1, 0], [0, 1, 0, 0], [0, 1, 0, 0], [0, 0, 0, 0]], 
								[[0, 0, 0, 0], [1, 1, 1, 0], [0, 0, 1, 0], [0, 0, 0, 0]], 
								[[0, 1, 0, 0], [0, 1, 0, 0], [1, 1, 0, 0], [0, 0, 0, 0]]
								]
								
		//Z字形2个方向				
		this.tetrominoesAry[4] = [
								[[0, 0, 0, 0], [1, 1, 0, 0], [0, 1, 1, 0], [0, 0, 0, 0]], 
								[[0, 0, 1, 0], [0, 1, 1, 0], [0, 1, 0, 0], [0, 0, 0, 0]]
								]
								
		//反Z字形2个方向				
		this.tetrominoesAry[5] = [
								[[0, 0, 0, 0], [0, 1, 1, 0], [1, 1, 0, 0], [0, 0, 0, 0]], 
								[[0, 1, 0, 0], [0, 1, 1, 0], [0, 0, 1, 0], [0, 0, 0, 0]]
								]
								
		//方形1个方向				
		this.tetrominoesAry[6] = [
								[[0, 1, 1, 0], [0, 1, 1, 0], [0, 0, 0, 0], [0, 0, 0, 0]] 
								]
	}
	
	/**
	 * 根据类型设置方块
	 * @param	type	方块类型
	 * @return	方块数组(包括方向)
	 */
	private function getTetrominoeByType(type:int):Array
	{
		if (type < 0) type = 0;
		if (type > this.tetrominoesAry.length - 1) type = this.tetrominoesAry.length - 1;
		return this.tetrominoesAry[type];
	}
	
	/**
	 * 根据方向获取方块数组
	 * @param	dir		方向
	 * @return	方块数组
	 */
	private function getTetrominoeByDir(dir:int):Array
	{
		var arr:Array = this.getTetrominoeByType(this.type);
		if (arr)
		{
			if (dir < 0) dir = 0;
			if (dir > arr.length - 1) dir = arr.length - 1;
			this.width = this.getWidth(arr[dir]);
			this.height = this.getHeight(arr[dir]);
			this.left = this.getLeft(arr[dir]);
			return arr[dir];
		}
		return null;
	}
	
	/**
	 * 获取宽度
	 * @param	arr	 方块数据
	 * @return	宽度
	 */
	private function getWidth(arr:Array):int
	{
		if (!arr) return 0;
		var length:int = arr.length;
		var maxWidth:int = 0;
		for (var i:int = 0; i < length; i += 1)
		{
			var width:int = 0;
			var rowAry:Array = arr[i];
			var len:int = rowAry.length;
			for (var j:int = 0; j < len; j += 1) 
			{
				if (rowAry[j] == 1)
				{
					width++;
				}
			}
			if (width > maxWidth)
				maxWidth = width;
		}
		return maxWidth;
	}
	
	/**
	 * 获取高度
	 * @param	arr	 方块数据
	 * @return	高度
	 */
	private function getHeight(arr:Array):int
	{
		if (!arr) return 0;
		var len:int = arr.length;
		var length:int = arr[0].length;
		var maxHeight:int = 0;
		for (var i:int = 0; i < length; i += 1)
		{
			var height:int = 0;
			for (var j:int = 0; j < len; j += 1) 
			{
				if (arr[j][i] == 1)
				{
					height++;
				}
			}
			if (height > maxHeight)
				maxHeight = height;
		}
		return maxHeight;
	}
	
	/**
	 * 获取方块数组最左边数据为1的索引
	 * @param	arr  方块数据
	 * @return	左边索引
	 */
	private function getLeft(arr:Array):int
	{
		if (!arr) return 0;
		var length:int = arr.length;
		var minIndex:int = arr[0].length;
		for (var i:int = 0; i < length; i += 1)
		{
			var rowAry:Array = arr[i];
			var len:int = rowAry.length;
			var index:int = len;
			for (var j:int = 0; j < len; j += 1) 
			{
				if (rowAry[j] == 1)
				{
					index = j;
					break;
				}
			}
			if (index < minIndex)
				minIndex = index;
		}
		return minIndex;
	}
	
	/**
	 * 获取方块数据
	 * @return	方块数组
	 */
	public function getTetrominoe():Array
	{
		return this.getTetrominoeByDir(this._dir);
	}
	
	/**
	 * 设置方向
	 */
	public function get dir():int{ return _dir; }
	public function set dir(value:int):void 
	{
		_dir = value;
		var arr:Array = this.getTetrominoeByType(this.type);
		if (this._dir < 0) this._dir = arr.length - 1;
		if (this._dir > arr.length - 1) this._dir = 0;
	}
}
}