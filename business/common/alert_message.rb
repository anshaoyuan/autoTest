#encoding:utf-8
module Message
	def do_confirm(type)
			message_div = @driver.find_element(:id,"jquery-msg-content")
			a_links = message_div.find_elements(:tag_name,"a")
			a_links.each do |a|
				if a.text.include?type
					a.click
					break
				end
			end
	end
	def has_warn?(id,form_id,color=nil)
		wait = Selenium::WebDriver::Wait.new({timeout:3})
		begin
			wait.until{@driver.find_element(:css,"div.#{id}formError.parentForm#{form_id}.formError#{color}")}
			@log.info("不能修改")
			true
		rescue Exception => e
			@log.info("能修改")
			false
		end
	end
end