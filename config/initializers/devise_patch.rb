# - - - - - - - - - - - - - - - - - - - -
# DEVISE MONKEY PATCH
# - - - - - - - - - - - - - - - - - - - -
# -  https://github.com/plataformatec/devise/issues/4127#issuecomment-309010663
# -  https://github.com/plataformatec/devise/blob/88724e10adaf9ffd1d8dbfbaadda2b9d40de756a/lib/devise/controllers/helpers.rb#L110-L130
# -  https://github.com/plataformatec/devise/blob/cbbe932ee22947fb7fc741a4da3e6783091c88b0/lib/devise/failure_app.rb#L157
# -  https://github.com/plataformatec/devise/commit/cbbe932ee22947fb7fc741a4da3e6783091c88b0

require "action_controller/metal"

module Devise
  # Failure application that will be called every time :warden is thrown from
  # any strategy or hook. Responsible for redirect the user to the sign in
  # page based on current scope and mapping. If no scope is given, redirect
  # to the default_url.
  class FailureApp < ActionController::Metal

  protected

    def scope_url
      opts  = {}

      # Initialize script_name with nil to prevent infinite loops in
      # authenticated mounted engines in rails 4.2 and 5.0
      opts[:script_name] = nil

      route = route(scope)

      opts[:format] = request_format unless skip_format?

      router_name = Devise.mappings[scope].router_name || Devise.available_router_name
      context = send(router_name)

      if relative_url_root?
        opts[:script_name] = relative_url_root
      elsif defined? context.routes
        rootpath = context.routes.url_helpers.root_path
        opts[:script_name] = rootpath.chomp('/') unless rootpath.length <= 1
      end

      if context.respond_to?(route)
        context.send(route, opts)
      elsif respond_to?(:root_url)
        root_url(opts)
      else
        "/"
      end
    end
  end
end