require "test_helper"

class PinTest < ActiveSupport::TestCase
  test "rent pin is valid with required fields" do
    pin = build(:pin)

    assert pin.valid?
  end

  test "discussion pin is valid without rent" do
    pin = build(:pin, kind: "discussion", rent_cents: nil)

    assert pin.valid?
  end

  test "kind must be supported" do
    pin = build(:pin, kind: "sale")

    assert_not pin.valid?
    assert pin.errors[:kind].any?
  end

  test "slug is generated before validation" do
    pin = build(:pin, slug: nil)

    assert pin.valid?
    assert_predicate pin.slug, :present?
  end

  test "slug must be unique" do
    existing_pin = create(:pin)
    pin = build(:pin, slug: existing_pin.slug)

    assert_not pin.valid?
    assert pin.errors[:slug].any?
  end

  test "hood is copied from locality before validation" do
    locality = build(:locality, name: "Logan Square")
    pin = build(:pin, locality: locality, hood: nil)

    assert pin.valid?
    assert_equal "Logan Square", pin.hood
  end

  test "latitude and longitude are required" do
    pin = build(:pin, latitude: nil, longitude: nil)

    assert_not pin.valid?
    assert_includes pin.errors[:latitude], "can't be blank"
    assert_includes pin.errors[:longitude], "can't be blank"
  end

  test "latitude must be between negative 90 and positive 90" do
    too_low = build(:pin, latitude: -91)
    too_high = build(:pin, latitude: 91)

    assert_not too_low.valid?
    assert_not too_high.valid?
    assert too_low.errors[:latitude].any?
    assert too_high.errors[:latitude].any?
  end

  test "longitude must be between negative 180 and positive 180" do
    too_low = build(:pin, longitude: -181)
    too_high = build(:pin, longitude: 181)

    assert_not too_low.valid?
    assert_not too_high.valid?
    assert too_low.errors[:longitude].any?
    assert too_high.errors[:longitude].any?
  end

  test "boundary coordinates are valid" do
    northwest_corner = build(:pin, latitude: 90, longitude: -180)
    southeast_corner = build(:pin, latitude: -90, longitude: 180)

    assert northwest_corner.valid?
    assert southeast_corner.valid?
  end

  test "rent pin requires rent" do
    pin = build(:pin, kind: "rent", rent_cents: nil)

    assert_not pin.valid?
    assert_includes pin.errors[:rent_cents], "can't be blank"
  end

  test "rent must be positive" do
    zero_rent = build(:pin, rent_cents: 0)
    negative_rent = build(:pin, rent_cents: -1)

    assert_not zero_rent.valid?
    assert_not negative_rent.valid?
    assert zero_rent.errors[:rent_cents].any?
    assert negative_rent.errors[:rent_cents].any?
  end

  test "bedrooms can be blank" do
    pin = build(:pin, bedrooms: nil)

    assert pin.valid?
  end

  test "bedrooms cannot be negative" do
    pin = build(:pin, bedrooms: -1)

    assert_not pin.valid?
    assert pin.errors[:bedrooms].any?
  end

  test "building is optional" do
    pin = build(:pin, building: nil)

    assert pin.valid?
  end

  test "user is required" do
    pin = build(:pin, user: nil)

    assert_not pin.valid?
    assert pin.errors[:user].any?
  end

  test "locality is required" do
    pin = build(:pin, locality: nil)

    assert_not pin.valid?
    assert pin.errors[:locality].any?
  end

  test "database inserts a valid pin" do
    assert_difference("Pin.count", 1) do
      create(:pin, latitude: 40.7128, longitude: -74.0060)
    end
  end

  test "database rejects invalid kind when validations are bypassed" do
    pin = raw_pin_attributes(kind: "sale")

    assert_raises(ActiveRecord::StatementInvalid) do
      Pin.insert!(pin)
    end
  end

  test "database rejects invalid coordinates when validations are bypassed" do
    pin = raw_pin_attributes(latitude: 100, longitude: -200)

    assert_raises(ActiveRecord::StatementInvalid) do
      Pin.insert!(pin)
    end
  end

  test "database rejects rent pin without rent when validations are bypassed" do
    pin = raw_pin_attributes(kind: "rent", rent_cents: nil)

    assert_raises(ActiveRecord::StatementInvalid) do
      Pin.insert!(pin)
    end
  end

  test "database allows discussion pin without rent when validations are bypassed" do
    pin = raw_pin_attributes(kind: "discussion", rent_cents: nil)

    assert_difference("Pin.count", 1) do
      Pin.insert!(pin)
    end
  end

  test "destroying a pin destroys dependent comments bookmarks and flags" do
    pin = create(:pin)
    comment = Comment.create!(pin: pin, user: create(:user), body: "Helpful note")
    bookmark = Bookmark.create!(pin: pin, user: create(:user))
    flag = PinFlag.create!(pin: pin, user: create(:user), reason: "spam")

    pin.destroy!

    assert_not Comment.exists?(comment.id)
    assert_not Bookmark.exists?(bookmark.id)
    assert_not PinFlag.exists?(flag.id)
  end

  test "destroying a pin does not destroy its optional building" do
    building = Building.create!(
      locality: create(:locality),
      street_number: "1234",
      street: "W Test Ave",
      city: "Chicago",
      state: "IL",
      postal_code: "60647",
      latitude: 41.9,
      longitude: -87.7
    )
    pin = create(:pin, building: building)

    pin.destroy!

    assert Building.exists?(building.id)
  end

  private

  def raw_pin_attributes(overrides = {})
    pin = build(:pin, overrides)
    now = Time.current
    user = pin.user.tap { |record| record.save! unless record.persisted? }
    locality = pin.locality.tap { |record| record.save! unless record.persisted? }

    pin.attributes.except("id").merge(
      "user_id" => user.id,
      "locality_id" => locality.id,
      "slug" => pin.slug.presence || SecureRandom.urlsafe_base64(6),
      "hood" => pin.hood.presence || locality.name,
      "created_at" => now,
      "updated_at" => now
    )
  end
end
