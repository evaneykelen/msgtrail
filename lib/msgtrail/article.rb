module Msgtrail
  class Article

    TYPE_FILE = 'file'
    TYPE_GIST = 'gist'
    TYPE_TWEET = 'tweet'

    #
    # Using :bodies array for file, gists, and tweets even
    # though for file-based articles only a single file is
    # supported at the moment.
    #
    # For the sake of symmetry and future expansion :bodies
    # is used for all three article types.
    #

    def self.fetch_file_based_article(working_directory, article)
      article[:bodies] = MarkdownFile.file_bodies(working_directory, article)
    end

    def self.fetch_gist_based_article(article)
      article[:bodies] = GitHub.gist_bodies(article[:gist_id])
    end

    def self.fetch_tweet_based_article(article)
      article[:bodies] = Twitter.tweet_bodies(article[:tweet_ids])
    end

  end
end
