#encoding:utf-8
module Remind

	def show_my_remind(remind_type)
		div = @wait.until{@driver.find_element(:id,"showtopsetteam")}
		a_links = div.find_elements(:tag_name,"a")
		a_links.each do |a|
			if(a.text.include?"我的提醒")
				a.click
				break
			end
		end

		@wait.until{@driver.find_element(:id,remind_type).text}
	end
	def at_remind_count
		show_my_remind("remindAtCount")
	end
	def comment_count
		show_my_remind("remindCommentCount")
	end
	def new_fans_remind_count
		show_my_remind("remindFansCount")
	end
	def commend_count
		show_my_remind("remindUpCount")
	end
	def invite_count
		show_my_remind("remindTeamJoinCount")
	end
	def trends_count
		show_my_remind("remindTeamAskForJoinCount")
	end
	def schedule_count
		show_my_remind("activityCount")
	end
end