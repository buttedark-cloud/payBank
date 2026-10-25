[🇷🇺 Русская версия](README.md)

# PayBank

A mobile banking app I built end to end on my own: the app is written in Flutter, the server in Node.js + TypeScript.
You sign up with a name and a phone number, get a card with a 5,000 ₽ welcome bonus, and can transfer money to other cards.

![PayBank](docs/preview.png)



https://github.com/user-attachments/assets/8e486454-8f58-4cfa-a3e7-4072815f4ad4



**Backend:** https://paybank-ki76.onrender.com

> The server runs on Render's free tier and goes to sleep when nobody uses it. The first request can take 30–60 seconds, after that everything is fast. The app shows a "preparing data" banner for this case.

## What it does

- Sign-up with name and phone number (input mask, validation)
- The server creates a new card and account with 5,000 ₽ on it
- Home screen: balance, card, list of recent operations
- Transfers by card number: 100 ₽ minimum, balance check, recipient card check
- USD / EUR / CNY to RUB rates, pull down to refresh
- Light and dark theme, toggle in the header

## What this project shows

It's a learning project, and I used it to practice connecting a client and a server:

- **BLoC**: events, states (loading, success, error) and a separate layer for API calls
- **Dio**: requests to my own server, timeouts, error handling
- **My own REST server** in Express + TypeScript: registration, accounts, transfers, exchange rates
- **CI** with GitHub Actions and automatic deploys to Render

## Tech stack

**App (`bank_client`)**
- Flutter, Material 3
- `flutter_bloc` + `equatable` for state management
- `dio` for HTTP
- `mask_text_input_formatter`, `google_fonts`

**Server (`server`)**
- Node.js, Express 5, TypeScript (strict mode)
- `axios` for exchange rates, `cors`, `dotenv`
- GitHub Actions: every push builds the server (`tsc`)
- Deployed to Render straight from this repo

## API

| Method | Path | What it does |
|--------|------|--------------|
| POST | `/api/register` | `{ name, phone }`, creates an account and a card. If the phone already exists, returns the existing account |
| GET | `/api/account/:cardNumber` | account data by card number |
| POST | `/api/transfer` | `{ senderCardNumber, recipientCardNumber, amount }` |
| GET | `/api/rates` | exchange rates (open.er-api.com) |

## Running it locally

Server:

```bash
cd server
npm install
npm run dev
```

App:

```bash
cd bank_client
flutter pub get
flutter run
```

The server URL lives in `lib/data/services/api_constants.dart`. For local testing change it to `http://10.0.2.2:3000` (Android emulator).

To try a transfer without registering a second account, send money to the test card `4400-9999-8888-7777`.

## Known limitations

This is a learning project, and I know where it falls short of a real bank:

- Data is stored in server memory and resets on restart. Next step: PostgreSQL.
- No real authentication: the phone number acts as an ID. It needs a password or SMS code and JWT.
- After a transfer the app updates the balance right away, before the server answers. It should wait for the response.
- No tests yet. I plan to cover the server with tests and add `flutter analyze` to CI.

## Author

Veronica, [GitHub](https://github.com/buttedark-cloud) · [LinkedIn](https://www.linkedin.com/in/veronikamalinovskaya)
