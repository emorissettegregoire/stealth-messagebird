module Stealth
  module Services
    module Messagebird
      class MessagebirdServiceMessage < Stealth::ServiceMessage
        attr_accessor :messagebird_id, :platform, :display_name, :first_name, :last_name

        def initialize(service:)
          @service = service
          @messagebird_id = messagebird_id
          @platform = platform
          @display_name = display_name
          @first_name = first_name
          @last_name = last_name
        end
      end
    end
  end
end
