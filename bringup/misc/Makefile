
all: c64_font.hex screen_buffer.hex

screen_buffer.hex: hello_world.rb
	./hello_world.rb > $@

c64_font.hex: c64_font.bin
	../../misc/create_mif.rb -f hex -w 8 $< > $@

c64_font.bin: c64_font_lc.rgb c64_font_uc.rgb
	cat $^ > $@

c64_font_lc.rgb: c64_font_lc_x1.png
	convert $< -depth 8 -threshold 25% -depth 1 GRAY:$@

c64_font_uc.rgb: c64_font_uc_x1.png
	convert $< -depth 8 -threshold 25% -depth 1 GRAY:$@

clean:
	\rm -f *.rgb *.bin *.hex
