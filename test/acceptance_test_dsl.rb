module AcceptanceTestDSL
  ANY = Object.new.freeze

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

  def should_see_open_task(title, reward: ANY, posted_by: ANY)
    open_bounties = @driver.list_open_bounties

    required_values = { title: @id_alias_map[title] }
    required_values[:reward] = reward if reward != ANY
    required_values[:posted_by] = @id_alias_map[posted_by] if posted_by != ANY
    matching_bounty = open_bounties.find { |bounty| bounty.slice(*required_values.keys) == required_values }

    error_message = <<~ERROR
      Expected to find an open bounty with
        #{required_values.inspect}
      in
        [
          #{open_bounties.join("\n    ")}
        ]
    ERROR
    assert matching_bounty, error_message
  end
end
