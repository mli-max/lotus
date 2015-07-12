# require 'pathname'
# require 'lotus/utils/string'
# require 'lotus/utils/class'

module Lotus
  module Commands
    # @since 0.3.0
    # @api private
    class Generate < Thor
      namespace :generate

      desc 'generate app NAME', 'generate Lotus app (only for Container arch)'
      long_desc <<-DESC
      `lotus generate app admin` will generate a new Lotus application at
      `apps/admin` (`Admin::Application`).

      It will be mounted under the `/admin` URI namespace.

      To customize the path use `--application-base-url=/foo` CLI argument.

      This generator is only available for Container architecture.
DESC

      method_option :application_base_url, desc: 'application base url', type: :string
      method_option :help, aliases: '-h',  desc: 'displays usage'

      def app(name = nil)
        if options[:help] || name.nil?
          invoke :help, ['app']
        else
          require 'lotus/generators/app'
          Lotus::Generators::App.new(self, environment, name).start
        end
      end

      desc 'generate web_action [APP] ACTION', 'generate web_action'
      desc 'web_action',                       'generate web_action'
      long_desc <<-DESC
      Generate an action, a view, a template, a route and the relative unit test code.

      View and template generation can be bypassed via `--skip-view=true` CLI argument.

      The route is named after the controller name:

        get '/home', to: 'home#index

      To customize the path use `--path=/` CLI argument.



      The syntax changes according to the current architecture.

      Container:

        `lotus generate web_action web home#index`

        Generates an action at `apps/web/controllers/home/index.rb`

        The first argument (`web`) is the name of the application.

        The second argument is made of the name of the controller and of the action,
        separated by `#`.



      Application:

        `lotus generate web_action home#index`

        Generates an action at `app/controllers/home/index.rb`

        The argument is made of the name of the controller and of the action,
        separated by `#`.
DESC

      method_option :path,                     desc: 'relative URI path',                       type: :string
      method_option :skip_view,                desc: 'skip the creation of view and templates', type: :boolean, default: false
      method_option :help,      aliases: '-h', desc: 'displays usage'

      def web_action(app_name = nil, name = nil)
        if options[:help] || name.nil?
          invoke :help, ['web_action']
        else
          require 'lotus/generators/action'
          Lotus::Generators::Action.new(self, environment, app_name, name).start
        end
      end

      desc 'generate model', 'generate model'
      desc 'model',          'generate model'

      method_option :help,      aliases: '-h', desc: 'displays usage'

      def model(name = nil)
        if options[:help] || name.nil?
          invoke :help, ['model']
        else
          require 'lotus/generators/model'
          Lotus::Generators::Model.new(self, environment, name).start
        end
      end

      desc 'generate migration', 'generate migration'
      desc 'migration',          'generate migration'

      method_option :help,      aliases: '-h', desc: 'displays usage'

      def migration(name = nil)
        if options[:help] || name.nil?
          invoke :help, ['migration']
        else
          require 'lotus/generators/migration'
          Lotus::Generators::Migration.new(self, environment, name).start
        end
      end

      private

      def environment
        Lotus::Environment.new(options)
      end
    end
  end
end
