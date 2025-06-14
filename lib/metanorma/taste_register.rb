# frozen_string_literal: true

require "yaml"
require "singleton"

module Metanorma
  class TasteRegister
    include Singleton

    def initialize
      @tastes = {}
      @taste_classes = {}
      scan_data_directory
    end

    def self.get(flavor)
      instance.get(flavor)
    end

    def get(flavor)
      flavor_sym = flavor.to_sym
      return @taste_classes[flavor_sym] if @taste_classes[flavor_sym]

      config = @tastes[flavor_sym]
      raise "Unknown taste: #{flavor}" unless config

      # Dynamically create and cache the taste class
      @taste_classes[flavor_sym] = create_taste_class(flavor_sym, config)
    end

    def available_tastes
      @tastes.keys
    end

    def taste_info(flavor)
      @tastes[flavor.to_sym]
    end

    def aliases
      # Build aliases dynamically from registered tastes
      aliases = {}
      @tastes.each do |flavor, info|
        aliases[flavor] = info[:base_flavor] if info[:base_flavor]
      end
      aliases
    end

    private

    def scan_data_directory
      data_dir = File.join(File.dirname(__FILE__), "..", "..", "data")
      return unless Dir.exist?(data_dir)

      Dir.entries(data_dir).each do |entry|
        next if entry.start_with?(".")

        taste_dir = File.join(data_dir, entry)
        next unless Dir.exist?(taste_dir)

        config_file = File.join(taste_dir, "config.yaml")
        next unless File.exist?(config_file)

        register_taste(entry, taste_dir, config_file)
      end
    end

    def register_taste(directory_name, taste_dir, config_file)
      config = YAML.load_file(config_file)
      flavor = config["flavor"]&.to_sym || directory_name.to_sym

      @tastes[flavor] = {
        flavor: flavor,
        owner: config["owner"],
        base_flavor: config["base-flavor"]&.to_sym,
        directory: taste_dir,
        config: config,
        copyright_notice: config["copyright-notice"],
        i18n_dictionary: config["i18n-dictionary"],
        base_override: config["base-override"] || {},
        doctypes: config["doctypes"] || {}
      }
    end

    def create_taste_class(flavor, config)
      # Create a dynamic class that inherits from Base
      taste_class = Class.new(Taste::Base) do
        define_method :initialize do
          super(flavor, config)
        end
      end

      # Define the class constant dynamically
      class_name = flavor.to_s.split(/[-_]/).map(&:capitalize).join
      unless Taste.const_defined?(class_name)
        Taste.const_set(class_name,
                        taste_class)
      end

      taste_class.new
    end
  end
end
