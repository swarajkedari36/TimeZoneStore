import React, { useState, useEffect, useRef } from 'react';
import { useParams } from 'react-router-dom';
import api from '../services/api';

function ShareView() {
  const { token } = useParams();
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [fileName, setFileName] = useState('');
  const [fileSize, setFileSize] = useState('');
  const [viewOnly, setViewOnly] = useState(false);
  const [downloadCount, setDownloadCount] = useState(0);
  const [maxDownloads, setMaxDownloads] = useState(null);
  const [expiryTime, setExpiryTime] = useState(null);
  const [passwordProtected, setPasswordProtected] = useState(false);
  const [enteredPassword, setEnteredPassword] = useState('');
  const [isPasswordValid, setIsPasswordValid] = useState(false);
  const [checkingPassword, setCheckingPassword] = useState(false);
  const [showDownload, setShowDownload] = useState(false);
  const [passwordAttempts, setPasswordAttempts] = useState(0);
  const [maxPasswordAttempts] = useState(3);
  const [isLocked, setIsLocked] = useState(false);
  const [fileInfoLoaded, setFileInfoLoaded] = useState(false);
  
  const passwordInputRef = useRef(null);

  // Check if link is valid - ONLY ONCE
  useEffect(() => {
    const checkLink = async () => {
      try {
        console.log('🔍 Checking token:', token);
        
        const response = await api.post(`/share/validate/${token}`, {});
        console.log('✅ Share info:', response.data);
        
        setFileName(response.data.fileName);
        setFileSize(formatFileSize(response.data.fileSize));
        setViewOnly(response.data.viewOnly);
        setDownloadCount(response.data.downloadCount);
        setMaxDownloads(response.data.maxDownloads);
        setExpiryTime(new Date(response.data.expiryTime));
        setPasswordProtected(response.data.passwordProtected || false);
        setFileInfoLoaded(true);
        
        if (!response.data.passwordProtected) {
          setShowDownload(true);
        }
        
        setLoading(false);
      } catch (error) {
        console.error('❌ Error:', error);
        const errorMsg = error.response?.data || error.message;
        
        // Check if password is required
        if (typeof errorMsg === 'string' && 
            (errorMsg.toLowerCase().includes('password') || 
             errorMsg.toLowerCase().includes('incorrect'))) {
          setPasswordProtected(true);
          setFileInfoLoaded(true);
          setLoading(false);
        } else if (errorMsg === 'Share link not found' || error.response?.status === 404) {
          setError('Link not found');
          setLoading(false);
        } else {
          setError(typeof errorMsg === 'string' ? errorMsg : 'Link has expired or is invalid');
          setLoading(false);
        }
      }
    };

    checkLink();
  }, [token]);

  // Focus password input when it appears
  useEffect(() => {
    if (passwordProtected && !isPasswordValid && !showDownload && !isLocked) {
      setTimeout(() => {
        if (passwordInputRef.current) {
          passwordInputRef.current.focus();
        }
      }, 100);
    }
  }, [passwordProtected, isPasswordValid, showDownload, isLocked]);

  // Format file size
  const formatFileSize = (bytes) => {
    if (!bytes || bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
  };

  // Handle password submission
  const handlePasswordSubmit = async () => {
    // Don't proceed if locked
    if (isLocked) return;
    
    // Don't proceed if no password entered
    if (!enteredPassword.trim()) {
      setError('Please enter a password');
      return;
    }

    setCheckingPassword(true);
    setError('');
    
    try {
      const response = await api.post(`/share/validate/${token}`, {
        password: enteredPassword
      });
      
      console.log('✅ Password correct:', response.data);
      setIsPasswordValid(true);
      setFileName(response.data.fileName);
      setFileSize(formatFileSize(response.data.fileSize));
      setViewOnly(response.data.viewOnly);
      setDownloadCount(response.data.downloadCount);
      setMaxDownloads(response.data.maxDownloads);
      setExpiryTime(new Date(response.data.expiryTime));
      setShowDownload(true);
      setError('');
      setPasswordAttempts(0);
      
    } catch (error) {
      console.error('❌ Password check failed:', error);
      
      // Increment attempts
      const newAttempts = passwordAttempts + 1;
      setPasswordAttempts(newAttempts);
      
      // Check if max attempts reached
      if (newAttempts >= maxPasswordAttempts) {
        setIsLocked(true);
        setError('Too many failed attempts. Link is now locked.');
      } else {
        setError(`Incorrect password. ${maxPasswordAttempts - newAttempts} attempts remaining.`);
      }
      
      // Clear password field but KEEP THE COMPONENT VISIBLE
      setEnteredPassword('');
      
      // Focus the input for next attempt
      setTimeout(() => {
        if (passwordInputRef.current) {
          passwordInputRef.current.focus();
        }
      }, 100);
      
    } finally {
      setCheckingPassword(false);
    }
  };

  // Handle download
  const handleDownload = async () => {
    try {
      const response = await api.get(`/files/public/${token}`, {
        responseType: 'blob',
      });

      const url = window.URL.createObjectURL(new Blob([response.data]));
      const link = document.createElement('a');
      link.href = url;
      
      let filename = 'download';
      const contentDisposition = response.headers['content-disposition'];
      if (contentDisposition) {
        const match = contentDisposition.match(/filename="(.+)"/);
        if (match) {
          filename = match[1];
        }
      }
      
      link.setAttribute('download', filename);
      document.body.appendChild(link);
      link.click();
      link.remove();
      window.URL.revokeObjectURL(url);
      
    } catch (error) {
      console.error('Download failed:', error);
      alert('Download failed!');
    }
  };

  // Calculate time remaining
  const getTimeRemaining = () => {
    if (!expiryTime) return '';
    const now = new Date();
    const diff = expiryTime - now;
    if (diff <= 0) return 'Expired';
    const hours = Math.floor(diff / (1000 * 60 * 60));
    const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
    if (hours > 0) return `${hours}h ${minutes}m remaining`;
    return `${minutes}m remaining`;
  };

  // ========== RENDER SECTIONS ==========

  // Loading state
  if (loading) {
    return (
      <div style={styles.container}>
        <div style={styles.card}>
          <div style={styles.spinner}>⏳</div>
          <p>Loading your file...</p>
        </div>
      </div>
    );
  }

  // Error state (only for non-password errors)
  if (error && !passwordProtected) {
    return (
      <div style={styles.container}>
        <div style={styles.card}>
          <div style={styles.errorIcon}>⚠️</div>
          <h2>Link Invalid</h2>
          <p>{error}</p>
          <a href="/login" style={styles.button}>Go to Mini Drive</a>
        </div>
      </div>
    );
  }

  // ===== PASSWORD VIEW (STAYS VISIBLE UNTIL SUCCESS OR LOCK) =====
  if (passwordProtected && !isPasswordValid && !showDownload) {
    const attemptsLeft = maxPasswordAttempts - passwordAttempts;

    // LOCKED STATE - Stays visible but shows lock message
    if (isLocked) {
      return (
        <div style={styles.container}>
          <div style={styles.card}>
            <div style={styles.lockedIcon}>🚫</div>
            <h2>🔒 Link Locked</h2>
            <p style={styles.lockedMessage}>
              Too many failed password attempts.
            </p>
            <p style={styles.lockedHint}>
              This link has been locked for security reasons.
            </p>
            <p style={styles.lockedSubHint}>
              Please contact the file owner for a new link.
            </p>
            <a href="/login" style={styles.button}>Go to Mini Drive</a>
          </div>
        </div>
      );
    }

    // PASSWORD INPUT VIEW - ALWAYS VISIBLE
    return (
      <div style={styles.container}>
        <div style={styles.card}>
          <div style={styles.fileIcon}>🔒</div>
          <h2>Password Protected File</h2>
          <p style={styles.message}>Enter the password to access this file</p>
          
          {/* Password Input - ALWAYS VISIBLE */}
          <div style={styles.passwordContainer}>
            <input
              ref={passwordInputRef}
              type="password"
              placeholder={`Enter password (${attemptsLeft} attempts left)`}
              value={enteredPassword}
              onChange={(e) => setEnteredPassword(e.target.value)}
              onKeyPress={(e) => e.key === 'Enter' && handlePasswordSubmit()}
              style={styles.passwordInput}
              disabled={checkingPassword || isLocked}
              autoFocus
            />
            <button 
              onClick={handlePasswordSubmit} 
              disabled={checkingPassword || isLocked || !enteredPassword.trim()}
              style={{
                ...styles.submitBtn,
                ...((checkingPassword || isLocked || !enteredPassword.trim()) ? styles.submitBtnDisabled : {})
              }}
            >
              {checkingPassword ? 'Checking...' : 'Unlock'}
            </button>
          </div>
          
          {/* Attempts remaining indicator */}
          <div style={styles.attemptsContainer}>
            <span style={styles.attemptsText}>
              Attempts remaining: 
              <strong style={attemptsLeft <= 1 ? styles.attemptsWarning : styles.attemptsNormal}>
                {' '}{attemptsLeft}
              </strong>
            </span>
          </div>
          
          {/* Error message - STAYS VISIBLE */}
          {error && (
            <div style={styles.errorContainer}>
              <span style={styles.errorText}>❌ {error}</span>
            </div>
          )}
        </div>
      </div>
    );
  }

  // ===== DOWNLOAD VIEW =====
  return (
    <div style={styles.container}>
      <div style={styles.card}>
        <div style={styles.fileIcon}>📁</div>
        <h2>File Ready for Download</h2>
        {fileName && <p style={styles.fileName}>📄 {fileName}</p>}
        {fileSize && <p style={styles.fileSize}>Size: {fileSize}</p>}
        {expiryTime && (
          <p style={styles.expiryInfo}>⏰ {getTimeRemaining()}</p>
        )}
        {maxDownloads && (
          <p style={styles.downloadInfo}>
            📥 Downloads: {downloadCount} / {maxDownloads}
          </p>
        )}
        {viewOnly && (
          <p style={styles.viewOnlyInfo}>👁️ View Only (Download disabled)</p>
        )}

        <div style={styles.expiryNote}>
          ⏰ This link expires in {getTimeRemaining()}
        </div>

        {viewOnly ? (
          <div style={styles.viewOnlyMessage}>
            <p>🔒 This file is view-only. Download is not available.</p>
          </div>
        ) : (
          <button 
            onClick={handleDownload} 
            style={{
              ...styles.downloadButton,
              ...(downloadCount >= maxDownloads ? styles.disabledButton : {})
            }}
            disabled={downloadCount >= maxDownloads}
          >
            {downloadCount >= maxDownloads && maxDownloads > 0 ? 'Download Limit Reached' : '⬇️ Download File'}
          </button>
        )}

        {downloadCount >= maxDownloads && maxDownloads > 0 && (
          <p style={styles.limitReached}>⚠️ Download limit reached. Link is no longer active.</p>
        )}

        <p style={styles.footer}>Powered by Mini Drive</p>
      </div>
    </div>
  );
}

const styles = {
  container: {
    minHeight: '100vh',
    background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    padding: '20px',
  },
  card: {
    backgroundColor: 'white',
    borderRadius: '16px',
    padding: '40px',
    textAlign: 'center',
    maxWidth: '450px',
    width: '100%',
    boxShadow: '0 20px 60px rgba(0,0,0,0.2)',
  },
  fileIcon: { fontSize: '64px', marginBottom: '10px' },
  errorIcon: { fontSize: '48px', marginBottom: '20px' },
  spinner: { fontSize: '40px', animation: 'spin 1s linear infinite', marginBottom: '20px' },
  fileName: { fontSize: '18px', fontWeight: 'bold', color: '#333', marginTop: '5px' },
  fileSize: { fontSize: '14px', color: '#666', marginTop: '5px' },
  expiryInfo: { fontSize: '14px', color: '#666', marginTop: '5px' },
  downloadInfo: { fontSize: '14px', color: '#666', marginTop: '5px' },
  viewOnlyInfo: { 
    fontSize: '14px', 
    color: '#856404', 
    marginTop: '5px', 
    backgroundColor: '#fff3cd', 
    padding: '5px 10px', 
    borderRadius: '4px' 
  },
  message: { color: '#666', margin: '15px 0' },
  expiryNote: { 
    backgroundColor: '#fff3cd', 
    border: '1px solid #ffc107', 
    borderRadius: '8px', 
    padding: '12px', 
    margin: '20px 0', 
    color: '#856404', 
    fontSize: '14px' 
  },
  downloadButton: { 
    backgroundColor: '#28a745', 
    color: 'white', 
    border: 'none', 
    padding: '14px 28px', 
    borderRadius: '8px', 
    fontSize: '18px', 
    cursor: 'pointer', 
    width: '100%', 
    marginTop: '10px' 
  },
  disabledButton: { backgroundColor: '#6c757d', cursor: 'not-allowed' },
  button: { 
    display: 'inline-block', 
    backgroundColor: '#667eea', 
    color: 'white', 
    textDecoration: 'none', 
    padding: '12px 24px', 
    borderRadius: '8px', 
    marginTop: '20px' 
  },
  footer: { marginTop: '20px', fontSize: '12px', color: '#aaa' },
  
  // Password styles
  passwordContainer: { 
    display: 'flex', 
    gap: '10px', 
    marginTop: '20px' 
  },
  passwordInput: { 
    flex: 1, 
    padding: '12px', 
    border: '1px solid #ddd', 
    borderRadius: '8px', 
    fontSize: '16px',
    outline: 'none',
    transition: 'border-color 0.2s',
  },
  submitBtn: { 
    padding: '12px 24px', 
    backgroundColor: '#667eea', 
    color: 'white', 
    border: 'none', 
    borderRadius: '8px', 
    cursor: 'pointer', 
    fontSize: '16px',
    transition: 'background-color 0.2s',
  },
  submitBtnDisabled: {
    backgroundColor: '#ccc',
    cursor: 'not-allowed',
  },
  
  // Error container - STAYS VISIBLE
  errorContainer: {
    marginTop: '12px',
    padding: '10px',
    backgroundColor: '#f8d7da',
    borderRadius: '6px',
    border: '1px solid #f5c6cb',
  },
  errorText: { 
    color: '#721c24', 
    fontSize: '14px',
  },
  
  // Attempts indicator
  attemptsContainer: {
    marginTop: '12px',
    padding: '8px',
    backgroundColor: '#f8f9fa',
    borderRadius: '6px',
  },
  attemptsText: {
    fontSize: '14px',
    color: '#666',
  },
  attemptsNormal: {
    color: '#28a745',
  },
  attemptsWarning: {
    color: '#dc3545',
    fontWeight: 'bold',
  },
  
  // Locked state
  lockedIcon: {
    fontSize: '64px',
    marginBottom: '10px',
  },
  lockedMessage: {
    color: '#dc3545',
    fontSize: '16px',
    fontWeight: 'bold',
  },
  lockedHint: {
    color: '#666',
    fontSize: '14px',
    marginTop: '10px',
  },
  lockedSubHint: {
    color: '#888',
    fontSize: '13px',
    marginTop: '5px',
  },
  
  viewOnlyMessage: { 
    backgroundColor: '#f8d7da', 
    color: '#721c24', 
    padding: '12px', 
    borderRadius: '8px', 
    marginTop: '10px' 
  },
  limitReached: { 
    color: '#dc3545', 
    marginTop: '10px', 
    fontSize: '14px' 
  },
};

// Add keyframes for spinner
const styleSheet = document.createElement("style");
styleSheet.textContent = `@keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }`;
document.head.appendChild(styleSheet);

export default ShareView;