// Cache Exceptions
class EmptyCacheException implements Exception {}

// Database Exceptions
class OfflineDatabaseException implements Exception {}

class EmptyDatabaseException implements Exception {}

// Login Exceptions
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

// Register Exceptions
class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// Generic Exceptions
class GenreicAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
