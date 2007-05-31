#!/usr/bin/env ruby

require 'rbconfig'
require 'fileutils'
include FileUtils::Verbose

include Config

dest = CONFIG["sitelibdir"]
install('lib/permutation.rb', dest)
install('lib/permutation/version.rb', File.join(dest, 'permutation'))
    # vim: set et sw=4 ts=4:
