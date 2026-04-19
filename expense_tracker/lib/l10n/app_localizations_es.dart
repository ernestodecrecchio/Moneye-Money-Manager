// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get aboutAndSupport => 'Información y Soporte';

  @override
  String get accept => 'Aceptar';

  @override
  String get account => 'Cuenta';

  @override
  String get accounts => 'Cuentas';

  @override
  String get accountsOptionDescription =>
      'Administra las cuentas y crea nuevas';

  @override
  String get addOne => 'agrega una';

  @override
  String get allTransactions => 'Todas las transacciones';

  @override
  String get amount => 'Monto';

  @override
  String get amountIsMandatory => 'El monto es obligatorio';

  @override
  String get analyticsAlertDescription =>
      'Tu privacidad es importante.\nSi aceptas, se recopilarán datos de uso anónimos para comprender cómo se utilizan las funciones y cómo mejorar la aplicación.\nNo se recopilarán datos personales, datos de ubicación, detalles de transacciones, información de cuentas ni ningún otro dato sensible.\n\nEsta opción puede desactivarse en cualquier momento desde Configuración.';

  @override
  String get analyticsAlertTitle => 'Ayuda a mejorar la aplicación';

  @override
  String get analyticsOptionDescription =>
      'Datos anónimos sobre el uso de las funciones utilizados para planificar futuros desarrollos.\nNo se recopilan datos personales.';

  @override
  String get analyticsOptionTitle => 'Estadísticas de uso anónimas';

  @override
  String get applyChanges => 'Aplicar cambios';

  @override
  String get areYouSure => '¿Estás seguro?';

  @override
  String get atTheEnd => 'Al final';

  @override
  String get atTheStart => 'Al inicio';

  @override
  String get back => 'Atrás';

  @override
  String get backupAndRestore => 'Copia de Seguridad y Restauración';

  @override
  String get backupAndRestoreOptionDescription => 'Exporta o importa tus datos';

  @override
  String get balance => 'Balance';

  @override
  String get bills => 'Facturas';

  @override
  String get billsAndUtilities => 'Facturas y Servicios Públicos';

  @override
  String get byCategory => 'Por categoria';

  @override
  String get byList => 'Por lista';

  @override
  String get cancel => 'Cancelar';

  @override
  String get cash => 'Efectivo';

  @override
  String get categories => 'Categorías';

  @override
  String get categoriesOptionDescription =>
      'Administra las categorías y crea nuevas';

  @override
  String get category => 'Categoría';

  @override
  String get color => 'Color';

  @override
  String get contacts => 'Contactos';

  @override
  String get contactsDescription =>
      'Contacta al desarrollador para informar un error o sugerir una función';

  @override
  String get contactsPageHeader =>
      '¡Puedes contactarme para informar un error, sugerir una función o lo que quieras!';

  @override
  String get continueCTA => 'Continuar';

  @override
  String get crashReports => 'Informes de errores y fallos';

  @override
  String get crashTest => 'Prueba de Fallo (Solo Debug)';

  @override
  String get creditCard => 'Tarjeta de Crédito';

  @override
  String get currency => 'Moneda';

  @override
  String get currencyConversionDisclaimer =>
      'Nota: Cambiar la moneda mostrada en la aplicación no resultará en conversiones de montos de transacciones.';

  @override
  String get currencyOptionDescription =>
      'Selecciona y personaliza la moneda utilizada';

  @override
  String get currencyPosition => 'Posición del símbolo de la moneda';

  @override
  String get daily => 'Diariamente';

  @override
  String dailyInterval(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Cada $count días',
      one: 'Diariamente',
    );
    return '$_temp0';
  }

  @override
  String get dailyReminder => 'Recordatorio diario';

  @override
  String get dailyReminderChannelDescription =>
      'Notificaciones para recordarte ingresar tus transacciones diarias.';

  @override
  String get dailyReminderChannelName => 'Recordatorios Diarios';

  @override
  String get darkTheme => 'Oscuro';

  @override
  String get dataAndPrivacy => 'Datos y Privacidad';

  @override
  String get date => 'Fecha';

  @override
  String get day => 'Día';

  @override
  String get debitCard => 'Tarjeta de Débito';

  @override
  String get decline => 'Rechazar';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteAccountAlertBody =>
      'Eliminar una cuenta no eliminará las transacciones asociadas a ella.';

  @override
  String get deleteCategoryAlertBody =>
      'Eliminar una categoría no eliminará las transacciones asociadas a ella.';

  @override
  String get deleteCategoryTitle => 'Eliminar Categoría';

  @override
  String deleteCategoryTransactionsMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Esta categoría contiene $count transacciones',
      one: 'Esta categoría contiene 1 transacción',
    );
    return '$_temp0. ¿Qué deseas hacer?';
  }

  @override
  String get description => 'Descripción';

  @override
  String get done => 'Hecho';

  @override
  String get edit => 'Editar';

  @override
  String get editAccount => 'Editar cuenta';

  @override
  String get editCategory => 'Editar categoría';

  @override
  String get editRecurringTransaction => 'Editar transacción recurrente';

  @override
  String get editRuleInfo =>
      'Los cambios en esta regla recurrente no afectarán a las transacciones que ya se hayan generado.';

  @override
  String get editTransaction => 'Editar transacción';

  @override
  String get education => 'Educación';

  @override
  String get endConfigurationMsg1 =>
      '¡Felicitaciones! Moneye está configurado y listo para ayudarte a administrar tus gastos de manera eficiente.';

  @override
  String get endConfigurationMsg2 =>
      'No olvides explorar otras características emocionantes para optimizar tu camino financiero.';

  @override
  String get endDate => 'Fecha final';

  @override
  String get endDateInfo =>
      'La fecha después de la cual no se generarán automáticamente más transacciones de este tipo.';

  @override
  String endedOn(String date) {
    return 'Terminada el $date';
  }

  @override
  String get entertainment => 'Entretenimiento';

  @override
  String get essentialDataOptionDescription =>
      'Datos anónimos sobre fallos y errores utilizados para garantizar el correcto funcionamiento de la aplicación.';

  @override
  String get essentialDataOptionTitle => 'Datos técnicos esenciales';

  @override
  String get expense => 'Gasto';

  @override
  String get expenses => 'Gastos';

  @override
  String get exportData => 'Exportar datos';

  @override
  String get exportError => 'Ocurrió un error al exportar los datos';

  @override
  String get exportSuccess => 'Datos exportados con éxito';

  @override
  String get feedback => 'Comentarios';

  @override
  String get feedbackAndReviewOptionDescription =>
      '¿Te gusta Moneye? ¡Háganoslo saber!';

  @override
  String get finance => 'Finanzas';

  @override
  String get financialOverviewForThisMonth => 'Resumen financiero de este mes';

  @override
  String get foodAndDining => 'Comida y Restaurantes';

  @override
  String get frequency => 'Frecuencia';

  @override
  String get generatedTransactions => 'Transacciones generadas';

  @override
  String generatedTransactionsSnackbar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transacciones recurrentes generadas',
      one: '1 transacción recurrente generada',
    );
    return '$_temp0';
  }

  @override
  String get health => 'Salud';

  @override
  String get icon => 'Icono';

  @override
  String get importData => 'Importar datos';

  @override
  String get importError => 'Ocurrió un error al importar los datos';

  @override
  String get importSuccess => 'Datos importados con éxito';

  @override
  String get importWarning =>
      'Importar una copia de seguridad eliminará todos los datos actuales. ¿Estás seguro de que quieres continuar?';

  @override
  String get includeInReports => 'Incluir en los informes';

  @override
  String get income => 'Ingreso';

  @override
  String get incomes => 'Ingresos';

  @override
  String get initialBalance => 'Saldo Inicial';

  @override
  String get initialBalancePlaceholder =>
      'Inserte el saldo inicial de la cuenta';

  @override
  String get insertTheAccountName => 'Inserta el nombre de la cuenta';

  @override
  String get insertTheAmountOfTheTransaction =>
      'Inserte el monto de la transacción';

  @override
  String get insertTheDescription => 'Inserta una descripción';

  @override
  String get insertTheTitleOfTheCategory => 'Inserta el título de la categoría';

  @override
  String get insertTheTitleOfTheTransaction =>
      'Inserta el título de la transacción';

  @override
  String get interval => 'Intervalo';

  @override
  String get language => 'Idioma';

  @override
  String get languageOptionDescription =>
      'Selecciona el idioma utilizado en la aplicación';

  @override
  String get lastTransactions => 'Últimas transacciones';

  @override
  String get lightTheme => 'Claro';

  @override
  String get management => 'Gestión';

  @override
  String get month => 'Mes';

  @override
  String get monthly => 'Mensualmente';

  @override
  String monthlyInterval(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Cada $count meses',
      one: 'Mensualmente',
    );
    return '$_temp0';
  }

  @override
  String get newAccount => 'Nueva cuenta';

  @override
  String get newCategory => 'Nueva categoría';

  @override
  String get newRecurringTransaction => 'Nueva transacción recurrente';

  @override
  String get newTransaction => 'Nueva transacción';

  @override
  String get nextDate => 'Próxima fecha';

  @override
  String get no => 'no';

  @override
  String get noAccountAdded => 'No se ha agregado ninguna cuenta,';

  @override
  String get noAccounts => 'Sin cuentas';

  @override
  String get noCategories => 'Sin categorías';

  @override
  String get none => 'Ninguno';

  @override
  String get notificationSubtitle =>
      '¡Recuerda ingresar tus transacciones diarias!';

  @override
  String get notificationTitle => 'Moneye';

  @override
  String get noTransactions => 'Sin transacciones';

  @override
  String get other => 'Otra';

  @override
  String get personalInfo => 'Información personal';

  @override
  String get personalization => 'Personalización';

  @override
  String get petExpenses => 'Gastos de Mascotas';

  @override
  String get privacy => 'Privacidad';

  @override
  String get privacyAssurance =>
      'La privacidad es una prioridad. Nunca se recopilan nombres, correos electrónicos, montos de transacciones ni ningún dato que pueda identificar al usuario. Todos los informes son estrictamente anónimos.';

  @override
  String get privacyAssuranceLabel => 'Garantía de Privacidad';

  @override
  String get privacyIntroduction =>
      'Elija qué datos se pueden recopilar para ayudar a mejorar la aplicación';

  @override
  String get privacyOptionDescription =>
      'Configura cómo se recopilan y utilizan los datos';

  @override
  String get recurringTransactions => 'Transacciones recurrentes';

  @override
  String get recurringTransactionsOptionDescription =>
      'Gestiona tus reglas de transacciones recurrentes';

  @override
  String get reminder => 'Recordatorio';

  @override
  String get reminderDescription =>
      'Moneye te recordará todos los días, a una hora establecida, que ingreses nuevas transacciones.\n\n¡Nunca olvidarás mantener tus datos actualizados!';

  @override
  String get reminderOptionDescription =>
      'Establece un recordatorio para recordar insertar nuevas transacciones';

  @override
  String get repeatTransaction => 'Repetir transacción';

  @override
  String get reportBug => 'Informar un error';

  @override
  String get resetData => 'Borrar todos los datos';

  @override
  String get resetError => 'Ocurrió un error al borrar los datos';

  @override
  String get resetSuccess => 'Todos los datos se borraron con éxito';

  @override
  String get resetWarning =>
      'Todos tus datos se eliminarán de forma permanente. Esta acción no se puede deshacer. ¿Estás seguro de que quieres continuar?';

  @override
  String get ruleDetails => 'Detalles de la regla';

  @override
  String get save => 'Guardar';

  @override
  String get saveToDevice => 'Guardar en el dispositivo';

  @override
  String get savings => 'Ahorros';

  @override
  String get selectAccount => 'Selecciona la cuenta';

  @override
  String get selectAccountMsg1 => 'Elige las cuentas que deseas monitorear';

  @override
  String get selectAccountMsg2 =>
      'Efectivo, tarjeta de crédito u otras opciones.\nSelecciona qué deseas vigilar de cerca.';

  @override
  String get selectCategory => 'Selecciona la categoría';

  @override
  String get selectCategoryMsg1 =>
      'Aprovecha al máximo Moneye categorizando tus transacciones';

  @override
  String get selectCategoryMsg2 =>
      'Elige de nuestra lista preconfigurada o crea tus propias categorías personalizadas más adelante.';

  @override
  String get selectColor => 'Seleccionar color';

  @override
  String get selectCurrency => 'Selecciona la moneda';

  @override
  String get selectCurrencyMsg1 => 'Selecciona tu moneda preferida';

  @override
  String get selectCurrencyMsg2 =>
      'No te preocupes, siempre podrás cambiarla después según tus necesidades.';

  @override
  String get selectDate => 'Selecciona la fecha';

  @override
  String get selectEndDate => 'Seleccionar fecha final';

  @override
  String get selectIcon => 'Seleccionar ícono';

  @override
  String get selectTargetCategory => 'Seleccionar categoría de destino';

  @override
  String get selectTimeInterval => 'Seleccione el intervalo de tiempo';

  @override
  String get sendTestNotification => 'Muéstrame cómo aparecerá';

  @override
  String get settings => 'Configuración';

  @override
  String get shareBackup => 'Compartir copia de seguridad';

  @override
  String get shopping => 'Compras';

  @override
  String get skip => 'Salta';

  @override
  String get sports => 'Deportes';

  @override
  String get subscriptions => 'Suscripciones';

  @override
  String get suggestFeature => 'Sugerir una función';

  @override
  String get systemLanguageOption => 'Automática (basada en el sistema)';

  @override
  String get systemTheme => 'Automático';

  @override
  String get testNotificationSent => '¡Notificación de prueba enviada!';

  @override
  String get theme => 'Tema';

  @override
  String get themeOptionDescription => 'Cambiar la apariencia de la aplicación';

  @override
  String get thisMonth => 'Este mes';

  @override
  String get title => 'Título';

  @override
  String get titleIsMandatory => 'El título es obligatorio';

  @override
  String get today => 'Hoy';

  @override
  String get total => 'Total';

  @override
  String get totalBalance => 'Balance total';

  @override
  String get transactionData => 'Montos y detalles de las transacciones';

  @override
  String get transactionDeleted => 'Transacción eliminada';

  @override
  String get transactionGeneratedByDeletedRule =>
      'Esta transacción fue generada por una regla recurrente que ha sido eliminada.';

  @override
  String get transactionGeneratedByRule =>
      'Esta transacción se generó automáticamente mediante una regla recurrente. Editar esta transacción no afectará a las futuras.';

  @override
  String get transactionList => 'Lista de transacciones';

  @override
  String get transferTransactions => 'Transferir Transacciones';

  @override
  String transferTransactionsMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Transferir $count transacciones',
      one: 'Transferir 1 transacción',
    );
    return '$_temp0 a:';
  }

  @override
  String get transportation => 'Transporte';

  @override
  String get updateHistory => 'Historial de actualizaciones';

  @override
  String get updateHistoryEmptyList => 'No se encontraron actualizaciones.';

  @override
  String get updateHistoryOptionDescription =>
      'Ver las últimas funciones y actualizaciones';

  @override
  String get usageData => 'Patrones de uso básicos';

  @override
  String get version => 'Versión';

  @override
  String get viewAll => 'Ver todo';

  @override
  String get viewRule => 'Ver regla';

  @override
  String get week => 'Semana';

  @override
  String get weekly => 'Semanalmente';

  @override
  String weeklyInterval(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Cada $count semanas',
      one: 'Semanalmente',
    );
    return '$_temp0';
  }

  @override
  String get welcomePageMsg1 => '¡Bienvenido a Moneye!';

  @override
  String get welcomePageMsg2 =>
      'Empecemos juntos tu camino hacia el control financiero.\nTe ayudaré a configurar la aplicación en solo unos pocos pasos.';

  @override
  String get whatIsNotTracked => 'Qué NO se rastrea:';

  @override
  String get whatIsTracked => 'Qué se rastrea:';

  @override
  String get whatsNew => 'Novedades';

  @override
  String get work => 'Trabajo';

  @override
  String get year => 'Año';

  @override
  String get yearly => 'Anualmente';

  @override
  String yearlyInterval(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Cada $count años',
      one: 'Anualmente',
    );
    return '$_temp0';
  }

  @override
  String get yes => 'sí';

  @override
  String get yesterday => 'Ayer';

  @override
  String get yourAccounts => 'Tus cuentas';

  @override
  String get yourCategories => 'Tus categorías';
}
