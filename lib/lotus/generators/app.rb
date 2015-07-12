require 'shellwords'
require 'lotus/generators/abstract'
require 'lotus/generators/slice'

module Lotus
  module Generators
    class App < Abstract
      attr_reader :name

      def initialize(command, environment, name)
        super
        assert_architecture!

        options.merge!(app_name_options)
        @slice_generator = Slice.new(command, environment, name)

        command.class.source_root(source)
      end

      def start
        @slice_generator.start
      end

      private

      # @since 0.4.0
      # @api private
      def assert_architecture!
        unless environment.container?
          puts "New applications can be only generated with Container architecture"
          exit 1
        end
      end

      # @since x.x.x
      # @api private
      def app_name_options
        {
          application: name,
          application_base_url: application_base_url
        }
      end

      # @since 0.4.0
      # @api private
      def application_base_url
        options[:application_base_url] || "/#{name}"
      end
    end
  end
end
