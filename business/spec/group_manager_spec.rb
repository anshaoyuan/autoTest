#encoding:utf-8
require_relative 'spec_helper'
require_relative '../config_option'
describe GroupManager do
	before(:all){@manager = GroupManager.new}
	after(:all){@manager.closeDriver}
	before(:each){@manager.get_my_first_team_manager}
	context "basic team info for manager" do
		
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
		it "should be true when set team to use tag or not",level1:true do
			check_team_use_tag(true,@manager)
			check_team_use_tag(false,@manager)
		end 

		it "should be true when set team to use backup email",level1:true do
			check_team_use_backup_email(true,@manager)
			check_team_use_backup_email(false,@manager)
		end

		it "should be true when set team to a invite team or not ",level1:true do
			check_team_for_invite(true,@manager)
			check_team_for_invite(false,@manager)
		end

		it "should be true when update team type",level1:true do
			@manager.update_team_type_to_public
			@manager.team_type_is_public?.should be_true
			@manager.update_team_type_to_helf_public
			@manager.team_type_is_helf_public?.should be_true
			@manager.update_team_type_to_private
			@manager.team_type_is_private?.should be_true
		end
	end

	def check_team_use_tag(is_use_tag,driver)
			driver.set_team_use_tag(is_use_tag)
			driver.valid_team_use_tag?.should == is_use_tag
	end
	def check_team_use_backup_email(is_use_backup_email,driver)
		driver.set_team_user_backup_email(is_use_backup_email)
		driver.valid_team_use_backup_email?.should == is_use_backup_email
	end
	def check_team_for_invite(is_invite,driver)
		driver.set_team_invite_info(is_invite)
		driver.valid_team_invite_info?.should == is_invite
	end
end