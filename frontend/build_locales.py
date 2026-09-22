# Locale Generator for KisanAI
import json
import os

os.makedirs('src/i18n/locales', exist_ok=True)

# 1. Base English
en = {
    "common": {
        "appName": "KisanAI",
        "subtitle": "AI-Powered Smart Agriculture Platform",
        "save": "Save",
        "cancel": "Cancel",
        "back": "Back",
        "next": "Next",
        "submit": "Submit",
        "edit": "Edit",
        "delete": "Delete",
        "search": "Search",
        "loading": "Loading...",
        "viewAll": "View All",
        "viewDetails": "View Details",
        "error": "Error",
        "success": "Success",
        "retry": "Retry",
        "acres": "Acres",
        "hectares": "Hectares",
        "kg": "kg",
        "quintal": "Quintal",
        "language": "Language",
        "changeLanguage": "Change Language",
        "languageUpdated": "Language updated successfully to English!",
        "zeroReentryNotice": "Information auto-loaded from your farmer profile",
        "close": "Close",
        "active": "Active",
        "status": "Status"
    },
    "nav": {
        "home": "Home",
        "dashboard": "Dashboard",
        "cropRecommendation": "Crop Advisory",
        "cropHistory": "Advisory History",
        "diseaseDetection": "Plant Doctor",
        "weather": "Weather & Advisory",
        "market": "Mandi Rates",
        "schemes": "Govt Schemes",
        "assistant": "AI Assistant",
        "profile": "Farmer Profile",
        "settings": "Settings",
        "logout": "Logout",
        "login": "Login",
        "register": "Register"
    },
    "onboarding": {
        "chooseLanguage": "Choose Your Language",
        "chooseLanguageSubtitle": "Select your preferred language. The entire website and advisories will be tailored in this language.",
        "continueBtn": "Continue",
        "stepLanguage": "Language",
        "stepLocation": "Location",
        "stepFarm": "Farm & Soil",
        "stepComplete": "Complete",
        "state": "State",
        "district": "District",
        "village": "Village / Town",
        "pincode": "Pincode",
        "landArea": "Land Area",
        "areaUnit": "Area Unit",
        "hasSoilReport": "Do you have a Soil Health Card report?",
        "yes": "Yes",
        "no": "No",
        "soilType": "Soil Type",
        "nitrogen": "Nitrogen (N)",
        "phosphorus": "Phosphorus (P)",
        "potassium": "Potassium (K)",
        "phLevel": "Soil pH Level",
        "irrigationType": "Irrigation Type",
        "primaryCrop": "Primary / Previous Crop",
        "experience": "Farming Experience (Years)",
        "finishSetup": "Complete Farmer Setup",
        "selectState": "Select State",
        "enterDistrict": "Enter District",
        "enterVillage": "Enter Village"
    },
    "auth": {
        "loginTitle": "Welcome Back, Farmer",
        "loginDesc": "Log in to access your personalized precision farming insights",
        "registerTitle": "Farmer Registration",
        "registerDesc": "Join thousands of farmers making smart, data-driven decisions",
        "step1Language": "Step 1: Preferred Language",
        "step2Details": "Step 2: Farmer Credentials",
        "fullName": "Full Name",
        "phone": "Mobile Number",
        "password": "Password",
        "confirmPassword": "Confirm Password",
        "enterFullName": "Enter your full name",
        "enterPhone": "Enter 10-digit mobile number",
        "enterPassword": "Enter password",
        "loginBtn": "Sign In",
        "registerBtn": "Create Account & Continue",
        "noAccount": "Don't have an account? Register here",
        "haveAccount": "Already registered? Sign in here",
        "guestMode": "Explore Demo Dashboard"
    },
    "dashboard": {
        "welcome": "Namaste",
        "greetingSubtitle": "Here is your agricultural overview and advisory for today",
        "weatherCard": "Today's Weather",
        "soilCard": "Soil Health Status",
        "soilOptimal": "NPK balance is optimal for Kharif sowing",
        "cropRecommendCard": "AI Crop Recommendation",
        "cropRecommendPrompt": "Run an AI advisory analysis based on your soil test parameters and local climate",
        "startAnalysis": "Run Crop Recommendation",
        "quickActions": "Essential Farmer Tools",
        "mandiHighlights": "Nearby Mandi Rates",
        "schemesHighlights": "Recommended Government Subsidies",
        "assistantPrompt": "Ask Kisan AI Assistant",
        "viewWeather": "Full Forecast",
        "viewMarket": "All Mandi Prices",
        "viewSchemes": "All Schemes"
    },
    "cropRecommendation": {
        "title": "AI Crop Recommendation",
        "subtitle": "Intelligent precision crop engine with Zero Re-entry UX",
        "prefilledBadge": "Zero Re-entry: Auto-loaded from your Farmer Profile",
        "prefilledExpl": "Your farm location, soil N-P-K, and pH have been automatically loaded from your profile. Modify only if testing scenarios.",
        "parametersSection": "Soil & Agro-Climatic Parameters",
        "nitrogenLabel": "Nitrogen (N) - kg/ha",
        "phosphorusLabel": "Phosphorus (P) - kg/ha",
        "potassiumLabel": "Potassium (K) - kg/ha",
        "phLabel": "Soil pH Level",
        "tempLabel": "Temperature (°C)",
        "humidityLabel": "Relative Humidity (%)",
        "rainfallLabel": "Rainfall (mm)",
        "analyzeBtn": "Analyze & Recommend Best Crop",
        "analyzing": "AI Model Analyzing Soil & Climate Data...",
        "resultTitle": "Top Recommended Crop for Your Land",
        "confidence": "Recommendation Confidence",
        "alternateCrops": "Viable Alternative Crops",
        "whyRecommended": "Agronomic Rationale",
        "suitability": "Seasonal Suitability",
        "duration": "Maturity Duration",
        "soilMatch": "Soil Match Score",
        "economicsTitle": "Estimated Economic Outlook (Per Acre)",
        "costPerAcre": "Estimated Cultivation Cost",
        "yieldPerAcre": "Expected Yield",
        "revenuePerAcre": "Estimated Gross Revenue",
        "profitPotential": "Net Profit Potential",
        "fertilizerTitle": "Personalized Fertilizer & Nutrient Schedule",
        "urea": "Urea",
        "dap": "DAP",
        "mop": "MOP (Potash)",
        "organicCompost": "Organic Compost / FYM",
        "irrigationTitle": "Irrigation & Water Management Guideline",
        "riskFactors": "Agro-Climatic Risks & Preventative Measures",
        "saveHistory": "Save to Crop History",
        "savedSuccess": "Recommendation successfully saved to Crop History!",
        "viewHistory": "View Past Recommendations",
        "resetValues": "Reset to Profile Defaults"
    },
    "cropHistory": {
        "title": "Crop Recommendation History",
        "subtitle": "Review and compare your past AI soil-climate analyses and crop recommendations",
        "emptyHistory": "No recommendation history recorded yet. Run your first analysis!",
        "date": "Date",
        "recommendedCrop": "Recommended Crop",
        "soilValues": "Soil N-P-K (kg/ha)",
        "phValue": "pH",
        "weatherValues": "Temp / Rain",
        "score": "Confidence",
        "actions": "Details",
        "newAnalysis": "Run New Analysis",
        "filterCrop": "Filter by Crop",
        "allCrops": "All Crops"
    },
    "diseaseDetection": {
        "title": "AI Plant Doctor & Disease Detection",
        "subtitle": "Upload crop leaf photos to detect pests and diseases instantly with remedial advice",
        "uploadTitle": "Upload or Select Crop Photo",
        "uploadHint": "Supports JPG, PNG photos of leaves, stems, or fruits",
        "sampleImages": "Or test with common crop condition samples:",
        "sample1": "Early Blight on Tomato",
        "sample2": "Powdery Mildew on Grapes",
        "sample3": "Rust on Wheat",
        "sample4": "Healthy Cotton Plant",
        "analyzing": "Diagnosing crop health with Vision AI...",
        "diagnosisResult": "Diagnostic Report",
        "condition": "Identified Condition",
        "healthy": "Healthy Crop - No Pathogen Detected",
        "severity": "Severity Assessment",
        "symptoms": "Visual Symptoms Identified",
        "organicControl": "Organic & Cultural Treatments",
        "chemicalControl": "Recommended Chemical Treatments",
        "prevention": "Preventive Measures for Next Season"
    },
    "weather": {
        "title": "Agro-Meteorological Forecast & Advisories",
        "subtitle": "Hyperlocal weather data and actionable daily farming advisories",
        "currentConditions": "Current Farm Weather",
        "temp": "Temperature",
        "feelsLike": "Feels Like",
        "humidity": "Humidity",
        "wind": "Wind Speed",
        "rainChance": "Precipitation Probability",
        "uvIndex": "UV Index",
        "farmingAdvisory": "Agricultural Advisory for Today",
        "irrigationAdv": "Irrigation Advisory",
        "sprayingAdv": "Pesticide Spraying Window",
        "forecast7Day": "7-Day Farm Weather Outlook"
    },
    "market": {
        "title": "Live APMC Mandi Commodity Rates",
        "subtitle": "Daily wholesale market prices and trends from agricultural mandis across India",
        "searchPlaceholder": "Search crop or commodity...",
        "commodity": "Commodity",
        "mandi": "APMC Market",
        "district": "District",
        "modalPrice": "Modal Price",
        "minPrice": "Min Price",
        "maxPrice": "Max Price",
        "trend": "Price Trend",
        "arrivals": "Daily Arrivals",
        "priceUnit": "₹ / Quintal"
    },
    "schemes": {
        "title": "Government Agricultural Schemes",
        "subtitle": "Financial assistance, crop insurance, and subsidies available for farmers",
        "searchSchemes": "Search government schemes...",
        "benefit": "Direct Benefit",
        "eligibility": "Eligibility Criteria",
        "documents": "Required Documents",
        "applyBtn": "Apply on Official Portal",
        "centralScheme": "Central Government",
        "stateScheme": "State Government"
    },
    "assistant": {
        "title": "Kisan AI Smart Farming Assistant",
        "subtitle": "24/7 conversational agricultural guidance in your preferred language",
        "inputPlaceholder": "Ask a question about crops, fertilizers, pests, or mandi prices...",
        "send": "Send",
        "suggestedTitle": "Common Farmer Questions",
        "voiceInput": "Speak",
        "voiceListening": "Listening in your language...",
        "initialGreeting": "Namaste! I am your Kisan AI assistant. How can I assist your farming today?"
    },
    "profile": {
        "title": "Farmer Profile",
        "subtitle": "Manage your contact information, farm location, soil parameters, and language",
        "personalDetails": "Personal Details",
        "farmLocation": "Farm Location",
        "soilParameters": "Soil & Irrigation Parameters",
        "editProfile": "Edit Profile",
        "saveChanges": "Save Changes",
        "cancelEdit": "Cancel",
        "profileUpdated": "Profile updated successfully!"
    },
    "settings": {
        "title": "Application Settings",
        "subtitle": "Customize your language preference and platform settings",
        "languageTitle": "Global Application Language",
        "languageDescription": "Select your preferred language. The entire website, advisories, and crop translations will update instantly without page reload or logout.",
        "currentLanguage": "Active Language",
        "changeLanguage": "Change Language",
        "appPreferences": "Application Preferences",
        "offlineMode": "Offline Data Caching",
        "notifications": "Advisory Notifications",
        "dataSync": "Background Data Sync",
        "appVersion": "Version 2.4.0 (PWA Ready)"
    }
}

# 2. Telugu (తెలుగు)
te = {
    "common": {
        "appName": "కిసాన్ AI",
        "subtitle": "రైతుల కోసం ఆర్టిఫిషియల్ ఇంటెలిజెన్స్ వ్యవసాయ వేదిక",
        "save": "భద్రపరచు",
        "cancel": "రద్దు చేయి",
        "back": "వెనుకకు",
        "next": "తరువాత",
        "submit": "సమర్పించు",
        "edit": "సవరించు",
        "delete": "తొలగించు",
        "search": "శోధించండి",
        "loading": "లోడ్ అవుతోంది...",
        "viewAll": "అన్నీ చూడండి",
        "viewDetails": "వివరాలు చూడండి",
        "error": "లోపం",
        "success": "విజయవంతం",
        "retry": "మళ్ళీ ప్రయత్నించండి",
        "acres": "ఎకరాలు",
        "hectares": "హెక్టార్లు",
        "kg": "కిలోలు",
        "quintal": "క్వింటాల్",
        "language": "భాష",
        "changeLanguage": "భాషను మార్చండి",
        "languageUpdated": "భాష విజయవంతంగా తెలుగుకు మార్చబడింది!",
        "zeroReentryNotice": "మీ రైతు ప్రొఫైల్ నుండి సమాచారం ఆటోమేటిక్‌గా లోడ్ చేయబడింది",
        "close": "మూసివేయి",
        "active": "యాక్టివ్",
        "status": "స్థితి"
    },
    "nav": {
        "home": "హోమ్",
        "dashboard": "డాష్‌బోర్డ్",
        "cropRecommendation": "పంట సిఫార్సు",
        "cropHistory": "సిఫార్సుల చరిత్ర",
        "diseaseDetection": "మొక్కల డాక్టర్",
        "weather": "వాతావరణం & సలహాలు",
        "market": "మార్కెట్ ధరలు",
        "schemes": "ప్రభుత్వ పథకాలు",
        "assistant": "AI సహాయకుడు",
        "profile": "రైతు ప్రొఫైల్",
        "settings": "సెట్టింగ్‌లు",
        "logout": "లాగ్ అవుట్",
        "login": "లాగిన్",
        "register": "రిజిస్టర్"
    },
    "onboarding": {
        "chooseLanguage": "మీ భాషను ఎంచుకోండి",
        "chooseLanguageSubtitle": "మీ ప్రాధాన్యత భాషను ఎంచుకోండి. యాప్ మొత్తం మరియు సలహాలు ఈ భాషలోనే ప్రదర్శించబడతాయి.",
        "continueBtn": "కొనసాగించండి",
        "stepLanguage": "భాష",
        "stepLocation": "స్థానం",
        "stepFarm": "భూమి & నేల",
        "stepComplete": "పూర్తయింది",
        "state": "రాష్ట్రం",
        "district": "జిల్లా",
        "village": "గ్రామం / పట్టణం",
        "pincode": "పిన్‌కోడ్",
        "landArea": "భూమి వైశాల్యం",
        "areaUnit": "యూనిట్",
        "hasSoilReport": "మీ వద్ద సాయిల్ హెల్త్ కార్డు రిపోర్ట్ ఉందా?",
        "yes": "అవును",
        "no": "లేదు",
        "soilType": "నేల రకం",
        "nitrogen": "నత్రజని (N)",
        "phosphorus": "భాస్వరం (P)",
        "potassium": "పొటాషియం (K)",
        "phLevel": "నేల pH స్థాయి",
        "irrigationType": "నీటిపారుదల రకం",
        "primaryCrop": "ప్రస్తుత / మునుపటి పంట",
        "experience": "వ్యవసాయ అనుభవం (సంవత్సరాలు)",
        "finishSetup": "ప్రొఫైల్ పూర్తి చేయండి",
        "selectState": "రాష్ట్రాన్ని ఎంచుకోండి",
        "enterDistrict": "జిల్లాను నమోదు చేయండి",
        "enterVillage": "గ్రామాన్ని నమోదు చేయండి"
    },
    "auth": {
        "loginTitle": "స్వాగతం, రైతు సోదరా",
        "loginDesc": "మీ వ్యవసాయ సలహాలు మరియు మార్కెట్ ధరలను పొందడానికి లాగిన్ అవ్వండి",
        "registerTitle": "రైతు నమోదు",
        "registerDesc": "ఆధునిక సమాచారంతో వ్యవసాయం చేయడానికి వేలాది మంది రైతులతో చేరండి",
        "step1Language": "దశ 1: భాషను ఎంచుకోండి",
        "step2Details": "దశ 2: రైతు వివరాలు",
        "fullName": "పూర్తి పేరు",
        "phone": "మొబైల్ నంబర్",
        "password": "పాస్‌వర్డ్",
        "confirmPassword": "పాస్‌వర్డ్ నిర్ధారణ",
        "enterFullName": "మీ పూర్తి పేరు నమోదు చేయండి",
        "enterPhone": "10 అంకెల మొబైల్ నంబర్ నమోదు చేయండి",
        "enterPassword": "పాస్‌వర్డ్ నమోదు చేయండి",
        "loginBtn": "లాగిన్ అవ్వండి",
        "registerBtn": "ఖాతాను సృష్టించండి",
        "noAccount": "ఖాతా లేదా? ఇక్కడ నమోదు చేసుకోండి",
        "haveAccount": "ఇప్పటికే ఖాతా ఉందా? లాగిన్ అవ్వండి",
        "guestMode": "డెమో డాష్‌బోర్డ్ చూడండి"
    },
    "dashboard": {
        "welcome": "నమస్కారం",
        "greetingSubtitle": "ఈ రోజు మీ వ్యవసాయ సారాంశం మరియు వాతావరణ సమాచారం ఇక్కడ ఉంది",
        "weatherCard": "నేటి వాతావరణం",
        "soilCard": "నేల ఆరోగ్య స్థితి",
        "soilOptimal": "ఖరీఫ్ విత్తనాలకు NPK సమతుల్యత అనుకూలంగా ఉంది",
        "cropRecommendCard": "AI పంట సిఫార్సు",
        "cropRecommendPrompt": "మీ నేల పరీక్ష మరియు స్థానిక వాతావరణం ఆధారంగా ఉత్తమ పంటను సిఫార్సు చేయండి",
        "startAnalysis": "పంట సిఫార్సును ప్రారంభించండి",
        "quickActions": "ముఖ్యమైన ఉపకరణాలు",
        "mandiHighlights": "సమీప మార్కెట్ ధరలు",
        "schemesHighlights": "రైతు సంక్షేమ పథకాలు",
        "assistantPrompt": "కిసాన్ AI సహాయకుడిని అడగండి",
        "viewWeather": "పూర్తి వాతావరణం",
        "viewMarket": "మార్కెట్ ధరలు",
        "viewSchemes": "అన్ని పథకాలు"
    },
    "cropRecommendation": {
        "title": "AI పంట సిఫార్సు",
        "subtitle": "జీరో రీ-ఎంట్రీతో రైతు ప్రొఫైల్ ఆధారిత స్మార్ట్ పంట నిర్ణయం",
        "prefilledBadge": "జీరో రీ-ఎంట్రీ: రైతు ప్రొఫైల్ నుండి సమాచారం లోడ్ చేయబడింది",
        "prefilledExpl": "మీ ప్రొఫైల్ నుండి నేల N-P-K, pH మరియు స్థానం ఆటోమేటిక్‌గా నింపబడ్డాయి. కొత్త పరిస్థితులను పరీక్షించడానికి మాత్రమే విలువలను మార్చండి.",
        "parametersSection": "నేల & వాతావరణ వివరాలు",
        "nitrogenLabel": "నత్రజని (N) - కిలో/హెక్టార్",
        "phosphorusLabel": "భాస్వరం (P) - కిలో/హెక్టార్",
        "potassiumLabel": "పొటాషియం (K) - కిలో/హెక్టార్",
        "phLabel": "నేల pH విలువ",
        "tempLabel": "ఉష్ణోగ్రత (°C)",
        "humidityLabel": "తేమ శాతం (%)",
        "rainfallLabel": "వర్షపాతం (మి.మీ)",
        "analyzeBtn": "విశ్లేషించి ఉత్తమ పంటను సిఫార్సు చేయండి",
        "analyzing": "AI నమూనా నేల మరియు వాతావరణాన్ని విశ్లేషిస్తోంది...",
        "resultTitle": "మీ భూమికి అత్యంత అనుకూలమైన పంట",
        "confidence": "సిఫార్సు ఖచ్చితత్వం",
        "alternateCrops": "ప్రత్యామ్నాయ అనుకూల పంటలు",
        "whyRecommended": "ఈ పంట ఎందుకు అనుకూలం?",
        "suitability": "సీజన్ అనుకూలత",
        "duration": "పంట కాలపరిమితి",
        "soilMatch": "నేల సరిపోలిక స్కోరు",
        "economicsTitle": "ఆర్థిక అంచనా (ఎకరానికి)",
        "costPerAcre": "అంచనా సాగు ఖర్చు",
        "yieldPerAcre": "ఆశించే దిగుబడి",
        "revenuePerAcre": "స్థూల రాబడి",
        "profitPotential": "నికర లాభ సామర్థ్యం",
        "fertilizerTitle": "వ్యక్తిగత ఎరువులు & పోషకాల ప్రణాళిక",
        "urea": "యూరియా",
        "dap": "డి.ఎ.పి (DAP)",
        "mop": "ఎం.ఒ.పి (పొటాష్)",
        "organicCompost": "పశువుల ఎరువు / కంపోస్ట్",
        "irrigationTitle": "నీటి నిర్వహణ మార్గదర్శకాలు",
        "riskFactors": "ప్రధాన నష్టాలు & నివారణ చర్యలు",
        "saveHistory": "చరిత్రలో భద్రపరచు",
        "savedSuccess": "పంట సిఫార్సు విజయవంతంగా భద్రపరచబడింది!",
        "viewHistory": "గత సిఫార్సులు చూడండి",
        "resetValues": "ప్రొఫైల్ డిఫాల్ట్‌లకు మార్చండి"
    },
    "cropHistory": {
        "title": "పంట సిఫార్సుల చరిత్ర",
        "subtitle": "మీ మునుపటి నేల పరీక్షలు మరియు పంట సిఫార్సుల రికార్డులను సమీక్షించండి",
        "emptyHistory": "ఇంకా ఎలాంటి సిఫార్సు చరిత్ర లేదు. మీ మొదటి విశ్లేషణను ప్రారంభించండి!",
        "date": "తేదీ",
        "recommendedCrop": "సిఫార్సు చేయబడిన పంట",
        "soilValues": "నేల N-P-K (కిలో/హెక్టార్)",
        "phValue": "pH",
        "weatherValues": "ఉష్ణోగ్రత / వర్షం",
        "score": "ఖచ్చితత్వం",
        "actions": "వివరాలు",
        "newAnalysis": "కొత్త పంట విశ్లేషణ",
        "filterCrop": "పంట ద్వారా ఫిల్టర్ చేయండి",
        "allCrops": "అన్ని పంటలు"
    },
    "diseaseDetection": {
        "title": "AI మొక్కల డాక్టర్ & తెగుళ్ల గుర్తింపు",
        "subtitle": "పంట ఆకుల ఫోటోలను అప్‌లోడ్ చేసి తెగుళ్లు, వ్యాధులను తక్షణమే గుర్తించండి",
        "uploadTitle": "ఆకు ఫోటోను అప్‌లోడ్ చేయండి లేదా తీయండి",
        "uploadHint": "ఆకులు, కాండం లేదా కాయల ఫోటోలను (JPG, PNG) అప్‌లోడ్ చేయవచ్చు",
        "sampleImages": "లేదా నమూనా ఫోటోలతో పరీక్షించండి:",
        "sample1": "టమోటా ముందస్తు తెగులు (Early Blight)",
        "sample2": "ద్రాక్ష బూడిద తెగులు (Powdery Mildew)",
        "sample3": "గోధుమ కుంకుమ తెగులు (Rust)",
        "sample4": "ఆరోగ్యకరమైన పత్తి మొక్క",
        "analyzing": "విజన్ AI తో పంటను పరిశీలిస్తోంది...",
        "diagnosisResult": "వ్యాధి నిర్ధారణ నివేదిక",
        "condition": "గుర్తించిన వ్యాధి",
        "healthy": "ఆరోగ్యకరమైన పంట - ఎలాంటి తెగుళ్లు లేవు",
        "severity": "తీవ్రత స్థాయి",
        "symptoms": "కనిపించే లక్షణాలు",
        "organicControl": "సేంద్రీయ మరియు సహజ నివారణ",
        "chemicalControl": "సిఫార్సు చేసిన రసాయన మందులు",
        "prevention": "భవిష్యత్తు జాగ్రత్తలు"
    },
    "weather": {
        "title": "వ్యవసాయ వాతావరణం & సలహాలు",
        "subtitle": "ఖచ్చితమైన స్థానిక వాతావరణం మరియు రోజువారీ వ్యవసాయ సూచనలు",
        "currentConditions": "ప్రస్తుత వాతావరణం",
        "temp": "ఉష్ణోగ్రత",
        "feelsLike": "అనిపించే ఉష్ణోగ్రత",
        "humidity": "గాలిలో తేమ",
        "wind": "గాలి వేగం",
        "rainChance": "వర్ష సూచన",
        "uvIndex": "UV సూచిక",
        "farmingAdvisory": "ఈ రోజు రైతు సలహా",
        "irrigationAdv": "నీటిపారుదల సలహా",
        "sprayingAdv": "మందుల పిచికారీ అనుకూలత",
        "forecast7Day": "7 రోజుల వాతావరణ అంచనా"
    },
    "market": {
        "title": "వ్యవసాయ మార్కెట్ ధరలు (మండి ధరలు)",
        "subtitle": "భారతదేశ వ్యాప్తంగా APMC వ్యవసాయ మార్కెట్ల తాజా హోల్‌సేల్ ధరలు",
        "searchPlaceholder": "పంట లేదా మార్కెట్ పేరును శోధించండి...",
        "commodity": "పంట / సరుకు",
        "mandi": "మార్కెట్ (మండి)",
        "district": "జిల్లా",
        "modalPrice": "సగటు ధర",
        "minPrice": "కనిష్ట ధర",
        "maxPrice": "గరిష్ట ధర",
        "trend": "ధరల ధోరణి",
        "arrivals": "మార్కెట్ రాక",
        "priceUnit": "రూ. / క్వింటాల్"
    },
    "schemes": {
        "title": "ప్రభుత్వ వ్యవసాయ పథకాలు",
        "subtitle": "రైతుల కోసం ఆర్థిక సహాయం, పంటల బీమా మరియు సబ్సిడీ పథకాలు",
        "searchSchemes": "పథకాలను శోధించండి...",
        "benefit": "పథకం ప్రయోజనం",
        "eligibility": "అర్హత నిబంధనలు",
        "documents": "అవసరమైన పత్రాలు",
        "applyBtn": "అధికారిక వెబ్‌సైట్ చూడండి",
        "centralScheme": "కేంద్ర ప్రభుత్వ పథకం",
        "stateScheme": "రాష్ట్ర ప్రభుత్వ పథకం"
    },
    "assistant": {
        "title": "కిసాన్ AI స్మార్ట్ సహాయకుడు",
        "subtitle": "మీ భాషలో పంటలు, ఎరువులు, తెగుళ్లు మరియు పథకాలపై 24/7 మార్గదర్శకత్వం",
        "inputPlaceholder": "పంటలు లేదా సమస్యలపై మీ ప్రశ్నను ఇక్కడ అడగండి...",
        "send": "పంపు",
        "suggestedTitle": "సాధారణ ప్రశ్నలు",
        "voiceInput": "మాట్లాడండి",
        "voiceListening": "వినబడుతోంది... మీ భాషలో మాట్లాడండి",
        "initialGreeting": "నమస్కారం! నేను మీ కిసాన్ AI సహాయకుడిని. ఈ రోజు మీకు ఏ విధంగా సహాయపడగలను?"
    },
    "profile": {
        "title": "రైతు ప్రొఫైల్",
        "subtitle": "మీ సంప్రదింపు సమాచారం, భూమి విస్తీర్ణం, నేల వివరాలు మరియు ప్రాధాన్య భాషను నిర్వహించండి",
        "personalDetails": "వ్యక్తిగత వివరాలు",
        "farmLocation": "భూమి స్థానం",
        "soilParameters": "నేల మరియు నీటి వివరాలు",
        "editProfile": "వివరాలు సవరించు",
        "saveChanges": "మార్పులను భద్రపరచు",
        "cancelEdit": "రద్దు",
        "profileUpdated": "రైతు ప్రొఫైల్ విజయవంతంగా నవీకరించబడింది!"
    },
    "settings": {
        "title": "యాప్ సెట్టింగ్‌లు",
        "subtitle": "మీ భాషా ప్రాధాన్యత మరియు యాప్ సెట్టింగ్‌లను అనుకూలీకరించండి",
        "languageTitle": "గ్లోబల్ అప్లికేషన్ భాష",
        "languageDescription": "మీకు నచ్చిన భాషను ఎంచుకోండి. యాప్ మొత్తం, సలహాలు మరియు పంట పేర్లు పేజీ రీలోడ్ లేకుండా వెంటనే మారతాయి.",
        "currentLanguage": "ప్రస్తుత భాష",
        "changeLanguage": "భాషను మార్చండి",
        "appPreferences": "యాప్ ప్రాధాన్యతలు",
        "offlineMode": "ఆఫ్‌లైన్ డేటా నిల్వ",
        "notifications": "వాతావరణ & పంట హెచ్చరికలు",
        "dataSync": "నేపథ్య డేటా సింక్",
        "appVersion": "వెర్షన్ 2.4.0 (PWA రెడీ)"
    }
}

# 3. Hindi (हिन्दी)
hi = {
    "common": {
        "appName": "किसान AI",
        "subtitle": "भारतीय किसानों के लिए एआई संचालित आधुनिक कृषि मंच",
        "save": "सुरक्षित करें",
        "cancel": "रद्द करें",
        "back": "वापस",
        "next": "आगे बढ़ें",
        "submit": "जमा करें",
        "edit": "संपादित करें",
        "delete": "हटाएं",
        "search": "खोजें",
        "loading": "लोड हो रहा है...",
        "viewAll": "सभी देखें",
        "viewDetails": "विवरण देखें",
        "error": "त्रुटि",
        "success": "सफलता",
        "retry": "पुनः प्रयास करें",
        "acres": "एकड़",
        "hectares": "हेक्टेयर",
        "kg": "किग्रा",
        "quintal": "क्विंटल",
        "language": "भाषा",
        "changeLanguage": "भाषा बदलें",
        "languageUpdated": "भाषा सफलतापूर्वक हिन्दी में अपडेट हो गई!",
        "zeroReentryNotice": "जानकारी आपकी किसान प्रोफाइल से स्वतः भरी गई है",
        "close": "बंद करें",
        "active": "सक्रिय",
        "status": "स्थिति"
    },
    "nav": {
        "home": "होम",
        "dashboard": "डैशबोर्ड",
        "cropRecommendation": "फसल अनुशंसा",
        "cropHistory": "अनुशंसा इतिहास",
        "diseaseDetection": "पौधा डॉक्टर",
        "weather": "मौसम व सलाह",
        "market": "मंडी भाव",
        "schemes": "सरकारी योजनाएं",
        "assistant": "एआई सहायक",
        "profile": "किसान प्रोफाइल",
        "settings": "सेटिंग्स",
        "logout": "लॉग आउट",
        "login": "लॉग इन",
        "register": "पंजीकरण"
    },
    "onboarding": {
        "chooseLanguage": "अपनी भाषा चुनें",
        "chooseLanguageSubtitle": "अपनी पसंदीदा भाषा चुनें। पूरा एप्लिकेशन और सभी कृषि सलाह इसी भाषा में उपलब्ध होंगे।",
        "continueBtn": "आगे बढ़ें",
        "stepLanguage": "भाषा",
        "stepLocation": "स्थान",
        "stepFarm": "खेत व मिट्टी",
        "stepComplete": "पूर्ण",
        "state": "राज्य",
        "district": "जिला",
        "village": "गांव / कस्बा",
        "pincode": "पिन कोड",
        "landArea": "भूमि का क्षेत्रफल",
        "areaUnit": "इकाई",
        "hasSoilReport": "क्या आपके पास मृदा स्वास्थ्य कार्ड रिपोर्ट है?",
        "yes": "हाँ",
        "no": "नहीं",
        "soilType": "मिट्टी का प्रकार",
        "nitrogen": "नाइट्रोजन (N)",
        "phosphorus": "फास्फोरस (P)",
        "potassium": "पोटेशियम (K)",
        "phLevel": "मिट्टी का pH",
        "irrigationType": "सिंचाई का साधन",
        "primaryCrop": "मुख्य / पिछली फसल",
        "experience": "खेती का अनुभव (वर्ष)",
        "finishSetup": "प्रोफाइल पूरी करें",
        "selectState": "राज्य चुनें",
        "enterDistrict": "जिला दर्ज करें",
        "enterVillage": "गांव दर्ज करें"
    },
    "auth": {
        "loginTitle": "स्वागत है, किसान भाई",
        "loginDesc": "अपनी सटीक कृषि सलाह और मंडी भाव देखने के लिए लॉग इन करें",
        "registerTitle": "किसान पंजीकरण",
        "registerDesc": "आधुनिक तकनीक से लाभ कमाने वाले हजारों किसानों से जुड़ें",
        "step1Language": "चरण 1: भाषा का चयन",
        "step2Details": "चरण 2: किसान विवरण",
        "fullName": "पूरा नाम",
        "phone": "मोबाइल नंबर",
        "password": "पासवर्ड",
        "confirmPassword": "पासवर्ड की पुष्टि",
        "enterFullName": "अपना पूरा नाम दर्ज करें",
        "enterPhone": "10 अंकों का मोबाइल नंबर दर्ज करें",
        "enterPassword": "पासवर्ड दर्ज करें",
        "loginBtn": "लॉग इन करें",
        "registerBtn": "खाता बनाएं",
        "noAccount": "खाता नहीं है? पंजीकरण करें",
        "haveAccount": "पहले से पंजीकृत हैं? लॉग इन करें",
        "guestMode": "डेमो डैशबोर्ड देखें"
    },
    "dashboard": {
        "welcome": "नमस्ते",
        "greetingSubtitle": "आज के लिए आपकी कृषि स्थिति और मौसम सलाह यहां है",
        "weatherCard": "आज का मौसम",
        "soilCard": "मृदा स्वास्थ्य स्थिति",
        "soilOptimal": "खरीफ बुवाई के लिए एनपीके पोषक तत्व संतुलित हैं",
        "cropRecommendCard": "स्मार्ट फसल अनुशंसा",
        "cropRecommendPrompt": "अपनी मिट्टी और मौसम के आधार पर सबसे उपयुक्त फसल की सलाह लें",
        "startAnalysis": "फसल अनुशंसा चलाएं",
        "quickActions": "त्वरित टूल्स",
        "mandiHighlights": "आज के मंडी भाव",
        "schemesHighlights": "सरकारी योजनाएं व सब्सिडी",
        "assistantPrompt": "किसान एआई सहायक से पूछें",
        "viewWeather": "विस्तृत मौसम",
        "viewMarket": "सभी मंडी भाव",
        "viewSchemes": "सभी योजनाएं"
    },
    "cropRecommendation": {
        "title": "एआई फसल अनुशंसा",
        "subtitle": "जीरो री-एंट्री के साथ आपकी प्रोफाइल से जुड़ी सटीक फसल सलाह",
        "prefilledBadge": "जीरो री-एंट्री: किसान प्रोफाइल से जानकारी स्वतः भरी गई",
        "prefilledExpl": "आपकी प्रोफाइल से मिट्टी के N-P-K, pH और स्थान की जानकारी पहले ही भरी गई है। आवश्यकता होने पर ही मान बदलें।",
        "parametersSection": "मिट्टी एवं जलवायु पैरामीटर",
        "nitrogenLabel": "नाइट्रोजन (N) - किग्रा/हेक्टेयर",
        "phosphorusLabel": "फास्फोरस (P) - किग्रा/हेक्टेयर",
        "potassiumLabel": "पोटेशियम (K) - किग्रा/हेक्टेयर",
        "phLabel": "मिट्टी का pH स्तर",
        "tempLabel": "तापमान (°C)",
        "humidityLabel": "हवा में नमी (%)",
        "rainfallLabel": "वर्षा (मिमी)",
        "analyzeBtn": "विश्लेषण करें और सर्वोत्तम फसल जानें",
        "analyzing": "एआई मॉडल मिट्टी और जलवायु का विश्लेषण कर रहा है...",
        "resultTitle": "आपकी भूमि के लिए सर्वोत्तम अनुशंसित फसल",
        "confidence": "सटीकता प्रतिशत",
        "alternateCrops": "अन्य उपयुक्त वैकल्पिक फसलें",
        "whyRecommended": "यह फसल क्यों अनुशंसित है?",
        "suitability": "मौसम अनुकूलता",
        "duration": "फसल की अवधि",
        "soilMatch": "मृदा अनुकूलता स्कोर",
        "economicsTitle": "अनुमानित आर्थिक लाभ (प्रति एकड़)",
        "costPerAcre": "अनुमानित खेती लागत",
        "yieldPerAcre": "अपेक्षित पैदावार",
        "revenuePerAcre": "अनुमानित कुल आय",
        "profitPotential": "शुद्ध लाभ संभावना",
        "fertilizerTitle": "उर्वरक एवं पोषण प्रबंधन",
        "urea": "यूरिया",
        "dap": "डी.ए.पी. (DAP)",
        "mop": "एम.ओ.पी. (पोटाश)",
        "organicCompost": "गोबर की खाद / कम्पोस्ट",
        "irrigationTitle": "सिंचाई एवं जल प्रबंधन सलाह",
        "riskFactors": "प्रमुख जोखिम एवं सावधानियां",
        "saveHistory": "इतिहास में सुरक्षित करें",
        "savedSuccess": "फसल अनुशंसा इतिहास में सुरक्षित कर ली गई!",
        "viewHistory": "पिछली अनुशंसाएं देखें",
        "resetValues": "प्रोफाइल मान पर रीसेट करें"
    },
    "cropHistory": {
        "title": "फसल अनुशंसा इतिहास",
        "subtitle": "अपनी पिछली मिट्टी जांच और एआई फसल अनुशंसाओं की समीक्षा करें",
        "emptyHistory": "कोई अनुशंसा इतिहास नहीं मिला। अपनी पहली फसल जांच चलाएं!",
        "date": "तारीख",
        "recommendedCrop": "अनुशंसित फसल",
        "soilValues": "मिट्टी N-P-K (किग्रा/हे)",
        "phValue": "pH मान",
        "weatherValues": "तापमान / वर्षा",
        "score": "सटीकता",
        "actions": "विवरण",
        "newAnalysis": "नई फसल जांच",
        "filterCrop": "फसल अनुसार खोजें",
        "allCrops": "सभी फसलें"
    },
    "diseaseDetection": {
        "title": "एआई पौधा डॉक्टर एवं रोग पहचान",
        "subtitle": "पौधे की पत्ती की तस्वीर अपलोड कर तुरंत बीमारी और समाधान जानें",
        "uploadTitle": "पत्ती की तस्वीर अपलोड करें",
        "uploadHint": "पत्ती, तने या फल की साफ तस्वीर (JPG, PNG) अपलोड करें",
        "sampleImages": "या नमूना चित्रों से परीक्षण करें:",
        "sample1": "टमाटर का अगेती झुलसा रोग (Early Blight)",
        "sample2": "अंगूर का चूर्णिल आसिता (Powdery Mildew)",
        "sample3": "गेहूं का रतुआ रोग (Rust)",
        "sample4": "स्वस्थ कपास का पौधा",
        "analyzing": "विजन एआई से रोग की जांच की जा रही है...",
        "diagnosisResult": "रोग निदान रिपोर्ट",
        "condition": "पहचाना गया रोग",
        "healthy": "स्वस्थ पौधा - कोई रोग नहीं पाया गया",
        "severity": "गंभीरता स्तर",
        "symptoms": "दिखने वाले लक्षण",
        "organicControl": "जैविक एवं प्राकृतिक उपचार",
        "chemicalControl": "अनुशंसित रासायनिक उपचार",
        "prevention": "भविष्य के लिए रोकथाम"
    },
    "weather": {
        "title": "कृषि मौसम पूर्वानुमान एवं सलाह",
        "subtitle": "सटीक स्थानीय मौसम और दैनिक कृषि कार्य संबंधी सलाह",
        "currentConditions": "वर्तमान मौसम",
        "temp": "तापमान",
        "feelsLike": "महसूस तापमान",
        "humidity": "नमी",
        "wind": "हवा की गति",
        "rainChance": "बारिश की संभावना",
        "uvIndex": "यूवी इंडेक्स",
        "farmingAdvisory": "आज की किसान सलाह",
        "irrigationAdv": "सिंचाई सलाह",
        "sprayingAdv": "दवा छिड़काव अनुकूलता",
        "forecast7Day": "7 दिनों का मौसम पूर्वानुमान"
    },
    "market": {
        "title": "लाइव एपीएमसी मंडी भाव",
        "subtitle": "देश भर की मंडियों से दैनिक थोक कृषि उपज मूल्य और रुझान",
        "searchPlaceholder": "फसल या मंडी खोजें...",
        "commodity": "फसल / जींस",
        "mandi": "मंडी का नाम",
        "district": "जिला",
        "modalPrice": "मॉडल भाव",
        "minPrice": "न्यूनतम भाव",
        "maxPrice": "अधिकतम भाव",
        "trend": "भाव का रुझान",
        "arrivals": "दैनिक आवक",
        "priceUnit": "₹ / क्विंटल"
    },
    "schemes": {
        "title": "सरकारी कृषि योजनाएं",
        "subtitle": "किसानों के लिए वित्तीय सहायता, फसल बीमा और सब्सिडी योजनाएं",
        "searchSchemes": "योजनाएं खोजें...",
        "benefit": "योजना का लाभ",
        "eligibility": "पात्रता शर्तें",
        "documents": "आवश्यक दस्तावेज",
        "applyBtn": "सरकारी पोर्टल पर आवेदन करें",
        "centralScheme": "केंद्र सरकार",
        "stateScheme": "राज्य सरकार"
    },
    "assistant": {
        "title": "किसान एआई स्मार्ट सहायक",
        "subtitle": "अपनी मातृभाषा में खेती, खाद, कीट और योजनाओं पर 24/7 सलाह पाएं",
        "inputPlaceholder": "फसल, कीट या मौसम के बारे में अपना सवाल यहां लिखें...",
        "send": "भेजें",
        "suggestedTitle": "अक्सर पूछे जाने वाले सवाल",
        "voiceInput": "बोलें",
        "voiceListening": "सुन रहे हैं... अपनी भाषा में बोलें",
        "initialGreeting": "नमस्ते! मैं आपका किसान एआई सहायक हूं। आज मैं आपकी खेती में क्या मदद कर सकता हूं?"
    },
    "profile": {
        "title": "किसान प्रोफाइल",
        "subtitle": "अपनी संपर्क जानकारी, खेत का स्थान, मिट्टी के पैरामीटर और भाषा प्रबंधित करें",
        "personalDetails": "व्यक्तिगत विवरण",
        "farmLocation": "खेत का स्थान",
        "soilParameters": "मिट्टी एवं सिंचाई विवरण",
        "editProfile": "संशोधित करें",
        "saveChanges": "बदलाव सहेजें",
        "cancelEdit": "रद्द करें",
        "profileUpdated": "किसान प्रोफाइल सफलतापूर्वक अपडेट हुई!"
    },
    "settings": {
        "title": "एप्लिकेशन सेटिंग्स",
        "subtitle": "अपनी भाषा प्राथमिकता और प्लेटफॉर्म सेटिंग्स प्रबंधित करें",
        "languageTitle": "वैश्विक एप्लिकेशन भाषा",
        "languageDescription": "अपनी भाषा चुनें। पूरी वेबसाइट, सभी सलाह और फसलों के नाम तुरंत बिना रीलोड बदले जाएंगे।",
        "currentLanguage": "सक्रिय भाषा",
        "changeLanguage": "भाषा बदलें",
        "appPreferences": "ऐप प्राथमिकताएं",
        "offlineMode": "ऑफ़लाइन डेटा स्टोरेज",
        "notifications": "मौसम एवं कृषि सूचनाएं",
        "dataSync": "बैकग्राउंड डेटा सिंक",
        "appVersion": "संस्करण 2.4.0 (PWA तैयार)"
    }
}

# Helper to create other Indian languages based on English template with native titles & localized key labels
def create_localized_dict(lang_code, lang_name, greeting_text, app_title_native):
    # Shallow copy en and customize top-level identifying headers and buttons
    d = json.loads(json.dumps(en))
    d["common"]["appName"] = app_title_native
    d["common"]["languageUpdated"] = f"Language updated successfully to {lang_name}!"
    d["dashboard"]["welcome"] = greeting_text
    d["auth"]["loginTitle"] = f"{greeting_text}, Farmer"
    d["assistant"]["initialGreeting"] = f"{greeting_text}! I am your Kisan AI assistant in {lang_name}. How can I assist your farming today?"
    return d

# Create other languages
ta_native = create_localized_dict("ta", "தமிழ்", "வணக்கம்", "கிசான் AI")
kn_native = create_localized_dict("kn", "ಕನ್ನಡ", "ನಮಸ್ಕಾರ", "ಕಿಸಾನ್ AI")
ml_native = create_localized_dict("ml", "മലയാളം", "നമസ്കാരം", "കിസാൻ AI")
mr_native = create_localized_dict("mr", "मराठी", "नमस्कार", "किसान AI")
bn_native = create_localized_dict("bn", "বাংলা", "নমস্কার", "কিসান AI")
gu_native = create_localized_dict("gu", "ગુજરાતી", "નમસ્તે", "કિસાન AI")
pa_native = create_localized_dict("pa", "ਪੰਜਾਬੀ", "ਸਤਿ ਸ੍ਰੀ ਅਕਾਲ", "ਕਿਸਾਨ AI")
or_native = create_localized_dict("or", "ଓଡ଼ିଆ", "ନମସ୍କାର", "କିସାନ AI")

# Specific native additions for Tamil
ta_native["nav"] = {
    "home": "முகப்பு", "dashboard": "டாஷ்போர்டு", "cropRecommendation": "பயிர் பரிந்துரை",
    "cropHistory": "பரிந்துரை வரலாறு", "diseaseDetection": "தாவர மருத்துவர்", "weather": "வானிலை & ஆலோசனைகள்",
    "market": "மண்டி சந்தை விலைகள்", "schemes": "அரசு திட்டங்கள்", "assistant": "AI உதவியாளர்",
    "profile": "விவசாயி சுயவிவரம்", "settings": "அமைப்புகள்", "logout": "வெளியேறு", "login": "உள்நுழை", "register": "பதிவுசெய்"
}
ta_native["common"]["changeLanguage"] = "மொழியை மாற்றவும்"
ta_native["common"]["save"] = "சேமி"
ta_native["common"]["cancel"] = "ரத்துசெய்"
ta_native["common"]["acres"] = "ஏக்கர்"
ta_native["common"]["quintal"] = "குவின்டால்"
ta_native["cropRecommendation"]["title"] = "AI பயிர் பரிந்துரை"
ta_native["cropRecommendation"]["analyzeBtn"] = "ஆராய்ந்து சிறந்த பயிரைப் பரிந்துரைக்கவும்"
ta_native["cropRecommendation"]["prefilledBadge"] = "ஜீரோ மறு நுழைவு: சுயவிவரத்திலிருந்து தானாக ஏற்றப்பட்டது"

# Specific native additions for Kannada
kn_native["nav"] = {
    "home": "ಮುಖಪುಟ", "dashboard": "ಡ್ಯಾಶ್‌ಬೋರ್ಡ್", "cropRecommendation": "ಬೆಳೆ ಶಿಫಾರಸು",
    "cropHistory": "ಶಿಫಾರಸು ಇತಿಹಾಸ", "diseaseDetection": "ಸಸ್ಯ ವೈದ್ಯ", "weather": "ಹವಾಮಾನ & ಸಲಹೆ",
    "market": "ಮಾರುಕಟ್ಟೆ ದರಗಳು", "schemes": "ಸರ್ಕಾರಿ ಯೋಜನೆಗಳು", "assistant": "AI ಸಹಾಯಕ",
    "profile": "ರೈತರ ಪ್ರೊಫೈಲ್", "settings": "ಸೆಟ್ಟಿಂಗ್‌ಗಳು", "logout": "ಲಾಗ್ ಔಟ್", "login": "ಲಾಗಿನ್", "register": "ನೋಂದಣಿ"
}
kn_native["common"]["changeLanguage"] = "ಭಾಷೆಯನ್ನು ಬದಲಾಯಿಸಿ"
kn_native["common"]["save"] = "ಉಳಿಸಿ"
kn_native["common"]["cancel"] = "ರದ್ದುಮಾಡಿ"
kn_native["common"]["acres"] = "ಎಕರೆ"
kn_native["common"]["quintal"] = "ಕ್ವಿಂಟಾಲ್"
kn_native["cropRecommendation"]["title"] = "AI ಬೆಳೆ ಶಿಫಾರಸು"
kn_native["cropRecommendation"]["analyzeBtn"] = "ವಿಶ್ಲೇಷಿಸಿ ಉತ್ತಮ ಬೆಳೆಯನ್ನು ಶಿಫಾರಸು ಮಾಡಿ"
kn_native["cropRecommendation"]["prefilledBadge"] = "ಶೂನ್ಯ ಮರು-ಪ್ರವೇಶ: ಪ್ರೊಫೈಲ್‌ನಿಂದ ಸ್ವಯಂ ಲೋಡ್ ಆಗಿದೆ"

# Specific native additions for Malayalam
ml_native["nav"] = {
    "home": "ഹോം", "dashboard": "ഡാഷ്‌ബോർഡ്", "cropRecommendation": "വിള ശുപാർശ",
    "cropHistory": "ശുപാർശ ചരിത്രം", "diseaseDetection": "സസ്യ ഡോക്ടർ", "weather": "കാലാവസ്ഥ & നിർദ്ദേശങ്ങൾ",
    "market": "വിപണി വിലകൾ", "schemes": "സർക്കാർ പദ്ധതികൾ", "assistant": "AI സഹായി",
    "profile": "കർഷക പ്രൊഫൈൽ", "settings": "ക്രമീകരണങ്ങൾ", "logout": "ലോഗ് ഔട്ട്", "login": "ലോഗിൻ", "register": "രജിസ്റ്റർ"
}
ml_native["common"]["changeLanguage"] = "ഭാഷ മാറ്റുക"
ml_native["cropRecommendation"]["title"] = "AI വിള ശുപാർശ"
ml_native["cropRecommendation"]["analyzeBtn"] = "വിശകലനം ചെയ്ത് മികച്ച വിള ശുപാർശ ചെയ്യുക"
ml_native["cropRecommendation"]["prefilledBadge"] = "സീറോ റീ-എൻട്രി: പ്രൊഫൈലിൽ നിന്ന് സ്വയം ലോഡ് ചെയ്തു"

# Specific native additions for Marathi
mr_native["nav"] = {
    "home": "मुख्यपृष्ठ", "dashboard": "डॅशबोर्ड", "cropRecommendation": "पीक शिफारस",
    "cropHistory": "शिफारस इतिहास", "diseaseDetection": "वनस्पती डॉक्टर", "weather": "हवामान व सल्ला",
    "market": "बाजार भाव", "schemes": "शासकीय योजना", "assistant": "एआय सहाय्यक",
    "profile": "शेतकरी प्रोफाइल", "settings": "सेटिंग्ज", "logout": "लॉग आउट", "login": "लॉग इन", "register": "नोंदणी"
}
mr_native["common"]["changeLanguage"] = "भाषा बदला"
mr_native["cropRecommendation"]["title"] = "एआय पीक शिफारस"
mr_native["cropRecommendation"]["analyzeBtn"] = "मातीचे विश्लेषण करून योग्य पीक निवडा"
mr_native["cropRecommendation"]["prefilledBadge"] = "झिरो री-एन्ट्री: प्रोफाइलमधून आपोआप भरले"

# Specific native additions for Bengali
bn_native["nav"] = {
    "home": "হোম", "dashboard": "ড্যাশবোর্ড", "cropRecommendation": "ফসল সুপারিশ",
    "cropHistory": "সুপারিশ ইতিহাস", "diseaseDetection": "উদ্ভিদ ডাক্তার", "weather": "আবহাওয়া ও পরামর্শ",
    "market": "বাজার দর", "schemes": "সরকারি প্রকল্প", "assistant": "এআই সহকারী",
    "profile": "কৃষক প্রোফাইল", "settings": "সেটিংস", "logout": "লগ আউট", "login": "লগ ইন", "register": "নিবন্ধন"
}
bn_native["common"]["changeLanguage"] = "ভাষা পরিবর্তন করুন"
bn_native["cropRecommendation"]["title"] = "এআই ফসল সুপারিশ"
bn_native["cropRecommendation"]["analyzeBtn"] = "বিশ্লেষণ করে সেরা ফসল সুপারিশ করুন"
bn_native["cropRecommendation"]["prefilledBadge"] = "জিরো রি-এন্ট্রি: প্রোফাইল থেকে স্বয়ংক্রিয়ভাবে লোড হয়েছে"

# Specific native additions for Gujarati
gu_native["nav"] = {
    "home": "હોમ", "dashboard": "ડૅશબોર્ડ", "cropRecommendation": "પાક ભલામણ",
    "cropHistory": "ભલામણ ઇતિહાસ", "diseaseDetection": "વનસ્પતિ ડૉક્ટર", "weather": "હવામાન & સલાહ",
    "market": "બજાર ભાવ", "schemes": "સરકારી યોજનાઓ", "assistant": "AI સહાયક",
    "profile": "ખેડૂત પ્રોફાઇલ", "settings": "સેટિંગ્સ", "logout": "લૉગ આઉટ", "login": "લૉગ ઇન", "register": "નોંધણી"
}
gu_native["common"]["changeLanguage"] = "ભાષા બદલો"
gu_native["cropRecommendation"]["title"] = "AI પાક ભલામણ"
gu_native["cropRecommendation"]["analyzeBtn"] = "વિશ્લેષણ કરી ઉત્તમ પાકની ભલામણ કરો"
gu_native["cropRecommendation"]["prefilledBadge"] = "ઝીરો રી-એન્ટ્રી: પ્રોફાઇલમાંથી આપમેળે લોડ થયેલ"

# Specific native additions for Punjabi
pa_native["nav"] = {
    "home": "ਹੋਮ", "dashboard": "ਡੈਸ਼ਬੋਰਡ", "cropRecommendation": "ਫ਼ਸਲ ਸਿਫ਼ਾਰਸ਼",
    "cropHistory": "ਸਿਫ਼ਾਰਸ਼ ਇਤਿਹਾਸ", "diseaseDetection": "ਪੌਦਾ ਡਾਕਟਰ", "weather": "ਮੌਸਮ ਅਤੇ ਸਲਾਹ",
    "market": "ਮੰਡੀ ਭਾਅ", "schemes": "ਸਰਕਾਰੀ ਸਕੀਮਾਂ", "assistant": "AI ਸਹਾਇਕ",
    "profile": "ਕਿਸਾਨ ਪ੍ਰੋਫਾਈਲ", "settings": "ਸੈਟਿੰਗਾਂ", "logout": "ਲਾਗ ਆਉਟ", "login": "ਲਾਗ ਇਨ", "register": "ਰਜਿਸਟਰੇਸ਼ਨ"
}
pa_native["common"]["changeLanguage"] = "ਭਾਸ਼ਾ ਬਦਲੋ"
pa_native["cropRecommendation"]["title"] = "AI ਫ਼ਸਲ ਸਿਫ਼ਾਰਸ਼"
pa_native["cropRecommendation"]["analyzeBtn"] = "ਵਿਸ਼ਲੇਸ਼ਣ ਕਰੋ ਅਤੇ ਵਧੀਆ ਫ਼ਸਲ ਚੁਣੋ"
pa_native["cropRecommendation"]["prefilledBadge"] = "ਜ਼ੀਰੋ ਰੀ-ਐਂਟਰੀ: ਪ੍ਰੋਫਾਈਲ ਤੋਂ ਆਪਣੇ-ਆਪ ਭਰਿਆ ਗਿਆ"

# Specific native additions for Odia
or_native["nav"] = {
    "home": "ମୂଳପୃଷ୍ଠା", "dashboard": "ଡ୍ୟାସବୋର୍ଡ", "cropRecommendation": "ଫସଲ ପରାମର୍ଶ",
    "cropHistory": "ପରାମର୍ଶ ଇତିହାସ", "diseaseDetection": "ଉଦ୍ଭିଦ ଡାକ୍ତର", "weather": "ପାଣିପାଗ ଓ ସୂଚନା",
    "market": "ମଣ୍ଡି ଦର", "schemes": "ସରକାରୀ ଯୋଜନା", "assistant": "AI ସହାୟକ",
    "profile": "କୃଷକ ପ୍ରୋଫାଇଲ୍", "settings": "ସେଟିଙ୍ଗ୍ସ", "logout": "ଲଗ୍ ଆଉଟ୍", "login": "ଲଗ୍ ଇନ୍", "register": "ପଞ୍ଜୀକରଣ"
}
or_native["common"]["changeLanguage"] = "ଭାଷା ପରିବର୍ତ୍ତନ କରନ୍ତୁ"
or_native["cropRecommendation"]["title"] = "AI ଫସଲ ପରାମର୍ଶ"
or_native["cropRecommendation"]["analyzeBtn"] = "ବିଶ୍ଳେଷଣ କରି ଉତ୍ତମ ଫସଲ ଚୟନ କରନ୍ତୁ"
or_native["cropRecommendation"]["prefilledBadge"] = "ଜିରୋ ରି-ଏଣ୍ଟ୍ରି: ପ୍ରୋଫାଇଲ୍‌ରୁ ସ୍ୱତଃ ପ୍ରବେଶ"

# Save all 11 files
locales = {
    "en": en, "te": te, "hi": hi, "ta": ta_native,
    "kn": kn_native, "ml": ml_native, "mr": mr_native,
    "bn": bn_native, "gu": gu_native, "pa": pa_native, "or": or_native
}

for code, data in locales.items():
    filepath = f"src/i18n/locales/{code}.json"
    with open(filepath, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    print(f"Wrote {filepath}")

print("All 11 locales successfully generated!")

