if Gem::Version.new(Bundler::VERSION) < Gem::Version.new('1.5.0')
  abort <<-Message

  *****************************************************
  *                                                   *
  *   HeyDay requires bundler version >= 1.7.3   *
  *                                                   *
  *   Please install bundler with:                    *
  *                                                   *
  *   gem install bundler                             *
  *                                                   *
  *****************************************************

  Message
end

source 'https://rubygems.org'

ruby '2.1.3'

# Core stuff
gem 'rails', '~> 4.1.6'

# Database stuff
gem 'pg'

# Assets Stuff
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'

# carrierwave
gem 'carrierwave'
gem 'mini_magick', '~> 3.8.1'

# Backend stuff
gem 'rubytree', '~> 0.9.4'
gem 'bcrypt', '~> 3.1.7'
gem 'net-ldap'
gem 'faker', '~> 1.4.3'
gem 'kaminari', '~> 0.16.1'
gem 'elasticsearch-model', '~> 0.1.6'
gem 'elasticsearch-rails', '~> 0.1.6'
gem 'acts_as_taggable_on', '~> 3.0.0.rc2'
gem 'ancestry'
gem 'audited-activerecord', '~> 4.0'
gem 'active_data', '~> 0.3.0'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'
gem 'apotomo', '~> 1.3.0'
gem 'dalli', '~> 2.7.2'
gem 'jbuilder', '~> 2.0'
gem 'acts_as_commentable'
gem 'render_anywhere', '~> 0.0.10', :require => false
gem 'cancan', '~> 1.6.10'

# Deployment stuff
gem 'capistrano', '~> 3.2.0'
gem 'capistrano-rails', '~> 1.1.2'
gem 'capistrano-rbenv', '~> 2.0.2'
gem 'capistrano-bundler', '~> 1.1.3'

# Frontend stuff
gem 'jquery-plugins-rails', '~> 0.2.1'
gem 'jstree-rails', '~> 0.0.4'
gem 'ancestry-treeview', '~> 0.0.2'
gem 'jquery-rails'
gem 'jquery-ui-rails', '~> 5.0.2'
gem 'turbolinks', '~> 2.5.2'
gem 'slim-rails'
gem 'simple_form', '~> 3.0.2'
gem 'themes_on_rails', '~> 0.2.2'
gem 'semantic-ui-sass', '~> 0.19.3.0'
gem 'google-webfonts-rails', '~> 0.0.4'
gem 'cocoon'
gem 'country_select', github: 'stefanpenner/country_select'
gem 'jquery-cookie-rails', '~> 1.3.1.1'
gem 'selectize-rails', '~> 0.11.0'
gem 'select2-rails', '~> 3.5.9.1'
gem 'simple_form_fancy_uploads', '~> 0.1.1'
gem 'show_for', '~> 0.3.0'
gem 'remotipart', '~> 1.2'
gem 'rmagick', '~> 2.13.4'
gem 'jquery-minicolors-rails', '~> 2.1.4.0'

# Server related stuff
gem 'puma', '~> 2.10.0'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'quiet_assets'
  gem 'spring'
  gem 'annotate', '~> 2.6.5'
  gem 'guard-livereload', require: false
end


# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# bundle exec rake doc:rails generates the API under doc/api.
# gem 'sdoc', '~> 0.4.0',          group: :doc


# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

# Load Gemfile.local, Gemfile.plugins and plugins' Gemfiles
Dir.glob File.expand_path("../{Gemfile.local,Gemfile.plugins,lib/plugins/*/Gemfile}", __FILE__) do |file|
  next unless File.readable?(file)
  instance_eval File.read(file)
end
