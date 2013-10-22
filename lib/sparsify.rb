# encoding: utf-8

module Sparsify
  # Your implementation goes here
  def self.sparse(source, options={})
    raise ArgumentError.new("ERROR: wrong number of arguments") if source.nil?
    separator = options[:separator] || "."

    result = {}
    source.each do |k, v|
      sparsify(result, k, v, separator)
    end

    result
  end

  def self.unsparse(source, options={})
    raise ArgumentError.new("ERROR: wrong number of arguments") if source.nil?

    separator = options[:separator] || "."
    result = {}
    source.each do |k, v|
      unsparsify(result, k, v, separator)
    end

    result
  end

  private

  def self.sparsify(result, key, value, separator)
    case value
    when Hash
      tmp = {}
      value.each do |k, v|
        sparsify(tmp, k, v, separator)
      end

      if tmp.keys.size > 0
        tmp.each do |k, v|
          result["#{key}#{separator}#{k}"] = v
        end
      else
        result[key] = {}
      end
    else
      result[key] = value
    end
  end

  def self.unsparsify(result, key, value, separator)
    first, rest = key.split(separator, 2)

    if rest.nil?
      result[first] = value
    else
      tmp = {}
      unsparsify(tmp, rest, value, separator)

      if result.has_key?(first)
        tmp.each do |k, v|
          if result[first].has_key?(k)
            result[first][k] = result[first][k].merge(v)
          else
            result[first][k] = v
          end
        end
      else
        result[first] = tmp
      end
    end
  end
end
