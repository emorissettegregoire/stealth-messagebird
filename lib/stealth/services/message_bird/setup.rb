# frozen_string_literal: true

require 'stealth/services/message_bird/client'

module Stealth
  module Services
    module MessageBird

      class Setup

        class << self
          def trigger
            Stealth::Logger.l(topic: "message_bird", message: "There is no setup needed!")
          end
        end

      end

    end
  end
end
