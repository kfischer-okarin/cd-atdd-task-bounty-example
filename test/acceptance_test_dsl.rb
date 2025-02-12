module AcceptanceTestDSL
  def given_a_user(name)
    @id_alias_map << name
    @driver.create_user(@id_alias_map[name])
  end

  def as(name, &block)
    @driver.login_as(@id_alias_map[name])

    instance_exec(&block)

    @driver.logout
  end

  def post_a_bounty(title, reward: 20)
    @id_alias_map << title
    @driver.post_bounty(title: @id_alias_map[title], reward: reward)
  end
end
