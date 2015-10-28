class JsonbHashSerializer
  def self.dump(hash)
    return if hash.nil?
    hash.to_json
  end

  def self.load(hash)
    # (hash || {}).with_indifferent_access
    return if hash.nil?
    hash.with_indifferent_access
  end
end
