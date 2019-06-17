module RenderHelper

  def as_rfc3339(published, updated = nil)
    updated.nil? ? datestamp = published : datestamp = updated
    ymd = datestamp[:date].split(/\D/).map(&:to_i)
    hm  = datestamp[:time].split(/\D/).map(&:to_i)
    DateTime.new(ymd[0], ymd[1], ymd[2], hm[0], hm[1], 0, datestamp[:utc_offset]).rfc3339
  end

  def now_as_rfc3339
    DateTime.now.rfc3339
  end

  def titlecase(word)
    return if word.to_s.strip.empty?
    Nice.title(word)
  end

  def xml_safe(str)
    ERB::Util.h(str)
  end

end

module Msgtrail

  class PageRenderer

    include RenderHelper

    attr_accessor :article, :articles, :config, :layout, :markdown, :plaintext, :template, :theme_directory

    def initialize(layout_filepath, template_filepath, config)
      self.article = {}
      self.config = config
      self.markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, fenced_code_blocks: true, strikethrough: true)
      self.plaintext = Redcarpet::Markdown.new(Redcarpet::Render::StripDown)
      self.theme_directory = File.join(config.working_directory, config.settings.file_matter.theme_directory)
      begin
        self.layout = File.read(layout_filepath)
      rescue
        puts("Can't find '#{layout_filepath}' (#{$!})")
        exit(2)
      end
      begin
        self.template = File.read(template_filepath)
      rescue
        puts("Can't find '#{template_filepath}' (#{$!})")
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

    def render_partial(partial_filename, variables)
      partial_filepath = File.join(self.theme_directory, "_#{partial_filename}.html.erb")
      PartialRenderer.new(partial_filepath, variables, self.config).render
    end

    def track(event, sub_event = nil)
      "<img src=\"#{self.config.settings.domain_matter.tracking_pixel_url}?e=#{event}&se=#{sub_event}\" width=\"1\" height=\"1\" alt=\".\"/>"
    end

    # Offer shortcut `cfg` to `settings.config` for use inside ERBs
    def method_missing(missing_method_name, *args, &block)
      if 'cfg' == missing_method_name.to_s
        self.config.settings
      else
        super
      end
    end

  end

  class PartialRenderer

    include RenderHelper

    attr_accessor :config, :markdown, :partial, :plaintext, :variables

    def initialize(partial_filepath, variables, config)
      begin
        self.partial = File.read(partial_filepath)
      rescue
        puts("Can't find '#{partial_filepath}' (#{$!})")
        exit(2)
      end
      self.config = config
      self.markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, fenced_code_blocks: true, strikethrough: true)
      self.plaintext = Redcarpet::Markdown.new(Redcarpet::Render::StripDown)
      self.variables = variables
    end

    def method_missing(missing_method_name, *args, &block)
      if 'cfg' == missing_method_name.to_s
        self.config.settings
      else
        super
      end
    end

    def render
      ERB.new(self.partial).result(binding)
    end

  end

end
