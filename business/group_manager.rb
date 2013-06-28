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
	def show_options
		@wait.until{@driver.find_element(:id,"show_options")}.click
		wait(1)
	end
	def go_to_group_manager
		show_options
		@wait.until{@driver.find_element(:id,"teamSet")}.click
		
	end
	def go_to_group_member
		show_options
		@wait.until{@driver.find_element(:id,"teamMember")}.click
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
	def set_team_use_tag(is_use)
		set_check_box_by_name("vo.useTeamTag",is_use)
	end
	def valid_team_use_tag?
		valid_check_box_by_name("vo.useTeamTag")
	end

	def  set_team_user_backup_email(is_use)
		set_check_box_by_name("vo.emailbox",is_use)
	end

	def valid_team_use_backup_email?
		valid_check_box_by_name("vo.emailbox")
	end
	def set_check_box_by_name(name,is_checked)
		checked = get_element_by_name(name).attribute("checked")
		get_element_by_name(name).click if is_checked == !checked
		save_basic_team_info
	end
	def valid_check_box_by_name(name)
		wait(10)
		go_to_group_manager
		!!get_element_by_name(name).attribute("checked") 
	end
	def set_team_invite_info(is_invite)
		set_check_box_by_name("vo.inviteFlag",is_invite)
	end
	def valid_team_invite_info?
		valid_check_box_by_name("vo.inviteFlag")
	end
	def update_team_type_to_public
		set_radio_box_by_id("team-access-open")
	end
	def update_team_type_to_helf_public
		set_radio_box_by_id("team-access-half")
	end
	def update_team_type_to_private
		set_radio_box_by_id("team-access-priv")
	end
	def team_type_is_public?
		valid_radio_box_by_id("team-access-open")
	end
	def team_type_is_helf_public?
		valid_radio_box_by_id("team-access-half")
	end
	def team_type_is_private?
		valid_radio_box_by_id("team-access-priv")
	end
	def set_radio_box_by_id(id)
		get_element_by_id(id).click
		save_basic_team_info
	end
	def valid_radio_box_by_id(id)
		wait(10)
		go_to_group_manager
		!!get_element_by_id(id).attribute("checked")
	end
	def remove_team_member(member_name)
		@wait.until{@driver.find_element(:link_text,"成员管理")}.click
		li = get_li_from_option_by_name("teammember_div",member_name)
		if !li.nil?
			li.find_element(:class_name,"search-choice-close").click
		end

	end
	def add_team_member(member_name)
		@wait.until{@driver.find_element(:link_text,"成员管理")}.click
		members = [member_name]
		set_option_to_input_by_class(members,"teammember_div")
	end
	def has_member?(member_name)
		go_to_group_member
		wait(10)
		members = @wait.until{@driver.find_elements(:css,"#teamMember-ul li.member-item.pull-left")}
		members.each do |member|
			member_text = member.find_element(:css,"div.member-info.pull-left h5 a").text
			return true if member_text.include?member_name
		end
		false
	end
	private 
	def show_team_member
		@wait.until{@driver.find_element(:css,"#teammember a.accordion-toggle")}.click
	end
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