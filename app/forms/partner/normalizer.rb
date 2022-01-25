module Partner
  class Normalizer
    include ActiveModel::Model

    attr_reader :attributes

    def initialize(params)
      @attributes = ActionController::Parameters.new(params)
      perform_mapping!(attributes)
    end

    private

    def perform_mapping!(attr, prefix = '')
      attr.each do |key, val|
        method_name = "#{key}="
        method_name = "#{prefix}_#{method_name}" if prefix != ''
        public_send(method_name, val) if respond_to?(method_name)
        perform_mapping!(val, key) if val.is_a?(ActionController::Parameters)  # recursion through the params
      end
    end
  end

  class InvalidPartnerError < StandardError
    def message
      'partner data is invalid'
    end
  end
end