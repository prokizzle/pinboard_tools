#!/usr/bin/env ruby

require 'net/https'
require 'open-uri'
require 'pinboard'
require 'progress_bar'
require 'embedly'
require_relative 'pinboard_tagger'

class String
  def is_number?
    true if Float(self) rescue false
  end
end

module PinboardTools

  class SafariReadingListImporter
    attr_accessor :tagger

    def initialize(args)
      @tagger = Tagger.new(tag: nil, verbose: args[:verbose])
    end

    def run
      links = Array.new

      # from gist: https://gist.github.com/andphe/3232343
      input = %x[/usr/bin/plutil -convert xml1 -o - ~/Library/Safari/Bookmarks.plist | grep -E  -o '<string>http[s]{0,1}:/.*</string>' | grep -v icloud | sed -E 's/<\/{0,1}string>/g']

      input.scan(/(http.+){/).each do |url|
        links.push url.first

        # p link
      end

      pinboard, bar = Pinboard::Client.new(:username => tagger.pb_user, password: tagger.pb_pass), ProgressBar.new(links.size)

      links.reverse_each do |url|
        begin
          meta = tagger.get_metadata(url)

          article = {
            url: url,
            description: meta[:title],
            extended: meta[:excerpt],
            tags: meta[:keywords],
            replace: true,
            toread: true,
            :public => false
          }

          pinboard.add(article) rescue false
        rescue
        end

        bar.increment!
      end
      clear_list = %x{cp -R ~/dev/pinboard_tools/lib/Bookmarks.plist ~/Library/Safari/Bookmarks.plist}
    end
  end
end
