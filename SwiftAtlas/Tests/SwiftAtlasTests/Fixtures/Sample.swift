class User: Person, Some {}
class Dog: Animal, Some {}

struct Account: Codable, Equatable {}
struct Point {}

enum Direction: String, CaseIterable {}
enum Suit {}

protocol Repository: Fetchable, Storable {}
protocol Loggable {}
