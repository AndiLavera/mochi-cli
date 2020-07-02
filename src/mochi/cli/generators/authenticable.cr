require "./generator"

module Mochi::CLI
  class Authenticable < Generator
    command :authenticable
    directory "#{__DIR__}/../templates/authenticable"

    getter migration_extension : String

    def initialize(name : String, orm : String)
      super(name)
      @orm = orm
      @migration_extension = @orm == "granite" ? "sql" : "cr"
    end

    def pre_render(directory, **args)
      add_plugs
      inherit_plug :web, :auth
      add_routes
      add_dependencies
      # TODO: Remove after testing
      # inject_application_controller_methods
    end

    private def add_routes
      add_routes :web, <<-ROUTES
          get "/signin", SessionController, :new
          post "/session", SessionController, :create
          get "/signup", #{class_name}Controller, :new
          post "/registration", #{class_name}Controller, :create
      ROUTES

      add_routes :auth, <<-ROUTES
          get "/profile", #{class_name}Controller, :show
          get "/profile/edit", #{class_name}Controller, :edit
          patch "/profile", #{class_name}Controller, :update
          get "/signout", SessionController, :destroy
      ROUTES
    end

    private def add_plugs
      add_plugs :web, <<-PLUGS
        plug Current#{class_name}.new
      PLUGS
      add_plugs :auth, <<-PLUGS
        plug Authenticate.new
      PLUGS
    end

    private def inherit_plug(base, target)
      routes = File.read("./config/routes.cr")
      pipes = routes.match(/pipeline :#{base.to_s} do(.+?)end/m)
      return unless pipes

      replacement = <<-PLUGS
        pipeline :#{base.to_s}, :#{target.to_s} do#{pipes[1]}
        end
      PLUGS
      File.write("./config/routes.cr", routes.gsub(pipes[0], replacement))
    end

    private def add_dependencies
      add_dependencies <<-DEPENDENCY
      require "../src/models/**"
      require "../src/pipes/**"
      DEPENDENCY
    end

    # private def inject_application_controller_methods
    #   filename = "./src/controllers/application_controller.cr"
    #   controller = File.read(filename)
    #   append_text = ""

    #   unless controller.includes? "property current_#{@name}"
    #     append_text += current_method_definition
    #   end

    #   append_text = "#{append_text}\nend\n"
    #   controller = controller.gsub(/end\s*\Z/, append_text)
    #   File.write(filename, controller)
    # end

    # private def current_method_definition
    #   <<-AUTH

    #     def current_#{@name}
    #       context.current_#{@name}
    #     end
    #   AUTH
    # end
  end
end
