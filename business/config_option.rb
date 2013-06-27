# encoding: utf-8
class Config_Option
	#LOGIN_URL="http://www.findest.com.cn/webStream!index.action"
	BASE_URL="http://192.168.16.45:8090/sloth/"
	LOGIN_URL=BASE_URL+"webStream!index.action"
	#跳转到专页页面
	COUSTOM_PAGE_URL=BASE_URL+"webDiy!showPage.action"
	LoginName="tanzq@visionet.com.cn"
	LoginPWD="tanzhiqiang"
	OTHER_USER_INFO={login_name:LoginName,pwd:LoginPWD,name:"谭志强",id:"310"}
	
	LOGIN_INFO={login_name:"lixj@visionet.com.cn",pwd:"123456",name:"李晓健",id:"311"}
	ULR_= BASE_URL+"userRegiste!toSendEmailToUpdatePasswd.action"
	
	#team dir
	TEAM_ALL_URL=BASE_URL+"webShowteam!showteam.action"
	BrowserName = "firefox"


	ACTIVE_DATE="2014-05-23 09:09:09"
	ACTIVE_PLACE="office"
	ACTIVE_MINUTE=20
	
	ACTIVE_HOURS=1
	SEARCH_URL = BASE_URL+"sloth/webSearch!toSearch.action?method=post&searchVo.condition=&searchVo.tag=&searchVo.type=all"
	START_DATE_FOR_SEARCH="2012-12-12"
	END_DATE_FOR_SEARCH = "2013-12-12"
	VEST_NAME = "李晓健"	
	TEAM_NAME = "开发" 
	WRONG_VEST_NAME="ERROR VEST NAME"
	WRONG_TEAM_NAME = "ERROR TEAM NAME"
	VEST_NAME_LIUSS = "刘顺顺"
	MAX_TEAM_SIZE_ON_MIAN_PAGE=6;
	MIN_TEAM_SIZE_ON_MAIN_PAGE=1;
	USER = "用户"
	MESSAGE=[
		["在没？请我吃饭","没钱","不是发工资了吗？","交给媳妇了","汗"],
	["最近挺滋润嘛","哪有","床单滚多了吧","滚"],
	["问一件事","嗯","你借我钱什么时候还","不还","敢？"],
	["明天去体验","同去","你没病吧","你才有病","滚"]]
	STREAM_CONTENT="你借我钱什么时候还"
	RELEASE_STREAM_INFO = "测试发评论的博文"
	COMMNET = "测试发评论"
	COMMEND = "测试赞"
	MEMBERS=["刘顺顺"]
	SCHEDULE_TITLE="schedule release"
	SCHEDULE_CONTENT="测试日程"
	USER_INFO_FOR_UPDATE_RIGHT={name:"李晓健",title:"java工程师",bd:"1982-02-09",sign:"小猫咪睡觉觉",sex:1}
	USER_INFO_FOR_UDDATE_WRONG={}
	#user valid
	WRONG_USER_NAME_FOR_MORE_THAN_8_LENGTH = "aaaaaaaaa"
	WRONG_USER_NAME_FOR_EMPTY_NAME=""
	WRONG_USER_NAME_WITH_AT="@李晓健"
	WRONG_USER_NAME_WITH_TAG_FLAG="#李晓健"

	RIGHT_USER_NAME_FOR_8_LENGTH ="AAAAAAAA"
	RIGHT_USER_NAME_NORMAL="李晓健"

	WRONG_USER_TITLE_FOR_MORE_THAN_15_LENGTH="1234567890123456"
	WRONG_USER_TITLE_FOR_special_chatset="<a>test"

	RIGHT_USER_TITLE_NORMAL="搞基工程师"
	
	WRONG_SIGN_FOR_MORE_THAN_50_LENGTH="123456789012345678901234567890123456789012345678901"
	WRONG_SIGN_FOR_SPECIAL_CHATSET="<a>test.com</a>"

	RIGHT_SIGN_NORMAL="小猫咪睡觉觉"

	WRONG_MOBILE_NUMBER_FOR_NOT_NUMBER = "abcde"
	WRONG_MOBILE_NUMBER_FOR_12_LENGTH = "134123412341"
	WRONG_MOBILE_NUMBER_FOR_UNVALIDE = "11111111111"
	WRONG_MOBILE_NUMBER_FOR_TOO_SHORT = "021-11111"
	WRONG_MOBILE_NUMBER_FOR_TOO_LONG ="02122-12345679"

	RIGHT_MOBILE_NUMBER_FOR_11_LENGTH = "13412341234"

	RIGHT_MOBILE_NUMBER_FOR_TEL = "020-95219520"

	WRONG_SNS_ACCOUNT_FOR_QQ = "-100000"
	WRONG_SNS_ACOUNT_FOR_MSN = "hi guy"

	RIGHT_SNS_ACCOUNT_FOR_QQ = "5443899"
	RIGHT_SNS_ACOUNT_FOR_MSN ="lixj@visionet.com.cn"

	WRONG_ADDRESS_WITH_SPECIAL_CHAR = "Manhattan <script>alert('hi')</script>"
	WRONG_ADDRESS_WITH_LONG_DESCRIBE ="aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
	RIGHT_ADDRESS="Manhattan"

	WRONG_PWD_FOR_LESS_THAN_6_LENGTH ="12345"

	RIGHT_PWD = "123456"

	RIGHT_PWD_CONFIRM="123456"
	NEW_PWD = "1234567"

	SET_COUSTOME_TO_MAIN_PAGE = "将专页设为我的首页"
	
	CANCEL_COUSTOM_TO_MAIN_PAGE = "取消专页设为我的首页"
	COUSTOM_TEAM_INFO ="上海微企信息技术有限公司"
	COUSTOM_VEST_INFO = "刘顺顺"
	COUSTOM_TAG_INFO ="test"

	WRONG_TEAM_NAME_WITH_SPECIAL_CHAR = "<a>www.test.com</a>"
	WRONG_TEAM_NAME_WITH_LONG_DESCRIBE="aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"

	RIGHT_TEAM_DESCRIBE ="群组简介"
	WRONG_TEAM_DESCRIBE_WITH_LOGN_DESCRIBE="aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
end

