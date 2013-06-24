require 'spec_helper'

	

describe Stream do
	before(:all){@stream=Stream.new}
	after(:all){@stream.closeDriver}
	describe "release stream" do
		it "should release a new norimal stream" do
			
			@stream.release_stream(@stream.get_currtime_stream_content).should be_true
		end
		it "should release a new stream for vote" do
		
			@stream.release_vote(@stream.get_currtime_stream_content).should be_true
		end
		it "should release a new stream for active" do
		
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
		it "transimit stream should at top position on the stream div" do
			@stream.transmit_stream.should be_true
		end
	end
	describe "delete stream from user share" do
		it "should delete stream" do
			@stream.delete_stream.should be_true
		end
	end

end
