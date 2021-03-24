# frozen_string_literal: true
require "pry"
require "json"

module Stealth
  module Services
    module Messagebird
      class ReplyHandler < Stealth::Services::BaseReplyHandler
        attr_reader :recipient_id, :reply
        def initialize(recipient_id: nil, reply: nil)
          @recipient_id = recipient_id
          @reply = reply
        end

        def text
          check_text_length
          # format_response({ body: reply['text'] })
          format_response(type: 'text', content: { text: reply['text'] })
        end

        def image
          check_text_length
          # format_response({ body: reply['text'], media_url: reply['image_url'] })
          format_response(type: 'image', content: { image: { url: reply['image_url']} })
        end

        def audio
          check_text_length

          format_response(type: 'audio', content: { audio: reply['audio_url'] })
          # format_response({ body: reply['text'], media_url: reply['audio_url'] })
        end

        def video
          check_text_length

          format_response(type: 'video', content: { video: reply['video_url'] })
          # format_response({ body: reply['text'], media_url: reply['video_url'] })
        end

        def file
          check_text_length

          format_response({ body: reply['text'], media_url: reply['file_url'] })
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
          sender_info = { from: Stealth.config.messagebird.channel_id.to_s, to: recipient_id.to_s }
          response.merge(sender_info)
        end
      end
    end
  end
end
