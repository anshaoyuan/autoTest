#encoding:utf-8
require 'spec_helper'

describe Talk do
	before(:all){@talk = Talk.new }
	after(:all){@talk.closeDriver}
	it "should be true when open talk panel and send message ",level2:true do
		@talk.talk_to(Config_Option::OTHER_USER_INFO).should be_true
	end
	it "should be true when search chat message history",level2:true do
		@talk.search_my_chat_history.should be_true
	end
end