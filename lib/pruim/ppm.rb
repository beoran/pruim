module Pruim
  class PPM < Codec
    Codec.register('ppm', self) 
    
    def decode(stream)
      header = stream.gets
      lines  = []
      until stream.eof?
        lines << stream.gets
      end
      image   = nil
      page    = nil
      w, h, d = nil, nil
      y       = 0
      comment = ''
      lines.each do |line| 
        if line[0] == '#'
          comment << line
          next
        end
        if !image
          w , h = line.chomp.split(' ').map { |v| v.to_i }
          image = Image.new(w, h)
          page  = image.new_page(w, h)
          next
        end
        if !d
          d = line.chomp.to_i
          next
        end
        triplets = line.chomp.split(' ').map { |v| v.to_i }
        for x in (0...page.w) do
          r, g, b = triplets.shift(3)
          color   = Color.rgb(r, g, b)
          page.putpixel(x, y, color)
        end
        y += 1 
      end  
      return image
    end
    
    
    def encode(image, stream)
      stream.puts("P3")
      stream.puts("#No comments yet")
      stream.puts("#{image.w} #{image.h}")
      stream.puts("255")
      page = image.pages.first
      for y in (0...page.h) do
        for x in (0...page.w) do
          color = page.getpixel!(x, y)
          r, g, b = Color.to_rgb(color)
          stream.write(" ") if x > 0
          stream.write("#{r} #{g} #{b}")
        end
        stream.write("\n")
      end
    end
    
    def can_decode?(stream)
      header = stream.gets
      stream.rewind
      return header == "P3\n"
    end
    
    def can_encode?(image)
      return true
    end
    
    def encode_will_degrade?(image)
      return (image.pages.size > 1)
    end
  end
end