require "test_helper"

class PinsCrudLearningTest < ActionDispatch::IntegrationTest
  test "landing page renders map element" do
    get pins_path
    assert_response :success

    assert_select "#map"
    assert_select "[data-controller='map']"
  end


  # TODO: You write this public show test after `PinsController#show` is implemented.
  # Goal: create a pin, request its page, and assert response HTML includes useful pin content.
  # Hints:
  # - `pin = create(:pin, rent_cents: 210_000)`
  # - `get pin_path(pin)`
  # - `assert_response :success`
  # - `assert_select "turbo-frame#side_panel"` once the view uses a Turbo Frame.

  # TODO: You write this DB/request test after `PinsController#create` is implemented.
  # Goal: signed-in users can create a pin through `POST /pins`.
  # Hints:
  # - Use `user = create(:user)` and the existing session helper if available.
  # - `assert_difference("Pin.count", 1) do ... end`
  # - `post pins_path, params: { pin: { ... } }`
  # - Assert the created pin belongs to the signed-in user, not a submitted user_id.

  # TODO: You write this auth test after `PinsController#create` is implemented.
  # Goal: anonymous users cannot create pins.
  # Hints:
  # - Do not sign in.
  # - `assert_no_difference("Pin.count") do ... end`
  # - `post pins_path, params: { pin: attributes_for(:pin) }`
  # - Assert redirect to the login/session path.
end
