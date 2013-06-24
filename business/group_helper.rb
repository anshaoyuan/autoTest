#encoding:utf-8
require_relative 'group'
class Group_Helper
	
	def self.find_btn_by_team_info_and_team_type(li,team_type,log)
    	div_= li.find_element(:class,"group-info")
        small =div_.find_element(:css,"h5 small")
        if(small.text.include?team_type)
            action_btn = find_btn_by_team_info(li)
            if(action_btn!=nil)
                log.info("找到群组 #{small.text}")
            end
            action_btn
        end
	end
    def self.find_btn_by_team_info(li)
            	action_div = li.find_element(:class,"group-action")
                begin
                    action_btn = action_div.find_element(:tag_name,"a")
                rescue Exception => e
                    action_btn=nil
               	end
    end

end