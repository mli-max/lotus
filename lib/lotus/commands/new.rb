require 'pathname'
require 'securerandom'
require 'lotus/application_name'
require 'lotus/utils/string'
require 'lotus/utils/class'

module Lotus
  module Commands
    class New
      GENERATORS_NAMESPACE = "Lotus::Generators::Application::%s".freeze

      attr_reader :app_name, :source, :target, :cli, :options

      def initialize(app_name_or_path, environment, cli)
        @app_name = ApplicationName.new(_get_real_app_name(app_name_or_path))
        @options  = environment.to_options
        @arch     = @options.fetch(:architecture)

        @target   = Pathname.pwd.join(@options.fetch(:path, app_name_or_path))
        @source   = Pathname.new(@options.fetch(:source) { ::File.dirname(__FILE__) + '/../generators/application/' }).join(@arch)

        @cli      = cli

        require "lotus/generators/application/#{ @arch }"
        command  = Utils::String.new(@arch).classify
        @command = Utils::Class.load!(GENERATORS_NAMESPACE % command).new(self, environment)
      end

      def start
        @command.start
      end

      private
      def _get_real_app_name(app_name_or_path)
        if app_name_or_path.include?(::File::SEPARATOR)
          raise ArgumentError.new("Invalid application name. If you want to set application path, please use --path option")
        end

        app_name_or_path == '.' ? ::File.basename(Dir.getwd) : app_name_or_path
      end
    end
  end
end
