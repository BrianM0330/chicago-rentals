class TightenPinRentConstraint < ActiveRecord::Migration[8.1]
  def change
    remove_check_constraint :pins, name: "pins_rent_required_for_rent"

    add_check_constraint :pins,
      "kind = 'discussion' OR (rent_cents IS NOT NULL AND rent_cents > 0)",
      name: "pins_rent_required_for_rent"
  end
end
