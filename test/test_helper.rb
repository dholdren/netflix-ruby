$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift File.expand_path(File.join(File.dirname(__FILE__), 'support'))

require 'test/unit'
require 'yaml'
require 'fakeweb'
require 'netflix'
require 'fake_netflix'