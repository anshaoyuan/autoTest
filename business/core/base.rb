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
		@wait = Selenium::WebDriver::Wait.new({:timeout=>20})
		@title="title"+Time.now.strftime("%Y-%m-%d")
		if(@driver.nil? == false)
			@log.setDriver(@driver)
		end
		
	end
	
	def closeDriver
		begin
			@driver.close if !@driver.nil?
			true
		rescue Exception => e
			false
		end
	end
	def wait(second)
		begin
			error_wait = Selenium::WebDriver::Wait.new({:timeout=>second})
			error_wait.until{@driver.find_element(:id,"cannotfind")}
		rescue
		end
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
