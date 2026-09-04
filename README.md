# agent-skills

Production patterns for AI coding agents. One folder per skill. Add another folder when the next hard-won failure mode is worth teaching; do not open a new GitHub repo for it.

Install one skill:

```bash
npx skills add orleib-lab/agent-skills --skill session-verdict
```

Install every skill in the pack:

```bash
npx skills add orleib-lab/agent-skills
```

## Skills

| Skill | Use when |
| --- | --- |
| [session-verdict](./session-verdict/) | Capacitor / WebView + supabase-js bounces an authenticated user to login after background resume, or `SIGNED_OUT` fires on a still-valid token |

## License

MIT
