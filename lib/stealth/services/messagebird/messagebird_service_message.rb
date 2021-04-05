module Stealth
  module Services
    module Messagebird
      class MessagebirdServiceMessage < Stealth::ServiceMessage
        attr_accessor :msisdn, :messagebird_id, :platform, :display_name, :first_name, :last_name

      end
    end
  end
end
