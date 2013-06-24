require_relative '../test'
require 'spec_helper'
describe Test1 do
	
	context "release stream" do

		let(:test) { Test1.new }
		
		before(:all){test}
		#subject(test)
		it "should release a new norimal stream" do
			test.t
		end
		it "should release a new stream for vote" do
			test.t1
		end
	end
	describe "test" do
		it "should nothing" do
				expect(example.metadata[:description]).to eq("should nothing")
		end

	end

end