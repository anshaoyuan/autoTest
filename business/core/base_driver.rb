#encoding: utf-8
require_relative 'base'
class BaseDriver < Base
	def initialize(obj = Config_Option::LOGIN_INFO)
		if obj.instance_of?Hash
			super
		elsif obj.class.superclass.to_s =~/Base/
			@login_info = obj.get_login_info
			@driver = obj.getDriver
			@log = obj.getLog
			@wait = get_wait(20)
		else
			raise "initialize get a error , nonlicet args type for #{obj.class.superclass}"
		end
	end
end