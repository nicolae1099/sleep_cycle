import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

class L10n {
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('es'),
  ];

  static L10nLocalizations? of(BuildContext context) {
    return Localizations.of<L10nLocalizations>(context, L10nLocalizations);
  }
}

class L10nLocalizations {
  final Locale locale;

  L10nLocalizations(this.locale);

  static L10nLocalizations? of(BuildContext context) {
    return Localizations.of<L10nLocalizations>(context, L10nLocalizations);
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'sleepCycle': 'Sleep Cycle',
      'quickOptions': 'Quick Options',
      'quickNap': 'Quick Nap (20 mins)',
      'fullSleepCycles': 'Full Sleep Cycles',
      'oneCycle': '1h 30m (1 cycle)',
      'twoCycles': '3h (2 cycles)',
      'threeCycles': '4h 30m (3 cycles)',
      'calculateBedtime': 'Calculate Optimal Bedtime',
      'whenToSleep': 'When should I go to sleep?',
      'alarmSet': 'Alarm Set!',
      'alarmMessage': 'Your alarm is set for {time}.',
      'suggestedBedtimes': 'Suggested Bedtimes',
      'bedtimeMessage': 'To wake up refreshed, go to bed at: {times}.',
      'ok': 'OK',
    },
    'es': {
      'sleepCycle': 'Ciclo de Sueño',
      'quickOptions': 'Opciones Rápidas',
      'quickNap': 'Siesta Rápida (20 minutos)',
      'fullSleepCycles': 'Ciclos Completos de Sueño',
      'oneCycle': '1h 30m (1 ciclo)',
      'twoCycles': '3h (2 ciclos)',
      'threeCycles': '4h 30m (3 ciclos)',
      'calculateBedtime': 'Calcular Hora Óptima para Dormir',
      'whenToSleep': '¿Cuándo debo irme a dormir?',
      'alarmSet': '¡Alarma Configurada!',
      'alarmMessage': 'Tu alarma está configurada para {time}.',
      'suggestedBedtimes': 'Horas Sugeridas para Dormir',
      'bedtimeMessage': 'Para despertar renovado, acuéstate a las: {times}.',
      'ok': 'OK',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class L10nLocalizationsDelegate
    extends LocalizationsDelegate<L10nLocalizations> {
  const L10nLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es'].contains(locale.languageCode);

  @override
  Future<L10nLocalizations> load(Locale locale) async {
    return L10nLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate old) => false;
}

class SleepCycleDashboard extends StatefulWidget {
  @override
  SleepCycleDashboardState createState() => SleepCycleDashboardState();
}

class SleepCycleDashboardState extends State<SleepCycleDashboard> {
  DateTime? wakeUpTime;

  void _setQuickNap() {
    final napDuration = Duration(minutes: 20);
    final alarmTime = DateTime.now().add(napDuration);
    _showAlarmSetMessage(alarmTime);
  }

  void _setAlarmForCycle(Duration duration) {
    final alarmTime = DateTime.now().add(duration);
    _showAlarmSetMessage(alarmTime);
  }

  void _calculateBedtime() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      final now = DateTime.now();
      final wakeUpTime = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      final cycleDuration = Duration(minutes: 90);
      List<DateTime> bedtimes = [];
      for (int i = 1; i <= 6; i++) {
        bedtimes.add(wakeUpTime.subtract(cycleDuration * i));
      }
      _showBedtimeSuggestions(bedtimes);
    }
  }

  void _showAlarmSetMessage(DateTime alarmTime) {
    final formattedTime = DateFormat.jm().format(alarmTime);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(L10n.of(context)!.translate('alarmSet')),
        content: Text(L10n.of(context)!.translate('alarmMessage').replaceAll('{time}', formattedTime)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(L10n.of(context)!.translate('ok')),
          ),
        ],
      ),
    );
  }

  void _showBedtimeSuggestions(List<DateTime> bedtimes) {
    final formattedTimes = bedtimes
        .map((time) => DateFormat.jm().format(time))
        .join(', ');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(L10n.of(context)!.translate('suggestedBedtimes')),
        content: Text(L10n.of(context)!.translate('bedtimeMessage').replaceAll('{times}', formattedTimes)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(L10n.of(context)!.translate('ok')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context)!.translate('sleepCycle')),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              L10n.of(context)!.translate('quickOptions'),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _setQuickNap,
              child: Text(L10n.of(context)!.translate('quickNap')),
            ),
            SizedBox(height: 16),
            Text(
              L10n.of(context)!.translate('fullSleepCycles'),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _setAlarmForCycle(Duration(minutes: 90)),
              child: Text(L10n.of(context)!.translate('oneCycle')),
            ),
            ElevatedButton(
              onPressed: () => _setAlarmForCycle(Duration(minutes: 180)),
              child: Text(L10n.of(context)!.translate('twoCycles')),
            ),
            ElevatedButton(
              onPressed: () => _setAlarmForCycle(Duration(minutes: 270)),
              child: Text(L10n.of(context)!.translate('threeCycles')),
            ),
            SizedBox(height: 16),
            Text(
              L10n.of(context)!.translate('calculateBedtime'),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _calculateBedtime,
              child: Text(L10n.of(context)!.translate('whenToSleep')),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sleep Cycle App',
      supportedLocales: L10n.supportedLocales,
      localizationsDelegates: const [
        L10nLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: SleepCycleDashboard(),
    );
  }
}

