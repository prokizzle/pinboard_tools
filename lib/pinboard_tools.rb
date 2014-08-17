require_relative "pinboard_tools/version"

module PinboardTools

  Dir[File.dirname(__FILE__) + '/pinboard_tools/*.rb'].each do |file|
    require file
  end

end
