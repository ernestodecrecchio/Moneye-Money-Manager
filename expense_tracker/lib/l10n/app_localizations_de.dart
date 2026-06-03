// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get aboutAndSupport => 'Info & Support';

  @override
  String get accept => 'Akzeptieren';

  @override
  String get account => 'Konto';

  @override
  String get accounts => 'Konten';

  @override
  String get accountsOptionDescription =>
      'Verwalten Sie die Konten und erstellen Sie neue';

  @override
  String get addOne => 'eines hinzufügen';

  @override
  String get allTransactions => 'Alle Transaktionen';

  @override
  String get amount => 'Betrag';

  @override
  String get amountIsMandatory => 'Der Betrag ist obligatorisch';

  @override
  String get analyticsAlertDescription =>
      'Deine Privatsphäre ist wichtig.\nWenn du zustimmst, werden anonyme Nutzungsdaten erfasst, um zu verstehen, wie Funktionen verwendet werden und wie die App verbessert werden kann.\nEs werden keine personenbezogenen Daten, Standortdaten, Transaktionsdetails, Kontoinformationen oder andere sensible Daten erfasst.\n\nDiese Option kann jederzeit in den Einstellungen deaktiviert werden.';

  @override
  String get analyticsAlertTitle => 'Hilf mit, die App zu verbessern';

  @override
  String get analyticsOptionDescription =>
      'Anonyme Daten zur Nutzung von Funktionen, die zur Planung zukünftiger Entwicklungen verwendet werden.\nEs werden keine personenbezogenen Daten erfasst.';

  @override
  String get analyticsOptionTitle => 'Anonyme Nutzungsstatistiken';

  @override
  String get applyChanges => 'Änderungen anwenden';

  @override
  String get areYouSure => 'Bist du sicher?';

  @override
  String get atTheEnd => 'Am Ende';

  @override
  String get atTheStart => 'Am Anfang';

  @override
  String get back => 'Zurück';

  @override
  String get backupAndRestore => 'Sichern & Wiederherstellen';

  @override
  String get backupAndRestoreOptionDescription =>
      'Exportieren oder importieren Sie Ihre Daten';

  @override
  String get balance => 'Saldo';

  @override
  String get bills => 'Rechnungen';

  @override
  String get billsAndUtilities => 'Rechnungen und Dienstprogramme';

  @override
  String get byCategory => 'Nach Kategorie';

  @override
  String get byList => 'Nach Liste';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get cash => 'Bargeld';

  @override
  String get categories => 'Kategorien';

  @override
  String get categoriesOptionDescription =>
      'Verwalten Sie die Kategorien und erstellen Sie neue';

  @override
  String get budgeting => 'Budgetierung';

  @override
  String get newBudget => 'Neues Budget';

  @override
  String get editBudget => 'Budget bearbeiten';

  @override
  String get amountSpentOf => 'ausgegeben von';

  @override
  String get amountRemaining => 'verbleibend';

  @override
  String get overBudget => 'Budget überschritten';

  @override
  String get rollover => 'Übertrag';

  @override
  String get budgetDuration => 'Budgetdauer';

  @override
  String get selectCategories => 'Kategorien auswählen';

  @override
  String get allCategories => 'Alle Kategorien';

  @override
  String get allCategoriesDescription =>
      'Umfasst alle Kategorien, auch zukünftig hinzugefügte';

  @override
  String get category => 'Kategorie';

  @override
  String get color => 'Farbe';

  @override
  String get contacts => 'Kontakte';

  @override
  String get contactsDescription =>
      'Kontaktieren Sie den Entwickler, um einen Fehler zu melden oder eine Funktion vorzuschlagen';

  @override
  String get contactsPageHeader =>
      'Du kannst mich kontaktieren, um einen Fehler zu melden, eine Funktion vorzuschlagen oder was auch immer du willst!';

  @override
  String get continueCTA => 'Weiter';

  @override
  String get crashTest => 'Crash-Test (Nur Debug)';

  @override
  String get creditCard => 'Kreditkarte';

  @override
  String get currency => 'Währung';

  @override
  String get currencyConversionDisclaimer =>
      'Hinweis: Das Ändern der in der App angezeigten Währung führt nicht zu Umrechnungen der Transaktionsbeträge.';

  @override
  String get currencyPosition => 'Position des Währungssymbols';

  @override
  String get daily => 'Täglich';

  @override
  String dailyInterval(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Alle $count Tage',
      one: 'Täglich',
    );
    return '$_temp0';
  }

  @override
  String get dailyReminder => 'Tägliche Erinnerung';

  @override
  String get dailyReminderChannelDescription =>
      'Benachrichtigungen, die Sie daran erinnern, Ihre täglichen Transaktionen einzugeben.';

  @override
  String get dailyReminderChannelName => 'Tägliche Erinnerungen';

  @override
  String get darkTheme => 'Dunkel';

  @override
  String get dataAndPrivacy => 'Daten & Datenschutz';

  @override
  String get date => 'Datum';

  @override
  String get day => 'Tag';

  @override
  String get debitCard => 'EC-Karte';

  @override
  String get decline => 'Ablehnen';

  @override
  String get delete => 'Löschen';

  @override
  String get deleteAccountAlertBody =>
      'Das Löschen eines Kontos entfernt die damit verbundenen Transaktionen nicht.';

  @override
  String get deleteCategoryAlertBody =>
      'Das Löschen einer Kategorie entfernt die damit verbundenen Transaktionen nicht.';

  @override
  String get deleteCategoryTitle => 'Kategorie löschen';

  @override
  String deleteCategoryTransactionsMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Diese Kategorie enthält $count Transaktionen',
      one: 'Diese Kategorie enthält 1 Transaktion',
    );
    return '$_temp0. Was möchten Sie tun?';
  }

  @override
  String get description => 'Beschreibung';

  @override
  String get done => 'Fertig';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get editAccount => 'Konto bearbeiten';

  @override
  String get editCategory => 'Kategorie bearbeiten';

  @override
  String get editRecurringTransaction =>
      'Wiederkehrende Transaktion bearbeiten';

  @override
  String get editRuleInfo =>
      'Änderungen an dieser wiederkehrenden Regel wirken sich nicht auf bereits generierte Transaktionen aus.';

  @override
  String get editTransaction => 'Transaktion bearbeiten';

  @override
  String get education => 'Bildung';

  @override
  String get endConfigurationMsg1 =>
      'Herzlichen Glückwunsch! Moneye ist jetzt konfiguriert und bereit, dir bei der effizienten Ausgabenverwaltung zu helfen.';

  @override
  String get endConfigurationMsg2 =>
      'Vergiss nicht, andere spannende Funktionen zu erkunden, um deine finanzielle Reise zu optimieren.';

  @override
  String get endDate => 'Enddatum';

  @override
  String get endDateInfo =>
      'Das Datum, nach dem keine weiteren Transaktionen dieser Art automatisch generiert werden.';

  @override
  String endedOn(String date) {
    return 'Beendet am $date';
  }

  @override
  String get entertainment => 'Unterhaltung';

  @override
  String get essentialDataOptionDescription =>
      'Anonyme Daten zu Abstürzen und Fehlern, die verwendet werden, um die ordnungsgemäße Funktion der App sicherzustellen.';

  @override
  String get essentialDataOptionTitle => 'Wesentliche technische Daten';

  @override
  String get expense => 'Ausgabe';

  @override
  String get expenses => 'Ausgaben';

  @override
  String get exportError =>
      'Beim Exportieren der Daten ist ein Fehler aufgetreten';

  @override
  String get exportSuccess => 'Daten erfolgreich exportiert';

  @override
  String get feedback => 'Rückmeldung';

  @override
  String get feedbackAndReviewOptionDescription =>
      'Magst du Moneye? Lass es uns wissen!';

  @override
  String get finance => 'Finanzen';

  @override
  String get financialOverviewForThisMonth =>
      'Die finanzielle Übersicht für diesen Monat';

  @override
  String get foodAndDining => 'Essen und Gastronomie';

  @override
  String get frequency => 'Häufigkeit';

  @override
  String get generatedTransactions => 'Generierte Transaktionen';

  @override
  String generatedTransactionsSnackbar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wiederkehrende Transaktionen generiert',
      one: '1 wiederkehrende Transaktion generiert',
    );
    return '$_temp0';
  }

  @override
  String get health => 'Gesundheit';

  @override
  String get icon => 'Symbol';

  @override
  String get importData => 'Daten importieren';

  @override
  String get importError =>
      'Beim Importieren der Daten ist ein Fehler aufgetreten';

  @override
  String get importSuccess => 'Daten erfolgreich importiert';

  @override
  String get importWarning =>
      'Das Importieren eines Backups löscht alle aktuellen Daten. Möchten Sie wirklich fortfahren?';

  @override
  String get includeInReports => 'In Berichte einbeziehen';

  @override
  String get income => 'Einkommen';

  @override
  String get incomes => 'Einkommen';

  @override
  String get initialBalance => 'Startguthaben';

  @override
  String get initialBalancePlaceholder =>
      'Geben Sie den Anfangssaldo des Kontos ein';

  @override
  String get insertTheAccountName => 'Geben Sie den Kontonamen ein';

  @override
  String get insertTheAmountOfTheTransaction =>
      'Geben Sie den Betrag der Transaktion ein';

  @override
  String get insertTheDescription => 'Beschreibung eingeben';

  @override
  String get insertTheTitleOfTheCategory =>
      'Geben Sie den Titel der Kategorie ein';

  @override
  String get insertTheTitleOfTheTransaction =>
      'Geben Sie den Titel der Transaktion ein';

  @override
  String get interval => 'Intervall';

  @override
  String get language => 'Sprache';

  @override
  String get languageOptionDescription =>
      'Wählen Sie die Sprache, die in der App verwendet wird';

  @override
  String get lastTransactions => 'Letzte Transaktionen';

  @override
  String get lightTheme => 'Hell';

  @override
  String get management => 'Verwaltung';

  @override
  String get month => 'Monat';

  @override
  String get monthly => 'Monatlich';

  @override
  String monthlyInterval(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Alle $count Monate',
      one: 'Monatlich',
    );
    return '$_temp0';
  }

  @override
  String get newAccount => 'Neues Konto';

  @override
  String get newCategory => 'Neue Kategorie';

  @override
  String get newRecurringTransaction => 'Neue wiederkehrende Transaktion';

  @override
  String get newTransaction => 'Neue Transaktion';

  @override
  String get nextDate => 'Nächstes Datum';

  @override
  String get no => 'nein';

  @override
  String get noAccountAdded => 'Kein Konto hinzugefügt,';

  @override
  String get noAccounts => 'Keine Konten';

  @override
  String get noBudgetsYet => 'Noch keine Budgets';

  @override
  String get noCategories => 'Keine Kategorien';

  @override
  String get none => 'Keine';

  @override
  String get notificationSubtitle =>
      'Denke daran, deine täglichen Transaktionen einzutragen!';

  @override
  String get notificationTitle => 'Moneye';

  @override
  String get noTransactions => 'Keine Transaktionen';

  @override
  String get other => 'Andere';

  @override
  String get personalization => 'Personalisierung';

  @override
  String get petExpenses => 'Tierische Ausgaben';

  @override
  String get privacy => 'Datenschutz';

  @override
  String get privacyAssurance =>
      'Privatsphäre hat Priorität. Namen, E-Mails, Transaktionsbeträge oder andere Daten, die den Nutzer identifizieren könnten, werden niemals erfasst. Alle Berichte sind streng anonym.';

  @override
  String get privacyAssuranceLabel => 'Datenschutzgarantie';

  @override
  String get privacyIntroduction =>
      'Wählen Sie aus, welche Daten gesammelt werden dürfen, um die App zu verbessern und ihre Stabilität zu gewährleisten.';

  @override
  String get privacyOptionDescription =>
      'Konfigurieren Sie, wie Daten gesammelt und verwendet werden';

  @override
  String get recurringTransactions => 'Wiederkehrende Transaktionen';

  @override
  String get recurringTransactionsOptionDescription =>
      'Verwalten Sie Ihre wiederkehrenden Transaktionsregeln';

  @override
  String get reminder => 'Erinnerung';

  @override
  String get reminderDescription =>
      'Moneye erinnert Sie jeden Tag zu einer festgelegten Zeit daran, neue Transaktionen einzugeben.\n\nSie werden nie vergessen, Ihre Daten auf dem neuesten Stand zu halten!';

  @override
  String get reminderOptionDescription =>
      'Stellen Sie eine Erinnerung ein, um sich an das Einfügen neuer Transaktionen zu erinnern';

  @override
  String get repeatTransaction => 'Transaktion wiederholen';

  @override
  String get reportBug => 'Einen Fehler melden';

  @override
  String get resetData => 'Alle Daten löschen';

  @override
  String get resetError => 'Beim Löschen der Daten ist ein Fehler aufgetreten';

  @override
  String get resetSuccess => 'Alle Daten erfolgreich gelöscht';

  @override
  String get resetWarning =>
      'Alle Ihre Daten werden dauerhaft gelöscht. Diese Aktion kann nicht rückgängig gemacht werden. Möchten Sie wirklich fortfahren?';

  @override
  String get ruleDetails => 'Regeldetails';

  @override
  String get save => 'Speichern';

  @override
  String get saveToDevice => 'Auf dem Gerät speichern';

  @override
  String get savings => 'Ersparnisse';

  @override
  String get selectAccount => 'Konto auswählen';

  @override
  String get selectAccountMsg1 =>
      'Wähle die Konten aus, die du überwachen möchtest';

  @override
  String get selectAccountMsg2 =>
      'Bargeld, Kreditkarte oder andere Optionen.\nWähle aus, worauf du ein wachsames Auge haben möchtest.';

  @override
  String get selectCategory => 'Kategorie auswählen';

  @override
  String get selectCategoryMsg1 =>
      'Nutze Moneye optimal, indem du deine Transaktionen kategorisierst';

  @override
  String get selectCategoryMsg2 =>
      'Wähle aus unserer vorkonfigurierten Liste oder erstelle später deine eigenen benutzerdefinierten Kategorien.';

  @override
  String get selectColor => 'Farbe wählen';

  @override
  String get selectCurrency => 'Währung auswählen';

  @override
  String get selectDate => 'Datum auswählen';

  @override
  String get selectEndDate => 'Enddatum auswählen';

  @override
  String get selectIcon => 'Symbol auswählen';

  @override
  String get selectTargetCategory => 'Zielkategorie auswählen';

  @override
  String get selectTimeInterval => 'Wählen Sie das Zeitintervall aus';

  @override
  String get sendTestNotification => 'Zeig mir, wie es aussehen wird';

  @override
  String get settings => 'Einstellungen';

  @override
  String get shareBackup => 'Backup teilen';

  @override
  String get shopping => 'Shopping';

  @override
  String get skip => 'Überspringen';

  @override
  String get sports => 'Sport';

  @override
  String get subscriptions => 'Abonnements';

  @override
  String get suggestFeature => 'Eine Funktion vorschlagen';

  @override
  String get systemLanguageOption => 'Automatisch (basierend auf dem System)';

  @override
  String get systemTheme => 'Automatisch';

  @override
  String get testNotificationSent => 'Testbenachrichtigung gesendet!';

  @override
  String get theme => 'Thema';

  @override
  String get themeOptionDescription => 'App-Erscheinungsbild ändern';

  @override
  String get title => 'Titel';

  @override
  String get titleIsMandatory => 'Der Titel ist obligatorisch';

  @override
  String get today => 'Heute';

  @override
  String get total => 'Gesamt';

  @override
  String get totalBalance => 'Gesamtbilanz';

  @override
  String get startDate => 'Startdatum';

  @override
  String get startsOnDayOfMonth => 'Beginnt am Tag des Monats';

  @override
  String get startsOnWeekday => 'Beginnt am Wochentag';

  @override
  String get selectAtLeastOneCategory =>
      'Bitte wählen Sie mindestens eine Kategorie aus';

  @override
  String get deleteBudgetConfirmation => 'Möchten Sie dieses Budget löschen?';

  @override
  String get budgetTitleHint => 'z.B. Mein monatliches Lebensmittelbudget';

  @override
  String get budgetAmountHint => 'z.B. 500,00';

  @override
  String get budgetAmountInvalid => 'Geben Sie einen positiven Betrag ein';

  @override
  String get rolloverMode => 'Übertragsmodus';

  @override
  String get carryRemaining => 'Restguthaben übertragen';

  @override
  String get carryOverspending => 'Mehrausgaben übertragen';

  @override
  String get rolloverModeNoneDescription =>
      'Nicht genutztes Geld wird nicht übertragen. Jede Budgetperiode beginnt neu.';

  @override
  String get rolloverModeCarryRemainingDescription =>
      'Nicht ausgegebenes Geld wird dem Budget der nächsten Periode hinzugefügt.';

  @override
  String get rolloverModeCarryOverspendingDescription =>
      'Bei Mehrausgaben wird der negative Saldo in die nächste Periode übernommen.';

  @override
  String get transactionDeleted => 'Transaktion gelöscht';

  @override
  String get transactionGeneratedByDeletedRule =>
      'Diese Transaktion wurde durch eine wiederkehrende Regel generiert, die inzwischen gelöscht wurde.';

  @override
  String get transactionGeneratedByRule =>
      'Diese Transaktion wurde automatisch durch eine wiederkehrende Regel generiert. Die Bearbeitung hat keine Auswirkungen auf zukünftig generierte.';

  @override
  String get transactionList => 'Transaktionsliste';

  @override
  String get transferTransactions => 'Transaktionen übertragen';

  @override
  String transferTransactionsMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Transaktionen übertragen',
      one: '1 Transaktion übertragen',
    );
    return '$_temp0 nach:';
  }

  @override
  String get transportation => 'Transport';

  @override
  String get updateHistory => 'Aktualisierungsverlauf';

  @override
  String get updateHistoryEmptyList => 'Keine Updates gefunden.';

  @override
  String get updateHistoryOptionDescription =>
      'Die neuesten Funktionen und Updates anzeigen';

  @override
  String get version => 'Version';

  @override
  String get viewAll => 'Alle anzeigen';

  @override
  String get viewRule => 'Regel anzeigen';

  @override
  String get week => 'Woche';

  @override
  String get weekly => 'Wöchentlich';

  @override
  String weeklyInterval(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Alle $count Wochen',
      one: 'Wöchentlich',
    );
    return '$_temp0';
  }

  @override
  String get welcomePageMsg1 => 'Willkommen bei Moneye!';

  @override
  String get welcomePageMsg2 =>
      'Lass uns gemeinsam mit dir deine Reise zur finanziellen Kontrolle beginnen.\nIch helfe dir dabei, die App in nur wenigen Schritten einzurichten.';

  @override
  String get whatsNew => 'Neuigkeiten';

  @override
  String get work => 'Arbeit';

  @override
  String get year => 'Jahr';

  @override
  String get yearly => 'Jährlich';

  @override
  String yearlyInterval(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Alle $count Jahre',
      one: 'Jährlich',
    );
    return '$_temp0';
  }

  @override
  String get yes => 'ja';

  @override
  String get correctBalance => 'Saldo korrigieren';

  @override
  String get currentCalculatedBalance => 'Aktueller Saldo';

  @override
  String get realBalance => 'Tatsächlicher Saldo';

  @override
  String get realBalancePlaceholder =>
      'Geben Sie den tatsächlichen Kontostand ein';

  @override
  String get rebalanceAdjustment => 'Anpassung';

  @override
  String get rebalanceSuccess => 'Saldo erfolgreich korrigiert';

  @override
  String confirmTransferTransactionsMessage(
      int count, String source, String target) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Transaktionen werden',
      one: '1 Transaktion wird',
    );
    return '$_temp0 von $source nach $target übertragen. Sind Sie sicher?';
  }

  @override
  String get yesterday => 'Gestern';

  @override
  String get yourAccounts => 'Ihre Konten';

  @override
  String get yourCategories => 'Ihre Kategorien';
}
