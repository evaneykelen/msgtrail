module Msgtrail
  class MarkdownFile

    def self.file_bodies(working_directory, article)
      filepath = File.join(working_directory, article[:file])
      begin
        body = File.read(filepath)
      rescue
        puts("Can't find file '#{filepath}' (#{$!})")
        exit(2)
      end
      [
        {
          body: body,
          source: nil,
          type: Article::TYPE_FILE
        }
      ]
    end

  end
end

