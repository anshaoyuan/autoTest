#encoding:utf-8
require 'spec_helper'

describe User do
	before(:all){@user = User.new(Config_Option::LOGIN_INFO) }
	after(:all){@user.closeDriver}
	it "should be true when follow a user ",level1:true do
		pending " search is wrong" do
			@user.follow_user.should be_true
		end
	end
	it "should be true when a fans follow curr user",level1:true do
		pending " search is wrong" do
			@user.new_fans(Config_Option::OTHER_USER_INFO).should be_true
		end
	end
	describe "update user info" do
		before(:each) do
			@user.update_my_info
		end
		after(:all) do
			@user.valid_name(Config_Option::LOGIN_INFO[:name])
		end
		it "should be false when update name is more than eight char",level1:true do
			@user.valid_name(Config_Option::WRONG_USER_NAME_FOR_MORE_THAN_8_LENGTH).should be_false
		end
		it "should be false when update name  with empty context",level1:true do
			@user.valid_name(Config_Option::WRONG_USER_NAME_FOR_EMPTY_NAME).should be_false
		end
		it "should be false when update name wich special char",level1:true do
			@user.valid_name(Config_Option::WRONG_USER_NAME_WITH_AT).should be_false
		end
		it "should be false when update name is not eligible",level1:true do
			@user.valid_name(Config_Option::WRONG_USER_NAME_WITH_TAG_FLAG).should be_false
		end
		it "should be true when update name is eligible",level1:true do
			@user.valid_name(Config_Option::RIGHT_USER_NAME_NORMAL).should be_true
		end
		it "should be true when update name with 8 length",level1:true do
			@user.valid_name(Config_Option::RIGHT_USER_NAME_FOR_8_LENGTH).should be_true
		end
		it "should be false when update title is not eligible",level1:true do
			@user.valid_title(Config_Option::WRONG_USER_TITLE_FOR_MORE_THAN_15_LENGTH).should be_false
			@user.valid_title(Config_Option::WRONG_USER_TITLE_FOR_special_chatset).should be_false
		end
		it "should be true when update title is eligible",level1:true do
			@user.valid_title(Config_Option::RIGHT_USER_TITLE_NORMAL).should be_true	
		end
		it "should be false when update sign is not eligible",level1:true do
			@user.valid_sign(Config_Option::WRONG_SIGN_FOR_MORE_THAN_50_LENGTH).should be_false
			@user.valid_sign(Config_Option::WRONG_SIGN_FOR_SPECIAL_CHATSET).should be_false
		end
		it "should be true when update sign is eligible",level1:true do
			@user.valid_sign(Config_Option::RIGHT_SIGN_NORMAL).should be_true	
		end

		it "should be false when update mobile number is not number",level1:true do
			@user.valid_mobile(Config_Option::WRONG_MOBILE_NUMBER_FOR_NOT_NUMBER).should be_false
		end
		it "should be false when update mobile number is more than 11",level1:true do
			@user.valid_mobile(Config_Option::WRONG_MOBILE_NUMBER_FOR_12_LENGTH).should be_false
		end
		it "should be false when update mobile number is not eligible",level1:true do
			@user.valid_mobile(Config_Option::WRONG_MOBILE_NUMBER_FOR_UNVALIDE).should be_false
		end
		it "should be false when update mobile number is too short",level1:true do
			@user.valid_mobile(Config_Option::WRONG_MOBILE_NUMBER_FOR_TOO_SHORT).should be_false
		end
		it "should be false when update mobile number is too long",level1:true do
			@user.valid_mobile(Config_Option::WRONG_MOBILE_NUMBER_FOR_TOO_LONG).should be_false
		end
		it "should be true when update mobile number is eligible",level1:true do
			@user.valid_mobile(Config_Option::RIGHT_MOBILE_NUMBER_FOR_11_LENGTH).should be_true
			@user.valid_mobile(Config_Option::RIGHT_MOBILE_NUMBER_FOR_TEL).should be_true
		end
		it "should be false when update qq with a wrong account",level1:true do
			@user.valid_qq_or_msn(Config_Option::WRONG_SNS_ACCOUNT_FOR_QQ).should be_false
		end
		it "should be false when update msn with a wrong account",level1:true do
			@user.valid_qq_or_msn(Config_Option::WRONG_SNS_ACOUNT_FOR_MSN).should be_false
		end
		it "should be true when update qq with a right account",level1:true do
			@user.valid_qq_or_msn(Config_Option::RIGHT_SNS_ACCOUNT_FOR_QQ).should be_true
		end
		it "should be true when update msn with a right account",level1:true do
			@user.valid_qq_or_msn(Config_Option::RIGHT_SNS_ACOUNT_FOR_MSN).should be_true
		end

		it "should be false when update address with special char",level1:true do
			@user.valid_address(Config_Option::WRONG_ADDRESS_WITH_SPECIAL_CHAR).should be_false
		end
		it "should be false when update address with long describe",level1:true do
			@user.valid_address(Config_Option::WRONG_ADDRESS_WITH_LONG_DESCRIBE).should be_false
		end

		it "should be true when update address with right info ",level1:true do
			@user.valid_address(Config_Option::RIGHT_ADDRESS).should be_true
		end
		
		it "should be true when valid old pwd with login pwd",level1:true do
			@user.valid_old_pwd(Config_Option::LOGIN_INFO[:pwd]).should be_true
		end

		it "should be false when valid old pwd with wrong pwd" ,level:true do
			wrong_pwd = Config_Option::LOGIN_INFO[:pwd].to_s+"123"
			@user.valid_old_pwd(wrong_pwd).should be_false
		end

		it "should be false when valid new pwd with pwd less than 6 length",level1:true do
			@user.valid_new_pwd(Config_Option::WRONG_PWD_FOR_LESS_THAN_6_LENGTH).should be_false
		end
		it "should be true when valid new pwd with right pwd",level1:true do
			@user.valid_new_pwd(Config_Option::RIGHT_PWD).should be_true
		end
		it "should be false when confirm pwd is deferent with new pwd",level1:true do
			@user.valid_confirm_pwd(Config_Option::RIGHT_PWD_CONFIRM,Config_Option::RIGHT_PWD_CONFIRM.to_s+"123").should be_false
		end
		it "should be true when config pwd is the same as new pwd ",level1:true do 
			@user.valid_confirm_pwd(Config_Option::LOGIN_INFO[:pwd],Config_Option::LOGIN_INFO[:pwd]).should be_true
		end
		it "should be false when update pwd is the same as old pwd",level1:true do
			@user.update_pwd(Config_Option::LOGIN_INFO[:pwd],Config_Option::LOGIN_INFO[:pwd]).should be_false
		end
		it "should be true when update pwd is the deferent with  old pwd",level1:true do
			@user.update_pwd(Config_Option::LOGIN_INFO[:pwd],Config_Option::NEW_PWD).should be_true
			@user.update_pwd(Config_Option::NEW_PWD,Config_Option::LOGIN_INFO[:pwd]).should be_true
		end
		
	end
	describe "change user" do
		it "should be true when change login",level1:true do
			@user.change_login(Config_Option::LOGIN_INFO[:login_name],Config_Option::LOGIN_INFO[:pwd]).should be_true
		end
	end
end
