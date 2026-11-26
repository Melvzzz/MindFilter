import Foundation

// MARK: - Traductions centralisées de l'interface

enum AppStrings {

    // MARK: - Onboarding

    static func onboardingTitle1(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Testez vos connaissances\nà chaque moment d'attente."
        case .en: return "Test your knowledge\nevery time you wait."
        case .es: return "Pon a prueba tus conocimientos\ncada vez que esperas."
        case .de: return "Teste dein Wissen\nbei jeder Wartezeit."
        }
    }

    static func onboardingTitle2(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Un réglage à activer."
        case .en: return "One setting to enable."
        case .es: return "Un ajuste por activar."
        case .de: return "Eine Einstellung aktivieren."
        }
    }

    static func onboardingTitle3(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Configurer Slide Over."
        case .en: return "Set up Slide Over."
        case .es: return "Configurar Slide Over."
        case .de: return "Slide Over einrichten."
        }
    }

    static func settingsStep1(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Ouvrez les **Réglages** de l'iPad"
        case .en: return "Open your iPad **Settings**"
        case .es: return "Abre los **Ajustes** del iPad"
        case .de: return "Öffne die iPad-**Einstellungen**"
        }
    }

    static func settingsStep2(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Allez dans **Général**"
        case .en: return "Go to **General**"
        case .es: return "Ve a **General**"
        case .de: return "Gehe zu **Allgemein**"
        }
    }

    static func settingsStep3(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Touchez **Multitâche et gestes**"
        case .en: return "Tap **Multitasking & Gestures**"
        case .es: return "Toca **Multitarea y gestos**"
        case .de: return "Tippe auf **Multitasking & Gesten**"
        }
    }

    static func settingsStep4(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Activez **Autoriser plusieurs apps**"
        case .en: return "Enable **Allow Multiple Apps**"
        case .es: return "Activa **Permitir varias apps**"
        case .de: return "Aktiviere **Mehrere Apps erlauben**"
        }
    }

    static func slideOverStep1(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Glissez depuis le haut de l'écran"
        case .en: return "Swipe down from the top"
        case .es: return "Desliza desde la parte superior"
        case .de: return "Von oben nach unten wischen"
        }
    }

    static func slideOverStep2(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Touchez **Fenêtre** → **Slide Over**"
        case .en: return "Tap **Window** → **Slide Over**"
        case .es: return "Toca **Ventana** → **Slide Over**"
        case .de: return "Tippe auf **Fenster** → **Slide Over**"
        }
    }

    static func slideOverStep3(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "**Glissez la fenêtre** vers le bord droit"
        case .en: return "**Drag the window** to the right edge"
        case .es: return "**Arrastra la ventana** al borde derecho"
        case .de: return "**Ziehe das Fenster** an den rechten Rand"
        }
    }

    static func slideOverWarning(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Évitez de fermer l'application, sinon vous devrez répéter cette étape."
        case .en: return "Avoid closing the app, otherwise you'll have to repeat this step."
        case .es: return "Evita cerrar la aplicación, de lo contrario tendrás que repetir este paso."
        case .de: return "Schließe die App nicht, sonst musst du diesen Schritt wiederholen."
        }
    }

    static func getStarted(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Commencer"
        case .en: return "Get Started"
        case .es: return "Empezar"
        case .de: return "Los geht's"
        }
    }

    static func done(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Suivant →"
        case .en: return "Done →"
        case .es: return "Siguiente →"
        case .de: return "Weiter →"
        }
    }

    static func startQuiz(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Commencer le quiz"
        case .en: return "Start Quiz"
        case .es: return "Iniciar el quiz"
        case .de: return "Quiz starten"
        }
    }

    static func next(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Suivant"
        case .en: return "Next"
        case .es: return "Siguiente"
        case .de: return "Weiter"
        }
    }

    // MARK: - Onboarding : page choix des catégories

    static func onboardingChooseTitle(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Qu'est-ce que tu veux apprendre\nau lieu de perdre ton temps ?"
        case .en: return "What do you want to learn\ninstead of wasting your time?"
        case .es: return "¿Qué quieres aprender en vez\nde perder tu tiempo?"
        case .de: return "Was willst du lernen, anstatt\ndeine Zeit zu verschwenden?"
        }
    }

    // MARK: - Settings

    static func settings(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Réglages"
        case .en: return "Settings"
        case .es: return "Ajustes"
        case .de: return "Einstellungen"
        }
    }

    static func categoriesHeader(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Catégories"
        case .en: return "Categories"
        case .es: return "Categorías"
        case .de: return "Kategorien"
        }
    }

    static func language(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Langue"
        case .en: return "Language"
        case .es: return "Idioma"
        case .de: return "Sprache"
        }
    }

    static func displayDuration(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Temps d'affichage"
        case .en: return "Display Duration"
        case .es: return "Tiempo de visualización"
        case .de: return "Anzeigedauer"
        }
    }

    static func correctAnswer(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Bonne réponse"
        case .en: return "Correct answer"
        case .es: return "Respuesta correcta"
        case .de: return "Richtige Antwort"
        }
    }

    static func wrongAnswer(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Mauvaise réponse"
        case .en: return "Wrong answer"
        case .es: return "Respuesta incorrecta"
        case .de: return "Falsche Antwort"
        }
    }

    static func displayDurationFooter(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Durée avant passage automatique à la question suivante."
        case .en: return "Duration before automatically advancing to the next question."
        case .es: return "Duración antes de pasar automáticamente a la siguiente pregunta."
        case .de: return "Dauer bis zum automatischen Wechsel zur nächsten Frage."
        }
    }

    static func reduceSoundTitle(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Réduire le son"
        case .en: return "Reduce Sound"
        case .es: return "Reducir sonido"
        case .de: return "Ton reduzieren"
        }
    }

    static func reduceSoundFooter(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Réduit le volume des autres apps de 50 % quand MindFilter est ouvert."
        case .en: return "Reduces the volume of other apps by 50% when MindFilter is open."
        case .es: return "Reduce el volumen de otras apps un 50 % cuando MindFilter está abierto."
        case .de: return "Reduziert die Lautstärke anderer Apps um 50 %, wenn MindFilter geöffnet ist."
        }
    }

    static func replayTutorial(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Revoir le tutoriel"
        case .en: return "Replay Tutorial"
        case .es: return "Repetir tutorial"
        case .de: return "Tutorial wiederholen"
        }
    }

    static func doneButton(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "OK"
        case .en: return "Done"
        case .es: return "Listo"
        case .de: return "Fertig"
        }
    }

    // MARK: - Stats

    static func statistics(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Statistiques"
        case .en: return "Statistics"
        case .es: return "Estadísticas"
        case .de: return "Statistiken"
        }
    }

    static func all(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Tout"
        case .en: return "All"
        case .es: return "Todo"
        case .de: return "Alle"
        }
    }

    static func allFeminine(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Toutes"
        case .en: return "All"
        case .es: return "Todas"
        case .de: return "Alle"
        }
    }

    static func global(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Global"
        case .en: return "Global"
        case .es: return "Global"
        case .de: return "Gesamt"
        }
    }

    static func accuracy(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Précision"
        case .en: return "Accuracy"
        case .es: return "Precisión"
        case .de: return "Genauigkeit"
        }
    }

    static func questionsAnswered(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Questions répondues"
        case .en: return "Questions answered"
        case .es: return "Preguntas respondidas"
        case .de: return "Beantwortete Fragen"
        }
    }

    static func correctAnswers(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Bonnes réponses"
        case .en: return "Correct answers"
        case .es: return "Respuestas correctas"
        case .de: return "Richtige Antworten"
        }
    }

    static func wrongAnswers(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Mauvaises réponses"
        case .en: return "Wrong answers"
        case .es: return "Respuestas incorrectas"
        case .de: return "Falsche Antworten"
        }
    }

    static func bestStreak(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Meilleure série"
        case .en: return "Best streak"
        case .es: return "Mejor racha"
        case .de: return "Beste Serie"
        }
    }

    static func bySubCategory(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Par sous-catégorie"
        case .en: return "By sub-category"
        case .es: return "Por subcategoría"
        case .de: return "Nach Unterkategorie"
        }
    }

    static func byCategory(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Par catégorie"
        case .en: return "By category"
        case .es: return "Por categoría"
        case .de: return "Nach Kategorie"
        }
    }

    // MARK: - À propos / Legal

    static func restorePurchase(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Restaurer l'achat"
        case .en: return "Restore Purchase"
        case .es: return "Restaurar compra"
        case .de: return "Kauf wiederherstellen"
        }
    }

    static func privacyPolicy(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Politique de confidentialité"
        case .en: return "Privacy Policy"
        case .es: return "Política de privacidad"
        case .de: return "Datenschutzrichtlinie"
        }
    }

    static func termsOfUse(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Conditions d'utilisation"
        case .en: return "Terms of Use"
        case .es: return "Condiciones de uso"
        case .de: return "Nutzungsbedingungen"
        }
    }

    static func contact(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Contact"
        case .en: return "Contact"
        case .es: return "Contacto"
        case .de: return "Kontakt"
        }
    }

    static func version(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Version"
        case .en: return "Version"
        case .es: return "Versión"
        case .de: return "Version"
        }
    }

    static func about(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "À propos"
        case .en: return "About"
        case .es: return "Acerca de"
        case .de: return "Über"
        }
    }

    // MARK: - Pack Langues

    static func languagePackTitle(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Pack Langues"
        case .en: return "Language Pack"
        case .es: return "Pack de Idiomas"
        case .de: return "Sprachpaket"
        }
    }

    static func languagePackSubtitle(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "4 langues · Tous les niveaux CECRL\nA1 → C2"
        case .en: return "4 languages · All CEFR levels\nA1 → C2"
        case .es: return "4 idiomas · Todos los niveles MCER\nA1 → C2"
        case .de: return "4 Sprachen · Alle GER-Stufen\nA1 → C2"
        }
    }

    static func featureAllLanguages(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Anglais, Français, Espagnol, Allemand"
        case .en: return "English, French, Spanish, German"
        case .es: return "Inglés, Francés, Español, Alemán"
        case .de: return "Englisch, Französisch, Spanisch, Deutsch"
        }
    }

    static func featureAllLevels(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "6 niveaux CECRL (A1 → C2)"
        case .en: return "6 CEFR levels (A1 → C2)"
        case .es: return "6 niveles MCER (A1 → C2)"
        case .de: return "6 GER-Stufen (A1 → C2)"
        }
    }

    static func featureForever(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Accès à vie, pour toujours"
        case .en: return "Lifetime access, forever"
        case .es: return "Acceso de por vida, para siempre"
        case .de: return "Lebenslanger Zugang, für immer"
        }
    }

    static func featureNoSubscription(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Pas d'abonnement, achat unique"
        case .en: return "No subscription, one-time purchase"
        case .es: return "Sin suscripción, compra única"
        case .de: return "Kein Abo, einmaliger Kauf"
        }
    }

    static func oneTimePurchase(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Achat unique · Accès à vie"
        case .en: return "One-time purchase · Lifetime access"
        case .es: return "Compra única · Acceso de por vida"
        case .de: return "Einmaliger Kauf · Lebenslanger Zugang"
        }
    }

    static func unlockLanguages(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Débloquer les langues"
        case .en: return "Unlock Languages"
        case .es: return "Desbloquear idiomas"
        case .de: return "Sprachen freischalten"
        }
    }

    static func errorTitle(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Erreur"
        case .en: return "Error"
        case .es: return "Error"
        case .de: return "Fehler"
        }
    }

    static func languagesLocked(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Apprendre des langues"
        case .en: return "Learn languages"
        case .es: return "Aprender idiomas"
        case .de: return "Sprachen lernen"
        }
    }

    static func unlockLanguageLearning(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Débloquer l'apprentissage des langues"
        case .en: return "Unlock language learning"
        case .es: return "Desbloquear el aprendizaje de idiomas"
        case .de: return "Sprachenlernen freischalten"
        }
    }

    static func languagePackQuestionCount(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "+4 000 questions · A1 → C2"
        case .en: return "+4,000 questions · A1 → C2"
        case .es: return "+4 000 preguntas · A1 → C2"
        case .de: return "+4.000 Fragen · A1 → C2"
        }
    }

    static func oneTimeShort(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Paiement unique · à vie"
        case .en: return "One payment · lifetime access"
        case .es: return "Pago único · de por vida"
        case .de: return "Einmalzahlung · lebenslang"
        }
    }

    static func lifetimeAccessShort(_ lang: LanguageCode) -> String {
        switch lang {
        case .fr: return "Accès à vie · 4 langues"
        case .en: return "Lifetime access · 4 languages"
        case .es: return "Acceso de por vida · 4 idiomas"
        case .de: return "Lebenslanger Zugang · 4 Sprachen"
        }
    }
}
