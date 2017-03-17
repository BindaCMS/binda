class Binda::InstallGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

    def add_route
      return if Rails.env.production?
      return if Rails.application.routes.routes.detect { |route| route.app.app == Binda::Engine }
      route "mount Binda::Engine => '/admin_panel'"
    end

    def copy_migrations
      return if Rails.env.production?
      rails 'binda:install:migrations'
    end

    def run_migrations
      rails 'db:migrate'
    end

    def feedback
      puts
      puts "    Binda CMS has been succesfully installed! "
      puts
      puts "    Restart your server and visit http://localhost:3000 in your browser!"
      puts "    The admin panel is located at http://localhost:3000/admin_panel."
      puts
    end

end
