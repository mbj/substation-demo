class Demo
  module Web

    class Authenticator
      include Substation::Processor::Incoming
      include Adamantium

      INSTANCE = new

      def call(request)
        # implement authentication logic
        request.success(request.input)
      end
    end

    class Authorizer
      include Substation::Processor::Incoming
      include Adamantium

      INSTANCE = new

      def call(request)
        # implement authorization logic
        request.success(request.input)
      end
    end

    class Serializer
      include Substation::Processor::Outgoing
      include Adamantium

      module JSON

        class Model < Serializer
          def call(response)
            model = response.output
            hash  = model.class.attributes_hash(model)

            respond_with(response, MultiJson.dump(hash))
          end
        end

        class Custom < Serializer
          def call(response)
            respond_with(response, handler.new(response.output).to_json)
          end
        end

        MODEL  = Model.new
        CUSTOM = Custom.new
      end
    end

    class Renderer
      include Substation::Processor::Outgoing
      include Concord.new(:handler)
      include Adamantium::Flat

      def call(response)
        respond_with(response, Mustache.render(handler, response.output))
      end
    end

  end
end
