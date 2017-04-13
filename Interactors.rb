require 'digest/sha1'

module Memoize
	attr :lookup

	def call(*args)
		if @lookup.nil?
			@lookup = {}
		end

		stringified_args = args.join(" ")

		puts "Looking up " + stringified_args

		val = @lookup[stringified_args]
		if val.nil?
			puts "Caching " + stringified_args
			calculated_val = super args
			@lookup[stringified_args] = calculated_val
			return calculated_val
		end
		return val
	end
end

module Interactors

	class ImportantThing

		def initialize(*args)
			puts "Creating important thing"
		end

		def call(*args)
			return Digest::SHA1.hexdigest args.join(" ")
		end
	end

end

i = Interactors::ImportantThing.new

i.extend(Memoize)

puts i.call("foo", "bar", "bat")
puts i.call("foo", "bar", "bat")
puts i.call("foo", "bar", "baz")
puts i.call("foo", "bar", 3)
puts i.call("foo", "bar", 3)
