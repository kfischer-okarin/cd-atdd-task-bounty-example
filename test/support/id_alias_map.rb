class IdAliasMap
  def initialize
    @id_to_alias = {}
    @prng = Random.new
  end

  def <<(id)
    raise "ID already exists" if @id_to_alias.key?(id)

    @id_to_alias[id] = "#{id}_#{@prng.hex(4)}"
  end

  def [](id)
    @id_to_alias.fetch(id)
  end
end
