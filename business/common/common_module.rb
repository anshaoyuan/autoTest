#encoding:utf-8
module Common
	def jump_to_my_space
		a_link = get_element_by_id("right_userName")
		a_link.click
	end
	def show_my_follow_user
		jump_to_my_space
		my_follow_btn = get_element_by_id("myattention-lxj")
		my_follow_btn.click
		wait(3)
	end
	def show_my_new_fans_user
		jump_to_my_space
		my_remind_btn = get_element_by_id("myremind-lxj")
		my_remind_btn.click
		new_fans_li = get_element_by_id("fans-l")
		new_fans_li.find_element(:tag_name,"a").click
		wait(3)
	end
	def show_my_fans_user
		jump_to_my_space
		my_fans_btn = get_element_by_id("myfans-lxj") 
		my_fans_btn.click
		wait(3)
	end
	def show_my_chat_history
		jump_to_my_space
		my_talk = get_element_by_id("mynotes-lxj")
		my_talk.click
		wait(3)
	end
	def show_my_store_stream
		jump_to_my_space
		my_store = get_element_by_id("mystore-lxj")
		my_store.click
		wait(3)
	end
	def get_option_from_component_by_name(component_id,name)
		component = get_element_by_id(component_id)
		show_team_a = get_element_by_tag_name("a",component)
		show_team_a.click
		input= get_element_by_css("div div input",component) 
		input.send_keys name
		wait(1)
		lis = get_elements_by_tag_name("li",component)
		select_option_from_lis_by_search_name(lis,name)
	end
	def select_option_from_lis_by_search_name(lis,search_name)
		has_team=false
		lis.each do |option|
			if option.text.include?search_name
				option.click
				has_team=true
				break
			end
		end
		if(!has_team)
			@log.error("can't find the option by search name #{team_name}")
			raise "can't get the option to search"
		end
	end
	def set_option_to_input(member_array,div_id)
		return if member_array.nil?
		input = get_element_by_css("##{div_id} ul li input.default")
		input.clear
		select_option_by_members(member_array,input,div_id)
		
	end
	def set_option_to_input_by_class(member_array,div_id)
		return if member_array.nil?
		input = get_element_by_css("##{div_id} div div ul li.search-field input") 
		select_option_by_members(member_array,input,div_id)
	end
	def select_option_by_members(member_array,input,div_id)
		member_array.each do |member|
			input.send_keys member
			wait(1)
			input.click
			members = get_elements_by_css("##{div_id} div ul li")
			members.each do |li|
				if li.text.include?member
					li.click
					break
				end
			end
			
		end
	end
	def get_li_from_option_by_name(div_id,name)
		options = get_elements_by_css("##{div_id} div.accordion-inner div ul li")
		options.each do |li|
			return li if li.text.include?name
		end
		return nil
	end
	def set_option_to_input_by_search(member_array,div_id)
		return if member_array.nil?
			begin
				tag_input = get_element_by_css("##{div_id} ul li input.default")
				tag_input.clear
				member_array.each do |tag|
					tag_input.send_keys tag
					search_btn = get_element_by_css("##{div_id} ul li a")
					search_btn.click
					wait(3)
					tag_list = get_elements_by_css("##{div_id} div ul li")
					if tag_list.length>0
						tag_list[0].click
						@log.info("#{tag} add successfully")
					else
						@log.error("查不到标签")
					end
				end
			rescue Exception => e
				@log.error("出现异常，考虑是否是因为多个标签选择的问题!")
				raise e
			end
	end
	def change_login(login_name,pwd)
        get_element_by_id("username").click
        get_element_by_id("changeUserId").click
        username = get_element_by_id("signin-email")
        username.clear
        username.send_keys login_name
        userpwd = get_element_by_id("signin-password")
        userpwd.clear
        userpwd.send_keys pwd
        get_element_by_id("loginBtn").click
        wait(5)
    	change_panel_class = get_element_by_id("switcher").attribute("class")
    	!change_panel_class.include?("in")
    end
    def update_info_by_typename(name,info)
		typename = get_element_by_name(name)
		typename.clear
		typename.send_keys info
	end
	def is_update?(name,info)
		wait(3)
		get_element_by_name(name).attribute("value").eql?info
	end
	def get_element_by_name(name,finder = @driver)
		@wait.until{finder.find_element(:name,name)}
	end
	def get_element_by_id(id,finder = @driver)
		@wait.until{finder.find_element(:id,id)}
	end
	def get_element_by_css(css,finder = @driver)
		@wait.until{finder.find_element(:css,css)}
	end
	def get_elements_by_css(css,finder = @driver)
		@wait.until{finder.find_elements(:css,css)}
	end
	def get_element_by_tag_name(tag_name,finder = @driver)
		@wait.until{finder.find_element(:tag_name,tag_name)}
	end
	def get_elements_by_tag_name(tag_name,finder = @driver)
		@wait.until{finder.find_elements(:tag_name,tag_name)}
	end
	def get_element_by_link_text(link_text,finder = @driver)
		@wait.until{finder.find_element(:link_text,link_text)}
	end
	def get_elements_by_link_text(link_text,finder = @driver)
		@wait.until{finder.find_elements(:link_text,link_text)}
	end
	def get_element_by_class_name(class_name,finder = @driver)
		@wait.until{finder.find_elements(:class_name,class_name)}
	end
	def get_elements_by_class_name(class_name,finder = @driver)
		@wait.until{find.find_elements(:class_name,class_name)}
	end
end
