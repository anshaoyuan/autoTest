#encoding:utf-8
require 'spec_helper'
require_relative '../config_option'
describe Invite do

	context "invite user" do
		before(:all){@inviter = Invite.new(Config_Option::INVITE_USER) }
		after(:all){@inviter.closeDriver}
		it "should not have team link" do
			@inviter.has_team_link?.should be_false
		end
		it "should not have user link" do
			@inviter.has_user_link?.should be_false
		end

		it "should not have custome page link" do
			@inviter.has_custome_page_link?should be_false
		end

		it "cann't create a team " do 
			expect {@inviter.get_element_by_link_text("创建群组")}.to  raise_error(Selenium::WebDriver::Error::TimeOutError)
		end
		it "cann't find active user panel" do
			@inviter.get_element_by_id("index-active-users").text.should eq("")
		end
		it "cann't find active tag panel" do 
			@inviter.get_element_by_id("hot-tag").text.should eq("")
		end
		it "cann't find apps panel" do 
			@inviter.get_element_by_id("hot-app").text.should eq("")
		end
		it "cann't invite other user" do
			@inviter.get_element_by_id("invite").text.should eq("")
		end
		it "cann't find navigation tool" do 
			expect{@inviter.get_element_by_css("div.well.well-large.findmore")}.to  raise_error(Selenium::WebDriver::Error::TimeOutError)
		end
	end

	context "normal user " do 
		before(:all){@noraml_user_as_inviter = Invite.new }
		after(:all){@noraml_user_as_inviter.closeDriver}
		it "should have team link" do
			@noraml_user_as_inviter.has_team_link?.should be_true
		end

		it "should have user link" do
			@noraml_user_as_inviter.has_user_link?.should be_true
		end

		it "should have custom  page link" do
			@noraml_user_as_inviter.has_custome_page_link?.should be_true
		end

		it "can find create team button " do
			@noraml_user_as_inviter.get_element_by_link_text("创建群组").should_not be_nil
		end

		it " can find navigation tool " do 
			@noraml_user_as_inviter.get_element_by_css("div.well.well-large.findmore").should_not be_nil
		end
	end
end
