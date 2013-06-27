#encoding:utf-8
require_relative 'spec_helper'
require_relative '../config_option'
describe GroupManager do
	before(:all){@manager = GroupManager.new}
	after(:all){@manager.closeDriver}
	context "basic team info for manager" do
		before(:each){@manager.get_my_first_team_manager}
		it "should be true when update team name with uniqueness" do
			@manager.valid_teamName(@manager.getrandom).should be_true
		end
		it "should be false when update team name with empty " do
			@manager.valid_teamName("").should be_false
		end
		it "should be false when update team name with special char" do
			@manager.valid_teamName(Config_Option::WRONG_TEAM_NAME_WITH_SPECIAL_CHAR).should be_false
		end
		it "should be false when update team name with long describe " do
			@manager.valid_teamName(Config_Option::WRONG_TEAM_NAME_WITH_LONG_DESCRIBE).should be_false
		end

		it "should be true when update team describe with right info" do
			@manager.valid_teamDescribe(Config_Option::RIGHT_TEAM_DESCRIBE).should be_true
		end
		it "should be true when udpate team describe with empty" do
			@manager.valid_teamDescribe("").should be_true
		end
		it "should be false when update team desribe with too long info" do
			@manager.valid_teamDescribe(Config_Option::WRONG_TEAM_DESCRIBE_WITH_LOGN_DESCRIBE).should be_false
		end
	end
end