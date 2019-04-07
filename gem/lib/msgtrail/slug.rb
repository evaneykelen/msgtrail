module Msgtrail
  class Slug

    def self.generate(title, date, time)
      ymd = date.split(/\D/).map(&:to_i)
      hm = time.split(/\D/).map(&:to_i)
      datestamp = sprintf("%04d%02d%02d-%02d%02d", ymd[0], ymd[1], ymd[2], hm[0], hm[1])
      bucketnameify("#{datestamp}-#{slugify(title)}")
    end

    # Create URL-safe slug
    def self.slugify(title)
      URI.escape(title)
         .gsub(/%[0-9A-F]{2}/, '-')
         .gsub(/-/, '-')
         .downcase
    end

    # Create S3-safe slug.
    #
    # S3 bucket names must comply to these naming rules:
    # - must be between 3 and 63 characters long
    # - must be lowercase a-z
    # - may use numbers 0-9
    # - may use periods & dashes (and thus not _ or / or \)
    # - must start with letter or number
    # - may not end with dash
    # - may not have consecutive periods
    # - may not use dashes adjacent to periods (i.e. no .- or -.)
    # - may not not be formatted as a IP address
    #
    # Reference: http://tinyurl.com/yycoeogm
    #
    # Note: although periods are allowed this methods rejects them for sake of simplicity
    #
    def self.bucketnameify(string)
      #
      # Steps:
      # - change to lowercase
      # - remove periods
      # - truncate to 63 characters
      # - replace invalid characters
      # - replace leading dashes
      # - replace trailing dashes
      # - pad string with dashes if shorter than 3 characters
      #
      string.downcase
            .gsub(/\.*/, '')
            .slice(0..62)
            .gsub(/[^a-z,0-9,-]/, '-')
            .gsub(/\A-*/, '')
            .gsub(/-*\Z/, '')
            .ljust(3, '-')
    end

  end
end
