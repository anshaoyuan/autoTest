
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
	end

	context "normal user as inviter " do 
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
	end
end
