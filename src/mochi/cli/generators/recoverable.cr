require "./generator"

module Mochi::CLI
  class Recoverable < Generator
    command :recoverable
    directory "#{__DIR__}/../templates/recoverable"

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
        get "/reset/password", PasswordController, :new
        get "/reset/password/edit", PasswordController, :edit
        post "/reset/password", PasswordController, :create
        patch "/reset/password/:id", PasswordController, :update
      ROUTES
    end
  end
end
