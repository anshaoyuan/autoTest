#encoding:utf-8
require 'spec_helper'

describe Invite do

	context "invite user" do
		before(:all){@inviter = Invite.new(Config_Option::INVITE_USER) }
		after(:all){@inviter.closeDriver}
		it "should not have team link",level1:true do
			@inviter.has_team_link?.should be_false
		end
		it "should not have user link",level1:true do
			@inviter.has_user_link?.should be_false
		end

		it "should not have custome page link",level1:true do
			@inviter.has_custome_page_link?.should be_false
		end

		it "can't create a team ",level1:true do 
			expect {@inviter.get_element_by_link_text("创建群组")}.to  raise_error(Selenium::WebDriver::Error::TimeOutError)
		end
		it "can't find active user panel",level1:true do
			@inviter.get_element_by_id("index-active-users").text.should eq("")
		end
		it "can't find active tag panel",level1:true do 
			@inviter.get_element_by_id("hot-tag").text.should eq("")
		end
		it "can't find apps panel",level1:true do 
			@inviter.get_element_by_id("hot-app").text.should eq("")
		end
		it "can't invite other user",level1:true do
			@inviter.get_element_by_id("invite").text.should eq("")
		end
		it "can't find navigation tool",level1:true do 
			expect{@inviter.get_element_by_css("div.well.well-large.findmore")}.to  raise_error(Selenium::WebDriver::Error::TimeOutError)
		end
		it "can't visit normal user page ",level1:true  do 
			@inviter.visit_user_page(Config_Option::NORMAL_USER_PAGE).should be_false
		end
		it "can go to main page",level1:true do 
			@inviter.go_to_user_main_page.should be_true

		end
	end

	context "normal user " do 
		before(:all){@noraml_user_as_inviter = Invite.new }
		after(:all){@noraml_user_as_inviter.closeDriver}
		it "should have team link",level1:true do
			@noraml_user_as_inviter.has_team_link?.should be_true
		end

		it "should have user link",level1:true do
			@noraml_user_as_inviter.has_user_link?.should be_true
		end

		it "should have custom  page link",level1:true do
			@noraml_user_as_inviter.has_custome_page_link?.should be_true
		end

		it "can find create team button ",level1:true do
			@noraml_user_as_inviter.get_element_by_link_text("创建群组").should_not be_nil
		end

		it " can find navigation tool ",level1:true do 
			@noraml_user_as_inviter.get_element_by_css("div.well.well-large.findmore").should_not be_nil
		end
		it "can visit normal user page ",level1:true do
			@noraml_user_as_inviter.visit_user_page(Config_Option::NORMAL_USER_PAGE).should be_true
		end
		it "can go to main page",level1:true do 
			@noraml_user_as_inviter.go_to_user_main_page.should be_true

		end
	end
end
