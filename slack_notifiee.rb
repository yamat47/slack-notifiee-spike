module SlackNotifiee
  def enable
    _reset_storage(storage_path)
    _override_http_client(storage_path)
  end

  def storage_path
    Pathname('tmp/slack-notifiee')
  end

  def http_client
    SlackNotifiee::HttpClient.new(storage_path)
  end

  def _reset_storage(path)
    ::FileUtils.mkdir_p(path)
    ::FileUtils.rm_f(path.children)
  end

  def _override_http_client(path)
    ::Slack::Notifier.class_eval { prepend SlackNotifierExtension }
  end

  module_function :enable, :storage_path, :http_client, :_reset_storage, :_override_http_client
  private_class_method :_reset_storage, :_override_http_client

  class HttpClient
    def initialize(storage_path)
      @storage_path = storage_path
    end

    def post(uri, params)
      payload = JSON.parse(params[:payload])
      notification_content = payload.merge(uri: uri, datetime: Time.now.iso8601(6))

      filepath = @storage_path + "#{ULID.generate}.json"
      File.open(filepath, 'w') { |file| JSON.dump(notification_content, file) }
    end
  end

  module SlackNotifierExtension
    def initialize(webhook_url, options={}, &block)
      http_client = ::SlackNotifiee.http_client
      options.merge!(http_client: http_client)

      super(webhook_url, options, &block)
    end
  end
end
