# cfreg

A tiny, scriptable CLI wrapper around the **Cloudflare Registrar REST API**.
Single file, Python 3 stdlib only (no dependencies), JSON output, **no
interactive prompts** — every input is a flag or argument so it drops straight
into scripts and pipes into `jq`.

![cfreg demo](demo.gif)

<sub>Demo recorded with [vhs](https://github.com/charmbracelet/vhs); regenerate with `vhs demo.tape`.</sub>

> Why not the official `cf` CLI? As of `cf` v0.0.5 the registrar surface is only
> `cf registrar domains {get,list,update}` — no search, check, or register — and
> its OAuth token isn't accepted for raw API calls. So this tool talks to the API
> directly with a dedicated Registrar-scoped token.

## Setup

```bash
export CLOUDFLARE_API_TOKEN="cfat_…"          # token scoped to Registrar
export CLOUDFLARE_ACCOUNT_ID="<account id>"   # 32-hex id from your CF dashboard URL
```

(Or pass `--token` / `--account` per call.) Add `-c`/`--compact` for single-line JSON.

## Commands

```bash
cfreg search <query> [--ext com,dev,app] [--limit 20]   # suggestions (non-authoritative)
cfreg check <domain> [<domain>...]                       # real-time check (<=20 domains)
cfreg list [--sort-by name] [--direction asc] [--cursor …] [--per-page N]
cfreg domains                                            # legacy transfer-oriented list
cfreg get <domain>                                       # one registration's state
cfreg register <domain> [--years N] [--auto-renew] [--privacy redaction|off] [--async] --yes
cfreg update <domain> [--auto-renew|--no-auto-renew] [--lock|--no-lock] [--privacy|--no-privacy]
cfreg status <domain> [--type registration|update]       # poll a workflow
```

### Examples

```bash
cfreg search arcadevault --limit 5 -c | jq -r '.result.domains[].name'
cfreg check arcadevault.dev mybrand.com -c | jq '.result.domains'
cfreg register mybrand.com --years 1 --yes        # BILLABLE
cfreg status mybrand.com                          # poll if register returned 202
```

## Safety

- `register` is the **only billable, non-refundable** call. It refuses to run
  without `--yes` — a required flag, not a prompt, so scripts opt in explicitly
  and a stray re-run can't buy a domain.
- `auto_renew` defaults to **false**; it's only set when you ask. Note that
  enabling it authorizes future renewal charges.
- Only ~40 TLDs support programmatic registration; premium domains can be
  searched/checked but **not** registered via the API.

## Exit codes

| code | meaning |
|------|---------|
| 0 | API returned `success: true` |
| 1 | API returned `success: false` (errors on stderr) |
| 2 | usage/local error (missing token, missing `--yes`, bad args) |
| 3 | network/transport error |
