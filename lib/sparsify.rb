# encoding: utf-8

module Sparsify
  # Your implementation goes here
  def self.sparse(source)
    raise ArgumentError.new("ERROR: wrong number of arguments") if source.nil?

    result = {}
    source.each do |k, v|
      process(result, k, v)
    end

    result
  end

  def self.process(result, key, value)
    case value
    when Hash
      tmp = {}
      value.each do |k, v|
        process(tmp, k, v)
      end

      tmp.each do |k, v|
        result["#{key}.#{k}"] = v
      end
    else
      result[key] = value
    end
  end
end
