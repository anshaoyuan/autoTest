#encoding:utf-8
module Stream_Module
	def store_stream(stream)
		store_btn = stream.find_element(:css,"a.btn.stream-collect")
		#先取消收藏，再重新收藏
		store_btn.click if is_store?(store_btn)
		wait(3)
		store_btn.click
		wait(3)
		is_store?(store_btn)

	end
	def is_store?(store_btn)
		!store_btn.attribute("class").include?"favourite"
	end
end