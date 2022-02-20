# frozen_string_literal: true

require 'slack-notifier'
require 'dotenv/load'
require 'pathname'
require 'fileutils'

module MockHttpClient
  def post(uri, params)
    payload = JSON.parse(params[:payload])

    filepath = Pathname("tmp/slack-notifiee/#{Random.rand(100000..999999)}.json")
    File.open(filepath, 'w') { |file| JSON.dump(payload.merge(uri: uri), file) }
  end

  module_function :post
end

path = Pathname('tmp/slack-notifiee')
FileUtils.mkdir_p(path)
FileUtils.rm_f(path.children)

webhook_url = ENV.fetch('SLACK_WEBHOOK_URL')
notifier = Slack::Notifier.new(webhook_url, http_client: MockHttpClient)

text = "Danny Torrence left a 1 star review for your property."
block = [
  {
    "type": "section",
    "text": {
      "type": "mrkdwn",
      "text": "Danny Torrence left the following review for your property:"
    }
  },
  {
    "type": "section",
    "block_id": "section567",
    "text": {
      "type": "mrkdwn",
      "text": "<https://example.com|Overlook Hotel> \n :star: \n Doors had too many axe holes, guest in room 237 was far too rowdy, whole place felt stuck in the 1920s."
    },
    "accessory": {
      "type": "image",
      "image_url": "https://is5-ssl.mzstatic.com/image/thumb/Purple3/v4/d3/72/5c/d3725c8f-c642-5d69-1904-aa36e4297885/source/256x256bb.jpg",
      "alt_text": "Haunted hotel image"
    }
  },
  {
    "type": "section",
    "block_id": "section789",
    "fields": [
      {
        "type": "mrkdwn",
        "text": "*Average Rating*\n1.0"
      }
    ]
  }
]

notifier.post text: text, blocks: block
