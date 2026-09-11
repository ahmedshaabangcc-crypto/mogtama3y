/// Google Places API key for importing real shops into the directory.
///
/// This key is restricted (Google Cloud Console → APIs & Services →
/// Credentials) to only the Places API / Places API (New) — it is safe
/// to ship in client code under that restriction, the same way Google's
/// own Maps/Places JS client libraries always expose the key in the
/// browser. Ahmed is separately adding a "Websites" application
/// restriction limited to mogtama3y.com to stop it being used from
/// anywhere else.
class PlacesConfig {
  PlacesConfig._();

  static const String apiKey = 'AIzaSyDW7IEPhK2cv4QxIWUmAAAMf7ph5n9dv04';
}
