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
	//左边第一个有数据（颜色）的格子位置
	public var left:int;
	//顶部第一个有数据（颜色）的格子位置
	public var top:int;
	//当前方块类型
	public var type:int;
	//当前方向
	private var _dir:int;
	//方块地图数组
	private var tetrominoesModelList:Array;
	//当前方向方格的数据
	private var _map:Array;
	public function TetrominoesVo() 
	{
		this.tetrominoesModelList = [];
		//长形2个方向
		this.tetrominoesModelList[0] = [
								[[0, 0, 0, 0], [1, 1, 1, 1], [0, 0, 0, 0], [0, 0, 0, 0]], 
								[[0, 1, 0, 0], [0, 1, 0, 0], [0, 1, 0, 0], [0, 1, 0, 0]]
								];
		//凸字形4个方向
		this.tetrominoesModelList[1] = [
								[[0, 0, 0, 0], [1, 1, 1, 0], [0, 1, 0, 0], [0, 0, 0, 0]], 
								[[0, 1, 0, 0], [1, 1, 0, 0], [0, 1, 0, 0], [0, 0, 0, 0]],
								[[0, 1, 0, 0], [1, 1, 1, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
								[[0, 1, 0, 0], [0, 1, 1, 0], [0, 1, 0, 0], [0, 0, 0, 0]]
								];
		//L字形4个方向
		this.tetrominoesModelList[2] = [
								[[0, 0, 0, 0], [1, 1, 1, 0], [1, 0, 0, 0], [0, 0, 0, 0]], 
								[[1, 1, 0, 0], [0, 1, 0, 0], [0, 1, 0, 0], [0, 0, 0, 0]], 
								[[0, 0, 1, 0], [1, 1, 1, 0], [0, 0, 0, 0], [0, 0, 0, 0]], 
								[[0, 1, 0, 0], [0, 1, 0, 0], [0, 1, 1, 0], [0, 0, 0, 0]]
								]
		//反向L字形4个方向						
		this.tetrominoesModelList[3] = [
								[[1, 0, 0, 0], [1, 1, 1, 0], [0, 0, 0, 0], [0, 0, 0, 0]], 
								[[0, 1, 1, 0], [0, 1, 0, 0], [0, 1, 0, 0], [0, 0, 0, 0]], 
								[[0, 0, 0, 0], [1, 1, 1, 0], [0, 0, 1, 0], [0, 0, 0, 0]], 
								[[0, 1, 0, 0], [0, 1, 0, 0], [1, 1, 0, 0], [0, 0, 0, 0]]
								]
								
		//Z字形2个方向				
		this.tetrominoesModelList[4] = [
								[[0, 0, 0, 0], [1, 1, 0, 0], [0, 1, 1, 0], [0, 0, 0, 0]], 
								[[0, 0, 1, 0], [0, 1, 1, 0], [0, 1, 0, 0], [0, 0, 0, 0]]
								]
								
		//反Z字形2个方向				
		this.tetrominoesModelList[5] = [
								[[0, 0, 0, 0], [0, 1, 1, 0], [1, 1, 0, 0], [0, 0, 0, 0]], 
								[[0, 1, 0, 0], [0, 1, 1, 0], [0, 0, 1, 0], [0, 0, 0, 0]]
								]
								
		//方形1个方向				
		this.tetrominoesModelList[6] = [
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
		if (type > this.tetrominoesModelList.length - 1) type = this.tetrominoesModelList.length - 1;
		return this.tetrominoesModelList[type];
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
			var mapAry:Array = arr[dir];
			this.width = this.getWidth(mapAry);
			this.height = this.getHeight(mapAry);
			this.left = this.getLeft(mapAry);
			this.top = this.getTop(mapAry);
			return mapAry;
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
		var length:int = arr[0].length;
		var len:int = arr.length;
		var width:int = 0;
		//从左向右遍历
		for (var i:int = 0; i < length; i += 1)
		{
			//从上往下遍历
			for (var j:int = 0; j < len; j += 1) 
			{
				if (arr[j][i] == 1)
				{
					width++;
					break;
				}
			}
		}
		return width;
	}
	
	/**
	 * 获取高度
	 * @param	arr	 方块数据
	 * @return	高度
	 */
	private function getHeight(arr:Array):int
	{
		if (!arr) return 0;
		var length:int = arr.length;
		var len:int = arr[0].length;
		var height:int = 0;
		//从上往下遍历
		for (var i:int = 0; i < length; i += 1)
		{
			//从左往右遍历
			for (var j:int = 0; j < len; j += 1) 
			{
				if (arr[i][j] == 1)
				{
					height++;
					break;
				}
			}
		}
		return height;
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
	 * 获取顶部第一个有数据（颜色）的格子位置
	 * @param	arr	 方块数据
	 * @return	顶部第一个有数据（颜色）的格子位置索引
	 */
	private function getTop(arr:Array):int
	{
		if (!arr) return 0;
		var len:int = arr.length;
		var length:int = arr[0].length;
		var minIndex:int = len;
		for (var i:int = 0; i < length; i += 1)
		{
			var index:int = len;
			for (var j:int = 0; j < len; j += 1) 
			{
				if (arr[j][i] == 1)
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
	 * 设置方向
	 */
	public function get dir():int{ return _dir; }
	public function set dir(value:int):void 
	{
		_dir = value;
		var arr:Array = this.getTetrominoeByType(this.type);
		if (this._dir < 0) this._dir = arr.length - 1;
		if (this._dir > arr.length - 1) this._dir = 0;
		this._map = this.getTetrominoeByDir(this._dir);
	}
	
	/**
	 * 当前方向方格的数据
	 */
	public function get map():Array{ return _map; }
}
}