# encoding: utf-8

require 'highline/import'
require 'yaml'
namespace :pinboard do
  task :login do
    say("\nPlease enter your Pinboard credentials")
    puts ""
    user    = ask("Pinboard username:   ")
    pass    = ask("Pinboard password:   ") { |q| q.echo = "*" }
    embedly = ask("Embedly API key:     ")
    this = {pinboard_user: user.to_s, pinboard_pass: pass.to_s, embedly_key: embedly.to_s}
    puts this.to_yaml
    dir = %x{mkdir -p config} rescue false

    config_path = File.expand_path("../config/pinboard.yml", __FILE__)
        File.open(config_path, "w") do |f|
          f.write(this.to_yaml)
        end
  end
end