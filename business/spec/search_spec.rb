#encoding:utf-8
require 'spec_helper'

describe Search do
	before(:all){@search = Search.new}
	after(:all){@search.closeDriver}
	describe "search stream" do
		search_content = "_autotest"
		it "should have result by content",level2:true do
			@search.search_stream_by_content(search_content).should be_true
		end
		it "should be true when search stream by title",level2:true  do
			@search.search_stream_by_title("2012四川旅游-人物篇").should be_true
		end
		it "should be true when search stream by team",level2:true do
			@search.search_stream_by_team("开发").should be_true
		end
		it "should be true when search stream by user",level2:true do
			@search.search_stream_by_vest(Config_Option::VEST_NAME).should be_true
		end
		it "should be true when search stream by tag name",level2:true do
			@search.search_stream_by_tagname("txt").should be_true
		end
=begin		
		it "should be true when search stream by start date" do 
			pending "date search is wrong" do
			@search.search_stream_by_start_date.should be_true
			end
		end
		it "should be true when search stream by end date" do
			pending "date search is wrong" do
			@search.search_stream_by_end_date
			end
		end
=end		
		it "should be true when search stream by hot tag",level2:true do
			@search.search_stream_by_tag.should be_true
		end
	end
	describe "search user" do
		it "should not be nil when search user by user name",level2:true do
			@search.search_vest_by_vestname(Config_Option::VEST_NAME).should_not be_nil
		end
		it "should be nil when search user by wrong name",level2:true do
			@search.search_vest_by_vestname(Config_Option::WRONG_VEST_NAME).should be_nil
		end
		it "should be true when search user and follow it",level2:true do
			@search.follow_user_by_search(Config_Option::VEST_NAME_LIUSS).should be_true
		end
	end
	describe "search team" do
		it "should not be nil when search team by right team name",level2:true do
			@search.search_team_by_teamname(Config_Option::TEAM_NAME).should_not be_nil
		end
		it "should be nil when search team by wrong team name",level2:true do
			@search.search_team_by_teamname(Config_Option::WRONG_TEAM_NAME).should be_nil
		end
	end
end
