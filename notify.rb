# frozen_string_literal: true
#
# Usage:
#   $ bundle exec ruby notify.rb

require 'slack-notifier'
require 'slack_notifiee'
require 'dotenv/load'

SlackNotifiee.enable

webhook_url = ENV.fetch('SLACK_WEBHOOK_URL')
notifier = Slack::Notifier.new(webhook_url)

notifier.post text: 'Hello, World!', at: 'here', channel: '#random'

pp SlackNotifiee.notifications
