#encoding:utf-8
require_relative 'common_module'
module TeamModule
	include Common
	def get_team_create_by_myself_last
		get_my_teams[0]
	end
	def get_my_teams
		show_my_teams
		my_teams = @wait.until{@driver.find_elements(:css,"#collapseOne div li")}
	end
	def show_my_teams
		goto_main_page
		jump_to_my_space
		my_team = @wait.until{@driver.find_element(:css,"#myteam-lxj a")}
		my_team.click
		create_by_myself_team=@wait.until{@driver.find_element(:css,"#accordion2 div div a.accordion-toggle")}	
		create_by_myself_team.click
	end
	def get_curr_team_link
		get_element_by_css("#team-detials div h5 a")
	end
end