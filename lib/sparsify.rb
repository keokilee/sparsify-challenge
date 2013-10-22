# encoding: utf-8

module Sparsify
  # Your implementation goes here
  def self.sparse(source)
    raise ArgumentError.new("ERROR: wrong number of arguments") if source.nil?

    result = {}
    source.each do |k, v|
      sparsify(result, k, v)
    end

    result
  end

  def self.unsparse(source)
    raise ArgumentError.new("ERROR: wrong number of arguments") if source.nil?

    result = {}
    source.each do |k, v|
      unsparsify(result, k, v)
    end

    result
  end

  private

  def self.sparsify(result, key, value)
    case value
    when Hash
      tmp = {}
      value.each do |k, v|
        sparsify(tmp, k, v)
      end

      tmp.each do |k, v|
        result["#{key}.#{k}"] = v
      end
    else
      result[key] = value
    end
  end

  def self.unsparsify(result, key, value, level=0)
    first, rest = key.split(".", 2)

    if rest.nil?
      result[first] = value
    else
      tmp = {}
      unsparsify(tmp, rest, value, level += 1)

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
