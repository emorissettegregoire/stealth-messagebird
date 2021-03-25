module Stealth
  module Services
    module Messagebird
      class MessagebirdServiceMessage < Stealth::Services::ServiceMessage
        attr_reader :messagebird_id, :platform, :display_name, :first_name, :last_name

        def initialize(params:)
          @params = params
        end

        def contact_info
          # I want to capture info from a contact
          @contact_info = {
            messagebird_id: params['contact']['id'],
            platform: params['message']['platform'],
            display_name: params['contact']['displayName'],
            first_name: params['contact']['firstName'],
            last_name: params['contact']['lastName'],
          }
        end

      end
    end
  end
end
