#encoding:utf-8
require_relative '../config_option'
module Talk_Module
	def show_talk_user_list
		show_btn = @wait.until{@driver.find_element(:css,"#michat-right-foot-pannel span.sign")}
		show_btn.click
		wait(15)
	end
	def get_talker_from_my_follow(user_name)
		my_follow =  @wait.until{@driver.find_element(:css,"#michat-userlist-pannel div div.groupName.cascadeTitle")}
		my_follow.click
		my_follow_user_list = @wait.until{@driver.find_elements(:css,"#michat-userlist-pannel div ul li")}
		my_follow_user_list.each do |user|
			if user.text.include?user_name
				user.click
				break
			end
		end

	end
	def send_keys(worlds)

		text_area = @wait.until{@driver.find_element(:id,"chat_html")}
		text_area.send_keys worlds
		send_btn = @driver.find_element(:css,"body div div div div div div div.send")
		send_btn.click
		@log.info("#{worlds} send successful")
	end
	def read_all_chat_message(talk)
		talk.show_talk_user_list
		talk.getDriver.get Config_Option::LOGIN_URL
	end
end