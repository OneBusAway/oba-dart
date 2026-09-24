# oba_dart

This is a demo host app and the packages behind it. Together they let UCSD
embed OneBusAway real-time arrivals in its Flutter Student Life app.

| Path | What |
|---|---|
| `packages/onebusaway` | Pure-Dart OneBusAway REST client. It is built to grow toward the full API |
| `packages/oba_arrivals` | Flutter arrivals panel (`ObaArrivalsPanel`) |
| `lib/` | Demo app that mimics the Student Life home feed |
| `docs/superpowers/` | Design spec and implementation plan |

## Setup

The toolchain is pinned with [mise](https://mise.jdx.dev): Flutter 3.47.5 /
Dart 3.13.4.

```bash
mise install
mise exec -- flutter pub get
```

## Run the demo

```bash
mise exec -- flutter run
# Optional overrides:
mise exec -- flutter run \
  --dart-define=OBA_BASE_URL=https://realtime.sdmts.com/api/ \
  --dart-define=OBA_API_KEY=org.onebusaway.iphone
```

`OBA_BASE_URL` is the OBA *server root*. The API lives at
`{OBA_BASE_URL}api/where/…`.

## Test

```bash
mise exec -- flutter test                                     # demo app
(cd packages/onebusaway && mise exec -- dart test)
(cd packages/oba_arrivals && TZ=America/Los_Angeles mise exec -- flutter test)
```

## Platforms

iOS and Android are the primary targets, and macOS works for desktop runs.
The SDMTS server sends CORS headers for localhost, so `flutter run -d chrome`
works against it. Other OBA servers may not send those headers.

## License

Licensed under the [Apache License, Version 2.0](LICENSE).
