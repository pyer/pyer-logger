# encoding: UTF-8
#
# This Logger class provides a simple logging utility for Ruby applications.
# Log messages are sent to stdout, stderr, a file or a string by a Logger object.
#
# The messages will have varying levels reflecting their varying importance.
# The levels, and their meanings, are:
# 1. DEBUG : low-level information for developers
# 2. INFO  : generic (useful) information about system operation
# 3. WARN  : a warning
# 4. ERROR : an error condition
# 5. NONE  : no log
#
# So each message has a level, and the Logger itself has a level, which acts
# as a filter, so you can control the amount of information emitted from the
# logger without having to remove actual messages.
#
# == How to create a logger ?
#
# 1. Create a default logger which logs messages to STDOUT
#      log = Logger.new
#
# 2. Create a logger which logs messages to STDOUT or STDERR.
#      log = Logger.new(STDOUT)
#      log = Logger.new(STDERR)
#
# 3. Create a logger for the file which has the specified name.
#      log = Logger.new('logfile.log')
#
# 4. Create a logger which logs messages to a string.
#      log = Logger.new(STRING)
#
# == How to log a message ?
#
# Messages lower than log.level are not sent to output.
# Ranking: DEBUG < INFO < WARN < ERROR < NONE
# Default Logger.level is DEBUG. That means all messages are emitted.
# Each logger level is initialized with Logger.level and can set a different level.
#
# 1. Debug message
#      log.debug "dev info"
#
# 2. Information
#      log.info  "some informations"
#
# 3. Warning message
#      log.warn  "a warning message"
#
# 4. Error message
#      log.error "error is #{ @code }"
#
# Messages are provided in a string or in a block, or both.
#
# 1. Message in block.
#      log.error { "Argument 'foo' not given." }
#
# 2. Message as a string.
#      log.error "Argument #{ @foo } mismatch."
#
# 3. Both arguments
#      log.error("Argument ") { "#{ @foo } mismatch." }
#
# == How to set severity level ?
#
#      log.level = INFO
#
# == How to set default severity level ?
#
#      Logger.level = NONE
#
# == How to close a logger ?
#
#      log.close
#
# == Installation
#
#     gem install pyer-logger
#
module Pyer
  require 'stringio'

  # Logger class
  class Logger
    # Logging severity.
    module Severity
      DEBUG = 0
      INFO  = 1
      WARN  = 2
      ERROR = 3
      NONE  = 4
      # Severity label for logging. (max 5 char)
      SEVERITY_LABELS = ['DEBUG', 'INFO ', 'WARN ', 'ERROR', 'NONE']
      COLOURED_LABELS = ["\033[44mDEBUG\033[m", "\033[42mINFO \033[m", "\033[43mWARN \033[m", "\033[41mERROR\033[m", ""]
    end
    include Severity

    STRING = -1

    @@default_level = DEBUG

    def self.level=(level)
      @@default_level = level
    end

    def self.level
      @@default_level
    end

    # Logging severity threshold (e.g. <tt>Logger::INFO</tt>).
    attr_accessor :level

    # Prefix can be the class name
    attr_accessor :prefix

    # Create an instance.
    # outputs log messages on STDOUT, STDERR, a file or a StringIO
    #
    def initialize(logdev = STDOUT)
      @level = @@default_level
      @prefix = ""
      @logdev = $stdout
      @severity_label = COLOURED_LABELS
      if logdev == STDOUT
        @logdev = $stdout
      else
        if logdev == STDERR
          @logdev = $stderr
        else
          if logdev == STRING
            # no log device implies that messages are stored in a string
            @logdev = StringIO.new
            @severity_label = SEVERITY_LABELS
          else
            if logdev.is_a? String
              # the log device is a file name
              @logdev = File.new(logdev.to_s, 'a')
              @severity_label = SEVERITY_LABELS
            else
              # the default is no log
              @level = NONE
              @logdev = $stderr
            end
          end
        end
      end
    end

    def string
      @logdev.class == StringIO ? @logdev.string : ''
    end

    # Close the logging device.
    def close
      @logdev.close if @logdev.class == File
    end

    # Log a +DEBUG+ message.
    def debug(message = nil, &block)
      add(DEBUG, message, &block)
    end

    # Log an +INFO+ message.
    def info(message = nil, &block)
      add(INFO, message, &block)
    end

    # Log a +WARN+ message.
    def warn(message = nil, &block)
      add(WARN, message, &block)
    end

    # Log an +ERROR+ message.
    def error(message = nil, &block)
      add(ERROR, message, &block)
    end

    private

    # Log a message if the given severity is high enough.
    #
    def add(severity, message, &block)
      return if @logdev.nil? || severity < @level
      message = '' if message.nil?
      message += block.call if block_given?
      @logdev.write(Formatter.new.string(@prefix, @severity_label[severity], message))
    end
  end

  # Formatter class
  class Formatter
    FORMAT = "%s [%5d] %12s %s  %s\n"
    def string(prefix, label, message = nil)
      format(FORMAT, format_datetime(Time.now), $$, prefix, label, format_message(message))
    end

    private

    def format_datetime(time)
      time.strftime('%Y-%m-%d %H:%M:%S.') << format('%06d ', time.usec)
      # time.strftime("%Y-%m-%d %H:%M:%S ")
    end

    def format_message(msg)
      return '' if msg.nil?
      case msg
      when ::String
        msg
      when ::Exception
        "#{msg.message} (#{msg.class})\n" << (msg.backtrace || []).join("\n")
      else
        msg.inspect
      end
    end
  end
end

# == Aliases
#
# Aliases are made to make life simpler.
#
Logger = Pyer::Logger
STRING = Pyer::Logger::STRING

DEBUG = Pyer::Logger::DEBUG
INFO  = Pyer::Logger::INFO
WARN  = Pyer::Logger::WARN
ERROR = Pyer::Logger::ERROR
NONE  = Pyer::Logger::NONE
