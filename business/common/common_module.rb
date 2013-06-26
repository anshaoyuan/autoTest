#encoding:utf-8
module Common
	def jump_to_my_space
		a_link =@wait.until{ @driver.find_element(:id,"right_userName") }
		a_link.click
	end
	def show_my_follow_user
		jump_to_my_space
		my_follow_btn = @wait.until{@driver.find_element(:id,"myattention-lxj")}
		my_follow_btn.click
		wait(3)
	end
	def show_my_new_fans_user
		jump_to_my_space
		my_remind_btn = @wait.until{@driver.find_element(:id,"myremind-lxj")}
		my_remind_btn.click
		new_fans_li = @wait.until{@driver.find_element(:id,"fans-l")}
		new_fans_li.find_element(:tag_name,"a").click
		wait(3)
	end
	def show_my_fans_user
		jump_to_my_space
		my_fans_btn = @wait.until{@driver.find_element(:id,"myfans-lxj")}
		my_fans_btn.click
		wait(3)
	end
	def show_my_chat_history
		jump_to_my_space
		my_talk = @wait.until{@driver.find_element(:id,"mynotes-lxj")}
		my_talk.click
		wait(3)
	end
	def show_my_store_stream
		jump_to_my_space
		my_store = @wait.until{@driver.find_element(:id,"mystore-lxj")}
		my_store.click
		wait(3)
	end
	def get_option_from_component_by_name(component_id,name)
		component = @wait.until{@driver.find_element(:id,component_id)}
		show_team_a = component.find_element(:tag_name,"a")
		show_team_a.click
		input=@wait.until{ component.find_element(:css,"div div input")}
		input.send_keys name
		wait(1)
		lis = component.find_elements(:tag_name,"li")
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
		input = @wait.until{@driver.find_element(:css,"##{div_id} ul li input.default")}
		input.clear
		member_array.each do |member|
			input.send_keys member
			wait(1)
			input.click
			members = @wait.until{@driver.find_elements(:css,"##{div_id} div ul li")}
			members.each do |li|
				if li.text.include?member
					li.click
					break
				end
			end
			
		end
		
	end
	def set_option_to_input_by_search(member_array,div_id)
		return if member_array.nil?
			begin
				tag_input = @wait.until{@driver.find_element(:css,"##{div_id} ul li input.default")}
				tag_input.clear
				member_array.each do |tag|
					tag_input.send_keys tag
					search_btn = @wait.until{@driver.find_element(:css,"##{div_id} ul li a")}
					search_btn.click
					wait(3)
					tag_list = @wait.until{@driver.find_elements(:css,"##{div_id} div ul li")}
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
        @wait.until{@driver.find_element(:id,"username")}.click
        @wait.until{@driver.find_element(:id,"changeUserId")}.click
        username = @wait.until{@driver.find_element(:id,"signin-email")}
        username.clear
        username.send_keys login_name
        userpwd = @wait.until{@driver.find_element(:id,"signin-password")}
        userpwd.clear
        userpwd.send_keys pwd
        @driver.find_element(:id,"loginBtn").click
        wait(5)
    	change_panel_class = @driver.find_element(:id,"switcher").attribute("class")
    	!change_panel_class.include?("in")
    end
end
