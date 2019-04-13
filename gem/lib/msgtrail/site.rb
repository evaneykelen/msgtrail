module Msgtrail
  class Site

    attr_accessor :blog_directory, :config, :pages, :theme_directory

    def initialize(config)
      self.config = config
      self.blog_directory = File.join(config.working_directory, config.settings.file_matter.blog_directory)
      self.theme_directory = File.join(config.working_directory, config.settings.file_matter.theme_directory)
    end

    def fetch_site_pages
      filepath = File.join(self.config.working_directory, self.config.settings.file_matter.site_manifest_file)
      begin
        manifest = File.read(filepath)
      rescue
        puts("Can't find site manifest '#{filepath}'")
        exit(2)
      end
      begin
        self.pages = MultiJson.load(manifest, symbolize_keys: true)
      rescue
        puts("Invalid JSON in '#{filepath}'")
        exit(2)
      end
    end

    def generate_articles(articles)
      self.pages.each do |page|
        layout_filepath = File.join(self.theme_directory, page[:layout])
        template_filepath = File.join(self.theme_directory, page[:template])
        if page[:iterator_subject] == false
          renderer = PageRenderer.new(layout_filepath, template_filepath, self.config)
          renderer.articles = articles
          write_article_directory_and_file(page, renderer)
        else
          articles.each do |article|
            renderer = PageRenderer.new(layout_filepath, template_filepath, self.config)
            renderer.article = article
            write_article_directory_and_file(page, renderer, article[:slug])
          end
        end
      end
    end

    def write_article_directory_and_file(page, renderer, slug = nil)
      # Create directory
      article_directory = File.join(self.blog_directory, (page[:output_path] || "") % slug)
      begin
        FileUtils.mkdir_p(article_directory)
      rescue
        puts("Can't create '#{article_directory}'")
        exit(2)
      end
      # Create file
      index_filepath = File.join(self.blog_directory, (page[:output_path] || "") % slug, page[:output_file])
      begin
        File.write(index_filepath, renderer.render)
      rescue
        puts("Can't write '#{index_filepath}'")
        exit(2)
      end
      puts("Created '#{index_filepath}'")
    end

  end
end
