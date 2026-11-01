# SecureDev Rails

A small Ruby on Rails 8.1 application that shows common OWASP Top 10 vulnerabilities **side by side with their fixes**.
Every vulnerability has an intentionally vulnerable endpoint, a secure endpoint, and an automated test that proves
the attack works on the first one and fails on the second.

![CI](https://github.com/ammar-ferchichi/secure-dev-rails/actions/workflows/ci.yml/badge.svg)

## What is covered

| OWASP 2021 | Attack | Vulnerable code | Fix | Proof |
|---|---|---|---|---|
| A03 Injection | **SQL injection** in document search: `q = %') OR 1=1 --` returns every user's documents | String interpolation in `where("... LIKE '%#{params[:q]}%'")` — [vulnerable/documents_controller.rb](app/controllers/vulnerable/documents_controller.rb) | Bound parameter, `sanitize_sql_like`, query scoped to `Current.user` — [secure/documents_controller.rb](app/controllers/secure/documents_controller.rb) | [sql_injection_test.rb](test/integration/sql_injection_test.rb) |
| A01 Broken Access Control | **IDOR**: Alice opens Bob's document by changing the id in the URL | `Document.find(params[:id])` | `Current.user.documents.find(params[:id])` → 404 | [idor_test.rb](test/integration/idor_test.rb) |
| A01 Broken Access Control | **Privilege escalation by mass assignment**: a user sends `role=admin` | `params.require(:user).permit!` — [vulnerable/profiles_controller.rb](app/controllers/vulnerable/profiles_controller.rb) | Strong parameters allow only `display_name` — [secure/profiles_controller.rb](app/controllers/secure/profiles_controller.rb) | [mass_assignment_test.rb](test/integration/mass_assignment_test.rb) |
| A03 Injection | **Stored XSS**: a document body containing `<script>` | `<%= raw @document.body %>` — [vulnerable view](app/views/vulnerable/documents/show.html.erb) | Default ERB escaping + strict Content Security Policy — [secure view](app/views/secure/documents/show.html.erb) | [xss_test.rb](test/integration/xss_test.rb) |
| A07 Identification & Authentication Failures | **Login brute force** and account enumeration | — | `rate_limit to: 10, within: 3.minutes` on login, same error message for unknown email and wrong password, bcrypt passwords | [brute_force_test.rb](test/integration/brute_force_test.rb) |
| A05 Security Misconfiguration | Missing browser protections | — | Strict CSP (`script-src 'self'`, `frame-ancestors 'none'`), `X-Content-Type-Options`, `X-Frame-Options`; vulnerable routes never mounted in production | [security_headers_test.rb](test/integration/security_headers_test.rb) |

## Static analysis in CI

The [CI workflow](.github/workflows/ci.yml) runs on every push:

1. **Brakeman on the secure code must report zero warnings.**
2. **Brakeman on the whole app must detect the planted vulnerabilities**: SQL Injection, Cross-Site Scripting and Mass Assignment.
3. RuboCop and the test suite.

Brakeman does **not** detect the IDOR: static analysis cannot know that a document must belong to the current user.
Access control has to be designed and tested, which is why every fix here has an integration test.

## Safety

The vulnerable endpoints live under `/vulnerable/*` and are only mounted in development and test
(see [config/initializers/vulnerable_demos.rb](config/initializers/vulnerable_demos.rb)). A test checks that they are disabled in production.
Do not deploy this app with `ENABLE_VULNERABLE_DEMOS=1`.

## Run it

```bash
bundle install
bin/rails db:setup        # creates the database and seeds alice@example.com / bob@example.com (password123)
bin/rails test            # 15 tests: each attack and each fix
bin/brakeman              # see the 3 warnings in app/controllers/vulnerable and app/views/vulnerable
bin/rails server          # http://localhost:3000
```

Stack: Ruby 3.3, Rails 8.1, SQLite, Rails 8 built-in authentication (`has_secure_password`, database-backed sessions, signed http-only cookies), Minitest, Brakeman, RuboCop.

## Author

Ammar Ferchichi — full stack developer working on cybersecurity platforms (IAM, API security, vulnerability intelligence).
[LinkedIn](https://www.linkedin.com/in/ammarferchichi)
