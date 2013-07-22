require 'spec_helper'

describe Message_Info do
	before(:all){ @message = Message_Info.new}
	after(:all){ @message.closeDriver }
	it "should be true when release stream at someone" do
		@message.at_mention_me.should be_true
	end
	it "should be true when comment a stream" do
		@message.comment_me(Config_Option::OTHER_USER_INFO).should be_true
	end
	it "should be true when commend a stream " do
		@message.commend_me(Config_Option::OTHER_USER_INFO).should be_true
	end
	it "should be true when visit me to a new team" do
		@message.visit_me(Config_Option::OTHER_USER_INFO).should be_true
	end
	it "should be true when schedule me" do
		@message.schedule_me(Config_Option::OTHER_USER_INFO).should be_true
	end
	it "should be true when trend me " do 
		@message.trends_me(Config_Option::OTHER_USER_INFO).should be_true
	end
end