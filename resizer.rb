#########################################
# Imlib2 Processor for Paperclip
# Written by Tomás Pollak <tomas@forkhq.com>
# (c) 2011 - Fork Ltd.
# Licensed under the MIT license
#########################################

require 'imlib2'

module Paperclip

	class Resizer < Processor

		attr_accessor :format, :whiny, :convert_options, :source_file_options

		def initialize(file, options = {}, attachment = nil)
			super

			@file                = file
			begin
				@img               = Imlib2::Image.load(file.path)
			rescue Imlib2::Error::UNKNOWN
				raise PaperclipError("Unknown error while loading image")
			end

			@crop                = options[:geometry][-1,1] == '#'
			@target_geometry     = options[:geometry].split('x')
			# @current_geometry    = [@img.w, @img.h]

			@source_file_options = options[:source_file_options]
			@convert_options     = options[:convert_options]
			@whiny               = options[:whiny].nil? ? true : options[:whiny]
			@format              = options[:format] || (@img ? @img.format.gsub('jpeg', 'jpg') : '')

			@basename            = File.basename(@file.path)
		end

		# Returns true if the +target_geometry+ is meant to crop.
		def crop?
			@crop
		end

		def get_new_geometry
			if crop?
				return @target_geometry[0], @target_geometry[1]
			else
 				new_h = ((@target_geometry[0].to_f / @img.w) * @img.h).round
 				return @target_geometry[0], new_h
			end
		end

		# Performs the conversion of the +file+ into a thumbnail. Returns the Tempfile
		# that contains the new image.
		def make
			dst = Tempfile.new("#{@basename}.#{@format}")
			dst.binmode

			return dst if @img.nil?
			new_w, new_h = get_new_geometry

			begin
				@img.crop_scaled!(0, 0, @img.w, @img.h, new_w.to_i, new_h.to_i)
				@img.save(dst.path)
			rescue Imlib2::FileError => e
				raise PaperclipError, "Error processing the thumbnail for #{@basename}"
				# raise("Unknown error while loading image")
			end

			dst
		end

	end
end
