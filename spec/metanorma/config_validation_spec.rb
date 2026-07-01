require_relative "../spec_helper"
require "yaml"

RSpec.describe "Config YAML Validation" do
  # Helper module for extracting lutaml-model metadata
  module LutamlIntrospection
    # Extract all attribute names and their YAML key mappings from a lutaml-model class
    # @param klass [Class] A Lutaml::Model::Serializable subclass
    # @return [Hash] Map of YAML keys to attribute names
    def self.extract_key_mappings(klass)
      return {} unless klass.respond_to?(:mappings)

      mappings = {}

      # Get the YAML adapter mappings
      yaml_mapping = klass.mappings[:yaml]
      return {} unless yaml_mapping

      # Extract mappings from the adapter
      if yaml_mapping.respond_to?(:mappings)
        yaml_mapping.mappings.each do |mapping|
          # mapping.name is the YAML key, mapping.to is the attribute name
          yaml_key = mapping.name.to_s
          attr_name = mapping.to.to_s
          mappings[yaml_key] = attr_name
        end
      end

      mappings
    end

    # Get all attribute names defined in a lutaml-model class
    # @param klass [Class] A Lutaml::Model::Serializable subclass
    # @return [Array<String>] Array of attribute names
    def self.extract_attribute_names(klass)
      return [] unless klass.respond_to?(:attributes)

      klass.attributes.keys.map(&:to_s)
    end

    # Get the type of an attribute (for handling nested objects)
    # @param klass [Class] A Lutaml::Model::Serializable subclass
    # @param attr_name [String] The attribute name
    # @return [Class, nil] The attribute type class
    def self.get_attribute_type(klass, attr_name)
      return nil unless klass.respond_to?(:attributes)

      attr_sym = attr_name.to_sym
      attr = klass.attributes[attr_sym]
      attr&.type
    end

    # Check if an attribute is a collection
    # @param klass [Class] A Lutaml::Model::Serializable subclass
    # @param attr_name [String] The attribute name
    # @return [Boolean] True if the attribute is a collection
    def self.collection?(klass, attr_name)
      return false unless klass.respond_to?(:attributes)

      attr_sym = attr_name.to_sym
      attr = klass.attributes[attr_sym]
      attr&.collection? || false
    end
  end

  # Validator class for checking YAML structure against lutaml-model classes
  class ConfigValidator
    attr_reader :errors

    def initialize
      @errors = []
    end

    # Validate a config.yaml structure
    # @param yaml_hash [Hash] The parsed YAML
    # @param flavor_name [String] The flavor name for error messages
    def validate_config(yaml_hash, flavor_name)
      @errors = []
      @flavor_name = flavor_name

      validate_level(
        yaml_hash,
        Metanorma::Taste::TasteConfig,
        "root",
      )

      @errors
    end

    private

    # Validate a level in the YAML structure
    # @param yaml_data [Hash, Array] The YAML data at this level
    # @param model_class [Class] The lutaml-model class for this level
    # @param path [String] The current path in the YAML (for error messages)
    def validate_level(yaml_data, model_class, path)
      return unless yaml_data.is_a?(Hash)

      # Get allowed YAML keys for this model class
      key_mappings = LutamlIntrospection.extract_key_mappings(model_class)
      allowed_keys = key_mappings.keys

      # Check each key in the YAML
      yaml_data.each do |yaml_key, value|
        unless allowed_keys.include?(yaml_key)
          @errors << "Unknown key '#{yaml_key}' at #{path} in #{@flavor_name}"
          next
        end

        # Get the attribute name and type
        attr_name = key_mappings[yaml_key]
        attr_type = LutamlIntrospection.get_attribute_type(model_class,
                                                           attr_name)
        is_collection = LutamlIntrospection.collection?(model_class,
                                                        attr_name)

        # Special case handling before recursive validation
        if yaml_key == "override-attributes" && value.is_a?(Array)
          # Special case: override-attributes can contain arbitrary presentation-metadata-* keys
          # We validate these are hashes but don't validate their keys
          value.each_with_index do |item, index|
            unless item.is_a?(Hash)
              @errors << "Invalid override-attributes item at #{path}.#{yaml_key}[#{index}] - must be a hash"
            end
          end
        elsif yaml_key == "committees" && value.is_a?(Array)
          # Committees is now a simple array of CommitteeItem objects
          value.each_with_index do |item, index|
            validate_level(item, Metanorma::Taste::CommitteeItem,
                           "#{path}.#{yaml_key}[#{index}]")
          end
        elsif yaml_key == "stages" && value.is_a?(Array)
          # Stages is now a simple array of StageConfig objects (similar to doctypes)
          value.each_with_index do |item, index|
            validate_level(item, Metanorma::Taste::StageConfig,
                           "#{path}.#{yaml_key}[#{index}]")
          end
        elsif attr_type && attr_type.respond_to?(:attributes)
          # Recursively validate nested structures
          if is_collection && value.is_a?(Array)
            # Validate each item in the collection
            value.each_with_index do |item, index|
              validate_level(item, attr_type, "#{path}.#{yaml_key}[#{index}]")
            end
          elsif value.is_a?(Hash)
            # Validate nested object
            validate_level(value, attr_type, "#{path}.#{yaml_key}")
          end
        end
      end
    end
  end

  # Get all config.yaml files
  let(:data_dir) { File.join(__dir__, "..", "..", "data") }
  let(:config_files) do
    Dir.glob(File.join(data_dir, "*", "config.yaml")).sort
  end

  describe "validates all config.yaml files have known attributes" do
    let(:validator) { ConfigValidator.new }

    config_files_list = Dir.glob(File.join(File.dirname(__FILE__), "..", "..",
                                           "data", "*", "config.yaml")).sort

    config_files_list.each do |config_file|
      flavor_name = File.basename(File.dirname(config_file))

      it "validates #{flavor_name}/config.yaml" do
        yaml_content = File.read(config_file)
        yaml_hash = YAML.safe_load(yaml_content, permitted_classes: [Symbol])

        errors = validator.validate_config(yaml_hash, flavor_name)

        if errors.any?
          error_message = "Found unknown keys in #{flavor_name}/config.yaml:\n" +
            errors.map { |e| "  - #{e}" }.join("\n")
          fail error_message
        end
      end
    end
  end

  describe "lutaml-model introspection helpers" do
    it "extracts key mappings from TasteConfig" do
      mappings = LutamlIntrospection.extract_key_mappings(Metanorma::Taste::TasteConfig)

      expect(mappings).to include(
        "flavor" => "flavor",
        "owner" => "owner",
        "base-flavor" => "base_flavor",
        "base-override" => "base_override",
        "doctypes" => "doctypes",
      )
    end

    it "extracts key mappings from ValueAttributes" do
      mappings = LutamlIntrospection.extract_key_mappings(Metanorma::Taste::ValueAttributes)

      expect(mappings).to include(
        "publisher" => "publisher",
        "publisher_abbr" => "publisher_abbr",
        "body-font" => "body_font",
        "presentation-metadata-color-secondary" => "presentation_metadata_color_secondary",
      )
    end

    it "extracts key mappings from FilenameAttributes" do
      mappings = LutamlIntrospection.extract_key_mappings(Metanorma::Taste::FilenameAttributes)

      expect(mappings).to include(
        "copyright-notice" => "copyright_notice",
        "i18n-dictionary" => "i18n_dictionary",
        "publisher-logo" => "publisher_logo",
      )
    end

    it "extracts key mappings from DoctypeConfig" do
      mappings = LutamlIntrospection.extract_key_mappings(Metanorma::Taste::DoctypeConfig)

      expect(mappings).to include(
        "taste" => "taste",
        "base" => "base",
        "override-attributes" => "override_attributes",
      )
    end

    it "extracts key mappings from StageConfig" do
      mappings = LutamlIntrospection.extract_key_mappings(Metanorma::Taste::StageConfig)

      expect(mappings).to include(
        "default" => "default",
        "published" => "published",
        "abbrev" => "abbrev",
      )
    end

    it "detects collection attributes" do
      expect(LutamlIntrospection.collection?(Metanorma::Taste::TasteConfig,
                                             "doctypes")).to be true
      expect(LutamlIntrospection.collection?(Metanorma::Taste::TasteConfig,
                                             "flavor")).to be false
    end

    it "gets attribute type for nested objects" do
      type = LutamlIntrospection.get_attribute_type(
        Metanorma::Taste::TasteConfig, "base_override"
      )
      expect(type).to eq(Metanorma::Taste::BaseOverride)
    end
  end

  describe "ConfigValidator" do
    let(:validator) { ConfigValidator.new }

    it "detects unknown keys at root level" do
      invalid_yaml = {
        "flavor" => "test",
        "unknown-key" => "value",
      }

      errors = validator.validate_config(invalid_yaml, "test")
      expect(errors).to include("Unknown key 'unknown-key' at root in test")
    end

    it "detects unknown keys in nested structures" do
      invalid_yaml = {
        "flavor" => "test",
        "base-override" => {
          "value-attributes" => {
            "publisher" => "Test",
            "unknown-attr" => "value",
          },
        },
      }

      errors = validator.validate_config(invalid_yaml, "test")
      expect(errors).to include(match(/Unknown key 'unknown-attr'.*value-attributes/))
    end

    it "allows valid configuration" do
      valid_yaml = {
        "flavor" => "test",
        "owner" => "Test Org",
        "base-flavor" => "iso",
        "base-override" => {
          "value-attributes" => {
            "publisher" => "Test Org",
            "output-extensions" => "xml,html",
          },
          "filename-attributes" => {
            "copyright-notice" => "copyright.adoc",
          },
        },
        "doctypes" => [
          {
            "taste" => "standard",
            "base" => "international-standard",
            "abbrev" => "S",
          },
        ],
      }

      errors = validator.validate_config(valid_yaml, "test")
      expect(errors).to be_empty
    end

    it "allows override-attributes with arbitrary keys in doctypes" do
      valid_yaml = {
        "flavor" => "test",
        "doctypes" => [
          {
            "taste" => "standard",
            "base" => "international-standard",
            "override-attributes" => [
              { "presentation-metadata-color-secondary" => "#376795" },
              { "any-custom-key" => "value" },
            ],
          },
        ],
      }

      errors = validator.validate_config(valid_yaml, "test")
      expect(errors).to be_empty
    end

    it "validates stages as an array of stage configurations" do
      valid_yaml = {
        "flavor" => "test",
        "stages" => [
          {
            "taste" => "draft",
            "base" => "draft",
            "abbrev" => "D",
          },
          {
            "taste" => "published",
            "base" => "published",
            "default" => "true",
            "published" => "true",
          },
        ],
      }

      errors = validator.validate_config(valid_yaml, "test")
      expect(errors).to be_empty
    end

    it "detects unknown keys in stage configurations" do
      invalid_yaml = {
        "flavor" => "test",
        "stages" => [
          {
            "taste" => "draft",
            "base" => "draft",
            "unknown-stage-key" => "value",
          },
        ],
      }

      errors = validator.validate_config(invalid_yaml, "test")
      expect(errors).to include(match(/Unknown key 'unknown-stage-key'.*stages\[0\]/))
    end
  end
end
