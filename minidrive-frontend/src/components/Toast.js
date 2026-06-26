import React, { useState, useEffect } from 'react';
import { FiX, FiCheckCircle, FiAlertCircle, FiInfo, FiAlertTriangle } from 'react-icons/fi';

export const toast = {
  success: (message) => showToast(message, 'success'),
  error: (message) => showToast(message, 'error'),
  info: (message) => showToast(message, 'info'),
  warning: (message) => showToast(message, 'warning'),
};

let showToastFn;

function ToastContainer() {
  const [toasts, setToasts] = useState([]);

  useEffect(() => {
    showToastFn = (message, type) => {
      const id = Date.now();
      setToasts(prev => [...prev, { id, message, type }]);
      setTimeout(() => {
        setToasts(prev => prev.filter(t => t.id !== id));
      }, 3000);
    };
  }, []);

  const removeToast = (id) => {
    setToasts(prev => prev.filter(t => t.id !== id));
  };

  if (toasts.length === 0) return null;

  return (
    <div style={styles.container}>
      {toasts.map((toast) => (
        <div key={toast.id} style={{...styles.toast, ...styles[toast.type]}}>
          <span style={styles.icon}>{getIcon(toast.type)}</span>
          <span style={styles.message}>{toast.message}</span>
          <button onClick={() => removeToast(toast.id)} style={styles.closeBtn}>
            <FiX />
          </button>
        </div>
      ))}
    </div>
  );
}

function getIcon(type) {
  switch(type) {
    case 'success': return <FiCheckCircle />;
    case 'error': return <FiAlertCircle />;
    case 'warning': return <FiAlertTriangle />;
    default: return <FiInfo />;
  }
}

function showToast(message, type) {
  if (showToastFn) {
    showToastFn(message, type);
  }
}

const styles = {
  container: {
    position: 'fixed',
    top: '20px',
    right: '20px',
    zIndex: 999999,
    display: 'flex',
    flexDirection: 'column',
    gap: '10px',
  },
  toast: {
    display: 'flex',
    alignItems: 'center',
    gap: '12px',
    padding: '14px 20px',
    borderRadius: '8px',
    boxShadow: '0 4px 12px rgba(0,0,0,0.15)',
    minWidth: '300px',
    maxWidth: '450px',
    animation: 'slideIn 0.3s ease',
  },
  success: { backgroundColor: '#d4edda', color: '#155724', borderLeft: '4px solid #28a745' },
  error: { backgroundColor: '#f8d7da', color: '#721c24', borderLeft: '4px solid #dc3545' },
  warning: { backgroundColor: '#fff3cd', color: '#856404', borderLeft: '4px solid #ffc107' },
  info: { backgroundColor: '#d1ecf1', color: '#0c5460', borderLeft: '4px solid #17a2b8' },
  icon: { fontSize: '20px' },
  message: { flex: 1, fontSize: '14px' },
  closeBtn: {
    background: 'none',
    border: 'none',
    cursor: 'pointer',
    color: 'inherit',
    fontSize: '16px',
    opacity: 0.6,
  },
};

// Add animation
const styleSheet = document.createElement("style");
styleSheet.textContent = `
  @keyframes slideIn {
    from { transform: translateX(100%); opacity: 0; }
    to { transform: translateX(0); opacity: 1; }
  }
`;
document.head.appendChild(styleSheet);

export default ToastContainer;

// Attach helper methods to the default export so it can be used as `toast.success()`
ToastContainer.success = (message) => showToast(message, 'success');
ToastContainer.error = (message) => showToast(message, 'error');
ToastContainer.info = (message) => showToast(message, 'info');
ToastContainer.warning = (message) => showToast(message, 'warning');