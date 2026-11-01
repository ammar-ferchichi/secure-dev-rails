# Demo data: two users, each with private documents.
alice = User.find_or_create_by!(email_address: "alice@example.com") { |u| u.password = "password123"; u.display_name = "Alice" }
bob   = User.find_or_create_by!(email_address: "bob@example.com")   { |u| u.password = "password123"; u.display_name = "Bob" }

alice.documents.find_or_create_by!(title: "Alice notes") { |d| d.body = "Alice's private notes." }
bob.documents.find_or_create_by!(title: "Bob salary") { |d| d.body = "Bob's confidential salary slip." }
bob.documents.find_or_create_by!(title: "Bob comment") { |d| d.body = %(<script>alert("XSS")</script>Nice post!) }
