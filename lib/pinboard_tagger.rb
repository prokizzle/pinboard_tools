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
    attr_reader :pb_user, :pb_pass, :pinboard

    def initialize(args)
      config_path = File.expand_path("../../config/pinboard.yml", __FILE__)
      @config = YAML.load_file(config_path)
      @embedly_key = @config[:embedly_key].to_s
      @pb_user = @config[:pinboard_user]
      @pb_pass = @config[:pinboard_pass]
      @errors = 0
      # @_tag = Array.new
      @_tag = args[:tag]
      @verbose = args[:verbose]
      @pinboard = {}
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
      title, description, tags, error_code, type = "", "", Array.new, nil, nil
      embedly_api = Embedly::API.new :key => @embedly_key
      # single url
      obj = embedly_api.extract :url => url
      obj.each do |i|
        i.keywords.each do |k|
          tags.push k["name"] unless k["name"].is_number?
        end
        tags << "unread"
        title = i.title
        desription = i.description
        error_code = ""
        error_code = i.respond_to?(:error_code) ? i.error_code : 200
        # p i
        type = i.type
      end
      return {keywords: tags.take(5), title: title, excerpt: description, error_code: error_code, type: type}
    end

    # Initiates new Pinboard session, fetches articles to be re-tagged, and applies new tags
    #
    def run
      pinboard = Pinboard::Client.new(:username => @pb_user, password: @pb_pass)
      posts = []
      # unless @_tag.empty? && @_tag.is_a Array
      if @_tag.is_a? Array
        @_tag.each do |t|
          pinboard.posts(tag: t).each {|p| posts << p}
        end
      else
        posts = pinboard.posts(:tag => @_tag) rescue nil
      end
      # else
      # posts = pinboard.posts(:results => 10)
      # end
      bar = ProgressBar.new(posts.size)
      posts.each do |post|

        tag_list = Array.new
        post_metadata = get_metadata(post.href)
        params = {
          url: post.href,
          description: post_metadata[:title],
          tags: post_metadata[:keywords],
          replace: true,
          :public => true,
          :toread => true,
          :type => post_metadata[:type]
        }
        if post_metadata[:error_code] == 404
          pinboard.delete(post.href)
        elsif params[:type] != "html"
          pinboard.add(url: post.href, tags: [params[:type]], description: post.href)
        else
          pinboard.add(params) rescue @errors += 1
        end
        bar.increment! if @verbose
      end
      puts "#{@errors} errors."
    end
  end
end
