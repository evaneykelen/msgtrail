require 'base64'
require 'date'
require 'dotenv'
require 'fileutils'
require 'http'
require 'msgtrail/article'
require 'msgtrail/blog'
require 'msgtrail/config'
require 'msgtrail/github'
require 'msgtrail/markdown_file'
require 'msgtrail/renderers'
require 'msgtrail/site'
require 'msgtrail/slug'
require 'msgtrail/titlecase'
require 'msgtrail/twitter'
require 'multi_json'
require 'ostruct'
require 'redcarpet'
require 'redcarpet/render_strip'
require 'tilt/erb'
require 'uri'

include ERB::Util

module Msgtrail
  class Publish

    def self.to_file_system(current_directory, directory_argument)
      working_directory = File.join(current_directory, directory_argument)

      config = Config.new(working_directory)

      blog = Blog.new(config)
      site = Site.new(config)

      blog.fetch_blog_articles
      blog.prepare_output_directory
      blog.fetch_article_content
      blog.generate_article_slugs

      site.fetch_site_pages
      site.generate_articles(blog.articles)
      site.copy_favicon

      exit(0)
    end

  end
end
