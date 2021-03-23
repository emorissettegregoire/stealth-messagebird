# frozen_string_literal: true
require "pry"

module Stealth
  module Services
    module Messagebird
      class MessageHandler < Stealth::Services::BaseMessageHandler
        attr_reader :service_message, :params, :headers

        def initialize(params:, headers:)
          @params = params
          @headers = headers
        end

        def coordinate
          Stealth::Services::HandleMessageJob.perform_async(
            'messagebird',
            params,
            headers
          )
          # Relay our acceptance
          [200, 'OK']
        end

        def process
          @service_message = ServiceMessage.new(service: 'messagebird')
          service_message.sender_id = params["contact"]["msisdn"]
          service_message.message = params['message']['content']['text']

          #TWILIO
          # service_message.sender_id = params['From']
          # service_message.target_id = params['To']
          # service_message.message = params['Body']

          # It seems that it can not take several attachements for one
          # message

          # Check for media attachments
          #### Need to be changed for messagebird params
          # attachment_count = params['NumMedia'].to_i

          # attachment_count.times do |i|
          #   service_message.attachments << {
          #     type: params["MediaContentType#{i}"],
          #     url: params["MediaUrl#{i}"]
          #   }
          # end

          service_message.attachments << {
            type: params["message"]["type"],
            url: params["message"]["content"]
          }

          service_message
        end
      end
    end
  end
end
