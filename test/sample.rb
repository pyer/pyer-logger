#!/usr/bin/ruby
# encoding: UTF-8
# require 'pyer/logger'
require './lib/pyer/logger.rb'

log = Logger.new(STRING, self.class)
log.debug 'StringIO'
log.close
print log.string

log = Logger.new(STDOUT, self.class)
log.debug 'debug'
log.info  'information'
log.info('what ?') { 'glop ' * 2 }
log.warn  'warning'
log.error 'error'
log.close

puts 'Formatter:'
f = Pyer::Formatter.new
puts f.string('KLASS', 'VOID')
puts f.string('KLASS', 'LABEL', 'message')

class Sample
  def logging
    log = Logger.new(STDOUT, self.class)
    log.level = Logger::WARN
    log.debug 'debug'
    log.info  'information'
    log.warn  'level is WARN'
    log.error 'error'
    log.close
  end
end

s = Sample.new
s.logging
