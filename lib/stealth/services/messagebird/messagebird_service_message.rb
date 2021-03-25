module Stealth
  module Services
    module Messagebird
      class MessagebirdServiceMessage < Stealth::Services::BaseMessageHandler
        attr_accessor :messagebird_id, :platform, :display_name, :first_name, :last_name

        def initialize(service:)
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
