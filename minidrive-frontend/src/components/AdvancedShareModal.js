import React, { useState } from 'react';
import { FiLock, FiUnlock, FiUsers, FiClock, FiDownload, FiX, FiCopy, FiQrCode, FiCheckCircle } from 'react-icons/fi';
import { QRCodeSVG } from 'qrcode.react'; // ← ADD THIS IMPORT
import api from '../services/api';

function AdvancedShareModal({ file, onClose, onShare }) {
  const [password, setPassword] = useState('');
  const [enablePassword, setEnablePassword] = useState(false);
  const [expiryOption, setExpiryOption] = useState('7d');
  const [customExpiry, setCustomExpiry] = useState('');
  const [maxDownloads, setMaxDownloads] = useState('');
  const [allowedUsers, setAllowedUsers] = useState([]);
  const [newUserEmail, setNewUserEmail] = useState('');
  const [viewOnly, setViewOnly] = useState(false);
  const [loading, setLoading] = useState(false);
  const [shareResult, setShareResult] = useState(null);
  const [error, setError] = useState('');

  const expiryOptions = [
    { value: '1h', label: '1 Hour' },
    { value: '24h', label: '24 Hours' },
    { value: '7d', label: '7 Days' },
    { value: '30d', label: '30 Days' },
    { value: 'custom', label: 'Custom' },
  ];

  const handleAddUser = () => {
    if (newUserEmail && !allowedUsers.includes(newUserEmail)) {
      setAllowedUsers([...allowedUsers, newUserEmail]);
      setNewUserEmail('');
    }
  };

  const handleRemoveUser = (email) => {
    setAllowedUsers(allowedUsers.filter(u => u !== email));
  };

  const copyToClipboard = (text) => {
    navigator.clipboard.writeText(text);
    alert('📋 Share link copied to clipboard!');
  };

  const handleSubmit = async () => {
    setLoading(true);
    setError('');
    
    try {
      const requestData = {
        password: enablePassword ? password : null,
        expiryOption: expiryOption,
        customExpiry: expiryOption === 'custom' ? customExpiry : null,
        maxDownloads: maxDownloads ? parseInt(maxDownloads) : null,
        allowedUsers: allowedUsers.length > 0 ? allowedUsers : null,
        viewOnly: viewOnly,
        folderSharing: false,
      };

      const response = await api.post(`/files/share/advanced/${file.id}`, requestData);
      console.log('✅ Share created:', response.data);
      
      setShareResult(response.data);
      if (onShare) onShare(response.data);
      
    } catch (error) {
      console.error('❌ Share failed:', error);
      setError(error.response?.data || 'Failed to create share link');
    } finally {
      setLoading(false);
    }
  };

  // If we have a share result, show the success popup
  if (shareResult) {
    return (
      <div style={styles.modalOverlay}>
        <div style={styles.successModal}>
          <div style={styles.successHeader}>
            <FiCheckCircle style={styles.successIcon} />
            <h2>✅ Share Link Created!</h2>
          </div>
          
          <div style={styles.resultContainer}>
            <div style={styles.urlContainer}>
              <span style={styles.urlLabel}>🔗 Share URL:</span>
              <div style={styles.urlRow}>
                <input 
                  type="text" 
                  value={shareResult.shareUrl} 
                  readOnly 
                  style={styles.urlInput}
                />
                <button onClick={() => copyToClipboard(shareResult.shareUrl)} style={styles.copyBtn}>
                  <FiCopy /> Copy
                </button>
              </div>
            </div>
            
            {/* ===== REAL QR CODE ===== */}
            <div style={styles.qrContainer}>
              {shareResult.shareUrl && (
                <QRCodeSVG 
                  value={shareResult.shareUrl} 
                  size={150}
                  level="H"
                  includeMargin={true}
                  style={styles.qrImage}
                />
              )}
              <span style={styles.qrLabel}>Scan with your phone</span>
            </div>
            
            <div style={styles.shareDetails}>
              <div style={styles.detailRow}>
                <span>🔐 Password Protected:</span>
                <span style={shareResult.passwordProtected ? styles.badgeYes : styles.badgeNo}>
                  {shareResult.passwordProtected ? '✅ Yes' : '❌ No'}
                </span>
              </div>
              <div style={styles.detailRow}>
                <span>⏰ Expires:</span>
                <span>{new Date(shareResult.expiryTime).toLocaleString()}</span>
              </div>
              <div style={styles.detailRow}>
                <span>📥 Downloads:</span>
                <span>{shareResult.downloadCount} / {shareResult.maxDownloads || '∞'}</span>
              </div>
              <div style={styles.detailRow}>
                <span>👁️ Permission:</span>
                <span>{shareResult.viewOnly ? 'View Only' : 'Can Download'}</span>
              </div>
              {shareResult.allowedUsers && shareResult.allowedUsers.length > 0 && (
                <div style={styles.detailRow}>
                  <span>👥 Allowed Users:</span>
                  <span>{shareResult.allowedUsers.join(', ')}</span>
                </div>
              )}
            </div>
          </div>
          
          <button onClick={onClose} style={styles.doneBtn}>
            Done
          </button>
        </div>
      </div>
    );
  }

  // Main form
  return (
    <div style={styles.modalOverlay}>
      <div style={styles.modal}>
        <button onClick={onClose} style={styles.closeBtn}>✕</button>
        <h2 style={styles.modalTitle}>🔗 Advanced Share: {file.fileName}</h2>

        {error && <div style={styles.errorMessage}>{error}</div>}

        {/* Password Protection */}
        <div style={styles.field}>
          <label style={styles.label}>
            <FiLock /> Password Protect
          </label>
          <div style={styles.toggleContainer}>
            <button
              onClick={() => setEnablePassword(!enablePassword)}
              style={{
                ...styles.toggleBtn,
                ...(enablePassword ? styles.toggleActive : {})
              }}
            >
              {enablePassword ? '🔒 Enabled' : '🔓 Disabled'}
            </button>
          </div>
          {enablePassword && (
            <input
              type="password"
              placeholder="Enter password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              style={styles.input}
            />
          )}
        </div>

        {/* Expiry */}
        <div style={styles.field}>
          <label style={styles.label}><FiClock /> Expires</label>
          <select
            value={expiryOption}
            onChange={(e) => setExpiryOption(e.target.value)}
            style={styles.select}
          >
            {expiryOptions.map(opt => (
              <option key={opt.value} value={opt.value}>{opt.label}</option>
            ))}
          </select>
          {expiryOption === 'custom' && (
            <input
              type="datetime-local"
              value={customExpiry}
              onChange={(e) => setCustomExpiry(e.target.value)}
              style={styles.input}
            />
          )}
        </div>

        {/* Max Downloads */}
        <div style={styles.field}>
          <label style={styles.label}><FiDownload /> Max Downloads</label>
          <input
            type="number"
            placeholder="Leave blank for unlimited"
            value={maxDownloads}
            onChange={(e) => setMaxDownloads(e.target.value)}
            style={styles.input}
          />
        </div>

        {/* Allowed Users */}
        <div style={styles.field}>
          <label style={styles.label}><FiUsers /> Share with Specific Users</label>
          <div style={styles.userInputContainer}>
            <input
              type="email"
              placeholder="Enter email address"
              value={newUserEmail}
              onChange={(e) => setNewUserEmail(e.target.value)}
              style={styles.input}
            />
            <button onClick={handleAddUser} style={styles.addUserBtn}>+ Add</button>
          </div>
          <div style={styles.userList}>
            {allowedUsers.map(email => (
              <span key={email} style={styles.userTag}>
                {email}
                <button onClick={() => handleRemoveUser(email)} style={styles.removeUserBtn}>✕</button>
              </span>
            ))}
          </div>
        </div>

        {/* Permission */}
        <div style={styles.field}>
          <label style={styles.label}>Permission</label>
          <div style={styles.permissionContainer}>
            <button
              onClick={() => setViewOnly(false)}
              style={{
                ...styles.permissionBtn,
                ...(!viewOnly ? styles.permissionActive : {})
              }}
            >
              📥 Can Download
            </button>
            <button
              onClick={() => setViewOnly(true)}
              style={{
                ...styles.permissionBtn,
                ...(viewOnly ? styles.permissionActive : {})
              }}
            >
              👁️ View Only
            </button>
          </div>
        </div>

        <div style={styles.buttonContainer}>
          <button onClick={onClose} style={styles.cancelBtn}>Cancel</button>
          <button onClick={handleSubmit} disabled={loading} style={styles.createBtn}>
            {loading ? 'Creating...' : 'Create Share Link'}
          </button>
        </div>
      </div>
    </div>
  );
}

const styles = {
  modalOverlay: {
    position: 'fixed',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: 'rgba(0,0,0,0.6)',
    display: 'flex',
    justifyContent: 'center',
    alignItems: 'center',
    zIndex: 9999,
  },
  modal: {
    backgroundColor: 'white',
    padding: '30px',
    borderRadius: '16px',
    maxWidth: '500px',
    width: '90%',
    maxHeight: '90vh',
    overflowY: 'auto',
    position: 'relative',
  },
  successModal: {
    backgroundColor: 'white',
    padding: '35px',
    borderRadius: '16px',
    maxWidth: '550px',
    width: '90%',
    maxHeight: '90vh',
    overflowY: 'auto',
    position: 'relative',
  },
  modalTitle: {
    marginTop: 0,
    marginBottom: '20px',
    fontSize: '20px',
  },
  closeBtn: {
    position: 'absolute',
    top: '10px',
    right: '15px',
    background: 'none',
    border: 'none',
    fontSize: '20px',
    cursor: 'pointer',
    color: '#888',
  },
  errorMessage: {
    backgroundColor: '#fee',
    color: '#c33',
    padding: '10px',
    borderRadius: '8px',
    marginBottom: '15px',
    fontSize: '14px',
  },
  field: {
    marginBottom: '20px',
  },
  label: {
    display: 'flex',
    alignItems: 'center',
    gap: '8px',
    fontSize: '14px',
    fontWeight: '600',
    marginBottom: '8px',
    color: '#333',
  },
  input: {
    width: '100%',
    padding: '10px',
    border: '1px solid #ddd',
    borderRadius: '8px',
    fontSize: '14px',
    marginTop: '8px',
  },
  select: {
    width: '100%',
    padding: '10px',
    border: '1px solid #ddd',
    borderRadius: '8px',
    fontSize: '14px',
    backgroundColor: 'white',
  },
  toggleContainer: {
    display: 'flex',
    gap: '10px',
  },
  toggleBtn: {
    padding: '8px 16px',
    border: '1px solid #ddd',
    borderRadius: '8px',
    background: 'white',
    cursor: 'pointer',
    fontSize: '14px',
  },
  toggleActive: {
    backgroundColor: '#667eea',
    color: 'white',
    borderColor: '#667eea',
  },
  userInputContainer: {
    display: 'flex',
    gap: '10px',
  },
  addUserBtn: {
    padding: '10px 16px',
    backgroundColor: '#28a745',
    color: 'white',
    border: 'none',
    borderRadius: '8px',
    cursor: 'pointer',
  },
  userList: {
    display: 'flex',
    flexWrap: 'wrap',
    gap: '8px',
    marginTop: '10px',
  },
  userTag: {
    backgroundColor: '#e8f0fe',
    padding: '5px 10px',
    borderRadius: '20px',
    fontSize: '13px',
    display: 'flex',
    alignItems: 'center',
    gap: '6px',
  },
  removeUserBtn: {
    background: 'none',
    border: 'none',
    cursor: 'pointer',
    color: '#888',
    fontSize: '12px',
  },
  permissionContainer: {
    display: 'flex',
    gap: '10px',
  },
  permissionBtn: {
    padding: '10px 20px',
    border: '1px solid #ddd',
    borderRadius: '8px',
    background: 'white',
    cursor: 'pointer',
    flex: 1,
  },
  permissionActive: {
    backgroundColor: '#667eea',
    color: 'white',
    borderColor: '#667eea',
  },
  buttonContainer: {
    display: 'flex',
    gap: '10px',
    marginTop: '20px',
  },
  cancelBtn: {
    flex: 1,
    padding: '12px',
    backgroundColor: '#6c757d',
    color: 'white',
    border: 'none',
    borderRadius: '8px',
    cursor: 'pointer',
  },
  createBtn: {
    flex: 2,
    padding: '12px',
    backgroundColor: '#667eea',
    color: 'white',
    border: 'none',
    borderRadius: '8px',
    cursor: 'pointer',
  },
  successHeader: {
    display: 'flex',
    alignItems: 'center',
    gap: '12px',
    marginBottom: '20px',
  },
  successIcon: {
    fontSize: '36px',
    color: '#28a745',
  },
  resultContainer: {
    backgroundColor: '#f8f9fa',
    padding: '20px',
    borderRadius: '12px',
    marginBottom: '20px',
  },
  urlContainer: {
    marginBottom: '15px',
  },
  urlLabel: {
    fontSize: '14px',
    fontWeight: '600',
    display: 'block',
    marginBottom: '8px',
  },
  urlRow: {
    display: 'flex',
    gap: '10px',
  },
  urlInput: {
    flex: 1,
    padding: '8px 12px',
    border: '1px solid #ddd',
    borderRadius: '6px',
    fontSize: '13px',
    backgroundColor: 'white',
  },
  copyBtn: {
    padding: '8px 16px',
    backgroundColor: '#17a2b8',
    color: 'white',
    border: 'none',
    borderRadius: '6px',
    cursor: 'pointer',
    display: 'flex',
    alignItems: 'center',
    gap: '6px',
  },
  qrContainer: {
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    margin: '15px 0',
    padding: '10px',
    backgroundColor: 'white',
    borderRadius: '8px',
  },
  qrImage: {
    padding: '5px',
  },
  qrLabel: {
    fontSize: '12px',
    color: '#888',
    marginTop: '8px',
  },
  shareDetails: {
    display: 'flex',
    flexDirection: 'column',
    gap: '6px',
    marginTop: '10px',
  },
  detailRow: {
    display: 'flex',
    justifyContent: 'space-between',
    fontSize: '14px',
    padding: '4px 0',
    borderBottom: '1px solid #eee',
  },
  badgeYes: {
    color: '#28a745',
    fontWeight: '600',
  },
  badgeNo: {
    color: '#dc3545',
    fontWeight: '600',
  },
  doneBtn: {
    width: '100%',
    padding: '12px',
    backgroundColor: '#28a745',
    color: 'white',
    border: 'none',
    borderRadius: '8px',
    cursor: 'pointer',
    fontSize: '16px',
    fontWeight: '600',
  },
};

export default AdvancedShareModal;