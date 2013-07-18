#encoding:utf-8
require_relative 'core/base'
require_relative 'config_option'
require_relative 'common/common_module'
class Invite < Base
	include Common
	def has_team_link?
		is_link_disploy?("群组")
	end

	def has_user_link?
		is_link_disploy?("用户")
	end
	def has_custome_page_link?
		is_link_disploy?("专页")
	end


	private 
	def is_link_disploy?(link_text)
		begin
			return false if get_element_by_link_text(link_text).nil?
			return true
		rescue Selenium::WebDriver::Error::TimeOutError => e1
			return false
		rescue Exception => e
			@log.error("查找#{link_text}链接失败")
			raise e
		end
	end
end