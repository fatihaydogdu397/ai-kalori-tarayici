import os
import json

translations = {
    'en': {
        'streakDays': '{count} Day Streak',
        'streakMotivation': 'Log every day to keep your streak!',
        'streakMilestone7': '1 week streak! Keep it up. 🎉',
        'streakMilestone30': '1 month streak! Incredible! 🏆'
    },
    'tr': {
        'streakDays': '{count} Günlük Seri',
        'streakMotivation': 'Her gün kayıt yaparak serisini koru!',
        'streakMilestone7': '1 haftalık seri! Harika gidiyorsun. 🎉',
        'streakMilestone30': '1 aylık seri! İnanılmaz bir başarı. 🏆'
    },
    'de': {
        'streakDays': '{count} Tage in Folge',
        'streakMotivation': 'Täglich loggen, um den Streak zu halten!',
        'streakMilestone7': '1 Woche am Stück! Weiter so. 🎉',
        'streakMilestone30': '1 Monat! Unglaublich! 🏆'
    },
    'fr': {
        'streakDays': '{count} Jours de série',
        'streakMotivation': 'Enregistrez chaque jour !',
        'streakMilestone7': '1 semaine de série ! Super. 🎉',
        'streakMilestone30': '1 mois de série ! Incroyable. 🏆'
    },
    'es': {
        'streakDays': '{count} Días de racha',
        'streakMotivation': '¡Registra todos los días!',
        'streakMilestone7': '¡1 semana de racha! ¡Genial! 🎉',
        'streakMilestone30': '¡1 mes de racha! ¡Increíble! 🏆'
    },
    'ar': {
        'streakDays': '{count} أيام متتالية',
        'streakMotivation': 'سجل كل يوم للحفاظ على سلسلتك!',
        'streakMilestone7': 'أسبوع متواصل! استمر. 🎉',
        'streakMilestone30': 'شهر متواصل! مذهل. 🏆'
    },
    'pt': {
        'streakDays': '{count} Dias seguidos',
        'streakMotivation': 'Registre todos os dias!',
        'streakMilestone7': '1 semana de série! Muito bem. 🎉',
        'streakMilestone30': '1 mês de série! Incrível! 🏆'
    },
    'ru': {
        'streakDays': '{count} Дней подряд',
        'streakMotivation': 'Добавляйте каждый день!',
        'streakMilestone7': '1 неделя подряд! Так держать. 🎉',
        'streakMilestone30': '1 месяц подряд! Потрясающе! 🏆'
    },
    'it': {
        'streakDays': '{count} Giorni consecutivi',
        'streakMotivation': 'Registra ogni giorno!',
        'streakMilestone7': '1 settimana di fila! Continua così. 🎉',
        'streakMilestone30': '1 mese di fila! Incredibile! 🏆'
    },
    'ka': {
        'streakDays': '{count} დღე მიჯრით',
        'streakMotivation': 'შეიყვანეთ ყოველდღე!',
        'streakMilestone7': '1 კვირა მიჯრით! ყოჩაღ. 🎉',
        'streakMilestone30': '1 თვე მიჯრით! საოცარია! 🏆'
    }
}

l10n_dir = 'lib/l10n'

for lang, trans in translations.items():
    file_path = os.path.join(l10n_dir, f'app_{lang}.arb')
    if not os.path.exists(file_path): continue
    
    with open(file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
        
    data['streakDays'] = trans['streakDays']
    data['@streakDays'] = {
        "placeholders": {
            "count": {
                "type": "int"
            }
        }
    }
    data['streakMotivation'] = trans['streakMotivation']
    data['streakMilestone7'] = trans['streakMilestone7']
    data['streakMilestone30'] = trans['streakMilestone30']
    
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

print("ARB files updated successfully for Task D.")
