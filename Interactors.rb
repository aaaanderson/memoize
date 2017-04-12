require 'digest/sha1'

module Memoize
	attr :lookup

	def initialize
		puts "Initializing lookup table"
		lookup = {}
		
	end

	def call(*args)
		stringified_args = args.join(" ")

		val = lookup[stringified_args]
		if val.nil?
			puts "Caching " + stringified_args
			calculated_val = super args
			lookup[stringified_args] = calculated_val
			return calculated_val
		end
		return val
	end
end

module Interactors

	class ImportantThing
		include Memoize

		def initialize(*args)
			puts "Creating important thing"
		end

		def call(*args)
			return Digest::SHA1.hexdigest args.join(" ")
		end
	end

end

i = Interactors::ImportantThing.new

puts i.call(["foo", "bar", "bat"])
