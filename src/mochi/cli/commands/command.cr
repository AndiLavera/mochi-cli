require "log"

# :nodoc:
abstract class Command < Cli::Command
  def info(msg)
    Log.info { msg }
  end

  def error(msg)
    Log.error { msg }
  end
end
