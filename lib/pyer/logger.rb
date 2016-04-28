# encoding: UTF-8
#
# == Description
#
# The Logger class provides a simple logging utility.
#
# You create a Logger object (output to a file, STDOUT or STDERR).
# The messages will have varying levels (+info+, +error+, etc),
# reflecting their varying importance.
#
# The levels, and their meanings, are:
#   +ERROR+:: an error condition
#   +WARN +:: a warning
#   +INFO +:: generic (useful) information about system operation
#   +DEBUG+:: low-level information for developers
#
# So each message has a level, and the Logger itself has a level, which acts
# as a filter, so you can control the amount of information emitted from the
# logger without having to remove actual messages.
#
# == HOWTOs
#
# === How to create a logger
#
# 1. Create a logger which logs messages to STDERR/STDOUT.
#      logger = Logger.new(STDOUT)
#      logger = Logger.new(STDERR)
#
# 2. Create a logger for the file which has the specified name.
#      logger = Logger.new('logfile.log')
#
# === How to log a message
#
# Notice the different methods (+fatal+, +error+, +warn+, +info+, +debug+)
# being used to log messages of various levels.
# Messages lower than logger.level are not emitted.
#
# 1. Message in block.
#
#      logger.error { "Argument 'foo' not given." }
#
# 2. Message as a string.
#
#      logger.error "Argument #{ @foo } mismatch."
#
# === How to set severity level
#
#      logger.level = Logger::INFO
#
#      DEBUG < INFO < WARN < ERROR
#
# === How to close a logger
#
#      logger.close
#
# All my tools are in module Pyer
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
      # Severity label for logging. (max 5 char)
      SEVERITY_LABELS = ['DEBUG', 'INFO ', 'WARN ', 'ERROR']
      COLOURED_LABELS = ["\033[44mDEBUG\033[m", "\033[42mINFO \033[m", "\033[43mWARN \033[m", "\033[41mERROR\033[m"]
    end
    include Severity

    STRING = -1

    # Logging severity threshold (e.g. <tt>Logger::INFO</tt>).
    attr_accessor :level

    # Returns +true+ if the current severity level allows the printing of the message

    def debug?
      @level <= DEBUG
    end

    def info?
      @level <= INFO
    end

    def warn?
      @level <= WARN
    end

    def error?
      @level <= ERROR
    end

    # Create an instance.
    # outputs log messages on STDOUT, STDERR, a file or a StringIO
    #
    def initialize(logdev = nil, klass = nil)
      @level = DEBUG
      @logdev = $stdout
      @severity_label = COLOURED_LABELS
      @klass_name = ''
      @klass_name = klass.name unless klass.nil?
      return if logdev.nil?
      if logdev == STRING
        # no log device implies that messages are stored in a string
        @logdev = StringIO.new
        @severity_label = SEVERITY_LABELS
      else
        if logdev == STDOUT
          @logdev = $stdout
        else
          if logdev == STDERR
            @logdev = $stderr
          else
            # the default log device is a file name
            @logdev = File.new(logdev.to_s, 'a')
            @severity_label = SEVERITY_LABELS
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
      @logdev.write(Formatter.new.string(@klass_name, @severity_label[severity], message))
    end
  end

  # Formatter class
  class Formatter
    FORMAT = "%s [%5d] %12s %s  %s\n"
    def string(klass_name, label, message = nil)
      format(FORMAT, format_datetime(Time.now), $$, klass_name, label, format_message(message))
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

# Backward-compatible alias
Logger = Pyer::Logger
STRING = Pyer::Logger::STRING

DEBUG = Pyer::Logger::DEBUG
INFO  = Pyer::Logger::INFO
WARN  = Pyer::Logger::WARN
ERROR = Pyer::Logger::ERROR
