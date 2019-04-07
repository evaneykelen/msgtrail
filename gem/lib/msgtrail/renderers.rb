module Msgtrail

  class PageRenderer

    attr_accessor :article, :articles, :config, :layout, :markdown, :template, :theme_directory

    def initialize(layout_filepath, template_filepath, config)
      self.article = {}
      self.markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, fenced_code_blocks: true)
      self.config = config
      begin
        self.layout = File.read(layout_filepath)
      rescue
        puts("Can't find '#{layout_filepath}'")
        exit(2)
      end
      begin
        self.template = File.read(template_filepath)
      rescue
        puts("Can't find '#{template_filepath}'")
        exit(2)
      end
    end

    def render
      erbs = [self.template, self.layout] # Note order!
      # Inject accepts value and block. Nil in inject(nil) sets initial value.
      # First iteration: prev = nil and erb = self.template.
      # Since self.template has no yield only a string is rendered.
      # Second iteration: prev = rendered string and erb = self.layout.
      # Since self.layout has yield, yield will be replaced by string in prev.
      erbs.inject(nil) do |prev, erb|
        _render(erb) { prev }
      end
    end

    def _render(template)
      ERB.new(template).result(binding)
    end

    def render_article(partial_filename, variables)
      partial_filepath = File.join(self.theme_directory, "_#{partial_filename}.html.erb")
      ArticlePartialRenderer.new(partial_filepath, variables).render
    end

    # Offer shortcut `cfg` to `settings.config` for use inside ERBs
    def method_missing(missing_method_name, *args, &block)
      if 'cfg' == missing_method_name.to_s
        self.config.settings
      else
        super
      end
    end

    def rfc2822_time(date, time)
      ymd = date.split(/\D/).map(&:to_i)
      hm = time.split(/\D/).map(&:to_i)
      Time.new(ymd[0], ymd[1], ymd[2], hm[0], hm[1])
          .getlocal(cfg.time_matter.utc_offset)
          .rfc2822
    end

  end

  class ArticlePartialRenderer

    attr_accessor :markdown, :partial, :variables

    def initialize(partial_filepath, variables)
      begin
        self.partial = File.read(partial_filepath)
      rescue
        puts("Can't find '#{partial_filepath}'")
        exit(2)
      end
      self.markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, fenced_code_blocks: true)
      self.variables = variables
    end

    def render
      ERB.new(self.partial).result(binding)
    end

  end

end
