module Msgtrail
  class GitHub

    SUPPORTED_MIME_TYPE = 'text/plain'.freeze
    SUPPORTED_LANGUAGE  = 'Markdown'.freeze
    GIST_API_ENDPOINT   = "https://api.github.com/gists/%s".freeze

    def self.gist_bodies(gist_id)
      json = fetch_gist(gist_id)
      source = json[:html_url]
      bodies = []
      json[:files].each do |key, value|
        if SUPPORTED_MIME_TYPE == value[:type] && SUPPORTED_LANGUAGE == value[:language]
          bodies << {
            body: value[:content],
            source: source,
            type: Article::TYPE_GIST
          }
        end
      end
      bodies
    end

    def self.fetch_gist(gist_id)
      begin
        url = GIST_API_ENDPOINT % gist_id
        result = HTTP.get(url)
      rescue
        puts("Can't access '#{url}'")
        exit(2)
      end
      begin
        json = MultiJson.load(result.to_s, symbolize_keys: true)
      rescue
        puts("Invalid JSON from '#{url}'")
        exit(2)
      end
      json
    end

  end
end

