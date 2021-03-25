# Messagebird WhatsApp Driver for Stealth

The [Stealth](https://github.com/hellostealth/stealth) WhatsApp driver adds the ability to build your bot using Messagebird service.

[![Gem Version](https://badge.fury.io/rb/stealth-twilio.svg)](https://badge.fury.io/rb/stealth-twilio)

## Supported Reply Types

* Text
* Image
* Audio
* Video
* File
* Delay
* Location

Image, Audio, Video, and File reply types will leverage the MMS protocol. It is recommended by Twilio that
the content is limited to images, however, this is the full list of supported content types: https://www.twilio.com/docs/api/messaging/accepted-mime-types.

If you store your files on S3, please make sure you have set the `content-type` appropriately or Twilio might reject your media.
