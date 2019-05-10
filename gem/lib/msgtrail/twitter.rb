module Msgtrail
  class Twitter

    PRE_AUTHENTICATION          = "Basic %s".freeze
    POST_AUTHENTICATION         = "Bearer %s".freeze
    CONTENT_TYPE_HEADER         = { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' }.freeze
    TWITTER_API_OAUTH_ENDPOINT  = 'https://api.twitter.com/oauth2/token'.freeze
    TWITTER_API_STATUS_ENDPOINT = "https://api.twitter.com/1.1/statuses/show.json?id=%s&tweet_mode=extended".freeze
    TWITTER_AUTH_BODY           = 'grant_type=client_credentials'.freeze
    EXPECTED_TOKEN_TYPE         = 'bearer'.freeze
    TWITTER_STATUS_ENDPOINT     = "https://twitter.com/i/web/status/%s".freeze

    def self.tweet_bodies(tweet_ids)
      tweet_ids.map { |tweet_id| fetch(tweet_id) }
    end

    def self.fetch(tweet_id)
      if access_token = authenticate
        full_tweet_text(access_token, tweet_id)
      else
        puts("Failed to authenticate with Twitter API")
      end
    end

    def self.authenticate
      api_key = ENV['TWITTER_CONSUMER_API_KEY']
      secret = ENV['TWITTER_CONSUMER_SECRET_KEY']
      credentials = Base64.strict_encode64("#{api_key}:#{secret}")
      begin
        result = HTTP.auth(PRE_AUTHENTICATION % credentials)
                     .headers(CONTENT_TYPE_HEADER)
                     .post(TWITTER_API_OAUTH_ENDPOINT, body: TWITTER_AUTH_BODY)
      rescue
        puts("Failed to authenticate with Twitter API (#{$!})")
        exit(2)
      end
      begin
        json = MultiJson.load(result.to_s, symbolize_keys: true)
      rescue
        puts("Invalid JSON from '#{TWITTER_API_OAUTH_ENDPOINT}' (#{$!})")
        exit(2)
      end
      EXPECTED_TOKEN_TYPE == json[:token_type] ? json[:access_token] : nil
    end

    # There seem to be two ways to get to any tweet by its ID:
    # 1. https://twitter.com/i/web/status/{id}
    # 2. https://twitter.com/statuses/#{id}
    # Using former method which seems to work best on desktop and mobile.
    def self.full_tweet_text(access_token, tweet_id)
      url = TWITTER_API_STATUS_ENDPOINT % tweet_id
      begin
        result = HTTP.auth(POST_AUTHENTICATION % access_token)
                     .get(url)
      rescue
        puts("Failed to get tweet from '#{url}' (#{$!})")
        exit(2)
      end
      begin
        json = MultiJson.load(result.to_s, symbolize_keys: true)
      rescue
        puts("Invalid JSON from '#{url}' (#{$!})")
        exit(2)
      end
      {
        body: json[:full_text],
        source: TWITTER_STATUS_ENDPOINT % tweet_id,
        type: Article::TYPE_TWEET
      }
    end

  end
end
