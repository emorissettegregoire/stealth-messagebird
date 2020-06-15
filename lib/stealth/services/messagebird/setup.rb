# frozen_string_literal: true

require 'stealth/services/messagebird/client'

module Stealth
  module Services
    module MessageBird

      class Setup

        class << self
          def trigger
            Stealth::Logger.l(topic: "messagebird", message: "There is no setup needed!")
          end
        end

      end

    end
  end
end
