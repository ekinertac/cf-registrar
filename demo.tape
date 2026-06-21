# VHS tape for ./cfreg demo. Render with: vhs demo.tape
# Credentials are loaded from a gitignored .env inside a Hidden block, so the
# token never appears in this file or the generated gif. Only safe, read-only
# commands are shown (plus the --yes purchase guard refusing).

Output demo.gif

Set Shell "bash"
Set FontSize 16
Set Width 1100
Set Height 700
Set Padding 18
Set Theme "Catppuccin Mocha"
Set TypingSpeed 45ms

Hide
Type "source .env && clear"
Enter
Sleep 500ms
Show

Type "# cfreg — scriptable Cloudflare Registrar CLI"
Enter
Sleep 1s

Type "# 1) search for available domains"
Enter
Type `./cfreg search arcadevault --limit 4 -c | jq -r '.result.domains[] | "\(.name)  $\(.pricing.registration_cost)/yr"'`
Enter
Sleep 3s

Type "# 2) authoritative availability check"
Enter
Type `./cfreg check arcadevault.dev google.com -c | jq -r '.result.domains[] | "\(.name)  registrable=\(.registrable)"'`
Enter
Sleep 3s

Type "# 3) register is gated — refuses without --yes (no accidental purchase)"
Enter
Type "./cfreg register cool-domain.com"
Enter
Sleep 3s
