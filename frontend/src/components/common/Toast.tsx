import React from 'react';
import { CheckCircle2, X } from 'lucide-react';
import { useLanguage } from '../../context/LanguageContext';

export const Toast: React.FC = () => {
  const { toastMessage, hideToast } = useLanguage();

  if (!toastMessage) return null;

  return (
    <div className="toast-container" role="alert" aria-live="assertive">
      <div className="toast-card">
        <div className="toast-icon-box">
          <CheckCircle2 size={20} className="toast-icon" />
        </div>
        <div className="toast-content">
          <p className="toast-title">{toastMessage}</p>
        </div>
        <button onClick={hideToast} className="toast-close-btn" aria-label="Close notification">
          <X size={16} />
        </button>
      </div>
    </div>
  );
};
