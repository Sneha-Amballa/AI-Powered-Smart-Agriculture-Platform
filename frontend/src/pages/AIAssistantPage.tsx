import React, { useState, useRef, useEffect } from 'react';
import { useTranslation } from 'react-i18next';
import { Bot, Send, Mic, MicOff, Sparkles, User, HelpCircle, Volume2 } from 'lucide-react';
import { useLanguage } from '../context/LanguageContext';
import { useAuth } from '../context/AuthContext';
import { ChatMessage } from '../types';

export const AIAssistantPage: React.FC = () => {
  const { t } = useTranslation();
  const { currentLanguage, languageInfo } = useLanguage();
  const { user, profile } = useAuth();

  const [inputVal, setInputVal] = useState('');
  const [isListening, setIsListening] = useState(false);
  const messagesEndRef = useRef<HTMLDivElement>(null);

  const initialMessage: ChatMessage = {
    id: 'm-init',
    sender: 'assistant',
    text: t('assistant.initialGreeting'),
    timestamp: 'Just now',
    language: currentLanguage,
    suggested_prompts: [
      'What is the recommended fertilizer schedule for Paddy in Guntur?',
      'How do I control yellow rust on my wheat crop?',
      "What are today's market prices for Cotton in APMC mandis?",
      'How do I apply for the PM-KISAN ₹6,000 subsidy?',
    ],
  };

  const [messages, setMessages] = useState<ChatMessage[]>([initialMessage]);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages]);

  // When language changes, update initial assistant greeting dynamically
  useEffect(() => {
    setMessages((prev) => [
      {
        ...prev[0],
        text: t('assistant.initialGreeting'),
        language: currentLanguage,
      },
      ...prev.slice(1),
    ]);
  }, [currentLanguage]);

  const handleSend = (textToSend?: string) => {
    const text = (textToSend || inputVal).trim();
    if (!text) return;

    const userMsg: ChatMessage = {
      id: 'user-' + Date.now(),
      sender: 'user',
      text,
      timestamp: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
      language: currentLanguage,
    };

    setMessages((prev) => [...prev, userMsg]);
    setInputVal('');

    // Generate intelligent contextual reply in farmer's preferred language
    setTimeout(() => {
      let replyText = '';
      const lower = text.toLowerCase();

      if (lower.includes('fertilizer') || lower.includes('paddy') || lower.includes('వరి') || lower.includes('खाद')) {
        replyText = `Based on your farm's Soil Health Card (${profile?.district || 'Guntur'}, pH ${profile?.farm_details?.ph_level || 6.8}), your optimal fertilizer dose for Paddy is: 100 kg Urea + 50 kg DAP + 40 kg MOP per acre. Apply DAP and MOP as basal dose before puddling, and split Urea into two top dressings at 30 days and panicle initiation.`;
      } else if (lower.includes('rust') || lower.includes('disease') || lower.includes('తెగులు') || lower.includes('रोग')) {
        replyText = `For fungal leaf spots or rust, spray Propiconazole 25% EC @ 1ml per litre of water or Mancozeb 75% WP @ 2.5g/L during early morning hours. Also avoid excessive nitrogen top-dressing to prevent succulent leaf spread.`;
      } else if (lower.includes('price') || lower.includes('mandi') || lower.includes('ధర') || lower.includes('भाव')) {
        replyText = `Today's modal price for Paddy in Guntur APMC is ₹2,320 / Quintal (+3.2% trend), and Cotton is trading at ₹7,150 / Quintal. Market arrivals are steady with strong wholesale buyer demand.`;
      } else if (lower.includes('kisan') || lower.includes('scheme') || lower.includes('పథకం') || lower.includes('योजना')) {
        replyText = `You are eligible for PM-KISAN (₹6,000/year via direct bank transfer). Ensure your Aadhaar is linked with e-KYC on pmkisan.gov.in. You can also avail 50% farm machinery subsidy through the SMAM portal.`;
      } else {
        replyText = `Thank you for your question, ${user?.full_name?.split(' ')[0] || 'Farmer'}. In your region (${profile?.district || 'Guntur'}, ${profile?.state || 'Andhra Pradesh'}), current weather and soil moisture are favorable for Kharif farming operations. Feel free to ask about crop choices, pest remediation, or market wholesale rates in ${languageInfo.nativeName}!`;
      }

      const botMsg: ChatMessage = {
        id: 'bot-' + Date.now(),
        sender: 'assistant',
        text: replyText,
        timestamp: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
        language: currentLanguage,
      };

      setMessages((prev) => [...prev, botMsg]);
    }, 700);
  };

  const handleVoiceToggle = () => {
    if (!isListening) {
      setIsListening(true);
      setTimeout(() => {
        setIsListening(false);
        setInputVal('What is the fertilizer schedule for my paddy crop?');
      }, 2500);
    } else {
      setIsListening(false);
    }
  };

  return (
    <div className="assistant-page">
      <div className="assistant-header-strip">
        <div className="assistant-title-group">
          <div className="assistant-avatar">
            <Bot size={24} />
          </div>
          <div>
            <h1 className="assistant-title">{t('assistant.title')}</h1>
            <p className="assistant-subtitle">
              Responding in <strong>{languageInfo.nativeName} ({languageInfo.englishName})</strong>
            </p>
          </div>
        </div>
      </div>

      {/* Chat Area */}
      <div className="chat-window-card">
        <div className="messages-area">
          {messages.map((msg) => (
            <div key={msg.id} className={`message-bubble-row ${msg.sender}`}>
              <div className="bubble-avatar">
                {msg.sender === 'assistant' ? <Bot size={18} /> : <User size={18} />}
              </div>
              <div className="bubble-content-wrap">
                <div className="bubble-content">
                  <p>{msg.text}</p>
                </div>
                <span className="bubble-time">{msg.timestamp}</span>

                {/* Suggested Prompt Chips */}
                {msg.suggested_prompts && msg.suggested_prompts.length > 0 && (
                  <div className="suggested-prompts-row">
                    <span className="prompt-label">{t('assistant.suggestedTitle')}:</span>
                    <div className="prompt-chips">
                      {msg.suggested_prompts.map((p, idx) => (
                        <button
                          key={idx}
                          type="button"
                          onClick={() => handleSend(p)}
                          className="prompt-chip"
                        >
                          <span>{p}</span>
                        </button>
                      ))}
                    </div>
                  </div>
                )}
              </div>
            </div>
          ))}
          <div ref={messagesEndRef} />
        </div>

        {/* Input Bar */}
        <form
          onSubmit={(e) => {
            e.preventDefault();
            handleSend();
          }}
          className="chat-input-bar"
        >
          {isListening && (
            <div className="listening-pulse-banner">
              <Mic size={16} className="spin-icon text-red" />
              <span>{t('assistant.voiceListening')}</span>
            </div>
          )}

          <input
            type="text"
            value={inputVal}
            onChange={(e) => setInputVal(e.target.value)}
            placeholder={t('assistant.inputPlaceholder')}
            className="chat-text-input"
          />

          <button
            type="button"
            onClick={handleVoiceToggle}
            className={`voice-btn ${isListening ? 'active-listening' : ''}`}
            title={t('assistant.voiceInput')}
          >
            {isListening ? <MicOff size={18} /> : <Mic size={18} />}
          </button>

          <button
            type="submit"
            disabled={!inputVal.trim()}
            className="chat-send-btn"
            title={t('assistant.send')}
          >
            <Send size={18} />
          </button>
        </form>
      </div>
    </div>
  );
};
