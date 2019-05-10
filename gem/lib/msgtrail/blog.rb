module Msgtrail
  class Blog

    attr_accessor :articles, :config

    def initialize(config)
      self.config = config
    end

    def fetch_blog_articles
      begin
        filepath = File.join(self.config.working_directory, self.config.settings.file_matter.blog_manifest_file)
        manifest = File.read(filepath)
      rescue
        puts("Can't find blog manifest '#{filepath}' (#{$!})")
        exit(2)
      end
      begin
        self.articles = MultiJson.load(manifest, symbolize_keys: true)
      rescue
        puts("Invalid JSON in '#{filepath}' (#{$!})")
        exit(2)
      end
    end

    def prepare_output_directory
      directory = File.join(self.config.working_directory, self.config.settings.file_matter.blog_directory)
      begin
        FileUtils.remove_dir(directory)
        puts("Deleted '#{directory}'")
      rescue
        # It is OK if this directory doesn't exist.
      end
      begin
        FileUtils.mkdir(directory)
        puts("Created '#{directory}'")
      rescue
        puts("Can't create '#{directory}' (#{$!})")
      end
    end

    def fetch_article_content
      self.articles.each do |article|
        if article.has_key?(:file)
          Article.fetch_file_based_article(self.config.working_directory, article)
        elsif article.has_key?(:gist_id)
          Article.fetch_gist_based_article(article)
        elsif article.has_key?(:tweet_ids)
          Article.fetch_tweet_based_article(article)
        else
          puts("Error preparing article based on '#{article}'")
        end
      end
    end

    def generate_article_slugs
      self.articles.each do |article|
        article[:slug] = Slug.generate(article[:title], article[:date], article[:time])
      end
    end

  end
end
