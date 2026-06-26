import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useTheme } from '../context/ThemeContext';
import Navbar from '../components/Navbar';
import api from '../services/api';
import toast from '../components/Toast';
import {
  FiTrendingUp,
  FiTrendingDown,
  FiClock,
  FiFile,
  FiDownload,
  FiShare2,
  FiHardDrive,
  FiImage,
  FiVideo,
  FiMusic,
  FiFileText,
  FiArchive,
} from 'react-icons/fi';

function Analytics() {
  const navigate = useNavigate();
  const { darkMode } = useTheme();
  const [analytics, setAnalytics] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [timeRange, setTimeRange] = useState('week');

  useEffect(() => {
    loadAnalytics();
  }, []);

  const loadAnalytics = async () => {
    try {
      setLoading(true);
      const response = await api.get('/analytics/dashboard');
      console.log('📊 Analytics Data:', response.data);
      setAnalytics(response.data);
      setError('');
    } catch (error) {
      console.error('Failed to load analytics:', error);
      setError('Failed to load analytics data');
      toast.error('Failed to load analytics');
      if (error.response?.status === 401) {
        navigate('/login');
      }
    } finally {
      setLoading(false);
    }
  };

  const formatFileSize = (bytes) => {
    if (!bytes || bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
  };

  const formatDate = (timestamp) => {
    if (!timestamp) return 'N/A';
    const date = new Date(timestamp);
    const now = new Date();
    const diff = Math.floor((now - date) / (1000 * 60));
    
    if (diff < 1) return 'Just now';
    if (diff < 60) return diff + 'm ago';
    if (diff < 1440) return Math.floor(diff / 60) + 'h ago';
    return date.toLocaleDateString();
  };

  const getFileTypeIcon = (type) => {
    const icons = {
      'Images': <FiImage />,
      'Videos': <FiVideo />,
      'Audio': <FiMusic />,
      'PDFs': <FiFileText />,
      'Documents': <FiFileText />,
      'Spreadsheets': <FiFileText />,
      'Presentations': <FiFileText />,
      'Text Files': <FiFileText />,
      'Archives': <FiArchive />,
      'Others': <FiFile />,
    };
    return icons[type] || <FiFile />;
  };

  const getFileTypeColor = (type) => {
    const colors = {
      'Images': '#6366f1',
      'Videos': '#ef4444',
      'Audio': '#f59e0b',
      'PDFs': '#e67e22',
      'Documents': '#22c55e',
      'Spreadsheets': '#10b981',
      'Presentations': '#f1c40f',
      'Text Files': '#3b82f6',
      'Archives': '#8b5cf6',
      'Others': '#6b7280',
    };
    return colors[type] || '#6b7280';
  };

  if (loading) {
    return (
      <div style={{...styles.container, ...(darkMode ? styles.containerDark : {})}}>
        <Navbar />
        <div style={styles.loadingContainer}>
          <div style={styles.loadingSpinner}></div>
          <p style={styles.loadingText}>Loading analytics...</p>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div style={{...styles.container, ...(darkMode ? styles.containerDark : {})}}>
        <Navbar />
        <div style={styles.errorContainer}>
          <div style={styles.errorIcon}>⚠️</div>
          <h3 style={styles.errorTitle}>Something went wrong</h3>
          <p style={styles.errorText}>{error}</p>
          <button onClick={loadAnalytics} style={styles.retryBtn}>Try Again</button>
        </div>
      </div>
    );
  }

  if (!analytics) return null;

  // Calculate total storage in GB
  const storageInGB = analytics.storageUsed / (1024 * 1024 * 1024);

  return (
    <div style={{...styles.container, ...(darkMode ? styles.containerDark : {})}}>
      <Navbar />
      
      <div style={styles.content}>
        {/* Header */}
        <div style={styles.header}>
          <div>
            <h1 style={{...styles.headerTitle, ...(darkMode ? styles.headerTitleDark : {})}}>
              📊 Analytics Dashboard
            </h1>
            <p style={{...styles.headerSubtitle, ...(darkMode ? styles.headerSubtitleDark : {})}}>
              Monitor your file usage and activity
            </p>
          </div>
          <button onClick={loadAnalytics} style={styles.refreshBtn}>
            🔄 Refresh
          </button>
        </div>

        {/* Stats Grid */}
        <div style={styles.statsGrid}>
          <div style={{...styles.statCard, ...(darkMode ? styles.statCardDark : {})}}>
            <div style={styles.statIconWrapper}>
              <FiHardDrive style={styles.statIcon} />
            </div>
            <div>
              <div style={{...styles.statValue, ...(darkMode ? styles.statValueDark : {})}}>
                {formatFileSize(analytics.storageUsed)}
              </div>
              <div style={{...styles.statLabel, ...(darkMode ? styles.statLabelDark : {})}}>Storage Used</div>
              <div style={styles.statProgress}>
                <div style={{...styles.statProgressBar, width: `${Math.min((storageInGB / 10) * 100, 100)}%`}} />
              </div>
              <div style={styles.statSubtext}>
                {storageInGB.toFixed(1)} GB of 10 GB
              </div>
            </div>
          </div>

          <div style={{...styles.statCard, ...(darkMode ? styles.statCardDark : {})}}>
            <div style={{...styles.statIconWrapper, backgroundColor: '#dbeafe'}}>
              <FiFile style={{...styles.statIcon, color: '#3b82f6'}} />
            </div>
            <div>
              <div style={{...styles.statValue, ...(darkMode ? styles.statValueDark : {})}}>
                {analytics.totalFiles}
              </div>
              <div style={{...styles.statLabel, ...(darkMode ? styles.statLabelDark : {})}}>Total Files</div>
              <div style={styles.statTrend}>
                <FiTrendingUp style={styles.trendUp} />
                <span style={styles.trendText}>12 new this week</span>
              </div>
            </div>
          </div>

          <div style={{...styles.statCard, ...(darkMode ? styles.statCardDark : {})}}>
            <div style={{...styles.statIconWrapper, backgroundColor: '#d1fae5'}}>
              <FiDownload style={{...styles.statIcon, color: '#22c55e'}} />
            </div>
            <div>
              <div style={{...styles.statValue, ...(darkMode ? styles.statValueDark : {})}}>
                {analytics.totalDownloads}
              </div>
              <div style={{...styles.statLabel, ...(darkMode ? styles.statLabelDark : {})}}>Total Downloads</div>
              <div style={styles.statTrend}>
                <FiTrendingUp style={styles.trendUp} />
                <span style={styles.trendText}>23 this week</span>
              </div>
            </div>
          </div>

          <div style={{...styles.statCard, ...(darkMode ? styles.statCardDark : {})}}>
            <div style={{...styles.statIconWrapper, backgroundColor: '#fef3c7'}}>
              <FiShare2 style={{...styles.statIcon, color: '#f59e0b'}} />
            </div>
            <div>
              <div style={{...styles.statValue, ...(darkMode ? styles.statValueDark : {})}}>
                {analytics.totalShareLinks}
              </div>
              <div style={{...styles.statLabel, ...(darkMode ? styles.statLabelDark : {})}}>Share Links</div>
              <div style={styles.statTrend}>
                <FiTrendingUp style={styles.trendUp} />
                <span style={styles.trendText}>3 active</span>
              </div>
            </div>
          </div>
        </div>

        {/* Charts Row */}
        <div style={styles.chartsRow}>
          {/* Upload Activity */}
          <div style={{...styles.chartCard, ...(darkMode ? styles.chartCardDark : {})}}>
            <div style={styles.chartHeader}>
              <h3 style={{...styles.chartTitle, ...(darkMode ? styles.chartTitleDark : {})}}>📈 Upload Activity</h3>
              <span style={{...styles.chartBadge, ...(darkMode ? styles.chartBadgeDark : {})}}>Last 7 days</span>
            </div>
            <div style={styles.barChart}>
              {analytics.uploadActivity && Object.entries(analytics.uploadActivity).map(([day, count]) => {
                const max = Math.max(...Object.values(analytics.uploadActivity));
                const height = max > 0 ? (count / max) * 100 : 0;
                return (
                  <div key={day} style={styles.barItem}>
                    <div style={styles.barContainer}>
                      <div style={{
                        ...styles.bar,
                        height: `${Math.max(height, 5)}%`,
                        backgroundColor: count > 0 ? '#6366f1' : '#e5e7eb'
                      }} />
                    </div>
                    <span style={{...styles.barLabel, ...(darkMode ? styles.barLabelDark : {})}}>{day}</span>
                    <span style={{...styles.barCount, ...(darkMode ? styles.barCountDark : {})}}>{count}</span>
                  </div>
                );
              })}
            </div>
          </div>

          {/* Download Activity */}
          <div style={{...styles.chartCard, ...(darkMode ? styles.chartCardDark : {})}}>
            <div style={styles.chartHeader}>
              <h3 style={{...styles.chartTitle, ...(darkMode ? styles.chartTitleDark : {})}}>📊 Download Activity</h3>
              <span style={{...styles.chartBadge, ...(darkMode ? styles.chartBadgeDark : {})}}>Last 7 days</span>
            </div>
            <div style={styles.barChart}>
              {analytics.downloadActivity && Object.entries(analytics.downloadActivity).map(([day, count]) => {
                const max = Math.max(...Object.values(analytics.downloadActivity));
                const height = max > 0 ? (count / max) * 100 : 0;
                return (
                  <div key={day} style={styles.barItem}>
                    <div style={styles.barContainer}>
                      <div style={{
                        ...styles.bar,
                        height: `${Math.max(height, 5)}%`,
                        backgroundColor: count > 0 ? '#22c55e' : '#e5e7eb'
                      }} />
                    </div>
                    <span style={{...styles.barLabel, ...(darkMode ? styles.barLabelDark : {})}}>{day}</span>
                    <span style={{...styles.barCount, ...(darkMode ? styles.barCountDark : {})}}>{count}</span>
                  </div>
                );
              })}
            </div>
          </div>
        </div>

        {/* File Type Distribution */}
        <div style={{...styles.chartCard, ...(darkMode ? styles.chartCardDark : {})}}>
          <div style={styles.chartHeader}>
            <h3 style={{...styles.chartTitle, ...(darkMode ? styles.chartTitleDark : {})}}>📂 File Type Distribution</h3>
            <span style={{...styles.chartBadge, ...(darkMode ? styles.chartBadgeDark : {})}}>
              {analytics.totalFiles} files
            </span>
          </div>
          <div style={styles.distributionContainer}>
            {analytics.fileTypeDistribution && Object.entries(analytics.fileTypeDistribution).map(([type, count]) => {
              const percentage = (count / analytics.totalFiles) * 100;
              const color = getFileTypeColor(type);
              return (
                <div key={type} style={styles.distributionItem}>
                  <div style={styles.distributionLabel}>
                    <span style={{...styles.distributionIcon, color}}>{getFileTypeIcon(type)}</span>
                    <span style={{...styles.distributionName, ...(darkMode ? styles.distributionNameDark : {})}}>{type}</span>
                  </div>
                  <div style={styles.distributionBarContainer}>
                    <div style={{
                      ...styles.distributionBar,
                      width: `${percentage}%`,
                      backgroundColor: color
                    }} />
                  </div>
                  <span style={{...styles.distributionCount, ...(darkMode ? styles.distributionCountDark : {})}}>
                    {count} ({percentage.toFixed(0)}%)
                  </span>
                </div>
              );
            })}
          </div>
        </div>

        {/* Most Shared Files & Recent Activity */}
        <div style={styles.twoColumnRow}>
          {/* Most Shared Files */}
          <div style={{...styles.chartCard, ...(darkMode ? styles.chartCardDark : {})}}>
            <div style={styles.chartHeader}>
              <h3 style={{...styles.chartTitle, ...(darkMode ? styles.chartTitleDark : {})}}>🔥 Most Shared Files</h3>
            </div>
            <div style={styles.sharedList}>
              {analytics.mostSharedFiles && analytics.mostSharedFiles.length > 0 ? (
                analytics.mostSharedFiles.map((file, index) => (
                  <div key={file.fileId} style={{...styles.sharedItem, ...(darkMode ? styles.sharedItemDark : {})}}>
                    <span style={styles.sharedRank}>#{index + 1}</span>
                    <span style={{...styles.sharedName, ...(darkMode ? styles.sharedNameDark : {})}}>{file.fileName}</span>
                    <span style={styles.sharedCount}>📥 {file.downloadCount} downloads</span>
                  </div>
                ))
              ) : (
                <p style={{...styles.noData, ...(darkMode ? styles.noDataDark : {})}}>No shared files yet</p>
              )}
            </div>
          </div>

          {/* Recent Activity */}
          <div style={{...styles.chartCard, ...(darkMode ? styles.chartCardDark : {})}}>
            <div style={styles.chartHeader}>
              <h3 style={{...styles.chartTitle, ...(darkMode ? styles.chartTitleDark : {})}}>🕐 Recent Activity</h3>
            </div>
            <div style={styles.activityList}>
              {analytics.recentActivity && analytics.recentActivity.length > 0 ? (
                analytics.recentActivity.map((event, index) => (
                  <div key={index} style={{...styles.activityItem, ...(darkMode ? styles.activityItemDark : {})}}>
                    <span style={styles.activityIcon}>
                      {event.type === 'upload' ? '📤' : '📥'}
                    </span>
                    <span style={{...styles.activityMessage, ...(darkMode ? styles.activityMessageDark : {})}}>
                      {event.message}
                    </span>
                    <span style={{...styles.activityTime, ...(darkMode ? styles.activityTimeDark : {})}}>
                      {formatDate(event.timestamp)}
                    </span>
                  </div>
                ))
              ) : (
                <p style={{...styles.noData, ...(darkMode ? styles.noDataDark : {})}}>No recent activity</p>
              )}
            </div>
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
    transition: 'background 0.3s ease',
  },
  containerDark: {
    background: 'linear-gradient(135deg, #111827 0%, #1f2937 100%)',
  },
  content: {
    maxWidth: '1200px',
    margin: '0 auto',
    padding: '24px',
  },
  header: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: '30px',
    flexWrap: 'wrap',
    gap: '16px',
  },
  headerTitle: {
    fontSize: '28px',
    fontWeight: '700',
    color: '#1f2937',
    margin: 0,
  },
  headerTitleDark: {
    color: '#f9fafb',
  },
  headerSubtitle: {
    fontSize: '16px',
    color: '#6b7280',
    margin: '4px 0 0',
  },
  headerSubtitleDark: {
    color: '#9ca3af',
  },
  refreshBtn: {
    backgroundColor: '#6366f1',
    color: 'white',
    border: 'none',
    padding: '10px 20px',
    borderRadius: '10px',
    cursor: 'pointer',
    fontSize: '14px',
    fontWeight: '500',
    transition: 'all 0.3s ease',
  },
  statsGrid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fit, minmax(220px, 1fr))',
    gap: '16px',
    marginBottom: '24px',
  },
  statCard: {
    background: 'rgba(255,255,255,0.8)',
    backdropFilter: 'blur(10px)',
    borderRadius: '16px',
    padding: '20px',
    display: 'flex',
    alignItems: 'center',
    gap: '16px',
    boxShadow: '0 4px 20px rgba(0,0,0,0.06)',
    border: '1px solid rgba(255,255,255,0.3)',
    transition: 'all 0.3s ease',
  },
  statCardDark: {
    background: 'rgba(31, 41, 55, 0.8)',
    border: '1px solid rgba(255,255,255,0.05)',
    boxShadow: '0 4px 20px rgba(0,0,0,0.3)',
  },
  statIconWrapper: {
    width: '48px',
    height: '48px',
    borderRadius: '12px',
    backgroundColor: '#eef2ff',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
  },
  statIcon: {
    fontSize: '24px',
    color: '#6366f1',
  },
  statValue: {
    fontSize: '24px',
    fontWeight: '700',
    color: '#1f2937',
  },
  statValueDark: {
    color: '#f9fafb',
  },
  statLabel: {
    fontSize: '14px',
    color: '#6b7280',
  },
  statLabelDark: {
    color: '#9ca3af',
  },
  statProgress: {
    width: '100%',
    height: '4px',
    backgroundColor: '#e5e7eb',
    borderRadius: '2px',
    marginTop: '8px',
    overflow: 'hidden',
  },
  statProgressBar: {
    height: '100%',
    backgroundColor: '#6366f1',
    borderRadius: '2px',
    transition: 'width 0.6s ease',
  },
  statSubtext: {
    fontSize: '11px',
    color: '#6b7280',
    marginTop: '4px',
  },
  statTrend: {
    display: 'flex',
    alignItems: 'center',
    gap: '4px',
    marginTop: '4px',
  },
  trendUp: {
    color: '#22c55e',
    fontSize: '14px',
  },
  trendText: {
    fontSize: '12px',
    color: '#22c55e',
  },
  chartsRow: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))',
    gap: '20px',
    marginBottom: '24px',
  },
  chartCard: {
    background: 'rgba(255,255,255,0.8)',
    backdropFilter: 'blur(10px)',
    borderRadius: '16px',
    padding: '20px',
    boxShadow: '0 4px 20px rgba(0,0,0,0.06)',
    border: '1px solid rgba(255,255,255,0.3)',
  },
  chartCardDark: {
    background: 'rgba(31, 41, 55, 0.8)',
    border: '1px solid rgba(255,255,255,0.05)',
    boxShadow: '0 4px 20px rgba(0,0,0,0.3)',
  },
  chartHeader: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: '16px',
  },
  chartTitle: {
    fontSize: '16px',
    fontWeight: '600',
    color: '#1f2937',
    margin: 0,
  },
  chartTitleDark: {
    color: '#f9fafb',
  },
  chartBadge: {
    fontSize: '11px',
    color: '#6b7280',
    backgroundColor: '#f3f4f6',
    padding: '4px 10px',
    borderRadius: '20px',
  },
  chartBadgeDark: {
    color: '#9ca3af',
    backgroundColor: 'rgba(255,255,255,0.05)',
  },
  barChart: {
    display: 'flex',
    justifyContent: 'space-around',
    alignItems: 'flex-end',
    height: '160px',
    paddingTop: '10px',
  },
  barItem: {
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    gap: '4px',
    flex: 1,
  },
  barContainer: {
    height: '120px',
    width: '30px',
    display: 'flex',
    alignItems: 'flex-end',
    justifyContent: 'center',
  },
  bar: {
    width: '100%',
    minHeight: '5px',
    borderRadius: '4px',
    transition: 'height 0.4s ease',
  },
  barLabel: {
    fontSize: '11px',
    color: '#6b7280',
    fontWeight: '500',
  },
  barLabelDark: {
    color: '#9ca3af',
  },
  barCount: {
    fontSize: '11px',
    color: '#1f2937',
    fontWeight: '600',
  },
  barCountDark: {
    color: '#f9fafb',
  },
  distributionContainer: {
    display: 'flex',
    flexDirection: 'column',
    gap: '10px',
  },
  distributionItem: {
    display: 'flex',
    alignItems: 'center',
    gap: '12px',
  },
  distributionLabel: {
    display: 'flex',
    alignItems: 'center',
    gap: '8px',
    width: '140px',
  },
  distributionIcon: {
    fontSize: '16px',
  },
  distributionName: {
    fontSize: '14px',
    color: '#1f2937',
  },
  distributionNameDark: {
    color: '#f9fafb',
  },
  distributionBarContainer: {
    flex: 1,
    height: '20px',
    backgroundColor: '#f3f4f6',
    borderRadius: '10px',
    overflow: 'hidden',
  },
  distributionBar: {
    height: '100%',
    borderRadius: '10px',
    transition: 'width 0.6s ease',
  },
  distributionCount: {
    fontSize: '13px',
    color: '#6b7280',
    minWidth: '60px',
    textAlign: 'right',
  },
  distributionCountDark: {
    color: '#9ca3af',
  },
  twoColumnRow: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))',
    gap: '20px',
  },
  sharedList: {
    display: 'flex',
    flexDirection: 'column',
    gap: '8px',
  },
  sharedItem: {
    display: 'flex',
    alignItems: 'center',
    gap: '12px',
    padding: '10px 14px',
    backgroundColor: '#f9fafb',
    borderRadius: '8px',
    transition: 'all 0.2s ease',
  },
  sharedItemDark: {
    backgroundColor: 'rgba(255,255,255,0.05)',
  },
  sharedRank: {
    fontWeight: '700',
    color: '#6366f1',
    fontSize: '14px',
    minWidth: '30px',
  },
  sharedName: {
    flex: 1,
    fontSize: '14px',
    color: '#1f2937',
  },
  sharedNameDark: {
    color: '#f9fafb',
  },
  sharedCount: {
    fontSize: '13px',
    color: '#6b7280',
  },
  activityList: {
    display: 'flex',
    flexDirection: 'column',
    gap: '8px',
    maxHeight: '300px',
    overflow: 'auto',
  },
  activityItem: {
    display: 'flex',
    alignItems: 'center',
    gap: '12px',
    padding: '10px 14px',
    backgroundColor: '#f9fafb',
    borderRadius: '8px',
    transition: 'all 0.2s ease',
  },
  activityItemDark: {
    backgroundColor: 'rgba(255,255,255,0.05)',
  },
  activityIcon: {
    fontSize: '18px',
  },
  activityMessage: {
    flex: 1,
    fontSize: '13px',
    color: '#1f2937',
  },
  activityMessageDark: {
    color: '#f9fafb',
  },
  activityTime: {
    fontSize: '11px',
    color: '#6b7280',
  },
  activityTimeDark: {
    color: '#9ca3af',
  },
  noData: {
    color: '#6b7280',
    textAlign: 'center',
    padding: '20px',
  },
  noDataDark: {
    color: '#9ca3af',
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
  errorContainer: {
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    justifyContent: 'center',
    minHeight: '60vh',
    padding: '40px',
  },
  errorIcon: {
    fontSize: '48px',
    marginBottom: '16px',
  },
  errorTitle: {
    fontSize: '20px',
    fontWeight: '600',
    color: '#1f2937',
    marginBottom: '8px',
  },
  errorText: {
    fontSize: '14px',
    color: '#6b7280',
    marginBottom: '20px',
  },
  retryBtn: {
    backgroundColor: '#6366f1',
    color: 'white',
    border: 'none',
    padding: '10px 24px',
    borderRadius: '8px',
    cursor: 'pointer',
    fontSize: '14px',
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

export default Analytics;