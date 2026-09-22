# Build script for KisanAI i18n and constants
import json
import os

os.makedirs('src/constants', exist_ok=True)
os.makedirs('src/i18n/locales', exist_ok=True)

# -------------------------------------------------------------
# 1. Crops Constant with Controlled Multilingual Mapping
# -------------------------------------------------------------
crops_data = {
    'rice': {
        'en': 'Rice / Paddy',
        'te': 'వరి (Paddy)',
        'hi': 'धान / चावल',
        'ta': 'நெல் (Paddy)',
        'kn': 'ಭತ್ತ (Paddy)',
        'ml': 'നെല്ല് (Paddy)',
        'mr': 'भात / तांदूळ',
        'bn': 'ধান / চাল',
        'gu': 'ડાંગર / ચોખા',
        'pa': 'ਝੋਨਾ / ਚਾਵਲ',
        'or': 'ଧାନ (Paddy)'
    },
    'maize': {
        'en': 'Maize / Corn',
        'te': 'మొక్కజొన్న',
        'hi': 'मक्का',
        'ta': 'மக்காச்சோளம்',
        'kn': 'ಮೆಕ್ಕೆಜೋಳ',
        'ml': 'മക്കച്ചോളം',
        'mr': 'मका',
        'bn': 'ভুট্টা',
        'gu': 'મકાઈ',
        'pa': 'ਮੱਕੀ',
        'or': 'ମକା'
    },
    'chickpea': {
        'en': 'Chickpea / Bengal Gram',
        'te': 'శనగలు (Chickpea)',
        'hi': 'चना / छोले',
        'ta': 'கொண்டைக்கடலை',
        'kn': 'ಕಡಲೆ',
        'ml': 'കടല',
        'mr': 'हरभरा',
        'bn': 'ছোলা',
        'gu': 'ચણા',
        'pa': 'ਛੋਲੇ',
        'or': 'ବୁଟ / ଚଣା'
    },
    'kidneybeans': {
        'en': 'Kidney Beans (Rajma)',
        'te': 'రాజ్మా',
        'hi': 'राजमा',
        'ta': 'ராஜ்மா',
        'kn': 'ರಾಜ್ಮಾ',
        'ml': 'രാജ്മ',
        'mr': 'राजमा',
        'bn': 'রাজমা',
        'gu': 'રાજમા',
        'pa': 'ਰਾਜਮਾਂਹ',
        'or': 'ରାଜମା'
    },
    'pigeonpeas': {
        'en': 'Pigeon Peas (Red Gram / Tur)',
        'te': 'కందులు (Tur)',
        'hi': 'अरहर / तुअर दाल',
        'ta': 'துவரம்பருப்பு',
        'kn': 'ತೊಗರಿ ಬೇಳೆ',
        'ml': 'തുവരപ്പരിപ്പ്',
        'mr': 'तूर डाळ',
        'bn': 'অড়হর ডাল',
        'gu': 'તુવેર દાળ',
        'pa': 'ਅਰਹਰ ਦਾਲ',
        'or': 'ହରଡ଼ ଡାଲି'
    },
    'mothbeans': {
        'en': 'Moth Beans',
        'te': 'బొబ్బర్లు / మోత్',
        'hi': 'मोठ दाल',
        'ta': 'நரிப்பயறு',
        'kn': 'ಮಡಿಕೆ ಕಾಳು',
        'ml': 'വൻപയർ',
        'mr': 'मटकी',
        'bn': 'মঠ ডাল',
        'gu': 'મઠ',
        'pa': 'ਮੋਠ',
        'or': 'ମୁଗ / ମଠ'
    },
    'mungbean': {
        'en': 'Green Gram (Moong)',
        'te': 'పెసలు (Moong)',
        'hi': 'मूंग दाल',
        'ta': 'பாசிப்பயறு',
        'kn': 'ಹೆಸರು ಕಾಳು',
        'ml': 'ചെറുപയർ',
        'mr': 'मूग',
        'bn': 'মুগ ডাল',
        'gu': 'મગ',
        'pa': 'ਮੂੰਗੀ',
        'or': 'ମୁଗ ଡାଲି'
    },
    'blackgram': {
        'en': 'Black Gram (Urad)',
        'te': 'మినుములు (Urad)',
        'hi': 'उड़द दाल',
        'ta': 'உளுந்து',
        'kn': 'ಉದ್ದು',
        'ml': 'ഉഴുന്ന്',
        'mr': 'उडीद',
        'bn': 'মাষকলাই ডাল',
        'gu': 'અડદ',
        'pa': 'ਮਾਂਹ ਦੀ ਦਾਲ',
        'or': 'ବିରି ଡାଲି'
    },
    'lentil': {
        'en': 'Lentil (Masoor)',
        'te': 'ఎర్ర కందిపప్పు (Masoor)',
        'hi': 'मसूर दाल',
        'ta': 'மசூர் பருப்பு',
        'kn': 'ಮಸೂರ್ ಬೇಳೆ',
        'ml': 'മസൂർ പരിപ്പ്',
        'mr': 'मसूर',
        'bn': 'মসুর ডাল',
        'gu': 'મસૂર',
        'pa': 'ਮਸਰ ਦੀ ਦਾਲ',
        'or': 'ମସୁର ଡାଲି'
    },
    'pomegranate': {
        'en': 'Pomegranate',
        'te': 'దానిమ్మ (Pomegranate)',
        'hi': 'अनार',
        'ta': 'மாதுளை',
        'kn': 'ದಾಳಿಂಬೆ',
        'ml': 'മാതളനാരകം',
        'mr': 'डाळिंब',
        'bn': 'বেদানা / ডালিম',
        'gu': 'દાડમ',
        'pa': 'ਅਨਾਰ',
        'or': 'ଡାଳିମ୍ବ'
    },
    'banana': {
        'en': 'Banana',
        'te': 'అరటి (Banana)',
        'hi': 'केला',
        'ta': 'வாழைப்பழம்',
        'kn': 'ಬಾಳೆಹಣ್ಣು',
        'ml': 'വാഴപ്പഴം',
        'mr': 'केळी',
        'bn': 'কলা',
        'gu': 'કેળા',
        'pa': 'ਕੇਲਾ',
        'or': 'କଦଳୀ'
    },
    'mango': {
        'en': 'Mango',
        'te': 'మామిడి (Mango)',
        'hi': 'आम',
        'ta': 'மாம்பழம்',
        'kn': 'ಮಾವಿನಹಣ್ಣು',
        'ml': 'മാങ്ങ',
        'mr': 'आंबा',
        'bn': 'আম',
        'gu': 'કેરી',
        'pa': 'ਅੰਬ',
        'or': 'ଆମ୍ବ'
    },
    'grapes': {
        'en': 'Grapes',
        'te': 'ద్రాక్ష (Grapes)',
        'hi': 'अंगूर',
        'ta': 'திராட்சை',
        'kn': 'ದ್ರಾಕ್ಷಿ',
        'ml': 'മുന്തിരി',
        'mr': 'द्राक्षे',
        'bn': 'আঙ্গুর',
        'gu': 'દ્રાક્ષ',
        'pa': 'ਅੰਗੂਰ',
        'or': 'ଅଙ୍ଗୁର'
    },
    'watermelon': {
        'en': 'Watermelon',
        'te': 'పుచ్చకాయ',
        'hi': 'तरबूज',
        'ta': 'தர்பூசணி',
        'kn': 'ಕಲ್ಲಂಗಡಿ',
        'ml': 'തണ്ണിമത്തൻ',
        'mr': 'कलिंगड',
        'bn': 'তরমুজ',
        'gu': 'તરબૂચ',
        'pa': 'ਤਰਬੂਜ਼',
        'or': 'ତରଭୁଜ'
    },
    'muskmelon': {
        'en': 'Muskmelon',
        'te': 'కర్బూజ',
        'hi': 'खरबूजा',
        'ta': 'முலாம் பழம்',
        'kn': 'ಖರಬೂಜ',
        'ml': 'തയ്ക്കുമ്പളം',
        'mr': 'खरबूज',
        'bn': 'ফুটি / খরমুজ',
        'gu': 'ટેટી / ખરબૂજા',
        'pa': 'ਖ਼ਰਬੂਜ਼ਾ',
        'or': 'ଖରଭୁଜ'
    },
    'apple': {
        'en': 'Apple',
        'te': 'యాపిల్',
        'hi': 'सेब',
        'ta': 'ஆப்பிள்',
        'kn': 'ಸೇಬು',
        'ml': 'ആപ്പിൾ',
        'mr': 'सफरचंद',
        'bn': 'আপেল',
        'gu': 'સફરજન',
        'pa': 'ਸੇਬ',
        'or': 'ସେଓ'
    },
    'orange': {
        'en': 'Orange',
        'te': 'నారింజ / బత్తాయి',
        'hi': 'संतरा',
        'ta': 'ஆரஞ்சு',
        'kn': 'ಕಿತ್ತಳೆ',
        'ml': 'ഓറഞ്ച്',
        'mr': 'संत्री',
        'bn': 'কমলালেবু',
        'gu': 'સંતરા',
        'pa': 'ਸੰਤਰਾ',
        'or': 'କମଳା'
    },
    'papaya': {
        'en': 'Papaya',
        'te': 'బొప్పాయి',
        'hi': 'पपीता',
        'ta': 'பப்பாளி',
        'kn': 'ಪರಂಗಿ ಹಣ್ಣು',
        'ml': 'പപ്പായ',
        'mr': 'पपई',
        'bn': 'পেঁপে',
        'gu': 'પપૈયું',
        'pa': 'ਪਪੀਤਾ',
        'or': 'ଅମୃତଭଣ୍ଡା'
    },
    'coconut': {
        'en': 'Coconut',
        'te': 'కొబ్బరి',
        'hi': 'नारियल',
        'ta': 'தேங்காய்',
        'kn': 'ತೆಂಗಿನಕಾಯಿ',
        'ml': 'തേങ്ങ',
        'mr': 'നാരळ',
        'bn': 'নারকেল',
        'gu': 'નાળિયેર',
        'pa': 'ਨਾਰੀਅਲ',
        'or': 'ନଡ଼ିଆ'
    },
    'cotton': {
        'en': 'Cotton',
        'te': 'ప్రత్తి (Cotton)',
        'hi': 'कपास',
        'ta': 'பருத்தி',
        'kn': 'ಹತ್ತಿ',
        'ml': 'പരുത്തി',
        'mr': 'कापूस',
        'bn': 'তুলা',
        'gu': 'કપાસ',
        'pa': 'ਕਪਾਹ',
        'or': 'ତୁଳା'
    },
    'jute': {
        'en': 'Jute',
        'te': 'జనపనార',
        'hi': 'जूट / पटसन',
        'ta': 'சணல்',
        'kn': 'ಸೆಣಬು',
        'ml': 'ചണം',
        'mr': 'ताग',
        'bn': 'পাট',
        'gu': 'શણ',
        'pa': 'ਪਟਸਨ',
        'or': 'ଝୋଟ'
    },
    'coffee': {
        'en': 'Coffee',
        'te': 'కాఫీ',
        'hi': 'कॉफ़ी',
        'ta': 'காபி',
        'kn': 'ಕಾಫಿ',
        'ml': 'കോഫി',
        'mr': 'कॉफी',
        'bn': 'কফি',
        'gu': 'કોફી',
        'pa': 'ਕੌਫ਼ੀ',
        'or': 'କଫି'
    }
}

crops_ts = f'''import {{ LanguageCode }} from '../types';

export interface CropTranslationMap {{
  [cropKey: string]: {{
    [lang in LanguageCode]?: string;
  }};
}}

/**
 * Controlled Multilingual Crop Name Translation Layer.
 * Machine learning prediction models output raw canonical strings (e.g., "rice", "cotton").
 * This lookup table safely maps them to presentation strings across 11 Indian languages.
 */
export const CROP_TRANSLATIONS: CropTranslationMap = {json.dumps(crops_data, ensure_ascii=False, indent=2)};

export const getCropDisplayName = (rawKey: string, lang: string = 'en'): string => {{
  if (!rawKey) return '';
  const cleanKey = rawKey.trim().toLowerCase();
  const cropEntry = CROP_TRANSLATIONS[cleanKey];
  if (!cropEntry) {{
    return cleanKey.charAt(0).toUpperCase() + cleanKey.slice(1);
  }}
  return cropEntry[lang as LanguageCode] || cropEntry['en'] || cleanKey;
}};

export const CROP_DURATIONS: Record<string, string> = {{
  rice: '120 - 150 Days',
  maize: '90 - 110 Days',
  chickpea: '90 - 120 Days',
  kidneybeans: '100 - 120 Days',
  pigeonpeas: '150 - 180 Days',
  mothbeans: '75 - 90 Days',
  mungbean: '65 - 75 Days',
  blackgram: '70 - 85 Days',
  lentil: '110 - 130 Days',
  pomegranate: '5 - 6 Months',
  banana: '11 - 12 Months',
  mango: 'Perennial',
  grapes: '130 - 160 Days',
  watermelon: '80 - 100 Days',
  muskmelon: '75 - 90 Days',
  apple: 'Perennial',
  orange: 'Perennial',
  papaya: '9 - 10 Months',
  coconut: 'Perennial',
  cotton: '150 - 180 Days',
  jute: '120 - 140 Days',
  coffee: 'Perennial',
}};

export const CROP_SEASONS: Record<string, string> = {{
  rice: 'Kharif / Rabi',
  maize: 'Kharif / Spring',
  chickpea: 'Rabi',
  kidneybeans: 'Kharif',
  pigeonpeas: 'Kharif',
  mothbeans: 'Kharif',
  mungbean: 'Kharif / Summer',
  blackgram: 'Kharif / Summer',
  lentil: 'Rabi',
  pomegranate: 'Ambe / Mrig Bahar',
  banana: 'Year-Round',
  mango: 'Summer',
  grapes: 'Winter / Spring',
  watermelon: 'Zaid / Summer',
  muskmelon: 'Zaid / Summer',
  apple: 'Autumn',
  orange: 'Winter',
  papaya: 'Year-Round',
  coconut: 'Year-Round',
  cotton: 'Kharif',
  jute: 'Pre-Kharif',
  coffee: 'Winter',
}};
'''

with open('src/constants/crops.ts', 'w', encoding='utf-8') as f:
    f.write(crops_ts)

print('Crops constant written.')

