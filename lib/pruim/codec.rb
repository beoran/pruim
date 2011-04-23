module Pruim
  module Codec
    
    def self.register(name, klass)
      @codecs     ||= {} 
      @codecs[name] = klass
    end
    
    def self.codec_for(name)
      return Pruim.const_get(name.upcase) 
    end
    
    def self.new_codec_for(name)
      codec = codec_for(name)
      return nil unless codec
      return codec.new(name)
    end
  
    # Stream should be an StringIO, or otherwise IO compatible object.
    def decode(stream)
      raise "not implemented"
    end
    
    def encode(image, stream)
      raise "not implemented"
    end
    
    def can_decode?(stream)
      raise "not implemented"
    end
    
    def can_encode?(image)
      raise "not implemented"
    end
    
    def encode_will_degrade?(image)
      raise "not implemented"
    end
    
    def text
      return "A codec that does nothing."
    end
  end
end