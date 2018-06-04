#! /usr/bin/env ruby

screen = [32] * (128 * 25)

str = "Hello World!"

str.chars.each_with_index do |c, idx|
    c = c.ord
    if c >= '@'.ord && c <= 'Z'.ord
        c = c - '@'.ord + 128
    elsif c >= 'a'.ord && c <= 'z'.ord
        c = c - 'a'.ord + 1
    elsif c == '!'.ord
        c = 33
    end

    screen[10*128 + 10 + idx] = c
end

screen.each do |b|
    puts "%02x" % b
end


