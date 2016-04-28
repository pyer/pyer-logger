# logger
This Logger class provides a simple logging utility for Ruby applications. Log messages are written in stdout, stderr, a file or a string.
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
