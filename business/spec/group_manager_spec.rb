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
	context "valid stream visible by team type" do
		pending "wait team member" do 
		end
	end
	context "team member manager" do
		before(:each){@manager.get_my_first_team_manager}
		it "should be true when add a member to team ",level1:true do
			@manager.add_team_member(Config_Option::VEST_NAME_LIUSS)
			@manager.has_member?(Config_Option::VEST_NAME_LIUSS).should be_true
		end
		it "should be true when remove a memeber from team",level1:true do
			@manager.remove_team_member(Config_Option::VEST_NAME_LIUSS)
			@manager.has_member?(Config_Option::VEST_NAME_LIUSS).should_not be_true
		end

	end
	context "team tag manager" do
		before(:each){@manager.get_my_first_team}
		it "should be true when add a tag to team ",level1:true do
			tag_count = @manager.get_team_tag_count
			@manager.add_team_tag(@manager.getrandom)
			@manager.get_my_first_team
			after_count = @manager.get_team_tag_count
			after_count.should > tag_count
		end
		it "should be true when remove a tag from team ",level1:true do
			tag_count = @manager.get_team_tag_count
			if tag_count==0
				@manager.add_team_tag(@manager.getrandom)
				@manager.get_my_first_team
				tag_count = @manager.get_team_tag_count
			end
			@manager.remove_team_tag
			@manager.get_my_first_team
			after_count = @manager.get_team_tag_count
			after_count.should < tag_count
		end
	end
	context "team announcement manager" do 
		before(:each) do 
			@manager.get_my_first_team
			@manager.go_to_group_announcement
		end
		context "valid announcement info when add a announcement" do
			before(:each) {@manager.show_add_announcement_panel}
			it "should be false when title is more than 50 chars" do
				@manager.valid_announcement_title(Config_Option::WRONG_SIGN_FOR_MORE_THAN_50_LENGTH).should be_false
			end
			it "should be false when title is empty" do
				@manager.valid_announcement_title(" ").should be_false
			end
			it "should be true when title is eligible" do 
				@manager.valid_announcement_title(@manager.getrandom).should be_true
			end
			it "should be false when announcement content is more than 50 chars" do
				@manager.valid_announcement_content(Config_Option::WRONG_SIGN_FOR_MORE_THAN_50_LENGTH).should be_false
			end
			it "should be true when announcement content is eligible" do
				@manager.valid_announcement_content(@manager.getrandom).should be_true
			end

		end
		context "add announcement " do
			before(:each) {@manager.show_add_announcement_panel}
			it "should be true when add a eligible announcement info" do
				announcement_info= {title:@manager.getrandom,content:@manager.getrandom}
				@manager.add_announcement(announcement_info).should be_true
			end

		end

		context "delete announcement" do
			it "should be true when delete a announcement info " do
				@manager.delete_announcement.should be_true
			end
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