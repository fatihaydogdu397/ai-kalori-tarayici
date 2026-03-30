import os
import json

translations = {
    'en': {
        'backToHome': 'OK, Back to Home',
        'mealAutoSaved': 'Meal saved automatically.'
    },
    'de': {
        'backToHome': 'OK, Zurück zur Startseite',
        'mealAutoSaved': 'Mahlzeit automatisch gespeichert.'
    },
    'fr': {
        'backToHome': 'OK, Retour à l\'accueil',
        'mealAutoSaved': 'Repas enregistré automatiquement.'
    },
    'es': {
        'backToHome': 'OK, Volver al inicio',
        'mealAutoSaved': 'Comida guardada automáticamente.'
    },
    'ar': {
        'backToHome': 'حسنا، العودة للرئيسية',
        'mealAutoSaved': 'تم حفظ الوجبة تلقائيا.'
    },
    'pt': {
        'backToHome': 'OK, Voltar ao Início',
        'mealAutoSaved': 'Refeição salva automaticamente.'
    },
    'ru': {
        'backToHome': 'ОК, На главную',
        'mealAutoSaved': 'Прием пищи сохранен автоматически.'
    },
    'it': {
        'backToHome': 'OK, Torna alla Home',
        'mealAutoSaved': 'Pasto salvato automaticamente.'
    },
    'ka': {
        'backToHome': 'კარგი, მთავარ გვერდზე დაბრუნება',
        'mealAutoSaved': 'კვება ავტომატურად შეინახა.'
    }
}

l10n_dir = 'lib/l10n'

for lang, trans in translations.items():
    file_path = os.path.join(l10n_dir, f'app_{lang}.arb')
    if not os.path.exists(file_path): continue
    
    with open(file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
        
    data['backToHome'] = trans['backToHome']
    data['mealAutoSaved'] = trans['mealAutoSaved']
    
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

print("ARB files updated successfully.")
