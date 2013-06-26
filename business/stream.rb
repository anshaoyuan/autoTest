#encoding: utf-8
require_relative 'core/base'
require 'time'
require_relative 'config_option'
require_relative 'common/common_module'
require_relative 'common/alert_message'
require_relative 'common/stream_module'
class Stream < Base
	attr_accessor :content,:title
	include Common
	include Message
	include Stream_Module
	def initialize(login_info = Config_Option::LOGIN_INFO)
		super(login_info)
		@currDate = Time.now.strftime("%Y-%m-%d%H:%M:%S")+"_autotest"
		@content = "this is stream content for release "+@currDate
		@transmit_content = "this is stream content for transmit"+@currDate
	end

	def release_stream(content,title=@title)
		begin
				release_stream_base(content,title)
		  		@log.info("just a release stream method")
				@driver.find_element(:id,"pub-btn").click
				@log.info("release stream result!")
				release_stream_successful? content
		rescue Exception => e
			@log.error("catch error #{e.message}")
			raise e
		end
				
	end
	


	def release_vote(content,title=@title)
				
				release_stream_base(content,title)
				find_votediv_and_fill_options
		  		@log.info("just a release stream for vote method")
				@driver.find_element(:id,"pub-btn").click
				@log.info("release stream for vote result!")
				release_stream_successful? content
	end

	

	def release_ative(content,members,title=@title)
		
		release_stream_base(content,title)
		find_activediv_and_fill_options members
		@log.info("just a release stream for active method")
		@driver.find_element(:id,"pub-btn").click
		@log.info("release stream for active result!")
		release_stream_successful? content
	end

=begin
	def first_title_is_release_title
		goto_main_page
		title_div = @wait.until {@driver.find_element(:id,"stream-panel")}
		first_title = get_first_title.text
		first_title.eql?@title
	end
=end
	def transmit_stream
		first_title = get_first_title
		
		team_detail_div =@wait.until{ @driver.find_element(:css,"#team-detials div.group-info.pull-left.side-hot-tags") }
		curr_team_name = team_detail_div.find_element(:tag_name,"a").text 
		@log.info("curr team name is #{curr_team_name}")
		first_title.click
		first_stream_transmit_btn = @wait.until{@driver.find_element(:css,"#stream-panel ul li div ul li a.forward.btn.stream-tansmit")}
		first_stream_transmit_btn.click
		@log.info("forward to transmit div")
		
		transmit_content_input = @wait.until{@driver.find_element(:id,"transmit_content")}
		
		content = get_currtime_stream_content 
		transmit_content_input.send_keys content
		transmit_team_select = @driver.find_element(:id,"teamIdForTransmit")	
		all_team = transmit_team_select.find_elements(:tag_name,"option")
		all_team.each do |option|
			if option.text.eql?curr_team_name
				option.click
			end

		end
		transmit_btn = @driver.find_element(:id,"transmit-btn")
		transmit_btn.click
		release_stream_successful? content
	end
	def delete_stream
		jump_to_my_space
		share_link = @wait.until{ @driver.find_element(:css,"#myshare-lxj a")}
		share_link.click
		wait(5)
		stream_count = @wait.until{@driver.find_elements(:css,"#my-share ul li.article-item.clearfix.stream-item")}
		del_btn = @wait.until{ @driver.find_element(:css,"#my-share ul li div ul li a.delete.btn.stream-del") }

		del_btn.click
		do_confirm("确定")
		wait(5)
		after_del_stream_count = @wait.until{@driver.find_elements(:css,"#my-share ul li.article-item.clearfix.stream-item")}
		stream_count.length==after_del_stream_count.length+1
	end
	def get_currtime_stream_content
		content = Time.now.strftime("%Y-%m-%d-%H:%M:%S")+"_autotest"
	end	
	def release_stream_base(content,title = @title)
				goto_main_page
		  		release_btn =@wait.until {@driver.find_element(:css,"#top div div ul li div a.global-writer")} 
		  		release_btn.click
		  		@log.info("coming to release page")
		  		title_r=@driver.find_element(:id,"post-title")
		  		title_r.send_keys title
		  		
		  		#switch to iframe,the arg for frame method is iframe name
		  		@wait.until {@driver.switch_to.frame("pubhtml5_iframe")}
		  		release_body = @wait.until {@driver.find_element(:tag_name,"body")}
		  		release_body.send_keys content
		  		#switch back to the main document
		  		@driver.switch_to.default_content
	end	
	def get_first_title
		goto_main_page
		title_div = @wait.until {@driver.find_element(:id,"stream-panel")}
		title_div.find_element(:css,"ul li div h5 a")
	end
	def get_first_title_first_stream
		get_first_title.click
		@wait.until{@driver.find_elements(:css,"#stream-panel ul li.article-item.clearfix.stream-item")[0]}
	end
	def get_first_stream_by_store
		show_my_store_stream
		@wait.until{@driver.find_elements(:css,"#my-store ul li.article-item.clearfix.stream-item")[0]}
	end
	private
	def compare_stream_content_from_streamli(li,content)
		compare_stream = li.find_element(:css,"div.old-stream-lxj.streamContent-p").text
		compare_stream.include?content
	end
	def release_stream_successful?(content)
		wait(3)
		first_li = get_first_title_first_stream
		compare_stream_content_from_streamli(first_li,content)
	end	
	def find_activediv_and_fill_options(members)
		schedule_btn = @driver.find_element(:id,"schedule-btn")
		schedule_btn.click
		activeDiv = @driver.find_element(:id,"add-calendar")
		time_btn = activeDiv.find_element(:css,"#choose-date span.add-on")
		time_btn.click
		wait(1)
		time_panel = @driver.find_element(:css,"div.bootstrap-datetimepicker-widget.dropdown-menu")
		time_table = time_panel.find_element(:tag_name,"table")
		curr_date = time_table.find_element(:css,"td.day.active")
		curr_date.click
		activeDiv.find_element(:name,"vo.activity.place").send_keys Config_Option::ACTIVE_PLACE
		activeDiv.find_element(:css,"#schedule_members_chzn ul li input.default").click
		set_option_to_input(members,"schedule_members_chzn")

		activeMinute = activeDiv.find_element(:id,"schedule-minute-in")
		activeMinute.clear
		activeMinute.send_keys Config_Option::ACTIVE_MINUTE
		activeHours = activeDiv.find_element(:id,"schedule-hours-in")
		activeHours.clear
		activeHours.send_keys Config_Option::ACTIVE_HOURS

	end

	def find_votediv_and_fill_options
		vote_btn = @driver.find_element(:id,"vote-btn")
		vote_btn.click
		vote_driver = @wait.until { @driver.find_element(:id,"add-vote")}
		ol = vote_driver.find_element(:css,"div ol ")
		lis = ol.find_elements(:tag_name,"li")
		li_index=1
		lis.each do |li|
			li.find_element(:tag_name,"input").send_keys "option#{li_index}"
			li_index +=1
		end
	end		
end

