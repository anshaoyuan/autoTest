#encoding:utf-8
require_relative 'core/base'
require_relative 'config_option'
require_relative 'common/remind_module'
require_relative 'common/user_module'
require_relative 'common/alert_message'
class User < Base
	include Remind
	include User_Module
	include Message
	def follow_user
		goto_main_page
		user_link = @wait.until{@driver.find_element(:link_text,Config_Option::USER)}
		user_link.click
		user_div = @wait.until{@driver.find_element(:id,"vestList")}
		user = user_div.find_elements(:css,"ul li.user-item.clearfix")[0]
		follow_user_successful?(user)
	end
	def new_fans(fans_info)
		wait(5)
		before_new_fans_remind_count = new_fans_remind_count.to_i
		@log.info("被关注之前新粉提醒数量#{before_new_fans_remind_count}")
		search = Search.new(fans_info)
		user = search.get_vest_info_by_vestname(@login_info[:name])
		search.follow_user_by_user_info(user)
		search.closeDriver
		wait(10)
		begin
			@wait.until { new_fans_remind_count.to_i > before_new_fans_remind_count}
		rescue Exception => e
			@log.info("新粉丝数量没有增加")
			raise "新粉丝数量没有增加"
		end
		check_new_fans_is_in_my_space(Config_Option::OTHER_USER_INFO)
	end
	def check_new_fans_is_in_my_space(fans_info)
		show_my_new_fans_user
		my_new_fans_user = @wait.until{@driver.find_elements(:css,"#fans-i ul li.user-item.clearfix")}
		first_user_in_my_new_fans = is_name_in_user_info?(fans_info[:name],my_new_fans_user[0])
		show_my_fans_user
		my_fans_users =  @wait.until{@driver.find_elements(:css,"#my-fans ul li")}
		first_user_in_my_fans = is_name_in_user_info?(fans_info[:name],my_fans_users[0])
		first_user_in_my_new_fans && first_user_in_my_fans
	end
	def update_my_info
		jump_to_my_space
	end

	def valid_sign(sign)
		update_and_valid("vo.personalityName",sign,"user-sonalityName","userMsg-form")
	end
	def valid_name(name)
		update_info_by_typename("vo.realName",name)
		save_update
		has_warn?("user-name","userMsg-form",".greenPopup")&&is_update?("vo.realName",name)
	end
	def valid_title(title)
		update_and_valid("vo.position",title,"job-title","userMsg-form")
	end
	def valid_mobile(mobile_number)
		update_and_valid("vo.mobile",mobile_number,"mobile-number","userMsg-form")
	end
	def valid_qq_or_msn(sns_number)
		update_and_valid("vo.qqmsn",sns_number,"tencent-qq","userMsg-form")
	end
	def valid_address(address)
		update_and_valid("vo.location",address,"address","userMsg-form")
	end

	def valid_old_pwd(pwd)
		update_info_by_typename("vo.loginPasswd",pwd)
		#@driver.find_element(:id,"new-password").click
		save_pwd
		has_warn?("old-password","changePassword-form",".greenPopup")
	end
	def valid_new_pwd(new_pwd)
		update_info_by_typename("vo.newPasswd",new_pwd)
		save_pwd
		!has_warn?("new-password","changePassword-form")
	end
	def valid_confirm_pwd(new_pwd,confirm_pwd)
		set_new_pwd_and_confirm_pwd(new_pwd,confirm_pwd)
		!has_warn?("repeat-password","changePassword-form")
	end
	def update_pwd(pwd,confirm_pwd)
		update_info_by_typename("vo.loginPasswd",pwd)
		set_new_pwd_and_confirm_pwd(confirm_pwd,confirm_pwd)
		!has_warn?("new-password","changePassword-form")
	end
	def set_new_pwd_and_confirm_pwd(new_pwd,confirm_pwd)
		update_info_by_typename("vo.newPasswd",new_pwd)
		@wait.until{@driver.find_element(:id,"repeat-password")}.send_keys confirm_pwd
		save_pwd
	end
	def save_update
		@wait.until{@driver.find_element(:id,"saveBaseMsg")}.click
	end
	def save_pwd
		@wait.until{@driver.find_element(:id,"savePassword")}.click
	end


	#这个方法其实没有什么意义，只是用于做修改某项资料失去焦点，并且等待提示消息消失
	def disappear_message
		@driver.find_element(:link_text,"我的资料").click
	end
	def update_and_valid(name,for_update,id,form_id,color=nil)
		update_info_by_typename(name,for_update)
		is_valid?(id,form_id,color)&&is_update?(name,for_update)
	end

	private
	def is_valid?(id,form_id,color=nil)
		disappear_message
		save_update
		!has_warn?(id,form_id,color)
	end

end