import Foundation

class QuestionLoader {

    /// Charge toutes les questions depuis les 5 fichiers JSON du bundle
    static func loadQuestions() -> [Question] {
        let fileNames = [
            "questions_culture_generale",
            "questions_english",
            "questions_french",
            "questions_spanish",
            "questions_german"
        ]

        var allQuestions: [Question] = []

        for name in fileNames {
            let urls = [
                Bundle.main.url(forResource: name, withExtension: "json"),
                Bundle.main.url(forResource: name, withExtension: "json", subdirectory: "Resources")
            ].compactMap { $0 }

            for url in urls {
                if let data = try? Data(contentsOf: url),
                   let questions = try? JSONDecoder().decode([Question].self, from: data),
                   !questions.isEmpty {
                    allQuestions.append(contentsOf: questions)
                    break
                }
            }
        }

        if allQuestions.isEmpty {
            return hardcodedQuestions
        }

        return allQuestions
    }

    /// Compte le nombre de questions par CategoryPath
    static func questionCounts() -> [CategoryPath: Int] {
        let questions = loadQuestions()
        var counts: [CategoryPath: Int] = [:]
        for q in questions {
            counts[q.categoryPath, default: 0] += 1
        }
        return counts
    }

    // MARK: - Fallback codé en dur

    static let hardcodedQuestions: [Question] = [
        Question(
            id: "cg_science_001",
            topCategory: .cultureGenerale, subCategory: .science,
            question: ["fr": "L'eau chaude gèle-t-elle plus vite que l'eau froide ?",
                       "en": "Does hot water freeze faster than cold water?",
                       "es": "¿El agua caliente se congela más rápido que la fría?",
                       "de": "Gefriert heißes Wasser schneller als kaltes?"],
            choiceLeft: ["fr": "Oui", "en": "Yes", "es": "Sí", "de": "Ja"],
            choiceRight: ["fr": "Non", "en": "No", "es": "No", "de": "Nein"],
            correctAnswer: .left,
            explanation: ["fr": "C'est l'effet Mpemba : l'eau chaude peut geler plus vite que l'eau froide dans certaines conditions.",
                          "en": "This is the Mpemba effect: hot water can freeze faster than cold water under certain conditions.",
                          "es": "Es el efecto Mpemba: el agua caliente puede congelarse más rápido en ciertas condiciones.",
                          "de": "Das ist der Mpemba-Effekt: Heißes Wasser kann unter bestimmten Bedingungen schneller gefrieren."],
            emoji: "🧊"
        ),
        Question(
            id: "cg_history_001",
            topCategory: .cultureGenerale, subCategory: .history,
            question: ["fr": "Cléopâtre vivait-elle plus près de l'alunissage ou de la Grande Pyramide ?",
                       "en": "Did Cleopatra live closer to the Moon landing or the Great Pyramid?",
                       "es": "¿Cleopatra vivió más cerca del alunizaje o de la Gran Pirámide?",
                       "de": "Lebte Kleopatra näher an der Mondlandung oder der Großen Pyramide?"],
            choiceLeft: ["fr": "Alunissage", "en": "Moon landing", "es": "Alunizaje", "de": "Mondlandung"],
            choiceRight: ["fr": "Pyramide", "en": "Pyramid", "es": "Pirámide", "de": "Pyramide"],
            correctAnswer: .left,
            explanation: ["fr": "Cléopâtre (-69 à -30 av. J.-C.) vivait plus près de 1969 que de -2560 av. J.-C.",
                          "en": "Cleopatra (69-30 BC) lived closer to 1969 than to 2560 BC.",
                          "es": "Cleopatra (69-30 a.C.) vivió más cerca de 1969 que de 2560 a.C.",
                          "de": "Kleopatra (69-30 v. Chr.) lebte näher an 1969 als an 2560 v. Chr."],
            emoji: "🏛️"
        ),
        Question(
            id: "cg_space_001",
            topCategory: .cultureGenerale, subCategory: .space,
            question: ["fr": "Un jour sur Vénus dure-t-il plus longtemps qu'une année sur Vénus ?",
                       "en": "Is a day on Venus longer than a year on Venus?",
                       "es": "¿Un día en Venus dura más que un año en Venus?",
                       "de": "Ist ein Tag auf der Venus länger als ein Jahr auf der Venus?"],
            choiceLeft: ["fr": "Oui", "en": "Yes", "es": "Sí", "de": "Ja"],
            choiceRight: ["fr": "Non", "en": "No", "es": "No", "de": "Nein"],
            correctAnswer: .left,
            explanation: ["fr": "Vénus tourne si lentement sur elle-même (243 jours) que son jour dépasse son année orbitale (225 jours).",
                          "en": "Venus rotates so slowly (243 days) that its day exceeds its orbital year (225 days).",
                          "es": "Venus gira tan lentamente (243 días) que su día supera su año orbital (225 días).",
                          "de": "Venus dreht sich so langsam (243 Tage), dass ihr Tag ihr Orbitaljahr (225 Tage) übersteigt."],
            emoji: "🌟"
        ),
        Question(
            id: "cg_geography_001",
            topCategory: .cultureGenerale, subCategory: .geography,
            question: ["fr": "Le Canada possède-t-il plus de lacs que le reste du monde réuni ?",
                       "en": "Does Canada have more lakes than the rest of the world combined?",
                       "es": "¿Canadá tiene más lagos que el resto del mundo combinado?",
                       "de": "Hat Kanada mehr Seen als der Rest der Welt zusammen?"],
            choiceLeft: ["fr": "Oui", "en": "Yes", "es": "Sí", "de": "Ja"],
            choiceRight: ["fr": "Non", "en": "No", "es": "No", "de": "Nein"],
            correctAnswer: .left,
            explanation: ["fr": "Le Canada possède environ 60% des lacs du monde, soit plus que tous les autres pays réunis.",
                          "en": "Canada has about 60% of the world's lakes, more than all other countries combined.",
                          "es": "Canadá tiene alrededor del 60% de los lagos del mundo.",
                          "de": "Kanada besitzt etwa 60% der Seen der Welt."],
            emoji: "🏞️"
        ),
        Question(
            id: "cg_food_001",
            topCategory: .cultureGenerale, subCategory: .food,
            question: ["fr": "Les bananes sont-elles techniquement des baies ?",
                       "en": "Are bananas technically berries?",
                       "es": "¿Los plátanos son técnicamente bayas?",
                       "de": "Sind Bananen technisch gesehen Beeren?"],
            choiceLeft: ["fr": "Oui", "en": "Yes", "es": "Sí", "de": "Ja"],
            choiceRight: ["fr": "Non", "en": "No", "es": "No", "de": "Nein"],
            correctAnswer: .left,
            explanation: ["fr": "Botaniquement, les bananes sont des baies, mais pas les fraises !",
                          "en": "Botanically, bananas are berries, but strawberries are not!",
                          "es": "Botánicamente, los plátanos son bayas, ¡pero las fresas no!",
                          "de": "Botanisch gesehen sind Bananen Beeren, Erdbeeren aber nicht!"],
            emoji: "🍌"
        ),
        Question(
            id: "en_a1_001",
            topCategory: .english, subCategory: .a1,
            question: ["fr": "Que signifie 'Cat' ?",
                       "en": "What does 'Cat' mean?",
                       "es": "¿Qué significa 'Cat'?",
                       "de": "Was bedeutet 'Cat'?"],
            choiceLeft: ["fr": "Chat", "en": "Cat", "es": "Gato", "de": "Katze"],
            choiceRight: ["fr": "Chien", "en": "Dog", "es": "Perro", "de": "Hund"],
            correctAnswer: .left,
            explanation: ["fr": "'Cat' signifie 'Chat'. 'Dog' signifie 'Chien'.",
                          "en": "'Cat' means cat, not dog.",
                          "es": "'Cat' significa 'Gato', no 'Perro'.",
                          "de": "'Cat' bedeutet 'Katze', nicht 'Hund'."],
            emoji: "🐱"
        ),
        Question(
            id: "fr_a1_001",
            topCategory: .french, subCategory: .a1,
            question: ["fr": "Que signifie 'Bonjour' ?",
                       "en": "What does 'Bonjour' mean?",
                       "es": "¿Qué significa 'Bonjour'?",
                       "de": "Was bedeutet 'Bonjour'?"],
            choiceLeft: ["fr": "Bonjour", "en": "Hello", "es": "Hola", "de": "Hallo"],
            choiceRight: ["fr": "Au revoir", "en": "Goodbye", "es": "Adiós", "de": "Tschüss"],
            correctAnswer: .left,
            explanation: ["fr": "'Bonjour' est une salutation, pas un au revoir.",
                          "en": "'Bonjour' means 'Hello', not 'Goodbye'.",
                          "es": "'Bonjour' significa 'Hola', no 'Adiós'.",
                          "de": "'Bonjour' bedeutet 'Hallo', nicht 'Tschüss'."],
            emoji: "🇫🇷"
        ),
        Question(
            id: "es_a1_001",
            topCategory: .spanish, subCategory: .a1,
            question: ["fr": "Que signifie 'Gracias' ?",
                       "en": "What does 'Gracias' mean?",
                       "es": "¿Qué significa 'Gracias'?",
                       "de": "Was bedeutet 'Gracias'?"],
            choiceLeft: ["fr": "Merci", "en": "Thank you", "es": "Gracias", "de": "Danke"],
            choiceRight: ["fr": "S'il vous plaît", "en": "Please", "es": "Por favor", "de": "Bitte"],
            correctAnswer: .left,
            explanation: ["fr": "'Gracias' signifie 'Merci'. 'Por favor' signifie 'S'il vous plaît'.",
                          "en": "'Gracias' means 'Thank you', not 'Please'.",
                          "es": "'Gracias' significa 'Thank you', no 'Please'.",
                          "de": "'Gracias' bedeutet 'Danke', nicht 'Bitte'."],
            emoji: "🇪🇸"
        ),
        Question(
            id: "de_a1_001",
            topCategory: .german, subCategory: .a1,
            question: ["fr": "Que signifie 'Danke' ?",
                       "en": "What does 'Danke' mean?",
                       "es": "¿Qué significa 'Danke'?",
                       "de": "Was bedeutet 'Danke'?"],
            choiceLeft: ["fr": "Merci", "en": "Thank you", "es": "Gracias", "de": "Danke"],
            choiceRight: ["fr": "Bonjour", "en": "Hello", "es": "Hola", "de": "Hallo"],
            correctAnswer: .left,
            explanation: ["fr": "'Danke' signifie 'Merci' en allemand.",
                          "en": "'Danke' means 'Thank you' in German.",
                          "es": "'Danke' significa 'Gracias' en alemán.",
                          "de": "'Danke' bedeutet 'Thank you' auf Englisch."],
            emoji: "🇩🇪"
        ),
        Question(
            id: "cg_mathematics_001",
            topCategory: .cultureGenerale, subCategory: .mathematics,
            question: ["fr": "Un jeu de 52 cartes mélangé a-t-il probablement un ordre unique dans l'histoire ?",
                       "en": "Has a shuffled 52-card deck likely never had the same order before?",
                       "es": "¿Una baraja de 52 cartas barajada probablemente nunca tuvo el mismo orden?",
                       "de": "Hatte ein gemischtes 52-Karten-Deck wahrscheinlich nie dieselbe Reihenfolge?"],
            choiceLeft: ["fr": "Oui", "en": "Yes", "es": "Sí", "de": "Ja"],
            choiceRight: ["fr": "Non", "en": "No", "es": "No", "de": "Nein"],
            correctAnswer: .left,
            explanation: ["fr": "52! ≈ 8×10⁶⁷ permutations possibles — plus que d'atomes dans l'univers.",
                          "en": "52! ≈ 8×10⁶⁷ possible permutations — more than atoms in the universe.",
                          "es": "52! ≈ 8×10⁶⁷ permutaciones posibles — más que átomos en el universo.",
                          "de": "52! ≈ 8×10⁶⁷ mögliche Permutationen — mehr als Atome im Universum."],
            emoji: "🃏"
        )
    ]
}
