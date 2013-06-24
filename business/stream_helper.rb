require_relative 'config_option'
class Stream_Helper 
	def initialize(base)
		@base = base
	end
	def comment_first_titile_first_stream(comment_content)
		first_title_first_stream = @base.get_first_title_first_stream
		comment_stream(first_title_first_stream,comment_content)
	end
	def commend_first_title_first_stream
		first_title_first_stream = @base.get_first_title_first_stream
		first_title_first_stream.find_element(:css,"div ul li a.value-up.btn.stream-agree").click

	end
	def closeDriver
		@base.closeDriver
	end
	private
	def comment_stream(stream,comment_text)
		comment_btn = stream.find_element(:css,"a.comment.btn.show-comment-lxj")	
		comment_btn.click
		send_comment(comment_text)
	end
	def comment_comment(comment,comment_text)
		re_comment_btn = comment.find_element(:css,"a.reply-lxj.reply")
		re_comment_btn.click
		send_comment(comment_text)
	end
	def send_comment(comment_text)
		@base.wait(3)
		comment_area = @base.getDriver.find_element(:id,"comment-content")
		comment_area.send_keys comment_text
		sub_btn = @base.getDriver.find_element(:css,"button.btn.btn-primary.submmit-but-lxj")
		sub_btn.click
	end

end