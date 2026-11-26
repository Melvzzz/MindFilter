# MindFilter — Style Guide
**Version** : 1.0
**Date** : 26 février 2026
**Inspiration** : CoinCraft (gradient hero + section blanche + typographie bold)

---

## 1. Philosophie visuelle

L'app doit ressentir **premium, calme et intellectuel** — pas gamifiée, pas criarde. L'utilisateur l'ouvre pendant une pub et doit avoir l'impression de consulter quelque chose de qualitatif.

Style global : **gradient hero bold + carte blanche épurée**
Référence : L'image CoinCraft — section supérieure en dégradé avec éléments flottants, section inférieure blanche avec typographie forte et CTA sombre arrondi.

---

## 2. Palette de couleurs

### 2.1 Couleurs principales

| Token | Valeur | Usage |
|-------|--------|-------|
| `gradientTop` | `#6B4EFF` | Début du dégradé hero (violet profond) |
| `gradientBottom` | `#B06EFF` | Fin du dégradé hero (lilas clair) |
| `surface` | `#FFFFFF` | Fond des cartes et sections contenu |
| `surfaceSecondary` | `#F5F5F7` | Fond de l'écran, zones secondaires |
| `textPrimary` | `#1C1C1E` | Texte principal (titres, faits) |
| `textSecondary` | `#6E6E73` | Sous-titres, sources, labels discrets |
| `textOnGradient` | `#FFFFFF` | Texte sur fond dégradé |
| `accent` | `#6B4EFF` | CTA, liens, éléments actifs |
| `accentDark` | `#1C1C1E` | Bouton CTA principal (noir mat) |

### 2.2 Couleurs par catégorie

Chaque catégorie a une teinte propre — utilisée pour les badges et icônes.

| Catégorie | Couleur | Hex |
|-----------|---------|-----|
| Science | Bleu ciel | `#0EA5E9` |
| Histoire | Ambre | `#F59E0B` |
| Inventions | Orange | `#F97316` |
| Géographie | Vert | `#22C55E` |
| Psychologie | Violet | `#A855F7` |
| Citations | Rose | `#EC4899` |
| Mathématiques | Indigo | `#6366F1` |
| Art & Culture | Corail | `#EF4444` |
| Food & Nutrition | Lime | `#84CC16` |
| Espace | Bleu nuit | `#3B82F6` |

### 2.3 Dark Mode

| Token | Light | Dark |
|-------|-------|------|
| `surface` | `#FFFFFF` | `#1C1C1E` |
| `surfaceSecondary` | `#F5F5F7` | `#2C2C2E` |
| `textPrimary` | `#1C1C1E` | `#FFFFFF` |
| `textSecondary` | `#6E6E73` | `#8E8E93` |
| `accentDark` (bouton CTA) | `#1C1C1E` | `#FFFFFF` |
| Gradient | inchangé | inchangé (dégradé identique) |

---

## 3. Typographie

Police système Apple : **SF Pro Display** (titres) + **SF Pro Text** (corps).
Aucune police custom — cohérence native iPadOS, zéro performance cost.

### 3.1 Échelle typographique

| Token | Police | Poids | Taille (plein écran) | Taille (Slide Over ~360pt) |
|-------|--------|-------|----------------------|-----------------------------|
| `displayLarge` | SF Pro Display | Bold (700) | 36pt | 26pt |
| `displayMedium` | SF Pro Display | Bold (700) | 28pt | 22pt |
| `headline` | SF Pro Display | Semibold (600) | 22pt | 18pt |
| `factText` | SF Pro Display | Medium (500) | 24pt | 18pt |
| `body` | SF Pro Text | Regular (400) | 17pt | 15pt |
| `caption` | SF Pro Text | Regular (400) | 13pt | 12pt |
| `label` | SF Pro Text | Semibold (600) | 12pt | 11pt |

### 3.2 Règles d'usage

- Les **faits** (`factText`) : alignement centré, line height × 1.4, couleur `textPrimary`
- Les **sources** : `caption`, couleur `textSecondary`, aligné à gauche ou centré
- Les **titres d'onboarding** : `displayLarge`, centré, sur fond blanc ou dégradé
- Les **sous-titres d'onboarding** : `body`, centré, couleur `textSecondary`
- Jamais de texte trop petit sur fond dégradé — minimum `body` (17pt)

---

## 4. Composants

### 4.1 Bouton CTA Principal

Inspiré du "Get Started" de CoinCraft.

```
┌────────────────────────────────────────┐
│         Unlock MindFilter              │
└────────────────────────────────────────┘
```

| Propriété | Valeur |
|-----------|--------|
| Background | `accentDark` (#1C1C1E) |
| Texte | Blanc, SF Pro Text Semibold, 17pt |
| Corner radius | 16pt (pill sur petites largeurs, rounded-rect sur grand écran) |
| Hauteur | 56pt |
| Padding horizontal | 24pt |
| Largeur | max 480pt, `fill` en Slide Over |
| Ombre | none (design flat) |

### 4.2 Bouton Secondaire / Lien texte

```
Already have an account?  Login
```

| Propriété | Valeur |
|-----------|--------|
| Texte normal | `textSecondary`, SF Pro Text Regular, 15pt |
| Texte lien | `accent` (#6B4EFF), SF Pro Text Semibold, 15pt |
| Background | none |

### 4.3 Carte de fait (FactCard)

La carte principale qui contient le fait affiché.

```
┌──────────────────────────────────────┐
│  🔬  Science               ·  ·  ○  │  ← badge catégorie + indicateur
│                                      │
│                                      │
│   "L'eau chaude peut geler           │
│    plus vite que l'eau froide.       │
│    Ce phénomène est connu sous       │
│    le nom d'effet Mpemba."           │
│                                      │
│                                      │
│   — University of Cambridge, 2012    │
│                                 ♡    │  ← bouton favori
└──────────────────────────────────────┘
```

| Propriété | Valeur |
|-----------|--------|
| Background | `surface` blanc |
| Corner radius | 24pt |
| Padding interne | 24pt (16pt en Slide Over) |
| Ombre | `0 4pt 20pt rgba(0,0,0,0.08)` |
| Texte du fait | `factText` + `textPrimary` |
| Source | `caption` + `textSecondary` |

### 4.4 Badge de catégorie

```
[🔬 Science]
```

| Propriété | Valeur |
|-----------|--------|
| Background | Couleur catégorie à 12% d'opacité |
| Texte | Couleur catégorie à 100%, `label` (12pt Semibold) |
| Corner radius | 8pt |
| Padding | 6pt vertical × 10pt horizontal |
| Icône | SF Symbol correspondant, taille 12pt |

### 4.5 Toggle de catégorie (onboarding & réglages)

```
┌─────────────────────────────┐
│  🔬  Science           [●]  │
└─────────────────────────────┘
```

| Propriété | Valeur |
|-----------|--------|
| Background de la cellule | `surfaceSecondary` |
| Corner radius | 12pt |
| Toggle ON | couleur de la catégorie |
| Toggle OFF | gris système |
| Texte | `body` + `textPrimary` |

### 4.6 Bouton favori (cœur)

| État | Icône SF | Couleur |
|------|----------|---------|
| Non favori | `heart` | `textSecondary` |
| Favori | `heart.fill` | `#FF375F` (rouge iOS) |
| Animation | scale 1.0 → 1.3 → 1.0 + spring | — |

---

## 5. Layouts

### 5.1 Écran d'onboarding — Structure "Hero + Blanc"

Directement inspiré de l'image CoinCraft.

```
┌─────────────────────────────────────────┐
│                                         │
│   ✦  🧠  ✦  💡  ✦  📖  ✦  🚀  ✦       │  ← Emojis flottants (animated)
│                                         │  GRADIENT SECTION
│       ✦  🔬  ✦  🌍  ✦  💬  ✦           │  (60% de la hauteur)
│                                         │  #6B4EFF → #B06EFF
│                                         │
├─────────────────────────────────────────┤  ← Coin radius 32pt
│                                         │
│   Learn something                       │  ← displayLarge, textPrimary
│   every time you wait.                  │
│                                         │
│   Turn idle moments into knowledge.     │  ← body, textSecondary
│                                         │
│      ● ○ ○ ○                            │  ← page indicator
│                                         │
│  ┌─────────────────────────────────┐    │
│  │         Get Started             │    │  ← Bouton CTA principal
│  └─────────────────────────────────┘    │
│                                         │
│       Skip onboarding                   │  ← lien texte discret
│                                         │
└─────────────────────────────────────────┘
```

**Proportions** :
- Section dégradé : 58% de la hauteur de l'écran
- Section blanche : 42%
- La section blanche a un `topCornerRadius` de 32pt qui chevauche le dégradé de ~16pt
- Padding horizontal global : 24pt (16pt en Slide Over)

### 5.2 Écran principal — Lecteur de faits

```
┌─────────────────────────────────────────┐
│  [⚙️]                        [🔬 Science] │  ← Barre top, fond surfaceSecondary
│─────────────────────────────────────────│
│                                         │
│   ┌─────────────────────────────────┐   │
│   │  🔬  Science          · · ○ ○ ○  │   │
│   │                                 │   │
│   │                                 │   │
│   │  "L'eau chaude peut geler       │   │
│   │   plus vite que l'eau froide."  │   │
│   │                                 │   │
│   │  — University of Cambridge      │   │
│   │                            ♡   │   │
│   └─────────────────────────────────┘   │
│                                         │
│          ← swipe →                      │
└─────────────────────────────────────────┘
```

- Fond de l'écran : `surfaceSecondary` (#F5F5F7)
- La carte occupe 88% de la largeur, centrée
- Padding vertical depuis la barre de navigation : 16pt

### 5.3 Slide Over (priorité P0)

En mode Slide Over (~360pt de large), les adaptations :
- Padding horizontal réduit à 12pt
- Police `factText` : 18pt (vs 24pt plein écran)
- Badge catégorie : icône seule (sans label texte si < 380pt)
- Bouton CTA : `fill` pleine largeur
- Section dégradé onboarding : 52% de hauteur (légèrement réduit)

---

## 6. Animations & Interactions

| Interaction | Animation | Durée |
|-------------|-----------|-------|
| Swipe entre faits | Slide horizontal natif (TabView `.page`) | Natif |
| Apparition d'une carte | Fade + légère montée (y: +10 → 0) | 0.3s, easeOut |
| Tap favori | Scale spring (1.0 → 1.3 → 1.0) | 0.4s, spring |
| Onboarding page change | Slide natif TabView | Natif |
| Toggle catégorie | Bounce spring natif iOS | Natif |
| Paywall apparition | Slide depuis le bas | 0.4s, easeInOut |

**Règle générale** : Toutes les animations sont **subtiles et rapides**. L'app est une app d'attente — elle doit réagir instantanément. Aucune animation > 0.5s.

---

## 7. Espacement & Grille

| Token | Valeur |
|-------|--------|
| `spacingXS` | 4pt |
| `spacingS` | 8pt |
| `spacingM` | 16pt |
| `spacingL` | 24pt |
| `spacingXL` | 32pt |
| `spacingXXL` | 48pt |
| Padding écran horizontal | 24pt (plein écran) / 16pt (Slide Over) |
| Padding écran vertical | 16pt |
| Rayon des cartes | 24pt |
| Rayon des boutons | 16pt |
| Rayon des badges | 8pt |

---

## 8. Iconographie

- **Système** : SF Symbols exclusivement pour toute l'UI
- **Catégories** : Emoji (grand, décoratif) + SF Symbol (petit, dans les badges)
- **Navigation** : SF Symbols monochromes, taille 20pt, couleur `textSecondary` ou `accent`

| Usage | SF Symbol |
|-------|-----------|
| Réglages | `gearshape` |
| Favori | `heart` / `heart.fill` |
| Science | `atom` |
| Histoire | `book.closed` |
| Inventions | `lightbulb` |
| Géographie | `globe.europe.africa` |
| Psychologie | `brain.head.profile` |
| Citations | `quote.bubble` |
| Mathématiques | `sum` |
| Art & Culture | `paintpalette` |
| Food | `fork.knife` |
| Espace | `moon.stars` |

---

## 9. Emojis flottants (section hero onboarding)

Inspirés des coins 3D flottants de CoinCraft. Dans MindFilter, ce seront des **emojis de catégories** qui flottent aléatoirement dans la section dégradé.

**Emojis utilisés** : 🧠 💡 🔬 📖 🌍 🚀 💬 🎨 🍕 🔢

**Animation** : Lévitation douce
```swift
// Chaque emoji a un offset Y qui oscille
.offset(y: sin(phase + index) * 8)  // amplitude 8pt
.animation(.easeInOut(duration: 2.5 + Double(index) * 0.3).repeatForever(autoreverses: true))
```

**Disposition** : Positionnement aléatoire mais équilibré — 2-3 rangées décalées, pas de chevauchement.
**Taille** : 44pt (plein écran), 32pt (Slide Over)
**Opacité** : 0.9 pour les proches, 0.6 pour ceux en arrière-plan (effet de profondeur)

---

## 10. Écrans par écran

### Écran 1 — Onboarding Welcome
- Section dégradé (58%) avec emojis flottants
- "MindFilter" en petit label blanc (`label`) en haut
- Section blanche (42%) :
  - Titre : "Learn something every time you wait." (`displayLarge`)
  - Sous-titre : "Turn idle moments into knowledge." (`body`, `textSecondary`)
  - Page indicator (4 points)
  - Bouton "Get Started" (CTA principal)
  - Lien "Skip" discret en bas

### Écran 2 — Choix des catégories
- Fond `surfaceSecondary`
- Titre "Choose your interests" (`displayMedium`)
- Grille 2 colonnes de `CategoryToggleCell`
- Bouton "Continue" (CTA principal) épinglé en bas

### Écran 3 — Tutoriel Slide Over
- Illustrations / captures d'écran simulées
- Texte court, bold, centré pour chaque étape
- Indicateur d'étape (1/3, 2/3, 3/3)

### Écran 4 — Paywall
- Section dégradé en haut (40%) avec texte "MindFilter" + icône app
- Section blanche (60%) :
  - "400+ facts. 10 categories. 4 languages." (`headline`)
  - Prix : "9.99 €" en gros, `displayLarge`
  - "One purchase. Lifetime access." (`body`, `textSecondary`)
  - Bouton "Unlock MindFilter" (CTA principal)
  - Lien "Restore Purchase" en dessous

### Écran principal — FactReader
- Fond `surfaceSecondary`
- Header : icône réglages (gauche) + badge catégorie (droite)
- Carte centrale `FactCard` avec ombre légère
- Swipe horizontal natif

### Réglages
- Style natif iPadOS — `List` avec sections groupées
- Couleur accent `accent` pour les éléments actifs

---

## 11. Ce qui ne change PAS

- Utilisation de **SF Pro système** uniquement (cohérence Apple)
- **Dark mode** supporté sur tous les écrans
- **Slide Over** comme mode d'affichage prioritaire
- Pas d'illustrations complexes — emojis + SF Symbols
- Pas d'animations > 0.5s
