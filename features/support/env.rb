require 'aruba/cucumber'

ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..', '..')).freeze
TEMPLATES_DIR = File.join(ROOT, 'features', 'support', 'templates')

Before do
  @dirs = ["tmp", "aruba"]
  @aruba_timeout_seconds = 15
end
