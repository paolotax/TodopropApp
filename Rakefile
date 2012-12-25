# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'bundler'

Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'youpropapp'
  app.provisioning_profile = '/Users/paolotax/Library/MobileDevice/Provisioning Profiles/700B219B-3E9F-4280-84B5-52CF2D33140D.mobileprovision' 
  app.codesign_certificate = 'iPhone Developer: Paolo Tassinari (9L6JUZD52Q)' 
  
  app.frameworks += ['QuartzCore', 'Security']

  app.pods do
    pod 'AFNetworking'
    pod "RDActionSheet"
    pod 'SSKeychain'
    pod "PDKeychainBindingsController"
  end
end