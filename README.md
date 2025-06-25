# ❄️ FlakeyCore — Lightweight FiveM Framework

Welcome to **FlakeyCore**, a lightweight and dependency-free FiveM framework designed for simplicity and full control. Whether you're building a serious RP server or experimenting with custom systems, FlakeyCore gives you the essentials — and nothing you don't need.

---

## ✨ Features

✅ Persistent player data (cash, bank, health, hunger, thirst, position)  
✅ Autosaving position every 20s and on disconnect  
✅ Job & grade system (e.g. Police → Cadet, Officer, Chief)  
✅ Role-based paychecks every 10 mins  
✅ Hunger & thirst needs system  
✅ Multiple character support  
✅ Server-side data caching (no spammy DB writes)  
✅ OxMySQL integration for smooth async DB handling  
✅ Clean modular structure (money, needs, jobs, characters, etc.)

---

## 🚀 Getting Started

1. Clone or download the repo into your resources folder  
2. Import the required SQL for `flakey_players` table  
3. Add `start flakey_core` to your `server.cfg`  
4. Make sure `oxmysql` is started before this resource  
5. Start your server and join!

---

## 🧾 SQL Structure

You’ll need to create a `flakey_players` table with fields like:

```sql
CREATE TABLE IF NOT EXISTS flakey_players (
  identifier VARCHAR(100) PRIMARY KEY,
  cash INT DEFAULT 1000,
  bank INT DEFAULT 5000,
  position LONGTEXT,
  ped LONGTEXT,
  job VARCHAR(50) DEFAULT 'unemployed',
  grade INT DEFAULT 0,
  firstname VARCHAR(50),
  lastname VARCHAR(50),
  dob VARCHAR(20),
  gender VARCHAR(10)
);

⸻

🛠️ Planned Features
	•	🔜 Character creator UI
	•	🔜 Admin tools
	•	🔜 Character selector UI
	•	🔜 Whitelisted Ped Selector
	•	🔜 Checks for whitelisted Job's
	•	🔜 Player owned vehicle system
	•	🔜 Anti cheat
	•	🔜 Blips on map
	•	🔜 Easy to use exports/events

⸻

❤️ Contributing

Pull requests, suggestions, and forks are welcome.
Make it yours. Break it. Rebuild it better.

⸻

📜 License

MIT — Free to use, modify, and distribute with credit.

⸻

Made with 🧠 and by Flakey❄️