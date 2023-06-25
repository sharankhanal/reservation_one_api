# frozen_string_literal: true

require 'find'
# service class for determining partner
class DeterminePartnerService < BaseService
  attr_reader :partner
  attr_reader :payload

  def initialize(**kwargs)
    super

    @payload = kwargs[:payload]
  end
  
  def call
   do_call
  end

  private

  def do_call
    # get all paths for partners  payload schema stored
    partner_schema_paths = partner_json_schemas_paths
    valid_schema_path = nil

    unless partner_schema_paths.present?
      add_error('No schemas found in the repository')
      return false
    end
   
    # validate incoming payload against the stored schemas
    partner_schema_paths.each do |path|
      schema = File.read(path)

      valid = JSON::Validator.validate(schema, payload.to_json)
      next unless valid

      valid_schema_path = path
      break
    end

    unless valid_schema_path.present?
      add_error('No valid schema found to parse the payload')
      return false
    end

    parsed_schema = JSON::Validator.parse(File.read(valid_schema_path))
  
    # use matched schema to find the partner
    @partner = determine_partner(parsed_schema['id'])

    unless partner.present?
      add_error('Partner not found or empty in the json schema id')
      return false
    end
  rescue JSON::ParserError => e
    add_error('Cannot parse json schema')
    return false
  end

  def partner_json_schemas_paths
    # FIXME: the hardcoded values need to avoided
    folder_to_check = 'app/schemas/reservations'
    paths = []

    Find.find(folder_to_check) do |path|
      # If the file is a JSON file, add its path to the array
      if File.extname(path) == '.json'
        paths << path
      end
    end

    paths
  end

  # extract partner id from id url of the schema
  # eg of id: https://example.com/schemas/partner_one
  # partner_id = 'parther_one'
  # here extract the last value after '/' to extract the partner_id
  # used for determining parser from the registry
  def determine_partner(schema_id)
    return unless schema_id

    schema_id.match(/\/([^\/]+)$/)&.captures&.first
  end
end
