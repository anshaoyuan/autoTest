#encoding:utf-8
require 'spec_helper'
describe Group do

	before(:all){@group = Group.new }
	after(:all){@group.closeDriver}
	describe "join unpublic team" do
		it "should join a unpublic team" do
			@group.joinGroup.should be_true
		end
	end
	describe "create new team" do
		it "should be true when create a new team and team member can search the team" do
			@group.create_new_team().should be_true
		end
		it "should be true when team memeber search team by team name " do
			@group.search_team_by_team_memeber(Config_Option::OTHER_USER_INFO).should be_true
		end
		it "should be false when create a team which name has been used" do
			team_info_first = @group.build_team_info
			@group.create_new_team(team_info_first).should be_true
			team_info_second = @group.build_team_info
			@group.create_new_team(team_info_second).should be_true
			@group.create_new_team(team_info_first).should be_false
		end
	end
	describe "add team show main page or cancle team show main page" do
		it "should have one team less" do
			@group.get_my_teams_length_on_right_side.should be >= 1
		end
		it "should be true when cancel a team show main page" do
			@group.delete_team_from_right_side.should be_true
		end
		it "should be true when add a team show main page" do
			@group.add_team_to_right_side.should be_true
		end

	end
	describe "dismiss team " do
		it "should be true when dismiss a team" do
			team_name = @group.dismiss_team_from_my_teams
			search = Search.new
			should_be_false = search.search_team_by_teamname(team_name)
			search.closeDriver
			expect(should_be_false).to be_false
		end
	end

	context "group mananger" do
		
	end

end
