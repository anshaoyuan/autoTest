# encoding: utf-8
require 'rubygems'
require 'selenium-webdriver'
require 'logger'
require_relative '../config_option'
require_relative 'loginHelp'
require 'time'
require_relative 'help_'
class Base

	def initialize(login_info = Config_Option::LOGIN_INFO)
		@login_info = login_info
		@driver=LoginHelp.login_method(login_info[:login_name],login_info[:pwd])
		@log=LogHelp.getLog
		@wait = get_wait(20)
		@title="title"+Time.now.strftime("%Y-%m-%d")
		@log.setDriver(@driver) unless @driver.nil?
	end
	
	def closeDriver
		begin
			@driver.close unless @driver.nil?
			true
		rescue Exception => e
			false
		end
	end

	def wait(second)
		begin
			get_wait(second).until{@driver.find_element(:id,"cannotfind")}
		rescue
			#this error needn't to catch
		end
	end	

	def get_wait(second)
		wait = Selenium::WebDriver::Wait.new({:timeout=>second})
	end

	def getrandom
		Time.now.to_i.to_s
	end
	def getDriver
		@driver
	end

	def getLog
		@log
	end

	def goto_main_page
		@driver.get Config_Option::LOGIN_URL
	end
end
