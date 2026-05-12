# AGENTS.md

## Project Intent
- This is a learning experiment for a senior engineer exploring Ruby and Rails; explain Rails magic, Ruby syntax, and non-obvious decisions as you work.
- Keep the app Rails 8, Ruby-first, MVC-first. Prefer Rails conventions over adding service layers, frontend frameworks, or extra tooling.
- Frontend work should stay within Hotwire, Turbo, Stimulus, Tailwind, importmap, and Rails views/assets.
- Rails owns state and HTML. Before adding client state, JSON fetching, or JS-rendered UI, ask whether Rails can render the HTML and Turbo can replace the fragment.
- Build the boring Rails version first, then polish. Prefer normal models, validations plus DB constraints, RESTful routes, partials, and query params over custom client-side patterns.

## Stack Facts
- Ruby is `ruby-3.4.9` from `.ruby-version`; Rails is `8.1.3` from `Gemfile.lock`.
- Database is SQLite in `storage/*.sqlite3`; production also uses SQLite-backed Solid Cache, Solid Queue, and Solid Cable databases.
- JavaScript is importmap-based, not bundled by npm. `leaflet` is pinned in `config/importmap.rb` and used by `app/javascript/controllers/map_controller.js`.
- Tailwind is built by `tailwindcss-rails`; the active Tailwind entrypoint is `app/assets/tailwind/application.css`.
- There is currently no root `package.json` or `yarn.lock`, even though `bin/setup`, `config/ci.rb`, and `Dockerfile` still reference Yarn.

## Commands
- Setup/update without starting the server: `bin/setup --skip-server`.
- Dev server: `bin/dev` runs `bin/rails server` and `bin/rails tailwindcss:watch` via `Procfile.dev` on port `3000` by default.
- Full local CI script: `bin/ci`; note it includes Yarn steps that are currently unsupported without `package.json`/`yarn.lock`.
- Main CI checks from `.github/workflows/ci.yml`: `bin/brakeman --no-pager`, `bin/bundler-audit`, `bin/importmap audit`, `bin/rubocop -f github`, `RAILS_ENV=test bin/rails db:test:prepare test`, and `RAILS_ENV=test bin/rails db:test:prepare test:system`.
- Focused Rails test: `bin/rails test test/models/pin_test.rb` or `bin/rails test test/models/pin_test.rb:LINE`.
- Prepare test DB before broad test runs when needed: `RAILS_ENV=test bin/rails db:test:prepare`.

## App Shape
- Root route is `pins#index`; public map/listing flow is in `PinsController#index/show` and `app/views/pins/*`.
- The pin is the core product record; buildings and localities are supporting context for map/listing display.
- Stimulus should own Leaflet/browser behavior only. Do not put auth, bookmarks, comments, flags, validation, or business rules in Stimulus.
- Sidebar/detail panels should be server-rendered Rails views loaded through Turbo Frames, not HTML constructed in JavaScript.
- Authentication is a Rails concern in `app/controllers/concerns/authentication.rb`; controllers are authenticated by default and opt out with `allow_unauthenticated_access`.
- Integration tests can sign in with `sign_in_as(user)` from `test/test_helpers/session_test_helper.rb`.
- Seed data depends on JSON files in `db/data/`; `config/ci.rb` verifies seeds with `RAILS_ENV=test bin/rails db:seed:replant`.

## Workflow Notes
- Use RuboCop Omakase style from `.rubocop.yml`; avoid introducing custom style rules unless the repo needs them.
- Prefer Minitest and FactoryBot patterns already in `test/`; tests parallelize by processor count in `test/test_helper.rb`.
- When adding map marker data, prefer Rails-rendered HTML/data attributes first; add JSON/GeoJSON endpoints only when the server-rendered approach no longer fits.
- For Turbo Streams, prefer stable DOM IDs via Rails helpers such as `dom_id(record)` rather than hand-rolled IDs.
- Watch for N+1s in map/detail flows; use `includes` or counter caches when rendering collections that touch associations or counts.
- Production deploy config is Kamal-oriented in `config/deploy.yml`, but it still contains generated placeholder host/registry values.
