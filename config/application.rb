require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'csv'
require 'socket'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Ccni
  class Application < Rails::Application
    config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
    config.assets.paths << Rails.root.join('app', 'assets', 'texts')
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.i18n.enforce_available_locales = true
    config.action_view.field_error_proc = Proc.new { |html_tag, instance|
      "#{html_tag}".html_safe
    }
  end
end
