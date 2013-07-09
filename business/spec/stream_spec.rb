#encoding:utf-8
require 'spec_helper'

describe Stream do
	before(:all){@stream=Stream.new}
	after(:all){@stream.closeDriver}
	describe "release stream" do
		it "should release a new norimal stream",level1:true do
			@stream.release_stream(@stream.get_currtime_stream_content).should be_true
		end
		it "should release a new stream for vote" ,level1:true do
			@stream.release_vote(@stream.get_currtime_stream_content).should be_true
		end
		it "should release a new stream for active" ,level1:true do
			@stream.release_ative(@stream.get_currtime_stream_content,Config_Option::MEMBERS,"schould").should be_true
		end
	end
=begin	
	describe "first title should be current date" do
		it "first title should be the release title" do
			@stream.first_title_is_release_title.should be_true
		end
	end	
=end	
	describe "transmit stream on curr team" do
		it "transimit stream should at top position on the stream div",level1:true do
			@stream.transmit_stream.should be_true
		end
	end
	describe "delete stream from user share" do
		it "should delete stream" do
			@stream.delete_stream_from_my_share.should be_true
		end
	end
	describe "store stream" do
		it "should be true when store a stream " do
			first_stream = @stream.get_first_title_first_stream
			@stream.store_stream(first_stream).should be_true
		end
		it "should be true when store a new stream by other user release" do 
			@stream.release_stream("测试收藏")
			stream_for_store = Stream.new(Config_Option::OTHER_USER_INFO)
			first_stream = stream_for_store.get_first_title_first_stream
			first_stream_content = first_stream.text
			
			stream_for_store.store_stream(first_stream).should be_true
			first_store_stream = stream_for_store.get_first_stream_by_store
			first_store_stream_content = first_store_stream.text
			stream_for_store.closeDriver
			first_store_stream_content.include?(first_stream_content).should be_true 
		end
	end

end
