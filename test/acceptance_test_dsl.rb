module AcceptanceTestDSL
  def it_works
    @driver.it_works
  end

  def given_a_user(name)
    @id_alias_map << name
    @driver.create_user(@id_alias_map[name])
  end

  def as(name, &block)
    @driver.login_as(@id_alias_map[name])

    instance_exec(&block)

    @driver.logout
  end
end
