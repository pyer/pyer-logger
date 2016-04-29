Logger
======

[![Gem Version](https://badge.fury.io/rb/pyer-logger.svg)](https://badge.fury.io/rb/pyer-logger)
[![Build Status](https://travis-ci.org/pyer/logger.svg?branch=master)](https://travis-ci.org/pyer/logger)

This Logger class provides a simple logging utility for Ruby applications.
Log messages are sent to stdout, stderr, a file or a string by a Logger object.

The messages will have varying levels reflecting their varying importance.
The levels, and their meanings, are:
* ERROR : an error condition
* WARN  : a warning
* INFO  : generic (useful) information about system operation
* DEBUG : low-level information for developers

So each message has a level, and the Logger itself has a level, which acts
as a filter, so you can control the amount of information emitted from the
logger without having to remove actual messages.

How to create a logger ?
------------------------

1. Create a logger which logs messages to STDERR/STDOUT.
     log = Logger.new(STDOUT, self.class)
     log = Logger.new(STDERR, self.class)

2. Create a logger for the file which has the specified name.
     log = Logger.new('logfile.log', self.class)

3. Create a logger which logs messages to a string.
     log = Logger.new(STRING, self.class)

Notice that self.class argument prints the class name of the caller object.

How to log a message ?
----------------------

Notice the different methods being used to log messages of various levels.
Messages lower than log.level are not sent to output.

Default log.level is DEBUG. That means all messages are emitted.

     DEBUG < INFO < WARN < ERROR

1. log.error "error is #{ @code }"

2. log.warn  "a warning message"

3. log.info  "some informations"

4. log.debug "dev info"

Messages are provided in a string or in a block, or both.

1. Message in block.

     log.error { "Argument 'foo' not given." }

2. Message as a string.

     log.error "Argument #{ @foo } mismatch."

3. Both arguments

     log.error("Argument ") { "#{ @foo } mismatch." } 

How to set severity level ?
---------------------------

     log.level = INFO

How to close a logger ?
-----------------------

     log.close


Installation
------------

    gem install pyer-options

Build
-----

Building pyer-logger gem is a rake task.

    rake build
