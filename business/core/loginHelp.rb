# encoding: utf-8
require 'rubygems'
require 'selenium-webdriver'
require_relative '../config_option'

class LoginHelp
        def self.login_method(login_name,pwd)
        #TODO there should make a while until @driver get login
        begin
            @driver = Selenium::WebDriver.for :firefox
            @driver.get Config_Option::LOGIN_URL
            wait=Selenium::WebDriver::Wait.new({:timeout => 10})
            element_loginName=wait.until {@driver.find_element(:id,'signin-email')}
            element_loginName.send_keys login_name
            element_pwd=@driver.find_element(:id,'signin-password')
            element_pwd.send_keys pwd
            element_loginBtn=wait.until { @driver.find_element(:id,'login_submit')}
            element_loginBtn.click
            @driver.get Config_Option::LOGIN_URL
            release_btn =wait.until {@driver.find_element(:css,"#top div div ul li div a.global-writer")} 
        rescue Exception => e
            puts e.message
        end
        @driver.get Config_Option::LOGIN_URL
        @driver

      end
end