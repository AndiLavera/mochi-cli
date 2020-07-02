module Mochi::CLI
  # :nodoc:
  abstract class Generator < Teeplate::FileTree
    class_getter registered_commands = Hash(String, Mochi::CLI::Generator.class).new

    macro command(name)
      Mochi::CLI::Generator.registered_commands[{{name.id.stringify}}] = {{ @type.id }}
    end

    include Helpers

    property name : String
    property timestamp : String

    def initialize(@name : String)
      @timestamp = Time.utc.to_s("%Y%m%d%H%M%S%L")
    end

    def render(directory, **args)
      pre_render(directory, **args)
      super(directory, **args)
      post_render(directory, **args)
    end

    def pre_render(directory, **args)
    end

    def post_render(directory, **args)
    end
  end
end
