# encoding: utf-8
require_relative 'core/base'
require 'time'
require_relative 'config_option'
#require_relative 'common/common_module'
require_relative 'common/user_module'
class Search < Base
	#include Common
	include User_Module
	
	def search_stream(search_content)
		search_input = clear_top_search_input
		search_input.send_keys search_content
		search_btn = @driver.find_element(:id,"search-query")
		search_btn.click
		
	end
	def clear_top_search_input
		
		search_input =@wait.until { @driver.find_element(:css,"#top div div div input.pull-left")}
		
		search_input.clear
		search_input
	end
	def search_stream_by_content(search_content)
		goto_main_page
		search_stream search_content
		result = get_record_count_for_stream
		#puts result
		if result.eql?"0条"
			@log.error("search fail or release fails")
			false
		else
			@log.info("search successful!")
			true
		end
	end

	def search_stream_by_title(title=@title)
		show_high_grade_query_from
		title_input = @wait.until{@driver.find_element(:name,"searchVo.titleName")}	
		title_input.send_keys title
		
		check_result_by_condition("search by title")
	end
	
	def search_stream_by_team(team_name)
		show_high_grade_query_from
		get_option_from_component_by_name("specify_groups_chzn",team_name)
		check_result_by_condition("search by team")	
	end

	def search_stream_by_vest(vest_name)
		show_high_grade_query_from
		get_option_from_component_by_name("specify_users_chzn",vest_name)
		check_result_by_condition("search by vest")
	end
	def search_stream_by_start_date
		show_high_grade_query_from
		start_date = @wait.until{@driver.find_element(:name,"searchVo.startDate")}
		start_date.click
		@driver.find_element(:tag_name,"body").click
		check_result_by_condition("search by start date")
	end
	def search_stream_by_end_date
		show_high_grade_query_from
		end_date = @wait.until{@driver.find_element(:name,"searchVo.endDate")}
		end_date.click
		@driver.find_element(:tag_name,"body").click
		check_result_by_condition("search by end date")
	end
	def search_stream_by_tag
		begin
			first_tag = @wait.until{@driver.find_elements(:css,"#hot-tag div div a")[0]}
			first_tag.click
			first_tag_relationship = @wait.until{@driver.find_elements(:css,"#tagRelationship div span")[0]}
			first_tag_relationship.click
			check_result_by_condition("search stream by tag")
		rescue  Exception => e
			@log.info("search stream by tag fail#{e.message}")
			raise e
		end
	end

	def search_stream_by_tagname(tag_name)
		has_option = get_option_from_top_search_input_and_click(tag_name,"标签信息")
		if !has_option
			raise "can't search tag by tag_name#{tag_name}"
		end
		have_reslut_from_stream_div_by_condition?
	end
	
	def search_vest_by_vestname(vest_name)
		get_option_from_top_search_input_and_click(vest_name,"有关用户")
		have_result_from_vest_div_by_condition?
	end
	def get_vest_info_by_vestname(vest_name)
		if search_vest_by_vestname(vest_name)
			user_info = @wait.until{@driver.find_elements(:css,"#search-user-list ul li.user-item.clearfix")[0]}
		else
			@log.error("没有找到#{vest_name}用户 ")
			raise "没有找到#{vest_name}用户 "
		end
	end
	def follow_user_by_search(vest_name)
		user = get_vest_info_by_vestname(vest_name)

		follow_user_successful?(user)

	end
	def search_team_by_teamname(team_name)
		get_option_from_top_search_input_and_click(team_name,"有关群组")
		have_result_from_team_div_by_condition?
		
	end
	def get_team_info_by_teamname(team_name)
		if search_team_by_teamname(team_name)
			team_info = @wait.until{@driver.find_elements(:css,"#search-team-list ul li.group-item.clearfix")[0]}
		else
			@log.error("没有找到#{team_name}群组 ")
			raise "没有找到#{team_name}群组 "
		end
	end

	def get_option_from_top_search_input_and_click(search_condition,type)
		
		search_input = 	clear_top_search_input
		search_input.send_keys search_condition
		ul_option = @wait.until{@driver.find_element(:css,"#top div div div.navbar-search.open")}		
		a_options = ul_option.find_elements(:tag_name,"a")
		has_option=false
		a_options.each do |a|
			if a.text.include?type
				a.click
				has_option=true
				break
			end
		end
		has_option
	end
	def check_result_by_condition(message)
		goto_search
		begin
		record_count = get_record_count_for_stream
		result =(!record_count.eql?"0条" == have_reslut_from_stream_div_by_condition?)
		rescue Exception =>e
			@log.info("#{message} fail,Exception info #{e.message}")
			raise e
		ensure
			@log.info("#{message} finish")
		end
	end
	
	def show_high_grade_query_from
		goto_main_page
		search_btn = @wait.until{@driver.find_element(:id,"search-query")}
		search_btn.click
		high_grade_link_div = @wait.until {@driver.find_element(:id,"a_search_div")}			
		high_grade_btn = high_grade_link_div.find_element(:tag_name,"a")
		high_grade_btn.click
	end

	def goto_search
		search_btn= @wait.until{@driver.find_element(:id,"searchbtn")}
		search_btn.click	
	end

	def get_record_count_for_stream
		result = @wait.until{@driver.find_element(:css,"#search-stream-result h5 small strong").text}
	end
	def get_record_count_for_vest
		result = @wait.until{@driver.find_element(:css,"#search-vest-result h5 small strong").text}
	end
	
	def get_record_count_for_team
		result = @wait.until{@driver.find_element(:css,"#search-team-result h5 small strong").text}
	end
	def have_reslut_from_stream_div_by_condition?
		li = @wait.until{@driver.find_elements(:css,"#search-stream-list ul li")[0]}
		!li.text.include?"没有搜索到相关的博文信息! "
	end
	def have_result_from_vest_div_by_condition?
		div = @wait.until{@driver.find_element(:css,"#search-user-list ul div")}
		!div.text.include?"没有搜索到相关的用户信息!"
	end
	def have_result_from_team_div_by_condition?
		div = @wait.until{@driver.find_element(:css,"#search-team-list ul div")}
		!div.text.include?"没有搜索到相关的群组信息!"
	end
end

