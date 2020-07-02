require "./generator"

module Mochi::CLI
  class Lockable < Generator
    command :lockable
    directory "#{__DIR__}/../templates/lockable"

    getter migration_extension : String

    def initialize(name : String, orm : String)
      super(name)
      @orm = orm
      @migration_extension = @orm == "granite" ? "sql" : "cr"
    end

    def pre_render(directory, **args)
      add_routes
    end

    private def add_routes
      add_routes :web, <<-ROUTES
        get "/unlock", UnlockableController, :update
      ROUTES
    end
  end
end
