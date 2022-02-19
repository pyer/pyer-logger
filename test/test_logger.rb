# encoding: UTF-8
require 'minitest/autorun'
require './lib/pyer/logger'

class TestLogger < Minitest::Test

  def test_default_level
    assert_equal(DEBUG, Logger.level)
    Logger.level = ERROR
    assert_equal(ERROR, Logger.level)
# reset default level for other tests
    Logger.level = DEBUG
    assert_equal(DEBUG, Logger.level)
  end

  def test_initialize
    log = Logger.new
    assert_equal(DEBUG, log.level)
    assert(log.prefix.is_a? String)
    assert(log.prefix.empty?)
    log.close
  end

  def test_initialize_1
    log = Logger.new(STRING)
    assert_equal(DEBUG, log.level)
    log.close
  end

  def test_initialize_2
    Logger.level = NONE
    log = Logger.new(STRING)
    assert_equal(NONE, log.level)
    log.info 'message'
    assert(log.string.empty?)
    log.close
    Logger.level = DEBUG
  end

  def test_nil
    log = Logger.new(nil)
    log.info 'message'
    assert(log.string.empty?)
    log.close
  end

  def test_string
    log = Logger.new(STRING)
    log.info 'message'
    log.close
    assert log.string.end_with?(" INFO   message\n")
  end

  def test_block
    log = Logger.new(STRING)
    log.info('msg=') { 'block' }
    assert log.string.end_with?(" INFO   msg=block\n")
    log.close
  end

  def test_block_without_message
    log = Logger.new(STRING)
    log.info { 'block' }
    assert log.string.end_with?(" INFO   block\n")
    log.close
  end

  def test_stdout
    assert_output(/ \e\[42mINFO \e\[m  message\n/) do
      log = Logger.new(STDOUT)
      log.info 'message'
      log.close
    end
  end

  def test_stderr
    assert_output(nil, / \e\[42mINFO \e\[m  message\n/) do
      log = Logger.new(STDERR)
      log.info 'message'
      log.close
    end
  end

  def test_file
    filename = '/tmp/test_logger.log'
    log = Logger.new(filename)
    log.info 'message'
    log.close
    s = File.read(filename)
    File.delete(filename)
    assert s.end_with?(" INFO   message\n")
  end

  def test_debug_output
    assert_output(/ \e\[44mDEBUG\e\[m  msg\n/) do
      log = Logger.new(STDOUT)
      log.debug 'msg'
      log.close
    end
  end

  def test_info_output
    assert_output(/ \e\[42mINFO \e\[m  msg\n/) do
      log = Logger.new(STDOUT)
      log.info 'msg'
      log.close
    end
  end

  def test_warn_output
    assert_output(/ \e\[43mWARN \e\[m  msg\n/) do
      log = Logger.new(STDOUT)
      log.warn 'msg'
      log.close
    end
  end

  def test_error_output
    assert_output(/ \e\[41mERROR\e\[m  msg\n/) do
      log = Logger.new(STDOUT)
      log.error 'msg'
      log.close
    end
  end

  def test_no_output
    assert_output(//) do
      log = Logger.new(STDOUT)
      log.error 'msg'
      log.close
    end
  end


  def test_formatter_with_message
    fmt = Pyer::Formatter.new
    str = fmt.string('prefix', 'LABEL', 'message')
    assert str.end_with?(" prefix LABEL  message\n")
  end

  def test_formatter_without_message
    fmt = Pyer::Formatter.new
    str = fmt.string('prefix', 'LABEL')
    assert str.end_with?(" prefix LABEL  \n")
  end
end
