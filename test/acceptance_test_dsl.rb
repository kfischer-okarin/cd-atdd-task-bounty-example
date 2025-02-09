module AcceptanceTestDSL
  def it_works
    @driver.it_works
  end

  def given_a_user(name)
    @id_alias_map << name
    @driver.create_user(@id_alias_map[name])
  end
end
