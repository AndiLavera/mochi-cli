require "./generator"

module Mochi::CLI
  class Confirmable < Generator
    command :confirmable
    directory "#{__DIR__}/../templates/confirmable"

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
        get "/registration/confirm", RegistrationController, :update
      ROUTES
    end
  end
end
