#encoding:utf-8
require 'spec_helper'
require_relative '../config_option'
describe Talk do
	before(:all){@talk = Talk.new }
	after(:all){@talk.closeDriver}
	it "should open talk panel" do
		@talk.talk_to(Config_Option::OTHER_USER_INFO)
	end
	it "should be true when search chat message" do
		@talk.search_my_chat_history.should be_true
	end
end