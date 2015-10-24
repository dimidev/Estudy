# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.scss, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

Rails.application.config.assets.precompile += %w( icheck/square/square.png )
Rails.application.config.assets.precompile += %w( icheck/square/square@2x.png )
Rails.application.config.assets.precompile += %w( icheck/square/blue.png )
Rails.application.config.assets.precompile += %w( icheck/square/blue@2x.png )
Rails.application.config.assets.precompile += %w( ckeditor/* )