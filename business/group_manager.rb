#encoding:utf-8
require_relative 'core/base'
require_relative 'common/team_module'
require_relative 'common/alert_message'
class GroupManager < Base
	include TeamModule
	include Message
	def initialize(obj = Config_Option::LOGIN_INFO)
		if obj.instance_of?Hash
			super
		elsif obj.class.superclass.to_s == "Base"
			@login_info = obj.get_login_info
			@driver = obj.getDriver
			@log = obj.getLog
			@wait = get_wait(20)
		else
			raise "initialize get a error , nonlicet args type for #{obj.class.superclass}"
		end
	end

	def get_my_first_team
		first_team = get_team_create_by_myself_last
		team_name = first_team.find_element(:css,"div h5 a").text
		first_team.find_element(:css,"div h5 a").click
		team_name
	end
	def go_to_team_manager
		if block_given?
			yield
		else
			get_my_first_team
		end
		go_to_group_manager
	end
	def show_options
		@wait.until{@driver.find_element(:id,"show_options")}.click
		wait(1)
	end
	def go_to_group_manager
		show_options
		@wait.until{@driver.find_element(:id,"teamSet")}.click
		get_element_by_css("#team-detials div h5 a").text
	end
	def go_to_group_main_page
		get_element_by_css("#team-detials div h5 a").click
	end
	def go_to_group_member
		show_options
		@wait.until{@driver.find_element(:id,"teamMember")}.click
	end
	def go_to_group_tag
		show_options
		get_element_by_id("tagtab").click
	end
	def go_to_group_announcement
		show_options
		get_element_by_id("teamPost").click
	end
	def valid_teamName(team_name)
		wait(2)
		update_info_by_typename("vo.teamName",team_name)
		lost_focus
		has_warn?("group-name","teamUpdateForm",".greenPopup")&&check_value_is_update?("vo.teamName",team_name)
	end
	def valid_teamDescribe(team_describe)
		wait(2)
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
	def get_team_tag_count
		wait(3)
		get_elements_by_css("#team-detials div.group-info.pull-left.side-hot-tags p.side-inner a").length
	end
	def add_team_tag(tag_name)
		go_to_group_tag
		get_element_by_css("#team-tagtab-h button").click
		wait(3)
		get_element_by_name("vo.tagName").send_keys tag_name
		get_element_by_css("button.btn.btn-primary",get_element_by_id("team-tagtab-body-new")).click
	end
	def remove_team_tag
		go_to_group_tag
		wait(3)
		get_elements_by_link_text("×")[0].click
	end
	def show_add_announcement_panel
		get_element_by_id("addPostBtn").click
	end
	def valid_announcement_title(title)
		update_info_by_typename("vo.posterTitle",title)
		get_element_by_id("addPostBtn").click
		!has_warn?("posterTitle","addPosterF")
	end
	def valid_announcement_content(content)
		update_info_by_typename("vo.posterContent",content)
		get_element_by_id("addPostBtn").click
		!has_warn?("description","addPosterF")
	end
	def add_announcement(option)
		if valid_announcement_title(option[:title])&&valid_announcement_content(option[:content])
			before_count = get_announcement_count
			get_element_by_css("button.btn.btn-success.btn-small",get_element_by_id("addPosterF")).click
			wait(3)
			get_announcement_count-before_count == 1
		else
			false
		end
	end 
	def get_announcement_count
		get_elements_by_css("div.accordion-group",get_element_by_id("group-annoucement")).length
	end
	def delete_announcement
		before_count = get_announcement_count
		if before_count==0
			@log.error("找不到可以删除的公告")
			raise "找不到可以删除的公告"
		else
			first_announcement = get_elements_by_css("div.accordion-group",get_element_by_id("group-annoucement"))[0]
			get_element_by_css("a.accordion-toggle",first_announcement).click
			wait(1)
			get_element_by_css("button.btn.btn-danger.btn-small.post-delete-d").click
			do_confirm("确定")
			refresh
			go_to_group_announcement
			get_announcement_count+1 == before_count
		end
	end

	def deliver_team(member_name)
		get_element_by_id("transfer-team").click
		css = "#transferTeam div div.accordion-inner div.chzn-container.chzn-container-single"
		get_option_from_component_by_name(css,member_name){ |css| get_element_by_css(css)}
		get_element_by_id("transfer-team－btn").click
		do_confirm("确定")
	end

	def change_member_manager(member_name)
		get_element_by_id("teammanage").click
		members = [member_name]
		set_option_to_input_by_class(members,"teammanage_div")
	end
	def is_manager?
		begin
			get_element_by_css("#dismissBtn a.accordion-toggle")
			true
		rescue Exception => e
			false
		end
	end

	def dismiss_team
		get_element_by_id("dismissBtn").click
		get_element_by_id("confirmation").click
		get_element_by_id("disband-btn").click

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