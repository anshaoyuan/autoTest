# encoding: utf-8
require 'logger'
require 'time'



class Logger
  #这个变量设置info日志级别时是否截图
  #include PictureHelp
  INFO_P=true

  ERROR_P=true
  attr :driver
  alias :old_info :info

  alias :old_error :error

  def setDriver(driver)
    puts "driver here"
    @driver = driver
  end
  def info(*args, &block)

    old_info(args[0],&block)
    if(INFO_P)
      p_path = save_p()
       old_info("see the picture#{p_path}")
    end
    
  end
  def error(*args,&block)

    old_error(args[0],&block)

    if(ERROR_P)
      p_path = save_p()
      old_error("see the picture#{p_path}")
    end
  end
  def save_p()

    if @driver.nil?
      return
    end
    path = File.expand_path(File.dirname(__FILE__))
    time = Time.now.strftime("%Y-%m-%d-%H-%M-%S")
    date = Time.now.strftime("%Y-%m-%d")

    pictureDir = path+"/../../picture"
    Dir.mkdir pictureDir if !File.directory?(pictureDir)
    pictureDir = path+"/../../picture/"+date
    Dir.mkdir pictureDir if !File.directory?(pictureDir)
    @p_name = pictureDir+'/'+time+'_p.png'
    begin
       @driver.save_screenshot @p_name
    rescue Exception => e
      puts @driver.class
      puts "save_screenshot fail"
    end
   
    File.expand_path(pictureDir)+'/'+time+'_p.png'
  end
end
class LogHelp
  def self.getLog

    path = File.expand_path(File.dirname(__FILE__))
    time = Time.now.strftime("%Y-%m-%d")
    logsDir =path+"/../../logs"

    Dir.mkdir logsDir  if !File.directory?(logsDir)

    log_file_name = logsDir+"/"+time+'.log'
    Logger.new(log_file_name, 'daily')
    
  end
end
