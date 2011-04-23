require 'test_helper'
require 'pruim'

test_w, test_h = 64, 32
bitmap1_w, bitmap1_h = 64, 64

assert { Pruim }
assert { Pruim::BMP } 
inname  = test_file('data', 'bitmap1.bmp')
inname2 = test_file('data', 'bitmap_alpha.bmp')
outname = test_file('data', 'out1.bmp')
outname2= test_file('data', 'out2.bmp')

codec   = Pruim::Codec.for_name('bmp')
assert { codec } 

image = Pruim::Image.load_from(inname, :bmp)

# 
# fin    = File.open(inname, 'r+')
# assert { codec.can_decode?(fin) }
# image  = nil
# assert { image = codec.decode(fin) }
# fin.close
assert { image.w == bitmap1_w }
assert { image.h == bitmap1_h }

image.save_as(outname, :bmp)

# 
# fout   = File.open(outname, 'w+')
# assert { codec.encode(image, fout) }
# fout.close

# system("display #{outname} &")


image2 = Pruim::Image.new(test_w, test_h, :mode => :palette, :pages => 1)
assert { image2 } 
assert { image2.w == test_w }
assert { image2.h == test_h }
gray  = image2.palette.new_rgb(127, 128, 129)
red   = image2.palette.new_rgb(255,   0,   0)
green = image2.palette.new_rgb(0  , 255, 255)
blue  = image2.palette.new_rgb(0  ,   0, 255)
image2.fill(gray)
image2.putpixel(4, 5, red)
image2.putpixel(5, 6, green)
image2.putpixel(6, 7, blue)
assert { image2.getpixel(4, 5) == red   }
assert { image2.getpixel(5, 6) == green }
assert { image2.getpixel(6, 7) == blue  }

image2.save_as(outname2, :bmp)
# 
# fout2   = File.open(outname2, 'w+')
# assert { codec.encode(image2, fout2) }
# fout2.close
assert { system("display #{outname2} &") }


 
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



