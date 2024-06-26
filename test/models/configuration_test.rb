require 'test_helper'

class ConfigurationTest < ActiveSupport::TestCase
  test "burn_ratio should be numerical and greater than or equal to 0" do
    configuration = Configuration.new(burn_ratio: 1.5, earn_ratio: 0.1)
    assert configuration.valid?

    configuration.burn_ratio = -1
    assert_not configuration.valid?
    assert_includes configuration.errors[:burn_ratio], "must be greater than or equal to 0"
  end

  test "earn_ratio should be numerical and greater than or equal to 0" do
    configuration = Configuration.new(burn_ratio: 1.5, earn_ratio: 2.0)
    assert configuration.valid?

    configuration.earn_ratio = -1
    assert_not configuration.valid?
  end

  test "current should return existing configuration or new configuration" do
    existing_configuration = configurations(:one)
    assert_equal existing_configuration.id, Configuration.current.id

    Configuration.destroy_all
    new_configuration = Configuration.current
    assert new_configuration.new_record?
    assert_equal 0, Configuration.count
  end
end
