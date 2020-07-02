require "./generator"

module Mochi::CLI
  class Invitable < Generator
    command :invitable
    directory "#{__DIR__}/../templates/invitable"

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
        get "/invite/new", InvitableController, :new
        get "/invite/edit", InvitableController, :edit
        post "/invite", InvitableController, :create
        patch "/invite", InvitableController, :update
      ROUTES
    end
  end
end
