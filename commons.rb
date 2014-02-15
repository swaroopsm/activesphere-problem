module ActiveSphere
  module Commons

		# Create hash of the key
		def generate_hash(key)
			Digest::MD5.hexdigest(key)
		end

  end
end
