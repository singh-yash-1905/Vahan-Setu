class ApiConstants {
  // We keep the variable name 'ngrokUrl' so all your existing repositories continue
  // to work without modification, but we point it to your live Render production backend.
  // Note: /api/v1 is required at the end so endpoint paths resolve correctly.
  static const String ngrokUrl =
      'https://vehicle-logistics-app-guaq.onrender.com/api/v1';

  // Backup/reference URLs
  static const String developmentUrl =
      'https://669a-2401-4900-8834-d777-7d87-e799-f4e6-402e.ngrok-free.app/api/v1';
  static const String productionUrl =
      'https://vehicle-logistics-app-guaq.onrender.com/api/v1';
}
