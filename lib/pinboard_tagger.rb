require 'pinboard'
require 'progress_bar'
require 'embedly'
require 'yaml'
require 'open-uri'

# Detect if a string contains only a numeric value
class String
  def is_number?
    true if Float(self) rescue false
  end
end


module PinboardTools

  # Replaces keywords on select Pinboard articles via Embed.ly
  # 
  # @param tag [Symbol] defines a string tag for tagger to filter articles by
  # 
  class Tagger
    attr_reader :pb_user, :pb_pass

    def initialize(args)
      config_path = File.expand_path("../../config/pinboard.yml", __FILE__)
      @config = YAML.load_file(config_path)
      @embedly_key = @config[:embedly_key].to_s
      @pb_user = @config[:pinboard_user]
      @pb_pass = @config[:pinboard_pass]
      @errors = 0
      # @_tag = Array.new
      @_tag = args[:tag]
    end

    # Handles downloading new metadata for articles via Embed.ly Extract API
    # 
    # @param url [String] URL of article to fetch keywords for
    # @return [Hash] A collection of important metadata tags for article:
    #   keywords [Array] 5 most relevant keywords for article
    #   title [String] the most likely title for the article
    #   excert [String] an excerpt or description for the article
    #
    def get_metadata(url)
      title, description, tags = "", "", Array.new
      embedly_api = Embedly::API.new :key => @embedly_key
      # single url
      obj = embedly_api.extract :url => url
      obj.each do |i|
        i.keywords.each do |k|
          tags.push k["name"] unless k["name"].is_number?
        end
        title = i.title
        desription = i.description
      end
      return {keywords: tags.take(5), title: title, excerpt: description}
    end

    # Initiates new Pinboard session, fetches articles to be re-tagged, and applies new tags
    #
    def run
      pinboard = Pinboard::Client.new(:username => @pb_user, password: @pb_pass)

      unless @_tag.empty?
        posts = pinboard.posts(:tag => @_tag)
      else
        posts = pinboard.posts(:results => 10)
      end
      bar = ProgressBar.new(posts.size)
      posts.reverse_each do |post|

        tag_list = Array.new
        # begin
        post_metadata = get_metadata(post.href)

        params = {
          url: post.href,
          description: post_metadata[:title],
          tags: post_metadata[:keywords],
          replace: true,
          :public => false
        }
        pinboard.add(params) rescue @errors += 1
        # rescue
        # end
        bar.increment!
      end
      puts "#{@errors} errors."
    end
  end
end
