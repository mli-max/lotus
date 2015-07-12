module Lotus
  module Generators
    module PathMethods
      APP_ARCHITECTURE = 'app'.freeze

       # @since 0.3.0
       # @api private
       def app_root
         @app_root ||= begin
           result = Pathname.new(@options[:apps_path])
           result = result.join(@name || @app_name) if @environment.container?
           result
         end
       end

       # @since 0.3.0
       # @api private
       def spec_root
         @spec_root ||= Pathname.new('spec')
       end

       # @since 0.3.1
       # @api private
       def model_root
         @model_root ||= Pathname.new(['lib', ::File.basename(Dir.getwd)]
           .join(::File::SEPARATOR))
       end

       def sanitize_input(app_name, name)
         if options[:architecture] == APP_ARCHITECTURE
           @app_name = nil
           @name     = app_name
         else
           @app_name = app_name
           @name     = name
         end
       end
     end
  end
end

