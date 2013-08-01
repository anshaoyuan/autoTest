# encoding: utf-8
require_relative 'core/base'
require 'time'
require_relative 'config_option'
require_relative 'common/team_module'
require_relative 'common/alert_message'

class Group < Base
	include TeamModule
	include Message
	def joinGroup
	  @driver.get Config_Option::TEAM_ALL_URL
      @action_btn=nil
      @log.info("开始查找符合条件的群组")
      begin
          wait = Selenium::WebDriver::Wait.new(:timeout => 10)
          until @action_btn!=nil
              	@team_div = wait.until { @driver.find_element(:id,"teamList")}
              	lis = wait.until {@team_div.find_elements(:class,"group-item")}
                lis.each do|li|
                      	@action_btn = Group_Helper.find_btn_by_team_info_and_team_type(li,"半公开",@log)
                    	break if(!@action_btn.nil?)
                end
                break if(!@action_btn.nil?)
				goto_next_page_for_team(@action_btn,@team_div)
          end

          if(@action_btn.nil?)
            @driver.error("Can't find the the button for join team!")
          end
          team_excute(@action_btn)
      rescue Exception => e
        @log.error("出现异常啦!  #{e.message}")
        raise e
      end
	end

    def goto_next_page_for_team(action_btn,team_div)
        if(action_btn==nil)
                team_div=nil
                next_page_btn = @wait.until{ @driver.find_element(:link,"下一页")}
				next_page_btn.click
        end
        wait(5)
    end	

    def team_excute(action_btn)
    	    if(action_btn.text.eql?"加入群组")
    	    	team_excute_successful?(action_btn,"取消申请")
          	else
          		team_excute_successful?(action_btn,"加入群组")
          	end
    end

    def team_excute_successful?(btn,out_info)
		raise "群组处理按钮值与预期相同，属于异常操作" if btn.text.include?out_info
		btn.click
	    begin
	        @wait.until {btn.text.eql?out_info}
	     rescue Exception => e
	        @log.error("button text is #{btn.text} but button text shoulde be #{out_info}")
	    end
	end

	def create_new_team(team_info=build_team_info)
		goto_main_page
		wait(5)
		new_team_btn = @wait.until{@driver.find_element(:link_text,"创建群组")}
		new_team_btn.click
		wait(5)
		team_name = @wait.until{@driver.find_element(:id,"team-name")}
		team_name.send_keys team_info["name"]
		teamDesc = @wait.until{@driver.find_element(:id,"teamDesc")}
		teamDesc.send_keys team_info["desc"]
		set_team_tag(team_info["add_tag"],team_info["tags"])
		set_option_to_input(team_info["members"],"team_memeber_chzn")
		select_team_type team_info["team_type"]
		set_release_stream_need_tag team_info["release_stream_need_tag"]
		set_need_private_title team_info["need_private_title"]
		submit_team_info("创建")
		wait(2)
		have_team_name_from_my_team_list?team_info["name"]
	end
	def search_team_by_team_memeber(user_info,team_info=build_team_info)
		team_info["members"] << user_info[:name]
		create_new_team (team_info)
		search = Search.new(user_info)
		is_success = search.search_team_by_teamname(team_info["name"])
		search.closeDriver
		is_success
	end
	def get_my_teams_length_on_right_side
		goto_main_page
		my_team = @wait.until{@driver.find_element(:id,"my-teams")}
		my_team.find_elements(:css,"li.clearfix").length
	end
	def add_team_to_right_side
		before_teams_size_of_main_page = get_my_teams_length_on_right_side
		if(before_teams_size_of_main_page==Config_Option::MAX_TEAM_SIZE_ON_MIAN_PAGE)
			delete_team_from_right_side
			add_team_to_right_side
		else
			@log.info("添加群组到首页之前的数据总数是：#{before_teams_size_of_main_page}")
			add_team_to_main_page
			after_teams_size_of_main_page = get_my_teams_length_on_right_side
			@log.info("添加群组到首页之后的数据总数是：#{before_teams_size_of_main_page}")
			before_teams_size_of_main_page < after_teams_size_of_main_page
		end
	end
	def delete_team_from_right_side
		before_teams_size_of_main_page = get_my_teams_length_on_right_side
		if(before_teams_size_of_main_page == Config_Option::MIN_TEAM_SIZE_ON_MAIN_PAGE)
			add_team_to_right_side
			delete_team_from_right_side
		else
			@log.info("取消群组到首页之前的数据总数是：#{before_teams_size_of_main_page}")
			cancle_main_page_show
			after_teams_size_of_main_page = get_my_teams_length_on_right_side
			@log.info("取消群组到首页之后的数据总数是：#{after_teams_size_of_main_page}")
			before_teams_size_of_main_page > after_teams_size_of_main_page
		end

	end
	def set_team_tag(need_tag,tags)
		if need_tag
			set_option_to_input_by_search(tags,"teamTags_chzn")
		end
	end

	def select_team_type(type)
		case type
			when 2
				half_public_team= @wait.until{@driver.find_element(:id,"halfopen-team")}
				half_public_team.click
			when 3
				private_team = @wait.until{@driver.find_element(:id,"private-team")}
				private_team.click
			else
				public_team = @wait.until{@driver.find_element(:id,"open-team")}
				public_team.click
		end
	end
	def set_release_stream_need_tag(need_flag)
		if need_flag
			release_stream_need_tag = @wait.until{@driver.find_element(:name,"vo.useTeamTag")}
			release_stream_need_tag.click
			@log.info("set release stream need tag successful")
		end
	end
	def set_need_private_title(need_flag)
		if need_flag 
			need_private_title=@wait.until{@driver.find_element(:name,"vo.privateFlag")}
			need_private_title.click
		end
	end
	def build_team_info
		curr = getrandom+"_auto_team"
		team_info={"name"=>curr,"desc"=>curr,"team_type"=>3,"release_stream_need_tag"=>true,"need_private_title"=>true,"members"=>[Config_Option::VEST_NAME,Config_Option::VEST_NAME_LIUSS],"add_tag"=>true,"tags"=>[]}
	end

	def add_team_to_main_page
		show_my_teams
		begin
			btn = @wait.until{ @driver.find_elements(:link_text,"添加首页显示")[0]}
			btn.click
		rescue Exception => e
			@log.error("可能没有找到 添加首页显示 按钮#{e.message}")
			raise e
		end
	end
	def cancle_main_page_show
		show_my_teams
		begin
			btn = @wait.until{ @driver.find_elements(:link_text,"取消首页显示")[0]}
			btn.click
		rescue Exception => e
			@log.error("可能没有找到 取消首页显示 按钮#{e.message}")
			raise e
		end
	end
	def dismiss_team_from_my_teams(team_name=nil)
		#if team_name
		my_last_team =get_my_teams[0]
		my_last_team_name = my_last_team.find_element(:css,"div h5 a").text
		dismiss_btn = my_last_team.find_element(:link_text,"解散群组")
		dismiss_btn.click
		@log.info("解散第一个群组")
		do_confirm("确定")
		my_last_team_name
	end
	def submit_team_info(btn_type)
		create_team_div = @wait.until{@driver.find_element(:id,"newteam")}
		submit_btns = create_team_div.find_elements(:tag_name,"button")
		submit_btns.each do |btn|
			if btn.text.eql?btn_type
				btn.click
				break
			end
		end
	end
	def have_team_name_from_my_team_list?(team_name)
		my_last_team =  get_team_create_by_myself_last
		my_last_team_name = my_last_team.find_element(:css,"div h5 a").text
		my_last_team_name.include?team_name
	end

end
