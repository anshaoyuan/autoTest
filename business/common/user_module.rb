#encoding:utf-8
require_relative 'common_module'
module User_Module
	include Common
	def check_user_is_curr_user(user_name)
		if user_name.eql?@login_info[:name]
			@log.error("自己不能关注用户自己")
			raise "自己不能关注用户自己"
		end
	end
	def follow_user_by_user_info(user_info)
		user_name = get_user_name_by_user_info(user_info)
		check_user_is_curr_user(user_name)
		follow_btn = @wait.until{user_info.find_element(:css,"div a.userTzq")}
		if(!follow_btn.text.eql?("关注用户"))
			#cancel follow before follow this user
			follow_btn.click
			wait(2)
		end
		follow_btn.click
		user_name
	end
	
	def get_user_name_by_user_info(user_info)
		user_info.find_element(:css,"div h5 a").text
	end

	def follow_user_successful?(user)
		follow_user_name = follow_user_by_user_info(user)
		show_my_follow_user
		my_follow_users = @wait.until{@driver.find_elements(:css,"#my-attention ul li")}
		is_name_in_user_info?(follow_user_name,my_follow_users[0])
	end

	def is_name_in_user_info?(name,user_info)
		user_info_name = get_user_name_by_user_info(user_info)
		user_info_name.include?name
	end
end