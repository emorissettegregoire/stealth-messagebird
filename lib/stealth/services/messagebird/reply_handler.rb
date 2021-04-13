# frozen_string_literal: true
module Stealth
  module Services
    module Messagebird
      class ReplyHandler < Stealth::Services::BaseReplyHandler

        # ALPHA_ORDINALS = ('A'..'Z').to_a.freeze
        # ENUMERATED_LIST = (1..100).to_a.freeze

        attr_reader :recipient_id, :reply

        def initialize(recipient_id: nil, reply: nil)
          @recipient_id = recipient_id
          @reply = reply
        end

        def text
          check_text_length

          translated_reply = reply['text']

          suggestions = generate_suggestions(suggestions: reply['suggestions'])
          buttons = generate_buttons(buttons: reply['buttons'])

          if suggestions.present?
            translated_reply = [
              translated_reply,
              message = I18n.t(
                "stealth.messagebird.respond_with_a_number",
                default: "Respond with a number:"
              )
              # 'Responde con número:'
            ].join("\n\n")

            suggestions.each_with_index do |suggestion, i|
              translated_reply = [
                translated_reply,

                # message = I18n.t(
                #   "stealth.messagebird.for",
                #   default: "#{i + 1} for #{suggestion}"
                # )

                "#{i + 1} para #{suggestion}"
                # "\"#{ENUMERATED_LIST[i]}\" for #{suggestion}"
              ].join("\n")
            end
          end

          if buttons.present?
            buttons.each do |button|
              translated_reply = [
                translated_reply,
                button
              ].join("\n\n")
            end
          end

          # format_response({ body: translated_reply })
          format_response(type: 'text', content: { text: translated_reply })
        end

        def image
          check_text_length

          format_response(type: 'image', content: { image: { caption: reply['text'], url: reply['image_url'] } })
        end

        def audio
          check_text_length

          format_response(type: 'audio', content: { audio: { caption: reply['text'], url: reply['audio_url'] } })
        end

        def video
          check_text_length

          format_response(type: 'video', content: { video: { caption: reply['text'], url: reply['video_url'] } })
        end

        def file
          check_text_length

          format_response(type: 'file', content: { file: { caption: reply['text'], url: reply['file_url'] } })
        end

        def location
          check_text_length

          format_response(type: 'location', content: { location: { latitude: reply['latitude'], longitude: reply['longitude'] } })
        end

        def delay

        end

        private

        def check_text_length
          if reply['text'].present? && reply['text'].size > 1600
            raise(ArgumentError, "Text messages must be 1600 characters or less.")
          end
        end

        def format_response(response)
          sender_info = {
            from: Stealth.config.messagebird.channel_id.to_s,
            to: recipient_id.to_s
          }
          response.merge(sender_info)
        end

        def generate_suggestions(suggestions:)
          return if suggestions.blank?

          mf = suggestions.collect do |suggestion|
            suggestion['text']
          end.compact
        end

        def generate_buttons(buttons:)
          return if buttons.blank?

          sms_buttons = buttons.map do |button|
            case button['type']
            when 'url'
              "#{button['text']}: #{button['url']}"
            when 'payload'
              "Para #{button['text'].downcase}: Texto #{button['payload'].upcase}"
            when 'call'
              "#{button['text']}: #{button['phone_number']}"
            end
          end.compact

          sms_buttons
        end
      end
    end
  end
end
