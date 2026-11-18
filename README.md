# Halo Taxi: mobile app for iOS and Android

A Flutter app for a taxi company. Customers sign in with their phone number, pick a car class, see the fixed fare before ordering, and follow the driver on the map until the ride ends.

**Interactive demo in the browser:** https://gudrat97.github.io/projects/halo-app/
**Portfolio:** https://gudrat97.github.io

## Features

- Phone sign-in with a 4-digit code. In the first release the dispatcher reads the code to the customer, so no SMS gateway is needed; SMS can be added behind the same API call.
- Five car classes (Economy, Comfort, VIP, Minivan, Courier), each with its own tariff and a fare shown before ordering
- Higher classes can take orders from lower ones, so customers wait less
- Live ride status: searching, driver on the way with arrival time, car outside, on the trip, finished
- Driver details once the order is accepted: name, rating, car, colour, plate and phone
- Cancel before the trip starts; cash payment only
- One code base for iOS and Android

## Architecture

```
lib/
  main.dart                    App start and screen switching
  theme.dart                   Colours and component styles
  models/                      ServiceClass (tariffs), Driver, Ride, RideStatus
  data/
    ride_repository.dart       Interface for the backend API
    demo_ride_repository.dart  Works offline for demos and tests
  state/
    booking_controller.dart    Booking flow state (ChangeNotifier)
  screens/                     Login, Home (map and order sheet), Tracking
  widgets/                     City map with animated car markers
test/                          Fare rules, ride status and repository tests
```

Screens never call the network directly. They read state from `BookingController`, which talks to a `RideRepository`. The demo repository simulates the backend; a production repository calls the company's dispatch API (for example the Laravel API in [relay-laravel](https://github.com/Gudrat97/relay-laravel)) without any change to the UI.

The app uses only the Flutter SDK, with no third-party packages, so it builds quickly and has nothing to keep updated. The drawn map is a placeholder that a map package replaces in production.

## Run it

```bash
git clone https://github.com/Gudrat97/halo-taxi-app.git
cd halo-taxi-app
flutter create . --platforms=android,ios   # generates the native folders
flutter pub get
flutter run
```

Any 4-digit code signs in to the demo.

```bash
flutter test
```

## License

MIT
