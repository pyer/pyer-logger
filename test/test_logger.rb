# encoding: UTF-8
require 'minitest/autorun'
require './lib/pyer/logger'

class TestLogger < Minitest::Test
  def test_initialize_0
    log = Logger.new
    assert_equal(DEBUG, log.level)
    log.close
  end

  def test_initialize_1
    log = Logger.new(STRING)
    assert_equal(DEBUG, log.level)
    log.close
  end

  def test_initialize_2
    log = Logger.new(STRING, self.class)
    assert_equal(DEBUG, log.level)
    log.close
  end

  def test_nil
    assert_output(/ \e\[42mINFO \e\[m  message\n/) do
      log = Logger.new(nil, self.class)
      log.info 'message'
      log.close
    end
  end

  def test_string
    log = Logger.new(STRING, self.class)
    log.info 'message'
    log.close
    assert log.string.end_with?(" INFO   message\n")
  end

  def test_block
    log = Logger.new(STRING, self.class)
    log.info('msg=') { 'block' }
    log.close
    assert log.string.end_with?(" INFO   msg=block\n")
  end

  def test_block_without_message
    log = Logger.new(STRING, self.class)
    log.info { 'block' }
    log.close
    assert log.string.end_with?(" INFO   block\n")
  end

  def test_stdout
    assert_output(/ \e\[42mINFO \e\[m  message\n/) do
      log = Logger.new(STDOUT, self.class)
      log.info 'message'
      log.close
    end
  end

  def test_stderr
    assert_output(nil, / \e\[42mINFO \e\[m  message\n/) do
      log = Logger.new(STDERR, self.class)
      log.info 'message'
      log.close
    end
  end

  def test_file
    filename = '/tmp/test_logger.log'
    log = Logger.new(filename, self.class)
    log.info 'message'
    log.close
    s = File.read(filename)
    File.delete(filename)
    assert s.end_with?(" INFO   message\n")
  end

  def test_debug_output
    assert_output(/ \e\[44mDEBUG\e\[m  msg\n/) do
      log = Logger.new(STDOUT, self.class)
      log.debug 'msg'
      log.close
    end
  end

  def test_info_output
    assert_output(/ \e\[42mINFO \e\[m  msg\n/) do
      log = Logger.new(STDOUT, self.class)
      log.info 'msg'
      log.close
    end
  end

  def test_warn_output
    assert_output(/ \e\[43mWARN \e\[m  msg\n/) do
      log = Logger.new(STDOUT, self.class)
      log.warn 'msg'
      log.close
    end
  end

  def test_error_output
    assert_output(/ \e\[41mERROR\e\[m  msg\n/) do
      log = Logger.new(STDOUT, self.class)
      log.error 'msg'
      log.close
    end
  end

  # LABELS = ["DEBUG", "INFO ", "WARN ", "ERROR"]
  def test_level
    log = Logger.new(STRING, self.class)

    # DEBUG is default level
    assert(log.debug?)

    log.level = ERROR
    assert(!log.debug?)
    assert(!log.info?)
    assert(!log.warn?)
    assert(log.error?)

    log.level = WARN
    assert(!log.debug?)
    assert(!log.info?)
    assert(log.warn?)
    assert(log.error?)

    log.level = INFO
    assert(!log.debug?)
    assert(log.info?)
    assert(log.warn?)
    assert(log.error?)

    log.level = DEBUG
    assert(log.debug?)
    assert(log.info?)
    assert(log.warn?)
    assert(log.error?)

    log.close
  end

  def test_formatter_with_message
    fmt = Pyer::Formatter.new
    str = fmt.string(self.class.name, 'LABEL', 'message')
    assert str.end_with?(" LABEL  message\n")
  end

  def test_formatter_without_message
    fmt = Pyer::Formatter.new
    str = fmt.string(self.class.name, 'LABEL')
    assert str.end_with?(" LABEL  \n")
  end
end
