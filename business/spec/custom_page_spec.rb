#encoding:utf-8
require 'spec_helper'

describe CustomPage do 
	before(:all){ @custom = CustomPage.new }
	after(:all){ @custom.closeDriver }
	#before(:each){@custom.goto_my_coustom_page}
	it "should be true when set custom page to main page or cancel custom page to main page" ,level1:true do 
		@custom.set_coustom_page_to_main_page.should be_true
	end
	it "should be true when remove all config",level1:true do
		@custom.check_all_config.should be_true
	end
	context "add config" do
		before(:each){@custom.goto_my_coustom_page}
		it "should be true when add team",level2:true do
			@custom.add_config_by_type("添加群组",Config_Option::COUSTOM_TEAM_INFO).should be_true
		end
		it "should be true when add user",level2:true do
			@custom.add_config_by_type("添加用户",Config_Option::COUSTOM_VEST_INFO).should be_true
		end
		it "should be true when add test",level2:true do
			@custom.add_config_by_type("添加标签",Config_Option::COUSTOM_TAG_INFO).should be_true
		end
	end

end