#encoding:utf-8
require_relative 'core/base'
require_relative 'common/remind_module'
require_relative 'group_helper'
require_relative 'stream_helper'
class Message_Info < Base
	include Common
	include Remind
	def at_mention_me
		wait(5)
		before_at_remind_count = at_remind_count.to_i
		stream = Stream.new(Config_Option::OTHER_USER_INFO)
		content = "@#{@login_info[:name]} #{Config_Option::STREAM_CONTENT}"
		stream.release_stream content
		stream.closeDriver
		wait(10)
		begin
			@wait.until { at_remind_count.to_i == before_at_remind_count+1}	
		rescue Exception => e
			@log.info("@提醒没有增加")
			raise "@提醒没有增加"
		end
		@driver.find_element(:id,"remindAtCount").click
		wait(10)
		first_li = @wait.until{@driver.find_elements(:css,"#mention-i ul li.article-item.clearfix.stream-item")[0]}
		compare_stream = first_li.find_element(:css,"div.old-stream-lxj.streamContent-p").text
		is_clear_remind(at_remind_count,"@提醒没有清空")
		compare_stream.include?Config_Option::STREAM_CONTENT
	end

	def comment_me(user_info = Config_Option::OTHER_USER_INFO)
		wait(5)
		before_comment_count = comment_count.to_i
		helper = get_stream_helper(Config_Option::RELEASE_STREAM_INFO,user_info)
		helper.comment_first_titile_first_stream Config_Option::COMMNET
		helper.closeDriver
		wait(10)
		begin
			@wait.until { comment_count.to_i == before_comment_count+1}	
		rescue Exception => e
			@log.info("评论没有增加")
			raise "评论没有增加"
		end
		@driver.find_element(:id,"remindCommentCount").click
		wait(10)
		first_li = @wait.until{@driver.find_elements(:css,"#comentMe-lxj li")[0]}
		comment_content_ = first_li.find_element(:tag_name,"p").text

		is_clear_remind(comment_count,"评论提醒没有清空")
		comment_content_.include?Config_Option::COMMNET
	end
	def commend_me(user_info = Config_Option::OTHER_USER_INFO)
		wait(5)
		before_commend_count = commend_count.to_i
		helper = get_stream_helper(Config_Option::COMMEND,user_info)
		helper.commend_first_title_first_stream
		helper.closeDriver
		wait(10)
		begin
			@wait.until { commend_count.to_i == before_commend_count+1}	
		rescue Exception => e
			@log.info("赞没有增加")
			raise "赞没有增加"
		end
		@driver.find_element(:id,"remindUpCount").click
		wait(10)
		first_content = @wait.until{@driver.find_elements(:css,"#gree-list li div p a")[0].text}
		realse_content = first_content.delete('......')
		is_clear_remind(commend_count,"赞提醒没有清空")
		Config_Option::COMMEND.include?realse_content
	end

	def visit_me(user_info = Config_Option::OTHER_USER_INFO)
		wait(5)
		before_visit_count = invite_count.to_i
		group = Group.new(user_info)
		team_info = group.build_team_info
		team_info["members"]=[@login_info[:name]]
		group.create_new_team(team_info)
		group.closeDriver
		wait(10)
		begin
			@wait.until { invite_count.to_i == before_visit_count+1}	
		rescue Exception => e
			@log.info("邀请没有增加")
			raise "邀请没有增加"
		end
		@driver.find_element(:id,"remindTeamJoinCount").click
		wait(10)
		first_li = @wait.until{@driver.find_elements(:css,"#invite-i ul li")[0]}
		visit_team_name = first_li.find_element(:css,"div h5 a").text
		is_clear_remind(invite_count,"邀请没有清空")
		visit_team_name.eql?team_info["name"]

	end
	def trends_me(user_info = Config_Option::OTHER_USER_INFO)
		wait(5)
		before_trends_count = trends_count.to_i
		group = Group.new(@login_info)
		team_info = group.build_team_info
		team_info["members"].clear
		team_info["team_type"]=2
		group.create_new_team(team_info)
		group.closeDriver
		search = Search.new(user_info)
		team_info_li = search.search_team_by_teamname(team_info["name"])
		join_btn = Group_Helper.find_btn_by_team_info(team_info_li)
		join_btn.click
		search.closeDriver
		wait(10)
		begin
			@wait.until { trends_count.to_i == before_trends_count+1}	
		rescue Exception => e
			@log.info("动态没有增加")
			raise "动态没有增加"
		end
		@driver.find_element(:id,"remindTeamAskForJoinCount").click
		wait(5)
		trends = @wait.until{@driver.find_elements(:css,"#trend-i ul li")}
		last_trends = trends[trends.length-1]
		excute_trends(last_trends,"同意")
		wait(30)
		begin
		@wait.until { trends_count.to_i == before_trends_count-1}
		true
		rescue Exception => e
			@log.info("动态没有减少1个单位")
			raise "动态没有减少1个单位"
		end

	end
	def excute_trends(li,type)
	
		div = li.find_element(:css,"div div.btn-group")
		div.find_element(:css,"a.btn.btn-small.btn-success.actiontzq").click

	end
	def schedule_me(user_info = Config_Option::OTHER_USER_INFO)
		wait(5)
		before_schedule_count = schedule_count.to_i
		stream = Stream.new(user_info)
		schedule_members = [@login_info[:name]]
		stream.release_ative(Config_Option::SCHEDULE_CONTENT,schedule_members,Config_Option::SCHEDULE_TITLE)
		stream.closeDriver
		wait(10)
		begin
			@wait.until { schedule_count.to_i == before_schedule_count+1}	
		rescue Exception => e
			@log.info("日程没有增加")
			raise "日程没有增加"
		end
		@driver.find_element(:id,"activityCount").click
		wait(10)
		first_li =@wait.until{@driver.find_elements(:css,"#schedule-i ul li")[0]}
		schedule_content = first_li.find_elements(:css,"div h5 a")[1].text
		is_clear_remind(schedule_count,"日程提醒没有清空")
		schedule_content.eql?Config_Option::SCHEDULE_TITLE 

	end

	 
	def get_stream_helper(content,user_info)
		stream = Stream.new(@login_info)
		stream.release_stream content
		stream.closeDriver 
		stream = Stream.new(user_info)
		Stream_Helper.new(stream)
	end
	def is_clear_remind(type,error_info)
		wait(30)
		begin
			@wait.until { type.to_i == 0}	
			true
		rescue Exception => e
			@log.error(error_info)
			raise error_info
		end
	end
end