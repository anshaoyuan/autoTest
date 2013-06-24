#encoding:utf-8
require_relative 'core/base'
require_relative 'config_option'
require_relative 'common/talk_module'

class Talk < Base
	include Common
	include Talk_Module
	def talk_to(user_info)
		show_talk_user_list
		#make a random number from Config_Option::MESSAGE size
		message_index = rand(Config_Option::MESSAGE.length)
		#get a message info from Config_Option::MESSAGE
		message_info = Config_Option::MESSAGE[message_index]
		
		talk_with_other_user(message_info,user_info)
		@log.info("消息发送完毕")
	end
	def search_my_chat_history
		show_my_chat_history
		wait(5)
		first_message = get_first_message
		search_message? first_message
	end
	def talk_with_other_user(message_info,user_info)
		get_talker_from_my_follow(user_info[:name])
		t = Talk.new(user_info)
		read_all_chat_message(t)
		send_keys(message_info[0])
		wait(10)
		t.show_talk_user_list
		wait(5)
		begin
			talkking(message_info,t)
		rescue Exception => e
			t.getLog.error("即时聊天失败")
			@log.error("即时聊天失败")
			raise "即时聊天失败",e
		end
	end
	def get_first_message
		messages = @wait.until{@driver.find_elements(:css,"#user_note div div div.clearfix")}
		first_message = messages[0].find_element(:css,"div p.liaotian").text
	end
	def search_message?(message)
		show_search_btn = @wait.until{@driver.find_element(:id,"searchNotes")}
		show_search_btn.click
		search_content_input = @driver.find_element(:id,"vo_context")
		search_content_input.send_keys message
		search_btn = @driver.find_element(:id,"search_note")
		search_btn.click
		first_result_from_search = get_first_message
		first_result_from_search.include?message

	end
	def talkking(message_info,user_driver)
		for i in 1...message_info.length
				if i%2==0
					send_keys(message_info[i])
				else
					user_driver.send_keys(message_info[i])
				end
				wait(1)
				if(i==message_info.length-1)
					user_driver.getLog.info("消息发送完毕")
					user_driver.closeDriver
				end
		end
	end
end