import Foundation

/// Maps puzzle title keywords to display emoji and German translations.
struct PuzzleMotifHelper {

    // MARK: - Emoji

    static func emoji(for title: String) -> String {
        let t = title.lowercased()
        let map: [(String, String)] = [
            // Animals
            ("cat", "🐱"), ("kitten", "🐱"), ("chihiro", "🐱"), ("chococat", "🐱"),
            ("dog", "🐶"), ("puppy", "🐶"), ("snoopy", "🐶"), ("pooh", "🐻"),
            ("penguin", "🐧"), ("peko", "🐧"),
            ("frog", "🐸"),
            ("monkey", "🐒"), ("gorilla", "🦍"),
            ("fish", "🐟"), ("carp", "🐠"),
            ("bird", "🐦"), ("owl", "🦉"), ("cock", "🐔"), ("duck", "🦆"),
            ("cow", "🐄"), ("lamb", "🐑"), ("sheep", "🐑"), ("pig", "🐷"),
            ("giraffe", "🦒"),
            ("bear", "🐻"), ("panda", "🐼"),
            ("elephant", "🐘"),
            ("rabbit", "🐰"),
            ("mouse", "🐭"), ("rat", "🐭"),
            ("snake", "🐍"),
            ("turtle", "🐢"),
            ("butterfly", "🦋"),
            ("deer", "🦌"),
            ("camel", "🐪"),
            ("leopard", "🐆"),
            ("horse", "🐴"),
            ("lion", "🦁"),
            ("tiger", "🐯"),
            ("kangaroo", "🦘"),
            ("ostrich", "🦢"),
            ("seal", "🦭"),
            ("wolf", "🐺"),
            ("fox", "🦊"),
            ("snail", "🐌"),
            ("crab", "🦀"),
            ("shark", "🦈"),
            ("whale", "🐳"),
            ("dolphin", "🐬"),
            ("croc", "🐊"),
            ("chiwawa", "🐶"),
            // Nature
            ("flower", "🌸"), ("cherry", "🌸"), ("rose", "🌹"),
            ("tree", "🌳"),
            ("moon", "🌙"), ("crescent", "🌙"),
            ("sun", "☀️"),
            ("star", "⭐"),
            ("heart", "❤️"),
            ("cloud", "☁️"),
            ("rain", "🌧️"),
            ("snow", "❄️"), ("ski", "⛷️"),
            ("mushroom", "🍄"),
            ("apple", "🍎"),
            ("peach", "🍑"),
            // People & characters
            ("smile", "😊"),
            ("girl", "👧"),
            ("senior", "👴"),
            ("scout", "🏕️"),
            ("snoopy", "🐾"), ("totoro", "🐼"), ("mickey", "🐭"), ("minnie", "🐭"),
            ("goofy", "🐶"), ("donald", "🦆"), ("pooh", "🐻"),
            ("shinchan", "🎭"), ("chaplin", "🎭"), ("freddie", "🎭"), ("mozart", "🎹"),
            ("panda", "🐼"), ("hamtori", "🐹"),
            // Sports & activities
            ("ball", "⚽"), ("soccer", "⚽"), ("football", "🏈"),
            ("basketball", "🏀"), ("dunk", "🏀"), ("dribble", "🏀"),
            ("bowling", "🎳"),
            ("tennis", "🎾"),
            ("golf", "⛳"),
            ("swim", "🏊"),
            ("surf", "🏄"),
            ("ski", "⛷️"),
            ("gym", "🏋️"),
            ("judo", "🥋"),
            ("hurdle", "🏃"),
            ("handball", "🤾"),
            ("lifting", "🏋️"),
            ("punch", "🥊"),
            ("hit", "🎯"),
            ("serving", "🏐"),
            ("flying", "✈️"),
            // Objects
            ("house", "🏠"),
            ("car", "🚗"),
            ("train", "🚂"),
            ("boat", "⛵"), ("ship", "🚢"),
            ("rocket", "🚀"),
            ("plane", "✈️"),
            ("ambulance", "🚑"), ("embulance", "🚑"),
            ("robot", "🤖"),
            ("crown", "👑"),
            ("key", "🔑"),
            ("lock", "🔒"),
            ("anchor", "⚓"),
            ("umbrella", "☂️"),
            ("trophy", "🏆"),
            ("flag", "🚩"),
            ("arrow", "➡️"),
            ("diamond", "💎"),
            ("cross", "✝️"),
            ("lightning", "⚡"),
            ("moon", "🌙"),
            // Food
            ("pizza", "🍕"),
            ("cake", "🎂"),
            ("icecream", "🍦"), ("cream", "🍦"),
            ("persimmon", "🍊"),
            // Music & art
            ("guitar", "🎸"),
            ("piano", "🎹"),
            ("drum", "🥁"),
            ("music", "🎵"),
            ("note", "🎵"),
            ("beatles", "🎸"),
            // Other
            ("delivery", "📦"),
            ("observe", "🔭"),
            ("shoes", "👟"),
            ("breath", "💨"),
            ("gegege", "👻"),
            ("qoo", "🥤"),
            ("ride", "🏇"),
        ]
        for (keyword, emote) in map {
            if t.contains(keyword) { return emote }
        }
        return "🧩"
    }

    // MARK: - German title

    static func germanTitle(for title: String) -> String? {
        let t = title.lowercased()
        let map: [String: String] = [
            "penguin": "Pinguin", "frog": "Frosch", "monkey": "Affe",
            "fish": "Fisch", "carp": "Karpfen", "owl": "Eule",
            "cow": "Kuh", "giraffe": "Giraffe", "gorilla": "Gorilla",
            "dog": "Hund", "puppy": "Welpe", "cat": "Katze",
            "bird": "Vogel", "ball": "Ball", "soccer": "Fußball",
            "robot": "Roboter", "ostrich": "Strauß", "mouse": "Maus",
            "scout": "Pfadfinder", "smile": "Lächeln", "girl": "Mädchen",
            "tree": "Baum", "seal": "Seehund", "crescent": "Halbmond",
            "cherry": "Kirsche", "fishing": "Angeln", "heart": "Herz",
            "cross": "Kreuz", "diamond": "Diamant", "moon": "Mond",
            "arrow": "Pfeil", "house": "Haus", "flag": "Flagge",
            "lock": "Schloss", "crown": "Krone", "star": "Stern",
            "sun": "Sonne", "cloud": "Wolke", "flower": "Blume",
            "mushroom": "Pilz", "apple": "Apfel", "anchor": "Anker",
            "butterfly": "Schmetterling", "rabbit": "Hase",
            "deer": "Hirsch", "camel": "Kamel", "panda": "Panda",
            "bear": "Bär", "horse": "Pferd", "lion": "Löwe",
            "tiger": "Tiger", "elephant": "Elefant", "snake": "Schlange",
            "turtle": "Schildkröte", "lamb": "Lamm", "train": "Zug",
            "car": "Auto", "boat": "Boot", "plane": "Flugzeug",
            "flying": "Fliegen", "ship": "Schiff", "giraffe": "Giraffe",
            "monkey": "Affe", "cow": "Kuh",
            "bowling": "Bowling", "gym": "Fitness", "judo": "Judo",
            "surfing": "Surfen", "lifting": "Gewichtheben",
            "hurdle": "Hürde", "handball": "Handball",
            "dunk": "Dunk", "dribble": "Dribbling",
            "ski": "Ski", "swimming": "Schwimmen",
        ]
        return map[t]
    }
}
