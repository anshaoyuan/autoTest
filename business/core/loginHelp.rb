# encoding: utf-8
require 'rubygems'
require 'selenium-webdriver'
require_relative '../config_option'
require_relative 'help_'

class LoginHelp
        def self.login_method(login_name,pwd)
            log = LogHelp.getLog
            begin
                @driver = Selenium::WebDriver.for Config_Option::BrowserName
                @driver.get Config_Option::LOGIN_URL
                log.setDriver(@driver)
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
                log.info("登录出现异常#{e.message}")
            end
            @driver
      end
end