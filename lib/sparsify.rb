# encoding: utf-8

module Sparsify
  # Your implementation goes here

  class Sparsifier
    def initialize(source, options={})
      @source = source
      @separator = options[:separator] || "."
    end

    def process
      result = {}
      @source.each{|k, v| sparsify(result, k, v)} and return result
    end

    private

    def escape(key)
      key = key.sub("\\", "\\\\\\\\")
      key = key.sub(@separator, "\\#{@separator}")
    end

    def sparsify(result, key, value)
      key = escape(key)

      case value
      when Hash
        tmp = {}
        value.each {|k, v| sparsify(tmp, k, v)}

        if tmp.empty?
          result[key] = {}
        else
          tmp.each{|k, v| result["#{key}#{@separator}#{k}"] = v}
        end
      else
        result[key] = value
      end
    end
  end

  class Unsparsifier
    def initialize(source, options={})
      @source = source
      @separator = options[:separator] || "."
    end

    def process
      result = {}
      @source.each{|k, v| unsparsify(result, k, v)} and return result
    end

    private

    def unsparsify(result, key, value)
      key = key.sub("\\\\", "\\")
      first, rest = key.split(@separator, 2)
      if first.end_with?("\\")
        first = first.sub("\\", "")
        cont, rest = rest.split(@separator, 2)
        first = "#{first}#{@separator}#{cont}"
      end

      if rest.nil?
        result[first] = value
      else
        tmp = {}
        unsparsify(tmp, rest, value)

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

  def self.sparse(source, options={})
    raise ArgumentError.new("ERROR: wrong number of arguments") if source.nil?

    sparsifier = Sparsifier.new(source, options)
    sparsifier.process()
  end

  def self.unsparse(source, options={})
    raise ArgumentError.new("ERROR: wrong number of arguments") if source.nil?

    unsparsifier = Unsparsifier.new(source, options)
    unsparsifier.process()
  end
end
