# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'bundler'

Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'youpropapp'
  app.provisioning_profile = '/Users/paolotax/Library/MobileDevice/Provisioning Profiles/7273E3EF-6FB1-4E7F-95FD-3A394D280C0B.mobileprovision' 
  app.codesign_certificate = 'iPhone Developer: Paolo Tassinari (9L6JUZD52Q)' 
  
  app.frameworks += ['QuartzCore']

  app.pods do
    pod 'AFNetworking'
    pod 'AFOAuth2Client'
    pod 'SSKeychain'
  end
end