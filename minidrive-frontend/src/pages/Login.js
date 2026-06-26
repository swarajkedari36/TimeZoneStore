import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { authAPI } from '../services/api';
import { useTheme } from '../context/ThemeContext';
import toast from '../components/Toast';

function Login() {
  const navigate = useNavigate();
  const { darkMode } = useTheme();
  const [isLogin, setIsLogin] = useState(true);
  const [formData, setFormData] = useState({
    username: '',
    password: '',
  });
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const [showPassword, setShowPassword] = useState(false);

  // Check if already logged in
  useEffect(() => {
    const token = localStorage.getItem('token');
    if (token) {
      navigate('/dashboard');
    }
  }, [navigate]);

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value,
    });
    setError('');
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      let response;
      if (isLogin) {
        // Login - only username and password
        response = await authAPI.login({
          username: formData.username,
          password: formData.password,
        });
        console.log('✅ Login successful:', response.data);
      } else {
        // Register - username, password, and email
        response = await authAPI.register({
          username: formData.username,
          password: formData.password,
          email: formData.email || `${formData.username}@example.com`,
        });
        console.log('✅ Registration successful:', response.data);
        toast.success('Account created! Please login.');
        setIsLogin(true);
        setFormData({ username: '', password: '' });
        setLoading(false);
        return;
      }

      // Save token and redirect
      if (response.data && response.data.token) {
        localStorage.setItem('token', response.data.token);
        localStorage.setItem('username', response.data.username);
        toast.success(`Welcome ${response.data.username}!`);
        // Use replace to prevent back button issues
        navigate('/dashboard', { replace: true });
      }
    } catch (err) {
      console.error('❌ Auth error:', err);
      
      if (err.response?.data?.message) {
        setError(err.response.data.message);
      } else if (err.response?.status === 400) {
        setError('Please check your username and password');
      } else if (err.response?.status === 401) {
        setError('Invalid username or password');
      } else if (err.code === 'ERR_NETWORK') {
        setError('Cannot connect to server. Make sure Spring Boot is running.');
      } else {
        setError('Authentication failed. Please try again.');
      }
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={{
      ...styles.container,
      background: darkMode 
        ? 'linear-gradient(135deg, #0f172a 0%, #1e293b 50%, #0f172a 100%)'
        : 'linear-gradient(135deg, #6366f1 0%, #8b5cf6 50%, #06b6d4 100%)'
    }}>
      <div style={{
        ...styles.card,
        ...(darkMode ? styles.cardDark : {})
      }}>
        {/* Logo */}
        <div style={styles.logoContainer}>
          <div style={styles.logoIcon}>📁</div>
          <h1 style={{
            ...styles.logoText,
            ...(darkMode ? styles.logoTextDark : {})
          }}>Mini Drive</h1>
        </div>

        <p style={{
          ...styles.subtitle,
          ...(darkMode ? styles.subtitleDark : {})
        }}>
          {isLogin ? 'Welcome back! Please login to your account.' : 'Create a new account to get started.'}
        </p>

        {/* Error Message */}
        {error && (
          <div style={styles.errorContainer}>
            <span style={styles.errorIcon}>⚠️</span>
            <span style={styles.errorText}>{error}</span>
          </div>
        )}

        <form onSubmit={handleSubmit} style={styles.form}>
          {/* Username Field */}
          <div style={styles.inputGroup}>
            <label style={{
              ...styles.label,
              ...(darkMode ? styles.labelDark : {})
            }}>
              👤 Username
            </label>
            <input
              type="text"
              name="username"
              placeholder="Enter your username"
              value={formData.username}
              onChange={handleChange}
              required
              autoFocus
              style={{
                ...styles.input,
                ...(darkMode ? styles.inputDark : {})
              }}
            />
          </div>

          {/* Password Field */}
          <div style={styles.inputGroup}>
            <label style={{
              ...styles.label,
              ...(darkMode ? styles.labelDark : {})
            }}>
              🔒 Password
            </label>
            <div style={styles.passwordWrapper}>
              <input
                type={showPassword ? 'text' : 'password'}
                name="password"
                placeholder="Enter your password"
                value={formData.password}
                onChange={handleChange}
                required
                style={{
                  ...styles.input,
                  ...styles.passwordInput,
                  ...(darkMode ? styles.inputDark : {})
                }}
              />
              <button
                type="button"
                onClick={() => setShowPassword(!showPassword)}
                style={styles.passwordToggle}
              >
                {showPassword ? '🙈' : '👁️'}
              </button>
            </div>
          </div>

          {/* Register - Email Field (Only when registering) */}
          {!isLogin && (
            <div style={styles.inputGroup}>
              <label style={{
                ...styles.label,
                ...(darkMode ? styles.labelDark : {})
              }}>
                📧 Email (Optional)
              </label>
              <input
                type="email"
                name="email"
                placeholder="Enter your email (optional)"
                value={formData.email || ''}
                onChange={handleChange}
                style={{
                  ...styles.input,
                  ...(darkMode ? styles.inputDark : {})
                }}
              />
            </div>
          )}

          {/* Submit Button */}
          <button
            type="submit"
            disabled={loading}
            style={{
              ...styles.submitBtn,
              ...(loading ? styles.submitBtnDisabled : {})
            }}
          >
            {loading ? (
              <span style={styles.loadingSpinner}></span>
            ) : (
              isLogin ? '🚀 Login' : '✨ Create Account'
            )}
          </button>
        </form>

        {/* Switch between Login & Register */}
        <div style={styles.switchContainer}>
          <p style={{
            ...styles.switchText,
            ...(darkMode ? styles.switchTextDark : {})
          }}>
            {isLogin ? "Don't have an account?" : "Already have an account?"}
          </p>
          <button
            onClick={() => {
              setIsLogin(!isLogin);
              setError('');
              setFormData({ username: '', password: '' });
            }}
            style={styles.switchBtn}
          >
            {isLogin ? 'Sign Up' : 'Sign In'}
          </button>
        </div>

        {/* Footer */}
        <p style={{
          ...styles.footer,
          ...(darkMode ? styles.footerDark : {})
        }}>
          Secure file sharing • Made with ❤️
        </p>
      </div>
    </div>
  );
}

const styles = {
  container: {
    minHeight: '100vh',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    padding: '20px',
    transition: 'all 0.3s ease',
  },
  card: {
    backgroundColor: 'rgba(255,255,255,0.85)',
    backdropFilter: 'blur(20px)',
    borderRadius: '24px',
    padding: '40px',
    width: '100%',
    maxWidth: '420px',
    boxShadow: '0 25px 60px rgba(0,0,0,0.15)',
    border: '1px solid rgba(255,255,255,0.2)',
    transition: 'all 0.3s ease',
    animation: 'fadeInUp 0.5s ease',
  },
  cardDark: {
    backgroundColor: 'rgba(30, 41, 59, 0.85)',
    border: '1px solid rgba(255,255,255,0.05)',
    boxShadow: '0 25px 60px rgba(0,0,0,0.4)',
  },
  logoContainer: {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: '12px',
    marginBottom: '8px',
  },
  logoIcon: {
    fontSize: '36px',
  },
  logoText: {
    fontSize: '28px',
    fontWeight: '700',
    color: '#1f2937',
    fontFamily: 'Poppins, sans-serif',
  },
  logoTextDark: {
    color: '#f9fafb',
  },
  subtitle: {
    textAlign: 'center',
    color: '#6b7280',
    marginBottom: '30px',
    fontSize: '14px',
  },
  subtitleDark: {
    color: '#9ca3af',
  },
  errorContainer: {
    display: 'flex',
    alignItems: 'center',
    gap: '8px',
    backgroundColor: '#fef2f2',
    border: '1px solid #fecaca',
    borderRadius: '10px',
    padding: '12px 16px',
    marginBottom: '20px',
  },
  errorIcon: {
    fontSize: '16px',
  },
  errorText: {
    color: '#dc2626',
    fontSize: '14px',
    flex: 1,
  },
  form: {
    display: 'flex',
    flexDirection: 'column',
    gap: '18px',
  },
  inputGroup: {
    display: 'flex',
    flexDirection: 'column',
    gap: '6px',
  },
  label: {
    fontSize: '13px',
    fontWeight: '500',
    color: '#374151',
  },
  labelDark: {
    color: '#d1d5db',
  },
  input: {
    padding: '12px 16px',
    border: '2px solid #e5e7eb',
    borderRadius: '10px',
    fontSize: '14px',
    transition: 'all 0.2s ease',
    backgroundColor: 'white',
    color: '#1f2937',
    outline: 'none',
    width: '100%',
    boxSizing: 'border-box',
  },
  inputDark: {
    backgroundColor: 'rgba(55, 65, 81, 0.5)',
    border: '2px solid #374151',
    color: '#f9fafb',
  },
  passwordWrapper: {
    position: 'relative',
  },
  passwordInput: {
    paddingRight: '48px',
  },
  passwordToggle: {
    position: 'absolute',
    right: '12px',
    top: '50%',
    transform: 'translateY(-50%)',
    background: 'none',
    border: 'none',
    cursor: 'pointer',
    fontSize: '18px',
    padding: '4px',
    opacity: 0.6,
  },
  submitBtn: {
    padding: '14px',
    backgroundColor: '#6366f1',
    color: 'white',
    border: 'none',
    borderRadius: '10px',
    fontSize: '16px',
    fontWeight: '600',
    cursor: 'pointer',
    transition: 'all 0.2s ease',
    marginTop: '6px',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    minHeight: '52px',
  },
  submitBtnDisabled: {
    backgroundColor: '#9ca3af',
    cursor: 'not-allowed',
  },
  loadingSpinner: {
    width: '24px',
    height: '24px',
    border: '3px solid rgba(255,255,255,0.3)',
    borderTopColor: 'white',
    borderRadius: '50%',
    animation: 'spin 0.8s linear infinite',
  },
  switchContainer: {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: '8px',
    marginTop: '20px',
  },
  switchText: {
    fontSize: '14px',
    color: '#6b7280',
  },
  switchTextDark: {
    color: '#9ca3af',
  },
  switchBtn: {
    background: 'none',
    border: 'none',
    color: '#6366f1',
    fontWeight: '600',
    fontSize: '14px',
    cursor: 'pointer',
    padding: '4px 8px',
    borderRadius: '4px',
    transition: 'all 0.2s ease',
  },
  footer: {
    textAlign: 'center',
    marginTop: '24px',
    fontSize: '12px',
    color: '#9ca3af',
  },
  footerDark: {
    color: '#6b7280',
  },
};

// Add animations
const styleSheet = document.createElement("style");
styleSheet.textContent = `
  @keyframes fadeInUp {
    from {
      opacity: 0;
      transform: translateY(20px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }
  @keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
  }
  input:focus {
    border-color: #6366f1;
    box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
  }
  input:focus-dark {
    border-color: #8b5cf6;
    box-shadow: 0 0 0 3px rgba(139, 92, 246, 0.1);
  }
`;
document.head.appendChild(styleSheet);

export default Login;