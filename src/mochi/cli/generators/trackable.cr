require "./generator"

module Mochi::CLI
  class Trackable < Generator
    command :trackable
    directory "#{__DIR__}/../templates/trackable"

    getter migration_extension : String

    def initialize(name : String, orm : String)
      super(name)
      @orm = orm
      @migration_extension = @orm == "granite" ? "sql" : "cr"
    end

    def pre_render(directory, **args)
    end
  end
end
