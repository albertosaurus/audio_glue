source "http://rubygems.org"

gem 'ruby-sox', :path => '/home/blake/dev/work/tmx/ruby-sox'

group :development do
  gem "bundler", "~> 1.0"
  gem "jeweler", "~> 1.8.7"
  gem 'yard'
end

group :development, :test do
  gem 'pry'
end

group :test do
  gem "rspec", "~> 2.14.1"
  gem 'simplecov', :require => false
  gem 'chromaprint', :git => 'git@github.com:TMXCredit/chromaprint.git', :branch => '12274_chromaprint'
end

