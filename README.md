# agent-skills

[![skills.sh](https://skills.sh/b/orleib/agent-skills)](https://skills.sh/orleib/agent-skills)

Production patterns for AI coding agents. One folder per skill. Add another folder when the next hard-won failure mode is worth teaching; do not open a new GitHub repo for it.

Install one skill:

```bash
npx skills add orleib/agent-skills --skill session-verdict
```

Install every skill in the pack:

```bash
npx skills add orleib/agent-skills
```

## Skills

| Skill | Use when |
| --- | --- |
| [session-verdict](./session-verdict/) | Capacitor WebView + supabase-js: empty `getSession`, storage still warming, or a network error treated as logout. Upgrade to 2.108.2+ for the old phantom `SIGNED_OUT` bug. |
| [capacitor-app-icons](./capacitor-app-icons/) | Capacitor app on macOS: generate every iOS, Android and PWA icon size and splash screen from one 1024x1024 image, with no dependencies beyond the built-in `sips`. |

## License

MIT
