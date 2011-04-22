require 'test_helper'
require 'pruim'

test_w, test_h = 64, 32

assert { Pruim }
assert { Pruim::BMP } 
outname = test_file('data', 'bitmap1.bmp')
codec   = Pruim::Codec.new_codec_for('bmp')
assert { codec } 
assert { codec }

fin     = File.open(outname, 'r+')
assert { codec.can_decode?(fin) }
image = nil
assert { image = codec.decode(fin) }
fin.close


 
# 
# assert { codec } 
# assert { codec.encode(image, fout) }
# fout.close
# # system("eog #{outname} &")
# fin = File.open(outname, 'r+')
# image2 = nil
# assert { image2 = codec.decode(fin) }
# fin.close
# page2  = image2.active
# assert { page2 }
# assert { image2.w == test_w }
# assert { image2.h == test_h }
# assert { page2.w  == test_w }
# assert { page2.h  == test_h }
# 
# assert { page2.getpixel!(1, 1)   == green }
# assert { page2.getpixel!(10, 10) == blue  }
# assert { page2.getpixel!(0, 0)   == red   }
# 
# assert { image2.getpixel(1, 1)   == green }
# assert { image2.getpixel(10, 10) == blue  }
# assert { image2.getpixel(0, 0)   == red   }
# 



