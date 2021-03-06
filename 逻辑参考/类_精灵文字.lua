--==============================================================================--
--╭━━╮┏━━╮╭━━╮╭━━╮╭╭╮╮╭━━╮　╭╭╮╮╭━━╮╭╮╭╮╭━━╮
--┃╭━╯┃╭╮┃┃╭━╯┃╭╮┃┃　　┃┃╭━╯　┃　　┃┃╭╮┃┃╰╯┃┃╭━╯
--┃╰━╮┃┃┃┃┃┃╭╮┃╰╯┃┃┃┃┃┃╰━╮　┃┃┃┃┃╰╯┃┃　╭╯┃╰━╮
--┃╭━╯┃┃┃┃┃┃┃┃┃╭╮┃┃╭╮┃┃╭━╯　┃╭╮┃┃╭╮┃┃　╰╮┃╭━╯
--┃╰━╮┃╰╯┃┃╰╯┃┃┃┃┃┃┃┃┃┃╰━╮　┃┃┃┃┃┃┃┃┃╭╮┃┃╰━╮
--╰━━╯┗━━╯╰━━╯╰╯╰╯╰╯╰╯╰━━╯  ╰╯╰╯╰╯╰╯╰╯╰╯╰━━╯
--
-- ★ 精灵文字扩展类
--=============================================================================--
类_精灵文字  = class()

--=============================================================================--
-- ■ 构造函数
--=============================================================================--

function 类_精灵文字:初始化()	
	self.序列_图片 = {}
	self.序列_精灵 = {}

	for n=1,10 do
		self.序列_图片 [n] = 引擎:载入图片	("Dat/attacknum/A/" .. tostring(n-1) .. ".png")
		self.序列_精灵 [n] = D2D_精灵.创建(self.序列_图片 [n],0,0,引擎:取图片宽度(self.序列_图片 [n]),引擎:取图片高度(self.序列_图片 [n]))
	end
	
	



end






--=============================================================================--
-- ■ 显示
--=============================================================================--

function 类_精灵文字:显示(数值,x,y,每数字宽度,每数字高度,透明度,颜色)	
	
	if (数值 ==nil or 数值<=0) then 
		return 
	end 
	
	self.显示文本 = tostring(数值)
	
	self.文本长度 = string.len(self.显示文本)


	for n=1, self.文本长度 do

		local  本次 = tonumber(取文本中间(self.显示文本,n,1)) + 1

		if (颜色=="红") then
			self.序列_精灵 [本次]:置颜色 (ARGB (透明度, 255, 0, 0))
		elseif (颜色=="黄") then
			self.序列_精灵 [本次]:置颜色 (ARGB (透明度, 255,255,0))
		elseif (颜色=="白") then
			self.序列_精灵 [本次]:置颜色 (ARGB (透明度, 255,255,255))
		elseif (颜色=="绿") then
			self.序列_精灵 [本次]:置颜色 (颜色_绿)
			
		end
	
	
		self.序列_精灵 [本次]:显示_高级(取整((n-1)*(每数字宽度-2)+x),取整(y),0,每数字宽度/self.序列_精灵 [本次]:取宽度(),每数字高度/self.序列_精灵 [本次]:取高度())
	

	end
	

end



--=============================================================================--
-- ■ 销毁
--=============================================================================--

function 类_精灵文字:销毁()	

	for n=1,10 do
		引擎:销毁图片(self.序列_图片 [n] )
		self.序列_精灵 [n]:销毁()
	end

end 
