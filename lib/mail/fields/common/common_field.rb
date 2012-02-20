# encoding: utf-8
module Mail
  module CommonField # :nodoc:

    RFC5322_LINE_LIMITS = 78

    def name=(value)
      @name = value
    end

    def name
      @name ||= nil
    end

    def value=(value)
      @length = nil
      @tree = nil
      @element = nil
      @value = value
    end

    def value
      @value
    end

    def to_s
      decoded
    end

    def default
      decoded
    end

    def field_length
      @length ||= "#{name}: #{encode(decoded)}".length
    end

    def responsible_for?( val )
      name.to_s.downcase == val.to_s.downcase
    end

    def encoding(val = nil)
      if val
        self.encoding = val
      elsif !defined?(@encoding) || @encoding.nil?
        self.encoding = "text"
      else
        @encoding
      end
    end

    def encoding=(val)
      @encoding = if val == "text" || val.blank?
        (only_ascii_printable? ? '7bit' : '8bit')
      else
        val
      end
    end

    def only_ascii_printable?
      !(self.value =~ /[^\x20-\x7e]/)
    end

    private

    def strip_field(field_name, value)
      if value.is_a?(Array)
        value
      else
        value.to_s.gsub(/#{field_name}:\s+/i, '')
      end
    end

  end
end
