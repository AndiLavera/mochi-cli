require "cli"
require "./version"
require "./cli/commands"

Mochi::CLI::MainCommand.run ARGV
