require 'delegate'
require_relative 'path_methods'
require 'lotus/utils/string'

module Lotus
  module Generators
    # Abstract super class for generators
    #
    # @abstract
    # @since 0.2.0
    class Abstract < SimpleDelegator
      include PathMethods
      # @api private
      # @since x.x.x
      attr_reader :environment, :name, :source, :target, :options

      # Initialize a generator
      #
      # @param command [Thor] a Thor instance that comes from Lotus::Cli
      #
      # @since 0.2.0
      # @api private
      def initialize(command, environment, name=nil)
        super(command)
        @environment = environment
        @name = name
        @options  = environment.to_options.merge(command.options)

        # p self.class.to_s
        # class_name = Lotus::Utils::String.new(self.class.to_s).demodulize
        # @source   = Pathname.new(::File.dirname(__FILE__) + "/#{ class_name.downcase }/").realpath
        @target   = Pathname.pwd.realpath
      end

      # Start the generator
      #
      # @raise [NotImplementedError]
      #
      # @abstract
      # @since 0.2.0
      def start
        raise NotImplementedError
      end

      def execute
      end
    end
  end
end
