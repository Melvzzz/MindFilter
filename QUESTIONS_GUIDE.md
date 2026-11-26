# Guide d'ajout de questions — MindFilter

## Emplacement des fichiers

Toutes les questions sont stockées dans des fichiers JSON situés dans :

```
MindFilter/
└── MindFilter/
    └── Resources/
        ├── questions_culture_generale.json   (100 questions — 10 sous-catégories × 10)
        ├── questions_english.json            (60 questions  — 6 niveaux × 10)
        ├── questions_french.json             (60 questions  — 6 niveaux × 10)
        ├── questions_spanish.json            (60 questions  — 6 niveaux × 10)
        └── questions_german.json             (60 questions  — 6 niveaux × 10)
```

**Total actuel : 340 questions.**

## Comment le code charge les questions

Le chargement se fait dans `MindFilter/Services/QuestionLoader.swift` :

1. `QuestionLoader.loadQuestions()` cherche les 5 fichiers JSON dans le bundle de l'app
2. Il décode chaque fichier en `[Question]` (modèle défini dans `MindFilter/Models/Question.swift`)
3. Si aucun fichier n'est trouvé, un fallback de 10 questions codées en dur est utilisé

**Fichiers clés :**

| Fichier | Rôle |
|---------|------|
| `Models/Question.swift` | Définit la struct `Question` et l'enum `CorrectAnswer` |
| `Models/Category.swift` | Définit `TopCategory`, `SubCategory`, `LanguageCode` |
| `Services/QuestionLoader.swift` | Charge et décode les JSON |
| `Services/QuestionSelector.swift` | Algorithme de sélection anti-répétition |

---

## Structure JSON d'une question

Chaque question est un objet JSON avec cette structure exacte :

```json
{
  "id": "prefixe_souscategorie_NNN",
  "topCategory": "culture_generale",
  "subCategory": "science",
  "question":    { "fr": "...", "en": "...", "es": "...", "de": "..." },
  "choiceLeft":  { "fr": "...", "en": "...", "es": "...", "de": "..." },
  "choiceRight": { "fr": "...", "en": "...", "es": "...", "de": "..." },
  "correctAnswer": "left",
  "explanation": { "fr": "...", "en": "...", "es": "...", "de": "..." },
  "emoji": "🔬"
}
```

### Champs obligatoires

| Champ | Type | Description |
|-------|------|-------------|
| `id` | String | Identifiant unique (voir convention ci-dessous) |
| `topCategory` | String | Catégorie principale |
| `subCategory` | String | Sous-catégorie |
| `question` | Objet `{lang: texte}` | La question dans les 4 langues |
| `choiceLeft` | Objet `{lang: texte}` | Réponse de gauche dans les 4 langues |
| `choiceRight` | Objet `{lang: texte}` | Réponse de droite dans les 4 langues |
| `correctAnswer` | `"left"` ou `"right"` | Quelle réponse est correcte |

### Champs optionnels

| Champ | Type | Description |
|-------|------|-------------|
| `explanation` | Objet `{lang: texte}` | Explication affichée après la réponse |
| `emoji` | String | Emoji illustratif affiché sur la carte |

### Les 4 langues requises

Chaque champ texte multilingue doit contenir les clés : `"fr"`, `"en"`, `"es"`, `"de"`.
Le français (`"fr"`) sert de fallback si la langue de l'utilisateur n'est pas trouvée.

---

## Convention d'ID

L'ID suit le format : `<préfixe>_<sous-catégorie>_<numéro à 3 chiffres>`

### Culture Générale

| `topCategory` | `subCategory` | Préfixe d'ID | Exemple |
|----------------|---------------|---------------|---------|
| `culture_generale` | `science` | `cg_science_` | `cg_science_001` |
| `culture_generale` | `history` | `cg_history_` | `cg_history_015` |
| `culture_generale` | `inventions` | `cg_inventions_` | `cg_inventions_003` |
| `culture_generale` | `geography` | `cg_geography_` | `cg_geography_022` |
| `culture_generale` | `psychology` | `cg_psychology_` | `cg_psychology_008` |
| `culture_generale` | `quotes` | `cg_quotes_` | `cg_quotes_011` |
| `culture_generale` | `mathematics` | `cg_mathematics_` | `cg_mathematics_005` |
| `culture_generale` | `art_culture` | `cg_art_culture_` | `cg_art_culture_019` |
| `culture_generale` | `food` | `cg_food_` | `cg_food_007` |
| `culture_generale` | `space` | `cg_space_` | `cg_space_012` |

### Langues (English, French, Spanish, German)

| `topCategory` | `subCategory` | Préfixe d'ID | Exemple |
|----------------|---------------|---------------|---------|
| `english` | `a1` à `c2` | `en_<niveau>_` | `en_a1_011`, `en_c2_005` |
| `french` | `a1` à `c2` | `fr_<niveau>_` | `fr_b1_003` |
| `spanish` | `a1` à `c2` | `es_<niveau>_` | `es_a2_020` |
| `german` | `a1` à `c2` | `de_<niveau>_` | `de_b2_014` |

**Les IDs existants vont de `001` à `010`. Les nouvelles questions doivent commencer à `011`.**

---

## Exemples complets par type

### Culture Générale — Science

```json
{
  "id": "cg_science_011",
  "topCategory": "culture_generale",
  "subCategory": "science",
  "question": {
    "fr": "Quel est le plus grand organe du corps humain ?",
    "en": "What is the largest organ in the human body?",
    "es": "¿Cuál es el órgano más grande del cuerpo humano?",
    "de": "Was ist das größte Organ des menschlichen Körpers?"
  },
  "choiceLeft":  { "fr": "La peau", "en": "The skin", "es": "La piel", "de": "Die Haut" },
  "choiceRight": { "fr": "Le foie", "en": "The liver", "es": "El hígado", "de": "Die Leber" },
  "correctAnswer": "left",
  "explanation": {
    "fr": "La peau est le plus grand organe du corps humain, pesant environ 3,6 kg chez l'adulte.",
    "en": "The skin is the largest organ of the human body, weighing about 3.6 kg in adults.",
    "es": "La piel es el órgano más grande del cuerpo humano, con un peso de unos 3,6 kg.",
    "de": "Die Haut ist das größte Organ des menschlichen Körpers und wiegt bei Erwachsenen etwa 3,6 kg."
  },
  "emoji": "🧬"
}
```

### Culture Générale — Citations

```json
{
  "id": "cg_quotes_011",
  "topCategory": "culture_generale",
  "subCategory": "quotes",
  "question": {
    "fr": "Qui a dit « Je pense, donc je suis » ?",
    "en": "Who said 'I think, therefore I am'?",
    "es": "¿Quién dijo «Pienso, luego existo»?",
    "de": "Wer sagte «Ich denke, also bin ich»?"
  },
  "choiceLeft":  { "fr": "Descartes", "en": "Descartes", "es": "Descartes", "de": "Descartes" },
  "choiceRight": { "fr": "Voltaire", "en": "Voltaire", "es": "Voltaire", "de": "Voltaire" },
  "correctAnswer": "left",
  "explanation": {
    "fr": "René Descartes a formulé cette phrase dans le Discours de la méthode (1637).",
    "en": "René Descartes wrote this in Discourse on the Method (1637).",
    "es": "René Descartes formuló esta frase en el Discurso del método (1637).",
    "de": "René Descartes formulierte diesen Satz in der Abhandlung über die Methode (1637)."
  },
  "emoji": "💬"
}
```

### Langue — English B1

```json
{
  "id": "en_b1_011",
  "topCategory": "english",
  "subCategory": "b1",
  "question": {
    "fr": "Complétez : 'If I ___ more time, I would travel.'",
    "en": "Complete: 'If I ___ more time, I would travel.'",
    "es": "Complete: 'If I ___ more time, I would travel.'",
    "de": "Ergänzen Sie: 'If I ___ more time, I would travel.'"
  },
  "choiceLeft":  { "fr": "had", "en": "had", "es": "had", "de": "had" },
  "choiceRight": { "fr": "have", "en": "have", "es": "have", "de": "have" },
  "correctAnswer": "left",
  "explanation": {
    "fr": "Le second conditionnel utilise 'If + past simple' → 'If I had'.",
    "en": "The second conditional uses 'If + past simple' → 'If I had'.",
    "es": "El segundo condicional usa 'If + past simple' → 'If I had'.",
    "de": "Das Second Conditional verwendet 'If + Past Simple' → 'If I had'."
  },
  "emoji": "📝"
}
```

### Langue — Spanish A1

```json
{
  "id": "es_a1_011",
  "topCategory": "spanish",
  "subCategory": "a1",
  "question": {
    "fr": "Que signifie 'Agua' en espagnol ?",
    "en": "What does 'Agua' mean in Spanish?",
    "es": "¿Qué significa 'Agua'?",
    "de": "Was bedeutet 'Agua' auf Spanisch?"
  },
  "choiceLeft":  { "fr": "Eau", "en": "Water", "es": "Agua", "de": "Wasser" },
  "choiceRight": { "fr": "Feu", "en": "Fire", "es": "Fuego", "de": "Feuer" },
  "correctAnswer": "left",
  "explanation": {
    "fr": "'Agua' signifie 'eau' en espagnol.",
    "en": "'Agua' means 'water' in Spanish.",
    "es": "'Agua' significa 'water' en inglés.",
    "de": "'Agua' bedeutet 'Wasser' auf Spanisch."
  },
  "emoji": "💧"
}
```

---

## Checklist avant d'ajouter des questions

- [ ] L'ID est unique et suit la convention `<préfixe>_<sous-catégorie>_<NNN>`
- [ ] `topCategory` et `subCategory` correspondent au bon fichier JSON
- [ ] Les 4 traductions (fr/en/es/de) sont présentes pour `question`, `choiceLeft`, `choiceRight`
- [ ] `correctAnswer` vaut `"left"` ou `"right"` (et correspond bien au bon choix)
- [ ] L'`explanation` est présente et traduite dans les 4 langues
- [ ] L'`emoji` est pertinent par rapport au sujet
- [ ] Le fichier JSON reste valide après l'ajout (pas de virgule en trop, crochets fermés)
- [ ] Les faits/réponses sont vérifiés et exacts

## Valeurs possibles — Référence rapide

**topCategory :** `culture_generale`, `english`, `french`, `spanish`, `german`

**subCategory (Culture Générale) :** `science`, `history`, `inventions`, `geography`, `psychology`, `quotes`, `mathematics`, `art_culture`, `food`, `space`

**subCategory (Langues) :** `a1`, `a2`, `b1`, `b2`, `c1`, `c2`

**correctAnswer :** `left`, `right`

**Langues de traduction :** `fr`, `en`, `es`, `de`
