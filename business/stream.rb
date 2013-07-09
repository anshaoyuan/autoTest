#encoding: utf-8
require_relative 'core/base_driver'
require 'time'
require_relative 'config_option'
require_relative 'common/team_module'
require_relative 'common/alert_message'
require_relative 'common/stream_module'
class Stream < BaseDriver
	def initialize(obj = Config_Option::LOGIN_INFO)
		super
		@title="title"+Time.now.strftime("%Y-%m-%d")
		@currDate = Time.now.strftime("%Y-%m-%d%H:%M:%S")+"_autotest"
		@content = "this is stream content for release "+@currDate
		@transmit_content = "this is stream content for transmit"+@currDate

	end
	include TeamModule
	include Message
	include Stream_Module
	def release_stream(content,title=@title)
		option = {
			content:content,
			title:title,
			first_info: "just a release stream method",
			last_info:"release stream finished"
		}
		release	option
	end

	def release_vote(content,title=@title)
		option = {
			content:content,
			title:title,
			first_info:"just a release stream for vote method",
			last_info:"release stream for vote finished"
		}
		release(option){find_votediv_and_fill_options}
	end

	def release_ative(content,members,title=@title)
		option = {
			content:content,
			title:title,
			first_info:"just a release stream for active method",
			last_info:"release stream for active finished"
		}
		release(option){find_activediv_and_fill_options members}
	end

	def transmit_stream
		curr_team_name = get_curr_team_link.text 
		@log.info("curr team name is #{curr_team_name}")
		get_first_title.click
		first_stream_transmit_btn = @wait.until{@driver.find_element(:css,"#stream-panel ul li div ul li a.forward.btn.stream-tansmit")}
		first_stream_transmit_btn.click
		@log.info("forward to transmit div")
		content = get_currtime_stream_content
		transmit_content_input = @wait.until{@driver.find_element(:id,"transmit_content")}
		transmit_content_input.send_keys content
		transmit_team_select = @driver.find_element(:id,"teamIdForTransmit")	
		all_team = transmit_team_select.find_elements(:tag_name,"option")
		all_team.each do |option|
			if option.text.eql?curr_team_name
				option.click
			end

		end
		@driver.find_element(:id,"transmit-btn").click
		release_stream_successful? content
	end

	def delete_stream_from_stream_list(div_id)
		get_elements_by_css("##{div_id} ul li.article-item.clearfix.stream-item"){ |streams|streams[0] }
	end
	def delete_stream(stream_li)
		del_btn = get_element_by_css("a.delete.btn.stream-del",stream_li)
		del_btn.click
		do_confirm("确定")
		wait(5)
		begin
			del_btn = get_element_by_css("a.delete.btn.stream-del",stream_li)
			false
		rescue Selenium::WebDriver::Error::StaleElementReferenceError => e
			true
		end
	end
	def delete_stream_from_my_share
		jump_to_my_space
		share_link =get_element_by_css("#myshare-lxj a")
		share_link.click
		wait(5)
		delete_stream_from_stream_list("my-share")

	end

	def delete_stream_from_first_title
		delete_stream(get_first_title_first_stream)
	end
	def get_currtime_stream_content
		content = Time.now.strftime("%Y-%m-%d-%H:%M:%S")+"_autotest"
	end	
	def release_stream_base(content,title = @title)
				goto_main_page
		  		release_btn =@wait.until {@driver.find_element(:css,"#top div div ul li div a.global-writer")} 
		  		release_btn.click
		  		wait(5)
		  		@log.info("coming to release page")
		  		title_r=@driver.find_element(:id,"post-title")
		  		title_r.send_keys title
		  		
		  		@wait.until {@driver.switch_to.frame("pubhtml5_iframe")}
		  		release_body = @wait.until {@driver.find_element(:tag_name,"body")}
		  		release_body.send_keys content
		  		
		  		@driver.switch_to.default_content
	end	
	def get_first_title
		goto_main_page
		get_elements_by_css("ul li div h5 a",get_element_by_id("stream-panel"))[0]
	end
	def get_first_title_first_stream
		get_first_title.click
		get_elements_by_css("#stream-panel ul li.article-item.clearfix.stream-item"){ |lis|lis[0]}
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
		lis.each_with_index do |li,index|
			li.find_element(:tag_name,"input").send_keys "option#{index+1}"
		end
	end		
	def submit_release
				@driver.find_element(:id,"pub-btn").click
				if has_warn?("teamTag","writer")
					select_first_option("teamTag_chzn")
					@driver.find_element(:id,"pub-btn").click
				end
	end

	def release(option)
		release_stream_base(option[:content],option[:title])
		yield if block_given?
		@log.info option[:first_info]
		submit_release
		@log.info option[:last_info]
		release_stream_successful? option[:content]
	end
end

