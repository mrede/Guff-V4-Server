LabelPusher::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  GCM.host = 'https://android.googleapis.com/gcm/send'
  # https://android.googleapis.com/gcm/send is default

  GCM.format = :json
  # :json is default and only available at the moment

  GCM.key =  "AIzaSyAYogRn5Y8UQkjqbglni0GdUV9y0JWSzuA"
  # this is the apiKey obtained from here https://code.google.com/apis/console/

  LabelPusher::Application.config.ios_pem = '/Users/ben/Sites/Label/LabelPusher/lib/joint.pem'


end
