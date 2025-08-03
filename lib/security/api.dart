class Botkey {
  static const apiKey = 'YOUR_API_KEY';

  static final headers = {
    'Authorization': 'Bearer ${Botkey.apiKey}',
    'Content-Type': 'application/json',
  };
}
