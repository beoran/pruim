require 'test_helper'
require 'pruim'

test_w, test_h = 64, 32

assert { Pruim }
assert { Pruim::Image } 
image = Pruim::Image.new(test_w, test_h, :pages => 1)
red   = Pruim::Color.rgb(255,  0,  0)
green = Pruim::Color.rgb(0  ,255, 255)
blue  = Pruim::Color.rgb(0  ,  0, 255)
page  = image.active
page.fill(red)
page.putpixel(1, 1, green)
page.putpixel(10, 10, blue)

outname = test_file("out.ppm")
assert { image.save_as(outname, "ppm") }

image2 = Pruim::Image.load_from(outname, "ppm")
# 
# fin = File.open(outname, 'r+')
# image2 = nil
# assert { image2 = codec.decode(fin) }
# fin.close
page2  = image2.active
assert { page2 }
assert { image2.w == test_w }
assert { image2.h == test_h }
assert { page2.w  == test_w }
assert { page2.h  == test_h }

assert { page2.getpixel!(1, 1)   == green }
assert { page2.getpixel!(10, 10) == blue  }
assert { page2.getpixel!(0, 0)   == red   }

assert { image2.getpixel(1, 1)   == green }
assert { image2.getpixel(10, 10) == blue  }
assert { image2.getpixel(0, 0)   == red   }




