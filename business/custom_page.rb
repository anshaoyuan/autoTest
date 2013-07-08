#encoding:utf-8
require_relative 'core/base'
require_relative 'config_option'
require_relative 'common/common_module'
require_relative 'common/alert_message'
class CustomPage < Base
	include Common
	include Message
	MIN_SIZE=1
	def set_coustom_page_to_main_page
		goto_my_coustom_page
		set_main_btn = get_set_main_page_btn
		content = set_main_btn.text
		set_main_btn.click
		wait(3)
		change_login(@login_info[:login_name],@login_info[:pwd])
		if(content.include?Config_Option::SET_COUSTOME_TO_MAIN_PAGE )
			set_main_btn = get_set_main_page_btn
			!set_main_btn.text.include?Config_Option::SET_COUSTOME_TO_MAIN_PAGE
		else
			goto_my_coustom_page
			set_main_btn = get_set_main_page_btn
			!set_main_btn.text.include?Config_Option::CANCEL_COUSTOM_TO_MAIN_PAGE
		end
	end
	def check_all_config
		goto_my_coustom_page
		wait(10)
		#这里先需要设置等待加载时间，不然会为0
		if get_all_config.length > MIN_SIZE
			del_all_config
			wait(3)
			get_all_config.length == MIN_SIZE
		else
			@wait.until{@driver.find_element(:id,"theme-stream-none")}.text.include?"暂无博文!"
		end
	end

	def goto_my_coustom_page
		@driver.get Config_Option::COUSTOM_PAGE_URL
	end
	def add_config_by_type(type,config_info)
		
		wait(10)
		del_all_config
		wait(5)
		@wait.until{@driver.find_element(:class_name,"icon-plus")}.click
		@wait.until{@driver.find_element(:link_text,type)}.click
		array=[]
		array << config_info
		if(type.eql?"添加群组")
			set_option_to_input(array,"addGroup_chzn")
		elsif(type.eql?"添加用户")
			set_option_to_input(array,"addUser_chzn")
		else
			set_option_to_input_by_search(array,"post_target_select_mytag_chzn")
		end
		@driver.find_element(:id,"addsubmit").click
		wait(10)
		get_all_config.length > MIN_SIZE
	end
	private
	def del_all_config
			del_btn = @wait.until{@driver.find_element(:id,"tabDel")}
			del_btn.click
			del_configs = @wait.until{@driver.find_elements(:css,"#leftab li a span i.icon-remove.icon-white")}
			del_configs.each do |del|
				del.click
				wait(1)
				do_confirm("确定")
			end
	end
	def get_all_config
		@wait.until{@driver.find_elements(:css,"#leftab li")}
	end
	def get_set_main_page_btn
		@wait.until{@driver.find_element(:id,"setfirstPage")}
	end
end