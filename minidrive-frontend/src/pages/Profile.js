import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useTheme } from '../context/ThemeContext';
import Navbar from '../components/Navbar';
import api from '../services/api';
import { toast } from '../components/Toast';
import {
  FiUser,
  FiMail,
  FiCalendar,
  FiHardDrive,
  FiLock,
  FiMoon,
  FiSun,
  FiBell,
  FiUpload,
  FiFolder,
  FiAlertTriangle,
  FiSave,
  FiEdit2,
  FiCheck,
  FiX,
} from 'react-icons/fi';

function Profile() {
  const navigate = useNavigate();
  const { darkMode, toggleDarkMode } = useTheme();
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [user, setUser] = useState(null);
  const [stats, setStats] = useState(null);
  const [isEditing, setIsEditing] = useState(false);
  
  // Profile form
  const [profileForm, setProfileForm] = useState({
    username: '',
    email: '',
  });
  
  // Password form
  const [passwordForm, setPasswordForm] = useState({
    currentPassword: '',
    newPassword: '',
    confirmPassword: '',
  });
  
  // Preferences
  const [preferences, setPreferences] = useState({
    darkMode: darkMode,
    emailNotifications: true,
    autoBackup: false,
    defaultFolder: 'root',
  });

  useEffect(() => {
    loadUserData();
  }, []);

  const loadUserData = async () => {
    try {
      setLoading(true);
      const username = localStorage.getItem('username');
      if (!username) {
        navigate('/login');
        return;
      }
      
      // Get user details from backend
      const response = await api.get('/users/me');
      console.log('User data:', response.data);
      setUser(response.data);
      setProfileForm({
        username: response.data.username,
        email: response.data.email || '',
      });
      
      // Get stats - use the existing analytics endpoint
      try {
        const statsResponse = await api.get('/analytics/dashboard');
        setStats(statsResponse.data);
      } catch (statsError) {
        console.log('Stats not available, using defaults');
        setStats({ storageUsed: 0, totalFiles: 0, totalDownloads: 0, totalShareLinks: 0 });
      }
      
    } catch (error) {
      console.error('Failed to load user data:', error);
      toast.error('Failed to load profile data');
    } finally {
      setLoading(false);
    }
  };

  const handleProfileUpdate = async () => {
    setSaving(true);
    try {
      const response = await api.put('/users/update', {
        username: profileForm.username,
        email: profileForm.email,
      });
      
      // Update localStorage with new username
      localStorage.setItem('username', response.data.username);
      toast.success('Profile updated successfully!');
      setIsEditing(false);
    } catch (error) {
      toast.error(error.response?.data || 'Failed to update profile');
    } finally {
      setSaving(false);
    }
  };

  const handlePasswordUpdate = async () => {
    if (passwordForm.newPassword !== passwordForm.confirmPassword) {
      toast.error('Passwords do not match');
      return;
    }
    if (passwordForm.newPassword.length < 6) {
      toast.error('Password must be at least 6 characters');
      return;
    }
    
    setSaving(true);
    try {
      await api.put('/users/change-password', {
        currentPassword: passwordForm.currentPassword,
        newPassword: passwordForm.newPassword,
      });
      toast.success('Password updated successfully!');
      setPasswordForm({
        currentPassword: '',
        newPassword: '',
        confirmPassword: '',
      });
    } catch (error) {
      toast.error(error.response?.data || 'Failed to update password');
    } finally {
      setSaving(false);
    }
  };

  const handlePreferenceUpdate = async () => {
    setSaving(true);
    try {
      await api.put('/users/preferences', preferences);
      toast.success('Preferences saved!');
    } catch (error) {
      toast.error('Failed to save preferences');
    } finally {
      setSaving(false);
    }
  };

  const handleDeleteAccount = () => {
    if (window.confirm('Are you sure you want to delete your account? This action cannot be undone!')) {
      if (window.confirm('All your files will be permanently deleted. Are you absolutely sure?')) {
        // Implement delete account API call
        toast.warning('Account deletion feature coming soon');
      }
    }
  };

  const formatFileSize = (bytes) => {
    if (!bytes || bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
  };

  if (loading) {
    return (
      <div style={{...styles.container, ...(darkMode ? styles.containerDark : {})}}>
        <Navbar />
        <div style={styles.loadingContainer}>
          <div style={styles.loadingSpinner}></div>
          <p style={styles.loadingText}>Loading profile...</p>
        </div>
      </div>
    );
  }

  return (
    <div style={{...styles.container, ...(darkMode ? styles.containerDark : {})}}>
      <Navbar />
      
      <div style={styles.content}>
        {/* Header */}
        <div style={styles.header}>
          <div>
            <h1 style={{...styles.headerTitle, ...(darkMode ? styles.headerTitleDark : {})}}>
              ⚙️ Settings
            </h1>
            <p style={{...styles.headerSubtitle, ...(darkMode ? styles.headerSubtitleDark : {})}}>
              Manage your account, security, and preferences
            </p>
          </div>
        </div>

        <div style={styles.profileLayout}>
          {/* Profile Section */}
          <div style={{...styles.card, ...(darkMode ? styles.cardDark : {})}}>
            <div style={styles.cardHeader}>
              <h2 style={{...styles.cardTitle, ...(darkMode ? styles.cardTitleDark : {})}}>
                <FiUser /> Profile
              </h2>
              <button
                onClick={() => setIsEditing(!isEditing)}
                style={styles.editBtn}
              >
                {isEditing ? <FiX /> : <FiEdit2 />}
                {isEditing ? 'Cancel' : 'Edit'}
              </button>
            </div>

            <div style={styles.profileContent}>
              {/* Avatar */}
              <div style={styles.avatarSection}>
                <div style={styles.avatar}>
                  <span style={styles.avatarText}>
                    {profileForm.username?.charAt(0).toUpperCase() || 'U'}
                  </span>
                </div>
                <div style={styles.avatarInfo}>
                  <div style={styles.usernameDisplay}>{profileForm.username}</div>
                  <div style={styles.emailDisplay}>{profileForm.email || 'No email set'}</div>
                  <div style={styles.memberSince}>
                    <FiCalendar /> Member since {user?.createdAt ? new Date(user.createdAt).toLocaleDateString() : 'N/A'}
                  </div>
                </div>
              </div>

              {/* Profile Form */}
              <div style={styles.formGroup}>
                <label style={{...styles.label, ...(darkMode ? styles.labelDark : {})}}>
                  <FiUser /> Username
                </label>
                <input
                  type="text"
                  value={profileForm.username}
                  onChange={(e) => setProfileForm({...profileForm, username: e.target.value})}
                  disabled={!isEditing}
                  style={{
                    ...styles.input,
                    ...(darkMode ? styles.inputDark : {}),
                    ...(!isEditing ? styles.inputDisabled : {}),
                  }}
                />
              </div>

              <div style={styles.formGroup}>
                <label style={{...styles.label, ...(darkMode ? styles.labelDark : {})}}>
                  <FiMail /> Email
                </label>
                <input
                  type="email"
                  value={profileForm.email}
                  onChange={(e) => setProfileForm({...profileForm, email: e.target.value})}
                  disabled={!isEditing}
                  style={{
                    ...styles.input,
                    ...(darkMode ? styles.inputDark : {}),
                    ...(!isEditing ? styles.inputDisabled : {}),
                  }}
                />
              </div>

              {isEditing && (
                <button
                  onClick={handleProfileUpdate}
                  disabled={saving}
                  style={styles.saveBtn}
                >
                  {saving ? 'Saving...' : <><FiSave /> Save Changes</>}
                </button>
              )}
            </div>

            {/* Storage Usage */}
            <div style={styles.storageSection}>
              <div style={styles.storageHeader}>
                <FiHardDrive style={styles.storageIcon} />
                <span style={styles.storageLabel}>Storage Usage</span>
              </div>
              <div style={styles.storageBar}>
                <div style={{
                  ...styles.storageFill,
                  width: `${Math.min((stats?.storageUsed / (1024 * 1024 * 1024 * 10)) * 100, 100)}%`
                }} />
              </div>
              <div style={styles.storageInfo}>
                <span>{formatFileSize(stats?.storageUsed || 0)} used</span>
                <span>of 10 GB</span>
              </div>
            </div>
          </div>

          {/* Security Section */}
          <div style={{...styles.card, ...(darkMode ? styles.cardDark : {})}}>
            <div style={styles.cardHeader}>
              <h2 style={{...styles.cardTitle, ...(darkMode ? styles.cardTitleDark : {})}}>
                <FiLock /> Security
              </h2>
            </div>

            <div style={styles.passwordSection}>
              <h4 style={{...styles.sectionLabel, ...(darkMode ? styles.sectionLabelDark : {})}}>
                Change Password
              </h4>
              
              <div style={styles.formGroup}>
                <label style={{...styles.label, ...(darkMode ? styles.labelDark : {})}}>
                  Current Password
                </label>
                <input
                  type="password"
                  placeholder="Enter current password"
                  value={passwordForm.currentPassword}
                  onChange={(e) => setPasswordForm({...passwordForm, currentPassword: e.target.value})}
                  style={{...styles.input, ...(darkMode ? styles.inputDark : {})}}
                />
              </div>

              <div style={styles.formGroup}>
                <label style={{...styles.label, ...(darkMode ? styles.labelDark : {})}}>
                  New Password
                </label>
                <input
                  type="password"
                  placeholder="Enter new password (min 6 characters)"
                  value={passwordForm.newPassword}
                  onChange={(e) => setPasswordForm({...passwordForm, newPassword: e.target.value})}
                  style={{...styles.input, ...(darkMode ? styles.inputDark : {})}}
                />
              </div>

              <div style={styles.formGroup}>
                <label style={{...styles.label, ...(darkMode ? styles.labelDark : {})}}>
                  Confirm New Password
                </label>
                <input
                  type="password"
                  placeholder="Confirm new password"
                  value={passwordForm.confirmPassword}
                  onChange={(e) => setPasswordForm({...passwordForm, confirmPassword: e.target.value})}
                  style={{...styles.input, ...(darkMode ? styles.inputDark : {})}}
                />
              </div>

              <button
                onClick={handlePasswordUpdate}
                disabled={saving || !passwordForm.currentPassword || !passwordForm.newPassword}
                style={styles.updatePasswordBtn}
              >
                {saving ? 'Updating...' : '🔑 Update Password'}
              </button>
            </div>
          </div>

          {/* Preferences Section */}
          <div style={{...styles.card, ...(darkMode ? styles.cardDark : {})}}>
            <div style={styles.cardHeader}>
              <h2 style={{...styles.cardTitle, ...(darkMode ? styles.cardTitleDark : {})}}>
                🎨 Preferences
              </h2>
            </div>

            <div style={styles.preferencesList}>
              <div style={styles.preferenceItem}>
                <div style={styles.preferenceInfo}>
                  <span style={styles.preferenceIcon}>
                    {darkMode ? <FiMoon /> : <FiSun />}
                  </span>
                  <div>
                    <div style={{...styles.preferenceLabel, ...(darkMode ? styles.preferenceLabelDark : {})}}>
                      Dark Mode
                    </div>
                    <div style={styles.preferenceDesc}>Toggle dark/light theme</div>
                  </div>
                </div>
                <button
                  onClick={() => {
                    toggleDarkMode();
                    setPreferences({...preferences, darkMode: !darkMode});
                  }}
                  style={{
                    ...styles.toggleBtn,
                    ...(preferences.darkMode ? styles.toggleBtnActive : {})
                  }}
                >
                  {preferences.darkMode ? '🌙' : '☀️'}
                </button>
              </div>

              <div style={styles.preferenceItem}>
                <div style={styles.preferenceInfo}>
                  <span style={styles.preferenceIcon}><FiBell /></span>
                  <div>
                    <div style={{...styles.preferenceLabel, ...(darkMode ? styles.preferenceLabelDark : {})}}>
                      Email Notifications
                    </div>
                    <div style={styles.preferenceDesc}>Receive email updates about your files</div>
                  </div>
                </div>
                <button
                  onClick={() => setPreferences({...preferences, emailNotifications: !preferences.emailNotifications})}
                  style={{
                    ...styles.toggleBtn,
                    ...(preferences.emailNotifications ? styles.toggleBtnActive : {})
                  }}
                >
                  {preferences.emailNotifications ? '✅' : '❌'}
                </button>
              </div>

              <div style={styles.preferenceItem}>
                <div style={styles.preferenceInfo}>
                  <span style={styles.preferenceIcon}><FiUpload /></span>
                  <div>
                    <div style={{...styles.preferenceLabel, ...(darkMode ? styles.preferenceLabelDark : {})}}>
                      Auto Backup
                    </div>
                    <div style={styles.preferenceDesc}>Automatically backup new files</div>
                  </div>
                </div>
                <button
                  onClick={() => setPreferences({...preferences, autoBackup: !preferences.autoBackup})}
                  style={{
                    ...styles.toggleBtn,
                    ...(preferences.autoBackup ? styles.toggleBtnActive : {})
                  }}
                >
                  {preferences.autoBackup ? '✅' : '❌'}
                </button>
              </div>

              <div style={styles.preferenceItem}>
                <div style={styles.preferenceInfo}>
                  <span style={styles.preferenceIcon}><FiFolder /></span>
                  <div>
                    <div style={{...styles.preferenceLabel, ...(darkMode ? styles.preferenceLabelDark : {})}}>
                      Default Folder
                    </div>
                    <div style={styles.preferenceDesc}>Default folder for new uploads</div>
                  </div>
                </div>
                <select
                  value={preferences.defaultFolder}
                  onChange={(e) => setPreferences({...preferences, defaultFolder: e.target.value})}
                  style={{...styles.select, ...(darkMode ? styles.selectDark : {})}}
                >
                  <option value="root">Root</option>
                  <option value="Photos">Photos</option>
                  <option value="Documents">Documents</option>
                  <option value="Work">Work</option>
                </select>
              </div>

              <button
                onClick={handlePreferenceUpdate}
                disabled={saving}
                style={styles.savePreferencesBtn}
              >
                {saving ? 'Saving...' : <><FiSave /> Save Preferences</>}
              </button>
            </div>
          </div>

          {/* Danger Zone */}
          <div style={{...styles.dangerCard, ...(darkMode ? styles.dangerCardDark : {})}}>
            <div style={styles.dangerHeader}>
              <FiAlertTriangle style={styles.dangerIcon} />
              <h3 style={styles.dangerTitle}>Danger Zone</h3>
            </div>
            <p style={styles.dangerText}>
              Once you delete your account, all your files and data will be permanently removed.
              This action cannot be undone.
            </p>
            <button onClick={handleDeleteAccount} style={styles.dangerBtn}>
              🗑️ Delete My Account
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}

const styles = {
  container: {
    minHeight: '100vh',
    background: 'linear-gradient(135deg, #f0f4ff 0%, #e8edf5 100%)',
    transition: 'all 0.3s ease',
  },
  containerDark: {
    background: 'linear-gradient(135deg, #111827 0%, #1f2937 100%)',
  },
  content: {
    maxWidth: '900px',
    margin: '0 auto',
    padding: '40px 24px',
  },
  header: {
    marginBottom: '32px',
  },
  headerTitle: {
    fontSize: '32px',
    fontWeight: '700',
    color: '#1f2937',
    fontFamily: 'Poppins, sans-serif',
    margin: 0,
  },
  headerTitleDark: {
    color: '#f9fafb',
  },
  headerSubtitle: {
    fontSize: '16px',
    color: '#6b7280',
    marginTop: '4px',
  },
  headerSubtitleDark: {
    color: '#9ca3af',
  },
  profileLayout: {
    display: 'flex',
    flexDirection: 'column',
    gap: '24px',
  },
  card: {
    background: 'rgba(255,255,255,0.85)',
    backdropFilter: 'blur(10px)',
    borderRadius: '16px',
    padding: '28px',
    boxShadow: '0 4px 20px rgba(0,0,0,0.06)',
    border: '1px solid rgba(255,255,255,0.3)',
  },
  cardDark: {
    background: 'rgba(31,41,55,0.85)',
    border: '1px solid rgba(255,255,255,0.05)',
  },
  cardHeader: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: '20px',
  },
  cardTitle: {
    fontSize: '20px',
    fontWeight: '600',
    color: '#1f2937',
    fontFamily: 'Poppins, sans-serif',
    display: 'flex',
    alignItems: 'center',
    gap: '10px',
  },
  cardTitleDark: {
    color: '#f9fafb',
  },
  editBtn: {
    display: 'flex',
    alignItems: 'center',
    gap: '6px',
    padding: '8px 16px',
    border: 'none',
    borderRadius: '8px',
    backgroundColor: '#eef2ff',
    color: '#6366f1',
    cursor: 'pointer',
    fontSize: '14px',
    fontWeight: '500',
    transition: 'all 0.2s ease',
  },
  profileContent: {
    display: 'flex',
    flexDirection: 'column',
    gap: '16px',
  },
  avatarSection: {
    display: 'flex',
    alignItems: 'center',
    gap: '20px',
    paddingBottom: '20px',
    borderBottom: '1px solid #e5e7eb',
  },
  avatar: {
    width: '80px',
    height: '80px',
    borderRadius: '50%',
    background: 'linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%)',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
  },
  avatarText: {
    fontSize: '32px',
    fontWeight: '700',
    color: 'white',
  },
  avatarInfo: {
    flex: 1,
  },
  usernameDisplay: {
    fontSize: '22px',
    fontWeight: '700',
    color: '#1f2937',
    fontFamily: 'Poppins, sans-serif',
  },
  emailDisplay: {
    fontSize: '15px',
    color: '#6b7280',
  },
  memberSince: {
    fontSize: '14px',
    color: '#6b7280',
    display: 'flex',
    alignItems: 'center',
    gap: '6px',
    marginTop: '4px',
  },
  formGroup: {
    display: 'flex',
    flexDirection: 'column',
    gap: '6px',
  },
  label: {
    fontSize: '14px',
    fontWeight: '500',
    color: '#4b5563',
    display: 'flex',
    alignItems: 'center',
    gap: '8px',
  },
  labelDark: {
    color: '#d1d5db',
  },
  input: {
    padding: '12px 16px',
    border: '2px solid #e5e7eb',
    borderRadius: '10px',
    fontSize: '15px',
    transition: 'all 0.2s ease',
    backgroundColor: 'white',
    color: '#1f2937',
    outline: 'none',
  },
  inputDark: {
    backgroundColor: 'rgba(55,65,81,0.5)',
    border: '2px solid #374151',
    color: '#f9fafb',
  },
  inputDisabled: {
    backgroundColor: '#f3f4f6',
    opacity: 0.6,
    cursor: 'not-allowed',
  },
  saveBtn: {
    padding: '12px',
    backgroundColor: '#6366f1',
    color: 'white',
    border: 'none',
    borderRadius: '10px',
    fontSize: '16px',
    fontWeight: '600',
    cursor: 'pointer',
    transition: 'all 0.2s ease',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: '8px',
    marginTop: '8px',
  },
  storageSection: {
    marginTop: '20px',
    paddingTop: '20px',
    borderTop: '1px solid #e5e7eb',
  },
  storageHeader: {
    display: 'flex',
    alignItems: 'center',
    gap: '8px',
    marginBottom: '8px',
  },
  storageIcon: {
    fontSize: '18px',
    color: '#6366f1',
  },
  storageLabel: {
    fontSize: '15px',
    fontWeight: '500',
    color: '#1f2937',
  },
  storageBar: {
    height: '8px',
    backgroundColor: '#e5e7eb',
    borderRadius: '4px',
    overflow: 'hidden',
  },
  storageFill: {
    height: '100%',
    backgroundColor: '#6366f1',
    borderRadius: '4px',
    transition: 'width 0.6s ease',
  },
  storageInfo: {
    display: 'flex',
    justifyContent: 'space-between',
    fontSize: '14px',
    color: '#6b7280',
    marginTop: '6px',
  },
  passwordSection: {
    display: 'flex',
    flexDirection: 'column',
    gap: '14px',
  },
  sectionLabel: {
    fontSize: '16px',
    fontWeight: '600',
    color: '#1f2937',
    marginBottom: '4px',
  },
  sectionLabelDark: {
    color: '#f9fafb',
  },
  updatePasswordBtn: {
    padding: '12px',
    backgroundColor: '#22c55e',
    color: 'white',
    border: 'none',
    borderRadius: '10px',
    fontSize: '16px',
    fontWeight: '600',
    cursor: 'pointer',
    transition: 'all 0.2s ease',
    marginTop: '4px',
  },
  preferencesList: {
    display: 'flex',
    flexDirection: 'column',
    gap: '16px',
  },
  preferenceItem: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: '12px 16px',
    backgroundColor: 'rgba(0,0,0,0.02)',
    borderRadius: '10px',
  },
  preferenceInfo: {
    display: 'flex',
    alignItems: 'center',
    gap: '12px',
  },
  preferenceIcon: {
    fontSize: '20px',
  },
  preferenceLabel: {
    fontSize: '15px',
    fontWeight: '500',
    color: '#1f2937',
  },
  preferenceLabelDark: {
    color: '#f9fafb',
  },
  preferenceDesc: {
    fontSize: '13px',
    color: '#6b7280',
  },
  toggleBtn: {
    padding: '8px 16px',
    border: '2px solid #e5e7eb',
    borderRadius: '8px',
    backgroundColor: 'white',
    cursor: 'pointer',
    fontSize: '18px',
    transition: 'all 0.2s ease',
  },
  toggleBtnActive: {
    borderColor: '#6366f1',
    backgroundColor: '#eef2ff',
  },
  select: {
    padding: '8px 16px',
    border: '2px solid #e5e7eb',
    borderRadius: '8px',
    fontSize: '14px',
    backgroundColor: 'white',
    cursor: 'pointer',
  },
  selectDark: {
    backgroundColor: 'rgba(55,65,81,0.5)',
    border: '2px solid #374151',
    color: '#f9fafb',
  },
  savePreferencesBtn: {
    padding: '12px',
    backgroundColor: '#6366f1',
    color: 'white',
    border: 'none',
    borderRadius: '10px',
    fontSize: '16px',
    fontWeight: '600',
    cursor: 'pointer',
    transition: 'all 0.2s ease',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: '8px',
    marginTop: '8px',
  },
  dangerCard: {
    background: 'rgba(254, 242, 242, 0.85)',
    backdropFilter: 'blur(10px)',
    borderRadius: '16px',
    padding: '24px',
    border: '1px solid #fecaca',
  },
  dangerCardDark: {
    background: 'rgba(127, 29, 29, 0.3)',
    border: '1px solid #7f1d1d',
  },
  dangerHeader: {
    display: 'flex',
    alignItems: 'center',
    gap: '10px',
    marginBottom: '12px',
  },
  dangerIcon: {
    fontSize: '24px',
    color: '#dc2626',
  },
  dangerTitle: {
    fontSize: '18px',
    fontWeight: '600',
    color: '#dc2626',
  },
  dangerText: {
    fontSize: '14px',
    color: '#6b7280',
    marginBottom: '16px',
  },
  dangerBtn: {
    padding: '12px 24px',
    backgroundColor: '#dc2626',
    color: 'white',
    border: 'none',
    borderRadius: '10px',
    fontSize: '16px',
    fontWeight: '600',
    cursor: 'pointer',
    transition: 'all 0.2s ease',
  },
  loadingContainer: {
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    justifyContent: 'center',
    minHeight: '60vh',
  },
  loadingSpinner: {
    width: '48px',
    height: '48px',
    border: '4px solid #e5e7eb',
    borderTopColor: '#6366f1',
    borderRadius: '50%',
    animation: 'spin 1s linear infinite',
  },
  loadingText: {
    marginTop: '16px',
    fontSize: '16px',
    color: '#6b7280',
  },
};

// Add animation
const styleSheet = document.createElement("style");
styleSheet.textContent = `
  @keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
  }
`;
document.head.appendChild(styleSheet);

export default Profile;