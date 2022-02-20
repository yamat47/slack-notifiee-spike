# frozen_string_literal: true

require 'slack-notifier'
require 'dotenv/load'
require 'pathname'
require 'fileutils'
require 'ulid'
require 'time'

require_relative './slack_notifiee'

SlackNotifiee.enable

webhook_url = ENV.fetch('SLACK_WEBHOOK_URL')
notifier = Slack::Notifier.new(webhook_url)

notifier.post text: 'Hello, World!', at: 'here', channel: '#random'

pp SlackNotifiee.notifications
