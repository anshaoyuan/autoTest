#encoding:utf-8
require_relative 'core/base'
require_relative 'common/team_module'
require_relative 'common/alert_message'
class GroupManager < Base
	include TeamModule
	include Message

	def get_my_first_team_manager
		get_team_create_by_myself_last.find_element(:css,"div h5 a").click
		go_to_group_manager
	end
	def go_to_group_manager
		@wait.until{@driver.find_element(:id,"show_options")}.click
		@wait.until{@driver.find_element(:id,"teamSet")}.click
		
	end
	def valid_teamName(team_name)
		update_info_by_typename("vo.teamName",team_name)
		lost_focus
		has_warn?("group-name","teamUpdateForm",".greenPopup")&&check_value_is_update?("vo.teamName",team_name)
	end
	def valid_teamDescribe(team_describe)
		update_info_by_typename("vo.teamDesc",team_describe)
		lost_focus
		!has_warn?("group-name","teamUpdateForm")&&check_value_is_update?("vo.teamDesc",team_describe)
	end
	private 
	def save_basic_team_info
		@driver.find_element(:css,"button.btn.btn-danger.btn-small.teamset-btn").click
	end

	def check_value_is_update?(name,value)
		save_basic_team_info
		wait(10)
		go_to_group_manager
		is_update?(name,value)
	end
	def lost_focus
		@driver.find_element(:id,"teamSetClue").click
	end
end