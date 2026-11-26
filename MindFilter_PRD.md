# Product Requirements Document (PRD)

**Projet** : MindFilter — Micro-learning pendant les temps morts (iPad)
**Version** : 1.0 (MVP)
**Date** : 25 février 2026
**Auteur** : Melvin
**Statut** : Draft

---

## 1. Vision & Mission

### Mission

Transformer les moments de temps perdu (publicités vidéo, temps de chargement, attentes) en opportunités d'apprentissage. Plutôt que de subir passivement du contenu publicitaire, l'utilisateur reprend le contrôle de son attention en accédant instantanément à du contenu éducatif, inspirant et utile.

### Positionnement

L'app ne se positionne **pas** comme un bloqueur de publicités. Elle se positionne comme un **compagnon d'apprentissage instantané** — une alternative intelligente à l'attente passive. Le message clé : *"Reprends le contrôle de ton attention. Apprends quelque chose à chaque moment perdu."*

### Proposition de valeur

- Chaque minute d'attente devient une minute d'apprentissage
- Contenu éducatif varié et configurable selon les centres d'intérêt
- Accès instantané en un geste grâce au Slide Over d'iPadOS
- Pas de compte, pas de tracking, pas de pub — juste du contenu utile

---

## 2. Nom & Identité

### Nom : **MindFilter**

**Concept** : Tu filtres ce qui entre dans ton esprit. Le bon contenu rentre, le bruit sort.

**Forces du nom** :
- Compréhension instantanée — le concept est clair en 2 secondes
- 10 lettres, facile à prononcer en anglais, français, espagnol, allemand
- "Mind" positionne dans la catégorie éducation/productivité
- "Filter" incarne la mission : trier le bon du mauvais
- SEO-friendly — les deux mots sont recherchés individuellement

**Tagline** : *"Filter your feed. Fuel your mind."*

---

## 3. Utilisateur cible

### Persona principal

- **Âge** : 16-35 ans
- **Appareil** : iPad (tous modèles compatibles iPadOS 26+)
- **Comportement** : Regarde régulièrement du contenu vidéo (YouTube, Twitch, etc.) sur son iPad
- **Frustration** : Temps perdu pendant les publicités, sentiment de passivité
- **Motivation** : Curiosité intellectuelle, envie d'optimiser son temps, culture générale

### Cas d'usage principal

1. L'utilisateur regarde une vidéo YouTube sur iPad (plein écran)
2. Une publicité commence
3. L'utilisateur **swipe depuis le bord droit de l'écran** → MindFilter réapparaît instantanément en Slide Over, toujours à la même position (1 seul geste, < 1 seconde)
4. YouTube continue de jouer en arrière-plan, visible à gauche
5. L'utilisateur lit un ou plusieurs faits en swipant horizontalement
6. Quand le bouton "Ignorer la pub" apparaît ou que la pub se termine, l'utilisateur swipe MindFilter vers le bord droit → l'app se cache (reste active en arrière-plan)
7. Retour instantané sur YouTube plein écran

> **Note** : Le swipe depuis le bord fonctionne parce que MindFilter a été placé en Slide Over une première fois (configuration initiale expliquée dans l'onboarding). Ensuite, l'app reste "cachée" sur le bord et revient toujours à la même position — aucune manipulation supplémentaire nécessaire.

### Cas d'usage secondaires

- Temps d'attente en général (transports, file d'attente) — l'app s'utilise aussi en plein écran de manière autonome
- Moment de pause : ouvrir l'app pour lire quelques faits rapides entre deux tâches

---

## 4. Spécifications fonctionnelles

### 4.1 Écran principal — Le lecteur de contenu

**Description** : Écran unique affichant un fait/citation à la fois. L'utilisateur swipe horizontalement pour passer au suivant.

**Comportement** :
- Au lancement, un fait aléatoire est affiché, issu des catégories activées par l'utilisateur
- Swipe gauche → fait suivant (nouveau fait aléatoire non vu récemment)
- Swipe droite → fait précédent (retour dans la session en cours)
- Le contenu occupe le centre de l'écran avec une typographie grande et lisible
- L'app est optimisée pour le mode Slide Over (fenêtre étroite) ET le plein écran

**Éléments affichés pour chaque fait** :
- Icône de la catégorie (petit, discret, en haut)
- Le fait / la citation / l'information (texte principal, grande taille)
- Source ou attribution si pertinent (petit texte en bas)
- Bouton favori (icône cœur ou signet) en bas à droite

**Algorithme de sélection** :
- Priorité aux contenus jamais vus
- Si tous les contenus d'une catégorie ont été vus, reprendre les plus anciennement vus (>30 jours)
- Ne jamais afficher le même contenu deux fois dans la même session
- Mélange aléatoire entre les catégories activées, avec pondération égale

### 4.2 Favoris

**Description** : L'utilisateur peut sauvegarder un fait en tapant sur l'icône favori.

**Comportement** :
- Tap sur l'icône cœur/signet → le fait est ajouté aux favoris (animation subtile de confirmation)
- Un deuxième tap retire le favori
- Section "Favoris" accessible depuis l'écran des réglages/menu
- Les favoris sont affichés en liste verticale scrollable
- Possibilité de retirer un favori depuis cette liste

**Stockage** : Local uniquement (SwiftData)

### 4.3 Historique & anti-répétition

**Description** : Système interne pour tracker les contenus déjà vus et éviter les répétitions.

**Comportement** :
- Chaque fait vu est enregistré avec sa date de dernière consultation
- L'algorithme de sélection évite les faits vus récemment (<30 jours)
- Pas d'écran "Historique" visible par l'utilisateur dans le MVP — c'est un mécanisme interne uniquement
- Les données d'historique sont stockées localement

**Stockage** : Local (SwiftData), structure : `HistoryEntry { factId: String, lastSeenAt: Date }`

### 4.4 Catégories & configuration

**Description** : L'utilisateur choisit les types de contenu qu'il souhaite voir.

**Catégories MVP** (à affiner) :

| Catégorie | Icône | Exemples de contenu |
|-----------|-------|---------------------|
| 🔬 Science | Atome | "L'eau chaude gèle plus vite que l'eau froide (effet Mpemba)" |
| 📖 Histoire | Livre | "Cléopâtre vivait plus proche dans le temps du premier iPhone que de la construction des pyramides" |
| 💡 Inventions | Ampoule | "Le micro-ondes a été inventé par accident en 1945" |
| 🌍 Géographie | Globe | "La Russie a plus de surface que Pluton" |
| 🧠 Psychologie | Cerveau | "L'effet Dunning-Kruger : moins on en sait, plus on surestime ses compétences" |
| 💬 Citations | Guillemets | Citations inspirantes de personnalités |
| 🔢 Mathématiques | Pi | Faits et curiosités mathématiques |
| 🎨 Art & Culture | Palette | Anecdotes sur l'art, la musique, le cinéma |
| 🍕 Food & Nutrition | Fourchette | Faits sur l'alimentation et la nutrition |
| 🚀 Espace | Fusée | Faits sur l'univers, les planètes, l'exploration spatiale |

**Écran de configuration** :
- Liste de toutes les catégories avec un toggle on/off pour chacune
- Au moins une catégorie doit être activée (sinon : message d'avertissement)
- Par défaut, toutes les catégories sont activées au premier lancement
- Accessible via une icône de réglages (engrenage) sur l'écran principal

### 4.5 Onboarding

**Description** : Tutoriel au premier lancement qui explique comment utiliser l'app, et surtout comment la configurer en Slide Over pour l'utiliser pendant les pubs.

**Flux** (3-4 écrans swipables) :

**Écran 1 — Bienvenue**
- Titre : "Learn something every time you wait."
- Sous-titre : "Turn idle moments into knowledge."
- Illustration/animation simple
- Bouton : "Get Started"

**Écran 2 — Choisis tes centres d'intérêt**
- Grille de catégories avec toggles
- Toutes activées par défaut
- L'utilisateur peut personnaliser immédiatement
- Bouton : "Continue"

**Écran 3 — Comment utiliser avec Slide Over**
- Tutoriel visuel étape par étape (images/GIFs)
- **Configuration initiale (une seule fois) :**
  - Étape 1 : "Add MindFilter to your Dock" — glisser l'icône dans le Dock
  - Étape 2 : "Drag it to the right edge of your screen" — l'app s'ouvre en Slide Over et se cache sur le bord
- **Usage quotidien (à chaque pub) :**
  - Étape 3 : "Swipe from the right edge" — MindFilter réapparaît instantanément, toujours à la même position
  - Étape 4 : "Swipe through facts while you wait"
  - Étape 5 : "Swipe it away when you're done" — l'app se cache, prête pour la prochaine pub
- Message clé : *"One swipe. That's all it takes."*
- Bouton : "Start Learning"

**Écran 4 — Paywall**
- Récapitulatif de la valeur : "400+ facts. 10 categories. 4 languages."
- Prix affiché clairement : "Unlock MindFilter — 9,99 €"
- Mention : "One purchase. Lifetime access. No subscription."
- Bouton principal : "Unlock MindFilter"
- Bouton secondaire discret : "Restore Purchase"
- Si l'utilisateur ferme → retour à cet écran au prochain lancement

> **Note** : L'onboarding ne s'affiche qu'au premier lancement. L'utilisateur peut le revoir depuis les réglages.

### 4.6 Écran Réglages

**Contenu** :
- **Catégories** : Toggles pour activer/désactiver chaque catégorie de contenu
- **Favoris** : Accès à la liste des favoris sauvegardés
- **Apparence** : Mode clair / sombre / automatique (suit le système)
- **Langue du contenu** : Sélecteur de langue pour le contenu affiché
- **Revoir le tutoriel** : Relancer l'onboarding Slide Over
- **Restaurer l'achat** : Bouton pour restaurer l'achat in-app (obligatoire Apple)
- **À propos** : Version, crédits, lien vers les conditions d'utilisation et politique de confidentialité
- **Contact / Feedback** : Lien mailto ou formulaire simple

---

## 5. Contenu

### 5.1 Source et format

- Tout le contenu est **pré-chargé** dans l'app (fichier JSON embarqué dans le bundle)
- Pas de backend, pas de fetch réseau pour le contenu
- Les mises à jour de contenu se font via les mises à jour de l'app sur l'App Store

**Processus de création du contenu** :
- Les faits sont générés automatiquement via un **skill Claude** dédié
- Le skill génère les faits par batch de 5, en respectant la structure de données et les 4 langues
- Les faits générés sont stockés dans une **base de données** locale (SQLite ou JSON de référence)
- Une fois le skill validé sur un batch de 5 faits, il est utilisé pour générer l'ensemble des 400 faits
- Chaque fait passe par une vérification manuelle avant inclusion dans le bundle
- Le fichier `facts.json` final est exporté depuis la base de données et embarqué dans l'app

### 5.2 Structure d'un fait

```json
{
  "id": "sci_042",
  "category": "science",
  "content": {
    "en": "Hot water can freeze faster than cold water. This counterintuitive phenomenon is known as the Mpemba effect.",
    "fr": "L'eau chaude peut geler plus vite que l'eau froide. Ce phénomène contre-intuitif est connu sous le nom d'effet Mpemba.",
    "es": "El agua caliente puede congelarse más rápido que el agua fría. Este fenómeno contraintuitivo se conoce como efecto Mpemba.",
    "de": "Heißes Wasser kann schneller gefrieren als kaltes Wasser. Dieses kontraintuitive Phänomen ist als Mpemba-Effekt bekannt."
  },
  "source": "University of Cambridge, 2012",
  "emoji": "🧊"
}
```

### 5.3 Volume de contenu (MVP)

| Catégorie | Nombre de faits (MVP) |
|-----------|-----------------------|
| Science | 50 |
| Histoire | 50 |
| Inventions | 30 |
| Géographie | 40 |
| Psychologie | 30 |
| Citations | 50 |
| Mathématiques | 30 |
| Art & Culture | 40 |
| Food & Nutrition | 30 |
| Espace | 50 |
| **Total** | **~400 faits** |

### 5.4 Langues supportées (MVP)

| Langue | Code | Priorité |
|--------|------|----------|
| Anglais | en | P0 — Langue par défaut |
| Français | fr | P0 |
| Espagnol | es | P1 |
| Allemand | de | P1 |
| Portugais | pt | P2 (post-MVP) |
| Italien | it | P2 (post-MVP) |

- L'app détecte la langue du système au premier lancement et pré-sélectionne la langue correspondante
- L'utilisateur peut changer la langue du contenu dans les réglages
- L'interface de l'app (boutons, titres, onboarding) est localisée via le système natif de localisation d'Apple (String Catalogs `.xcstrings`)

---

## 6. Monétisation

### Modèle : Achat unique (one-time purchase)

**Prix** : 9,99 € / $9.99 (équivalents locaux gérés par Apple)

**Modèle** : Paywall direct au premier lancement (après l'onboarding). Pas de période d'essai gratuite — l'utilisateur achète pour utiliser l'app.

**Paywall** :
- Affiché à la fin de l'onboarding (écran 4), après que l'utilisateur a compris la valeur de l'app
- Design clair et transparent : ce que l'app fait, le prix unique, ce qui est inclus
- Message clé : "Un seul achat. Accès à vie. Pas d'abonnement."
- Bouton principal : "Unlock MindFilter — 9,99 €"
- Bouton secondaire : "Restaurer l'achat" (obligatoire pour Apple)
- Si l'utilisateur ferme sans acheter → retour au paywall à chaque ouverture de l'app

**Ce qui est inclus dans l'achat** :
- Accès permanent à tout le contenu (400+ faits)
- Toutes les futures mises à jour de contenu incluses
- Toutes les catégories débloquées
- Aucun achat supplémentaire, jamais

**Implémentation technique** :
- Utilisation de **StoreKit 2** (API native Swift, async/await)
- Non-consumable In-App Purchase (achat unique)
- Vérification des transactions via `Transaction.currentEntitlements` (pas de serveur)
- StoreKit 2 gère automatiquement la persistance et la restauration des achats

---

## 7. Design & Interface

### 7.1 Principes de design

- **Épuré et focalisé** : Un seul fait visible à la fois, pas de distraction
- **Lisibilité maximale** : Grande typographie, contraste élevé, espacement généreux
- **Adaptatif** : L'interface s'adapte parfaitement au Slide Over (fenêtre étroite ~320-400pt) ET au plein écran
- **Respectueux du système** : Suit le dark mode / light mode d'iPadOS, utilise les polices système (SF Pro)
- **Aucune animation excessive** : Transitions fluides mais sobres
- **Illustrations simples** : SF Symbols (natifs, 5000+ icônes) et emojis pour les catégories et l'UI. Pas d'illustrations custom complexes. Si des visuels sont nécessaires pour l'onboarding, ils seront créés via Canva ou IA générative.

### 7.2 Palette de couleurs

| Élément | Light Mode | Dark Mode |
|---------|------------|-----------|
| Fond | #FFFFFF (blanc pur) | #1C1C1E (gris très sombre) |
| Texte principal | #1C1C1E | #FFFFFF |
| Texte secondaire | #8E8E93 | #8E8E93 |
| Accent | #007AFF (bleu iOS) | #0A84FF |
| Catégorie badge | Couleur spécifique par catégorie | Idem, légèrement désaturé |
| Fond de carte | #F2F2F7 | #2C2C2E |

### 7.3 Typographie

| Élément | Font | Taille (plein écran) | Taille (Slide Over) |
|---------|------|----------------------|---------------------|
| Fait principal | SF Pro Display, Medium | 24pt | 18pt |
| Source/attribution | SF Pro Text, Regular | 14pt | 12pt |
| Catégorie label | SF Pro Text, Semibold | 12pt | 10pt |
| Boutons/UI | SF Pro Text, Medium | 16pt | 14pt |

### 7.4 Layout — Écran principal

```
┌──────────────────────────────┐
│  [⚙️]              [🔖 cat] │  ← Header : réglages + badge catégorie
│                              │
│                              │
│                              │
│    "L'eau chaude peut        │
│     geler plus vite que      │
│     l'eau froide. Ce         │  ← Fait : centré verticalement
│     phénomène est connu      │     Grande typographie
│     sous le nom d'effet      │
│     Mpemba."                 │
│                              │
│                              │
│                              │
│    — University of Cambridge │  ← Source (optionnel)
│                              │
│              [♡]             │  ← Bouton favori
│  ● ● ○ ○ ○                  │  ← Indicateur de progression (optionnel, discret)
└──────────────────────────────┘
         ← swipe →               ← Geste pour changer de fait
```

### 7.5 Layout — Slide Over (utilisation principale)

```
┌────────────┐
│ [⚙]  [cat] │
│            │
│            │
│  "L'eau    │
│   chaude   │
│   peut     │  ← Le même contenu
│   geler    │     adapté à la
│   plus     │     largeur réduite
│   vite..." │
│            │
│            │
│   — UoC    │
│     [♡]    │
└────────────┘
     ↕
  YouTube     ← ~10% de l'écran visible en bas
```

---

## 8. Architecture technique

### 8.1 Stack technologique

| Composant | Technologie | Justification |
|-----------|-------------|---------------|
| Framework | **SwiftUI** (iPadOS 18+) | Framework natif Apple, parfait pour une app iPad-only. Slide Over, multitâche et gestures natifs sans configuration. |
| Langage | **Swift 6** | Type safety, concurrency moderne (async/await), performance native |
| Navigation | **NavigationStack** | Navigation native SwiftUI, simple et performante |
| Stockage local | **SwiftData** | Framework natif Apple pour la persistance (favoris, historique, préférences). Remplace Core Data avec une API Swift-native. |
| In-App Purchase | **StoreKit 2** | API native async/await, ~10 lignes pour un achat non-consumable. Gestion automatique des receipts et restauration. |
| Localisation | **String Catalogs** (`.xcstrings`) | Système natif Xcode, gestion visuelle des traductions, détection automatique des clés |
| Animations | **SwiftUI Animations** | Animations natives (`.animation()`, `withAnimation`, `matchedGeometryEffect`). Aucune dépendance externe. |
| Geste swipe | **TabView + .tabViewStyle(.page)** ou `DragGesture` | Swipe horizontal natif, fluide, zéro config |
| Build & Deploy | **Xcode + xcodebuild** | Build local sur MacBook, déploiement direct vers TestFlight et App Store via Xcode ou `xcodebuild` |
| IDE | **Xcode 16+** | Previews SwiftUI en temps réel, simulateur iPad intégré |

### 8.2 Structure du projet

```
MindFilter/
├── MindFilter/
│   ├── MindFilterApp.swift              ← Point d'entrée de l'app (@main)
│   ├── ContentView.swift                ← Vue racine (routing onboarding/paywall/main)
│   │
│   ├── Models/
│   │   ├── Fact.swift                   ← Struct Fact (Codable, Identifiable)
│   │   ├── Category.swift               ← Enum CategoryId + struct Category
│   │   ├── HistoryEntry.swift           ← Modèle SwiftData pour l'historique
│   │   └── FavoriteEntry.swift          ← Modèle SwiftData pour les favoris
│   │
│   ├── Views/
│   │   ├── FactReaderView.swift         ← Écran principal — swipe entre les faits
│   │   ├── FactCardView.swift           ← Carte d'un fait individuel
│   │   ├── FavoritesView.swift          ← Liste des favoris
│   │   ├── SettingsView.swift           ← Écran réglages
│   │   ├── OnboardingView.swift         ← Flux d'onboarding (TabView swipable)
│   │   ├── PaywallView.swift            ← Écran d'achat
│   │   └── Components/
│   │       ├── CategoryBadge.swift      ← Badge de catégorie (SF Symbol + label)
│   │       ├── FavoriteButton.swift     ← Bouton cœur avec animation
│   │       └── CategoryToggle.swift     ← Toggle on/off pour une catégorie
│   │
│   ├── ViewModels/
│   │   ├── FactViewModel.swift          ← Logique de sélection, session, historique
│   │   ├── StoreViewModel.swift         ← Gestion StoreKit 2 (achat + restauration)
│   │   └── SettingsViewModel.swift      ← Préférences utilisateur (catégories, langue, thème)
│   │
│   ├── Services/
│   │   ├── FactSelector.swift           ← Algorithme de sélection (anti-répétition)
│   │   └── FactLoader.swift             ← Chargement et décodage de facts.json
│   │
│   ├── Resources/
│   │   ├── facts.json                   ← Base de données de faits (toutes langues)
│   │   ├── Localizable.xcstrings        ← String Catalog — traductions interface
│   │   └── Assets.xcassets              ← App icon, couleurs, images onboarding
│   │
│   └── Info.plist                       ← Configuration de l'app
│
├── MindFilter.xcodeproj                 ← Projet Xcode
└── MindFilterTests/                     ← Tests unitaires (FactSelector, etc.)
```

### 8.3 Modèles de données

```swift
// MARK: - Fact (Codable, chargé depuis facts.json)

struct Fact: Codable, Identifiable {
    let id: String                              // ex: "sci_042"
    let category: CategoryId                    // ex: .science
    let content: [String: String]               // ["en": "...", "fr": "...", ...]
    let source: String?                         // attribution optionnelle
    let emoji: String?                          // emoji décoratif

    func localizedContent(for language: LanguageCode) -> String {
        content[language.rawValue] ?? content["en"] ?? ""
    }
}

// MARK: - Category

enum CategoryId: String, Codable, CaseIterable {
    case science, history, inventions, geography
    case psychology, quotes, mathematics
    case artCulture = "art_culture"
    case food, space
}

enum LanguageCode: String, Codable, CaseIterable {
    case en, fr, es, de
}

struct Category {
    let id: CategoryId
    let sfSymbol: String                        // SF Symbol natif (ex: "atom")
    let emoji: String                           // emoji fallback
    let color: Color                            // couleur accent
}

// MARK: - SwiftData Models (persistance locale)

import SwiftData

@Model
class HistoryEntry {
    var factId: String
    var lastSeenAt: Date

    init(factId: String, lastSeenAt: Date = .now) {
        self.factId = factId
        self.lastSeenAt = lastSeenAt
    }
}

@Model
class FavoriteEntry {
    var factId: String
    var savedAt: Date

    init(factId: String, savedAt: Date = .now) {
        self.factId = factId
        self.savedAt = savedAt
    }
}

// MARK: - User Preferences (stocké via @AppStorage / UserDefaults)

// Les préférences simples sont stockées via @AppStorage :
// - enabledCategories: [CategoryId]    → UserDefaults (encodé JSON)
// - contentLanguage: LanguageCode      → UserDefaults
// - onboardingCompleted: Bool          → UserDefaults
// - hasPurchased: Bool                 → vérifié via StoreKit 2 Transaction.currentEntitlements
```

### 8.4 Algorithme de sélection des faits

```
FONCTION getNextFact(enabledCategories, history, sessionShown):

  1. Charger tous les faits des catégories activées
  2. Exclure les faits déjà montrés dans cette session (sessionShown[])
  3. Trier par priorité :
     a. Jamais vus (pas dans history) → priorité maximale
     b. Vus il y a plus de 30 jours → priorité haute
     c. Vus il y a 7-30 jours → priorité moyenne
     d. Vus il y a moins de 7 jours → priorité basse (dernier recours)
  4. Dans le groupe de priorité le plus élevé non vide :
     - Sélection aléatoire
     - Équilibrage entre catégories (round-robin si possible)
  5. Ajouter le fait à sessionShown[] et mettre à jour history
  6. Retourner le fait
```

### 8.5 Workflow de développement (macOS)

```
ENVIRONNEMENT LOCAL (MacBook) :
  ├── Xcode 16+ (simulateur iPad intégré)
  ├── Swift 6 / SwiftUI
  ├── Previews SwiftUI pour itération rapide
  └── iPad connecté en USB ou Wi-Fi pour tests device

BUILD & TEST :
  ├── Cmd+R dans Xcode → lance sur simulateur iPad ou device connecté
  ├── Simulateur iPad supporte Slide Over / Split View pour tester les layouts
  └── StoreKit Testing in Xcode → tester les IAP sans App Store Connect

DÉPLOIEMENT TESTFLIGHT :
  ├── Product → Archive dans Xcode
  ├── Distribute App → TestFlight (Internal Testing)
  └── Le build apparaît dans TestFlight en ~15 min (testeur interne, pas de review)

WORKFLOW QUOTIDIEN :
  1. Développer avec les Previews SwiftUI (feedback instantané)
  2. Tester sur simulateur iPad (Slide Over, Split View, rotations)
  3. Tester les IAP avec StoreKit Configuration File (.storekit) dans Xcode
  4. Quand prêt → Archive + TestFlight pour test réel sur iPad
  5. Soumission App Store : Product → Archive → Distribute App → App Store Connect
```

> **Avantage SwiftUI** : Les Previews permettent de voir les changements en temps réel sans compiler. Le simulateur iPad supporte tous les modes multitâche. Le StoreKit Testing intégré à Xcode permet de tester les achats in-app sans configuration serveur.

---

## 9. Compatibilité & contraintes iPadOS

### 9.1 Versions supportées

| Élément | Minimum | Recommandé |
|---------|---------|------------|
| iPadOS | 26.1 | 26.2+ |
| iPad | Tous les modèles compatibles iPadOS 26 | iPad avec puce M1+ pour les meilleures performances |

### 9.2 Modes d'affichage

L'app doit fonctionner correctement dans tous ces contextes :

| Mode | Dimensions approximatives | Priorité |
|------|--------------------------|----------|
| **Slide Over** | ~320-400pt de large, hauteur plein écran | P0 — Usage principal |
| **Plein écran** | Largeur totale de l'iPad | P0 — Usage autonome |
| **Split View (50/50)** | ~50% de la largeur | P1 |
| **Fenêtre redimensionnable** | Variable | P1 |

### 9.3 Configuration Slide Over — Guide utilisateur

L'utilisateur doit être en mode **Windowed Apps** ou **Stage Manager** (pas "Full Screen Apps") pour utiliser Slide Over.

#### Configuration initiale (une seule fois)

1. Ajouter MindFilter au Dock (maintenir l'icône → glisser dans le Dock)
2. Ouvrir YouTube en plein écran
3. Afficher le Dock (swipe lent depuis le bas) → glisser l'icône MindFilter vers le bord droit de l'écran
4. MindFilter s'ouvre en Slide Over puis se cache sur le bord droit — **configuration terminée**

#### Usage quotidien (mécanisme principal)

| Action | Geste | Vitesse |
|--------|-------|---------|
| Ouvrir MindFilter | Swipe depuis le bord droit de l'écran | < 1 seconde |
| Cacher MindFilter | Swipe MindFilter vers le bord droit | < 1 seconde |

- L'app reste **toujours à la même position** — pas besoin de la repositionner
- L'app reste **active en arrière-plan** quand elle est cachée sur le bord
- YouTube continue de jouer pendant toute la durée d'utilisation de MindFilter

> **Message clé pour l'utilisateur** : *"One swipe. That's all it takes."* — après la configuration initiale, un seul geste suffit à chaque pub.

---

## 10. Localisation

### 10.1 Stratégie

Deux couches de localisation distinctes :

1. **Interface de l'app** (boutons, titres, onboarding) : localisée via **String Catalogs** (`.xcstrings`), suit la langue système de l'iPad
2. **Contenu des faits** : langue configurable indépendamment dans les réglages (un utilisateur français peut vouloir des faits en anglais)

### 10.2 Langues MVP

| Langue | Interface | Contenu des faits |
|--------|-----------|-------------------|
| Anglais | ✅ | ✅ (400 faits) |
| Français | ✅ | ✅ (400 faits) |
| Espagnol | ✅ | ✅ (400 faits) |
| Allemand | ✅ | ✅ (400 faits) |

### 10.3 Processus d'ajout de langues post-MVP

1. Ajouter la langue dans le String Catalog `Localizable.xcstrings` via Xcode (~50 clés, interface visuelle)
2. Ajouter les traductions dans `facts.json` pour chaque fait existant
3. Mettre à jour l'app sur l'App Store

---

## 11. App Store

### 11.1 Métadonnées

| Champ | Contenu (anglais) |
|-------|-------------------|
| **Nom** | MindFilter |
| **Sous-titre** | Filter your feed. Fuel your mind. |
| **Catégorie principale** | Education |
| **Catégorie secondaire** | Productivity |
| **Mots-clés** | learn, facts, knowledge, trivia, education, curiosity, micro-learning, idle, wait, discover |
| **Classification d'âge** | 4+ |

### 11.2 Description App Store (anglais)

> **Turn every idle moment into a learning opportunity.**
>
> MindFilter is a micro-learning companion for iPad designed for one thing: filling your waiting moments with fascinating knowledge instead of passive scrolling.
>
> Open it as a Slide Over window while watching videos, and swipe through curated facts about science, history, psychology, space, and more. When you're done, swipe it away in an instant.
>
> **Features:**
> - 400+ handpicked facts across 10 categories
> - Swipe-based browsing — one fact at a time, distraction-free
> - Choose your interests — toggle categories on and off
> - Save your favorites for later
> - Optimized for Slide Over — designed to work alongside your other apps
> - Available in English, French, Spanish, and German
> - No ads. No tracking. No subscriptions. One purchase, forever yours.
>
> Your attention is valuable. Filter the noise. Fuel your mind.

### 11.3 Screenshots nécessaires

| # | Contenu | Appareil |
|---|---------|----------|
| 1 | Écran principal avec un fait (plein écran) | iPad Pro 12.9" |
| 2 | L'app en Slide Over à côté de YouTube | iPad Pro 12.9" |
| 3 | Écran de sélection des catégories | iPad Pro 12.9" |
| 4 | Un fait favori sauvegardé | iPad Pro 12.9" |
| 5 | L'onboarding "Comment utiliser en Slide Over" | iPad Pro 12.9" |

### 11.4 Politique de confidentialité

Données collectées : **Aucune**.
- Pas de compte utilisateur
- Pas d'analytics
- Pas de tracking
- Toutes les données restent sur l'appareil (favoris, historique, préférences)
- Seule donnée transmise : le receipt d'achat à Apple pour validation (standard StoreKit)

**Hébergement** : Page statique sur **GitHub Pages** (gratuit). Un simple repository GitHub avec un fichier `index.html` contenant la privacy policy et les conditions d'utilisation. URL type : `https://[username].github.io/mindfilter-legal/`

---

## 12. Risques & contraintes identifiés

| Risque | Impact | Probabilité | Mitigation |
|--------|--------|-------------|------------|
| **Apple rejette l'app** car le concept est perçu comme anti-pub | Élevé | Faible | Le positionnement ne mentionne jamais le blocage de pubs. L'app est un outil d'apprentissage autonome qui fonctionne indépendamment de YouTube. |
| **Slide Over mal compris** par les utilisateurs | Moyen | Moyen | Onboarding très visuel avec GIFs étape par étape. Tutoriel accessible à tout moment. |
| **Contenu insuffisant** — les utilisateurs voient des répétitions trop vite | Moyen | Moyen | 400 faits pour le MVP. Avec ~10 faits vus par session, ~2 sessions/jour, ça couvre ~20 jours sans répétition. Ajouter du contenu dans les mises à jour suivantes. |
| **Taux de conversion faible** — paywall direct sans essai gratuit peut freiner | Moyen | Moyen | L'onboarding doit bien démontrer la valeur avant le paywall. Les screenshots et la description App Store doivent être convaincants. Possibilité d'ajuster le prix (4,99 € vs 9,99 €) si le taux est trop bas. |
| **L'achat unique ne génère pas assez de revenus** pour justifier les mises à jour | Faible | Moyen | Le coût de maintenance est très faible (pas de backend). Les mises à jour de contenu sont générées via le skill Claude. Envisager un pack d'extension si la base d'utilisateurs grandit. |
| **Mode "Full Screen Apps"** empêche le Slide Over | Moyen | Moyen | Clairement expliqué dans l'onboarding : il faut être en mode Windowed Apps. L'app fonctionne aussi seule en plein écran. |
| **Nécessite un Mac** pour le développement | Faible | Nul | MacBook disponible. Xcode est l'environnement natif, aucun workaround nécessaire. |

---

## 13. Roadmap

### Phase 1 — MVP (5-7 semaines)

| Semaine | Tâche |
|---------|-------|
| S1 | Setup projet Xcode (SwiftUI, SwiftData, cible iPad), structure des fichiers, modèles de données, chargement du JSON |
| S2 | Écran principal (`FactReaderView`) + swipe horizontal (TabView/DragGesture) + algorithme de sélection + responsive Slide Over |
| S3 | Catégories (toggles, SettingsView) + favoris (SwiftData, FavoritesView) + historique anti-répétition |
| S4 | Création du skill Claude pour générer les faits (validation sur batch de 5, puis production des 400 faits x 4 langues) |
| S5 | Onboarding (4 écrans dont paywall) + localisation interface (String Catalogs en/fr/es/de) |
| S6 | StoreKit 2 (achat unique + restauration + StoreKit Testing dans Xcode) + paywall fonctionnel |
| S7 | Test sur iPad via TestFlight + polish UI + dark mode + privacy policy GitHub Pages + soumission App Store |

### Phase 2 — Post-lancement (optionnel)

- Ajout de contenu régulier (packs de 100+ faits par mise à jour)
- Nouvelles catégories (Technologie, Langues étrangères, Philosophie)
- Nouvelles langues (Portugais, Italien, Japonais)
- Widget iPad : affiche un fait du jour directement sur l'écran d'accueil
- Recherche dans les faits (barre de recherche dans les favoris/historique)
- Version iPhone en mode standalone (pas de Slide Over, mais utilisable comme app de micro-learning)

---

## 14. Métriques de succès

| Métrique | Objectif MVP (3 mois) |
|----------|----------------------|
| Téléchargements (page vue) | 5 000+ |
| Taux de conversion (page → achat) | >5% |
| Note App Store | >4.5 / 5 |
| Revenus | 2 500€+ |

> **Note** : Sans analytics intégrée, ces métriques seront suivies via App Store Connect (téléchargements, revenus, notes) uniquement.

---

## 15. Questions ouvertes

| # | Question | Impact sur le développement |
|---|----------|----------------------------|
| 1 | Vérifier la disponibilité de "MindFilter" sur l'App Store (nom + bundle ID) | Nécessaire avant la création du projet sur App Store Connect |
| 2 | Définir les catégories finales — les 10 proposées sont-elles les bonnes ? | Affecte la structure du contenu et le skill de génération |
| 3 | Quel compte GitHub pour héberger la privacy policy ? (créer le repo mindfilter-legal) | Obligatoire avant soumission App Store |
| 4 | Valider le prix de 9,99 € — tester l'élasticité (4,99 € vs 9,99 €) ? | Affecte le taux de conversion |

### Questions résolues

| Question | Décision |
|----------|----------|
| Nom de l'app | **MindFilter** |
| Stack technique | **SwiftUI natif** (Swift 6, SwiftData, StoreKit 2) — app iPad-only, MacBook disponible, pas besoin de cross-platform |
| Période d'essai | **Non** — paywall direct après onboarding |
| Rédaction des faits | **Automatisée via un skill Claude** — batch de 5 pour validation, puis production complète |
| Illustrations | **Simples** — emojis, SF Symbols, visuels Canva/IA si besoin |
| Hébergement privacy policy | **GitHub Pages** (gratuit) |
| Modèle économique | **Achat unique 9,99 €** — pas d'abonnement |
