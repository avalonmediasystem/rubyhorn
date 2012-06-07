#require 'active-model'
require 'loggable'
require 'active_support/core_ext/hash'
require 'YAML'
require 'URI'
require 'rubyhorn/version'

module Rubyhorn
  autoload :MatterhornClient, "rubyhorn/matterhorn_client"
  autoload :Workflow, "rubyhorn/workflow"

  class << self
    attr_accessor :config, :config_path, :config_options
  end

  @config ||= {}
  @config_options ||= {}

  # Initializes Rubyhorn based on the info in matterhorn.yml
  # 
  # If Rails.env is set, it will use that environment.  Defaults to "development".
  # @param [Hash] options (optional) a list of options for the configuration of rubyhorn
  # @option options [String] :environment The environment within which to run
  # @option options [String] :config_path The full path to the matterhorn.yml config file.
  # 
  # If :environment is not set, order of preference is 
  # 1. Rails.env
  # 2. ENV['environment']
  # 3. RAILS_ENV
  #
  # If :config_path is not set, it will look in 
  # 1. +Rails.root+/config
  # 2. +current working directory+/config
  # 3. (default) the matterhorn.yml shipped with gem

  # Options allowed in matterhorn.yml
  # first level is the environment (e.g. development, test, production and any custom environments you may have) 
  # the second level has these keys:
  # 1. url: url including protocol, user/pass, host, port, and path (e.g. http://matterhorn_system_account:CHANGE_ME@127.0.0.1:8080/)

  def self.init( options={} )
    # Make config_options into a Hash if nil is passed in as the value
    options = {} if options.nil?
    @config_options = options
    config_reload!
  end

  def self.config_reload!
    reset!
    load_configs
  end

  def self.reset!
    @config_loaded = false  #Force reload of configs
  end

  def self.config_loaded?
    @config_loaded || false
  end

  def self.load_configs
    return if config_loaded?
    @config_env = environment
    load_config
    @config_loaded = true
  end

  def self.load_config
    @config_path = get_config_path

    logger.info("Loading Rubyhorn.config from #{File.expand_path(config_path)}")
    @config = YAML.load(File.open(config_path)).symbolize_keys
    raise "The #{@config_env.to_sym} environment settings were not found in the matterhorn.yml config.  If you already have a matterhorn.yml file defined, make sure it defines settings for the #{@config_env} environment" unless config[@config_env.to_sym]
    
    @config
  end

  def self.config_for_environment
    envconfig = @config[@config_env.to_sym].symbolize_keys
    url = envconfig[:url]
    u = URI.parse url
    envconfig[:user] = u.user
    envconfig[:password] = u.password
    envconfig[:url] = "#{u.scheme}://#{u.host}:#{u.port}#{u.path}"
    envconfig
  end

  # Determine what environment we're running in. Order of preference is:
  # 1. config_options[:environment]
  # 2. Rails.env
  # 3. ENV['environment']
  # 4. ENV['RAILS_ENV']
  # 5. development
  # @return [String]
  # @example 
  #  Rubyhorn.init(:environment=>"test")
  #  Rubyhorn.environment => "test"
  def self.environment
    if config_options.fetch(:environment,nil)
      return config_options[:environment]
    elsif defined?(Rails.env) and !Rails.env.nil?
      return Rails.env.to_s
    elsif defined?(ENV['environment']) and !(ENV['environment'].nil?)
      return ENV['environment']
    elsif defined?(ENV['RAILS_ENV']) and !(ENV['RAILS_ENV'].nil?)
      logger.warn("You're depending on RAILS_ENV for setting your environment. This is deprecated in Rails3. Please use ENV['environment'] for non-rails environment setting: 'rake foo:bar environment=test'")
      ENV['environment'] = ENV['RAILS_ENV']
      return ENV['environment']
    else
      ENV['environment'] = 'development' #raise "Can't determine what environment to run in!"
    end
  end

  # Determine the matterhorn config file to use. Order of preference is:
  # 1. Use the config_options[:config_path] if it exists
  # 2. Look in +Rails.root+/config/matterhorn.yml
  # 3. Look in +current working directory+/config/matterhorn.yml
  # 4. Load the default config that ships with this gem
  # @return [String]
  def self.get_config_path
    if (config_path = config_options[:config_path] )
      raise RubyhornConfigurationException, "file does not exist #{config_path}" unless File.file? config_path
      return config_path
    end
    
    if defined?(Rails.root)
      config_path = "#{Rails.root}/config/matterhorn.yml"
      return config_path if File.file? config_path
    end
    
    if File.file? "#{Dir.getwd}/config/matterhorn.yml"  
      return "#{Dir.getwd}/config/matterhorn.yml"
    end
    
    # Last choice, check for the default config file
    config_path = File.expand_path(File.join(File.dirname(__FILE__), "..", "config", "matterhorn.yml"))
    logger.warn "Using the default matterhorn.yml that comes with rubyhorn.  If you want to override this, pass the path to matterhorn.yml to Rubyhorn - ie. Rubyhorn.init(:config_path => '/path/to/matterhorn.yml) - or set Rails.root and put matterhorn.yml into \#{Rails.root}/config."
    return config_path if File.file? config_path
    raise RubyhornConfigurationException "Couldn't load matterhorn config file!"
  end

  # Connect to Opencast Matterhorn
  # @return Rubyhorn::Repository
  def self.connect *args
    @client ||= MatterhornClient.new *args
  end

  # Connect to Opencast Matterhorn using default config
  # @return Rubyhorn::MatterhornClient
  def self.client
    @client ||= self.connect(config_for_environment)
  end

  # Set the default Opencast Matterhorn client
  # @param [Rubyhorn::MatterhornClient] client
  # @return Rubyhorn::MatterhornClient
  def self.client= client
    @client = client
  end

#  def self.default_config
#    {:url=>'http://localhost:8080/', :user=>'matterhorn_system_account', :password=>'CHANGE_ME'}
#  end
end

module Rubyhorn
  class RubyhornConfigurationException < Exception; end # :nodoc:
end

