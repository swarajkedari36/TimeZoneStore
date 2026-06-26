import React, { useState, useEffect, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { fileAPI } from '../services/api';
import api from '../services/api';
import Navbar from '../components/Navbar';
import FolderView from '../components/FolderView';
import SearchBar from '../components/SearchBar';
import SearchResults from '../components/SearchResults';
import AdvancedShareModal from '../components/AdvancedShareModal';
import FilePreview from '../components/FilePreview';
import { toast } from '../components/Toast';
import FileCard from '../components/dashboard/FileCard';
import StatsCard from '../components/dashboard/StatsCard';
import QuickAccess from '../components/dashboard/QuickAccess';
import DragDropUpload from '../components/upload/DragDropUpload';
import Tooltip from '../components/Tooltip';
import { useTheme } from '../context/ThemeContext';

// Add dark mode support to Dashboard styles
const getStyles = (darkMode) => ({
  container: {
    minHeight: '100vh',
    background: darkMode
      ? 'linear-gradient(135deg, #111827 0%, #1f2937 100%)'
      : 'linear-gradient(135deg, #f0f4ff 0%, #e8edf5 100%)',
    transition: 'background 0.3s ease',
  },
  statCard: {
    background: darkMode
      ? 'rgba(31, 41, 55, 0.8)'
      : 'rgba(255,255,255,0.8)',
    backdropFilter: 'blur(10px)',
    borderRadius: '16px',
    padding: '20px',
    display: 'flex',
    alignItems: 'center',
    gap: '16px',
    boxShadow: darkMode
      ? '0 4px 20px rgba(0,0,0,0.3)'
      : '0 4px 20px rgba(0,0,0,0.06)',
    border: darkMode
      ? '1px solid rgba(255,255,255,0.05)'
      : '1px solid rgba(255,255,255,0.3)',
  },
  statValue: {
    fontSize: '24px',
    fontWeight: '700',
    color: darkMode ? '#f9fafb' : '#1f2937',
  },
  statLabel: {
    fontSize: '14px',
    color: darkMode ? '#9ca3af' : '#6b7280',
  },
});

function Dashboard() {
  const navigate = useNavigate();
  const { darkMode } = useTheme();
  const [files, setFiles] = useState([]);
  const [searchQuery, setSearchQuery] = useState('');
  const [loading, setLoading] = useState(true);
  const [uploading, setUploading] = useState(false);
  const [selectedFile, setSelectedFile] = useState(null);
  const [debugInfo, setDebugInfo] = useState('');
  const [tokenExpiryWarning, setTokenExpiryWarning] = useState('');
  const [tokenExpiryTime, setTokenExpiryTime] = useState(null);
  const [searchResults, setSearchResults] = useState([]);
  const [isSearching, setIsSearching] = useState(false);
  const [showSearchResults, setShowSearchResults] = useState(false);
  const [searchCount, setSearchCount] = useState(0);
  const [showAdvancedShare, setShowAdvancedShare] = useState(false);
  const [selectedFileForShare, setSelectedFileForShare] = useState(null);
  const [previewFile, setPreviewFile] = useState(null);
  const [showPreview, setShowPreview] = useState(false);
  const [showDragDrop, setShowDragDrop] = useState(false);
  const [viewMode, setViewMode] = useState('grid');
  
  const [folders, setFolders] = useState([]);
  const [currentFolder, setCurrentFolder] = useState('root');
  const [folderView, setFolderView] = useState(false);
  const [showNewFolderModal, setShowNewFolderModal] = useState(false);
  const [newFolderName, setNewFolderName] = useState('');
  const [folderItems, setFolderItems] = useState([]);
  
  // Stats
  const [stats, setStats] = useState({
    storageUsed: 0,
    totalFiles: 0,
    totalDownloads: 0,
    totalShareLinks: 0
  });

  const username = localStorage.getItem('username');

  // ===== UPLOAD HANDLER =====
  const handleUpload = async (file) => {
    if (!file) return;

    setUploading(true);
    setDebugInfo('Uploading file...');
    
    try {
      let response;
      if (currentFolder === 'root') {
        response = await fileAPI.upload(file);
      } else {
        response = await fileAPI.uploadToFolder(file, currentFolder);
      }
      
      console.log('✅ Upload response:', response.data);
      setDebugInfo(`✅ Upload successful! File ID: ${response.data.id}`);
      toast.success('File uploaded successfully!');
      
      setSelectedFile(null);
      const fileInput = document.getElementById('file-input');
      if (fileInput) fileInput.value = '';
      
      await loadAllItems();
      
    } catch (error) {
      console.error('❌ Upload failed:', error);
      setDebugInfo(`❌ Upload error: ${error.response?.data?.message || error.message}`);
      toast.error('Upload failed!');
    } finally {
      setUploading(false);
    }
  };

  // ===== LOAD STATS =====
  const loadStats = useCallback(async () => {
    try {
      const response = await api.get('/analytics/dashboard');
      setStats({
        storageUsed: response.data.storageUsed || 0,
        totalFiles: response.data.totalFiles || 0,
        totalDownloads: response.data.totalDownloads || 0,
        totalShareLinks: response.data.totalShareLinks || 0
      });
    } catch (error) {
      console.error('Failed to load stats:', error);
    }
  }, []);

  // ===== LOAD FILES & FOLDERS =====
  const loadAllItems = useCallback(async () => {
    try {
      setLoading(true);
      const response = await api.get('/files/all-items');
      setFolders(response.data.folders || []);
      const folderResponse = await api.get(`/files/folder/${currentFolder}`);
      setFolderItems(folderResponse.data || []);
      setFiles(folderResponse.data || []);
      setDebugInfo(`Found ${response.data.folders?.length || 0} folders, ${folderResponse.data?.length || 0} items in ${currentFolder}`);
      await loadStats();
    } catch (error) {
      console.error('Failed to load items:', error);
      if (error.response?.status === 401 || error.response?.status === 403) {
        setTimeout(() => handleLogout(), 2000);
      }
    } finally {
      setLoading(false);
    }
  }, [currentFolder, loadStats]);

  useEffect(() => {
    loadAllItems();
  }, [loadAllItems]);

  // ===== HANDLERS =====

  // ===== SEARCH HANDLER =====
  const handleSearch = async (filters) => {
    try {
      setIsSearching(true);
      setDebugInfo('Searching files...');
      
      const params = new URLSearchParams();
      if (filters.keyword) params.append('keyword', filters.keyword);
      if (filters.fileType) params.append('fileType', filters.fileType);
      
      // Date handling
      if (filters.dateRange) {
        const now = new Date();
        let startDate;
        switch (filters.dateRange) {
          case 'Today':
            startDate = new Date(now.getFullYear(), now.getMonth(), now.getDate());
            break;
          case 'This Week':
            startDate = new Date(now);
            startDate.setDate(now.getDate() - now.getDay());
            startDate.setHours(0, 0, 0, 0);
            break;
          case 'This Month':
            startDate = new Date(now.getFullYear(), now.getMonth(), 1);
            break;
          case 'Last 3 Months':
            startDate = new Date(now);
            startDate.setMonth(now.getMonth() - 3);
            break;
          case 'This Year':
            startDate = new Date(now.getFullYear(), 0, 1);
            break;
          default:
            startDate = null;
        }
        if (startDate) {
          params.append('startDate', startDate.toISOString());
          params.append('endDate', new Date().toISOString());
        }
      }
      
      // Size handling
      if (filters.sizeRange) {
        switch (filters.sizeRange) {
          case '< 1 MB': params.append('minSize', '0'); params.append('maxSize', '1048576'); break;
          case '1-5 MB': params.append('minSize', '1048576'); params.append('maxSize', '5242880'); break;
          case '5-10 MB': params.append('minSize', '5242880'); params.append('maxSize', '10485760'); break;
          case '10-50 MB': params.append('minSize', '10485760'); params.append('maxSize', '52428800'); break;
          case '> 50 MB': params.append('minSize', '52428800'); params.append('maxSize', '999999999'); break;
        }
      }
      
      if (filters.sortBy) params.append('sortBy', filters.sortBy);
      if (filters.sortOrder) params.append('sortOrder', filters.sortOrder);
      
      const response = await api.get(`/search/advanced?${params.toString()}`);
      setSearchResults(response.data.results || []);
      setSearchCount(response.data.count || 0);
      setShowSearchResults(true);
      setDebugInfo(`✅ Found ${response.data.count} files`);
      toast.success(`Found ${response.data.count} files matching your search`);
      
    } catch (error) {
      console.error('Search failed:', error);
      toast.error('Search failed!');
    } finally {
      setIsSearching(false);
    }
  };

  const handleClearSearch = () => {
    setSearchResults([]);
    setShowSearchResults(false);
    setSearchCount(0);
    setDebugInfo('Search cleared');
    loadAllItems();
    toast.info('Search cleared');
  };

  const handlePreview = (file) => {
    setPreviewFile(file);
    setShowPreview(true);
  };

  const handleClosePreview = () => {
    setShowPreview(false);
    setPreviewFile(null);
  };

  const handleAdvancedShare = (file) => {
    setSelectedFileForShare(file);
    setShowAdvancedShare(true);
  };

  const handleCloseAdvancedShare = () => {
    setShowAdvancedShare(false);
    setSelectedFileForShare(null);
    loadAllItems();
  };

  const handleDownload = async (fileId, fileName) => {
    try {
      const response = await fileAPI.download(fileId);
      const url = window.URL.createObjectURL(new Blob([response.data]));
      const link = document.createElement('a');
      link.href = url;
      link.setAttribute('download', fileName);
      document.body.appendChild(link);
      link.click();
      link.remove();
      window.URL.revokeObjectURL(url);
      toast.success('File downloaded successfully!');
    } catch (error) {
      toast.error('Download failed!');
    }
  };

  const handleShare = async (fileId) => {
    try {
      const response = await fileAPI.createShareLink(fileId);
      const shareLink = `http://localhost:3000/share/${response.data.token}`;
      await navigator.clipboard.writeText(shareLink);
      toast.success('Share link copied to clipboard!');
    } catch (error) {
      toast.error('Failed to create share link!');
    }
  };

  const handleDelete = async (fileId) => {
    if (!window.confirm('Delete this file?')) return;
    try {
      await fileAPI.deleteFile(fileId);
      toast.success('File deleted successfully!');
      loadAllItems();
    } catch (error) {
      toast.error('Delete failed!');
    }
  };

  const handleLogout = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('username');
    navigate('/login');
  };

  const formatFileSize = (bytes) => {
    if (!bytes || bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
  };

  if (loading && files.length === 0) {
    return (
      <div>
        <Navbar />
        <div style={styles.loading}>Loading your files...</div>
      </div>
    );
  }

  return (
    <div style={{
      ...styles.container,
      background: darkMode
        ? 'linear-gradient(135deg, #111827 0%, #1f2937 100%)'
        : 'linear-gradient(135deg, #f0f4ff 0%, #e8edf5 100%)'
    }}>
      <Navbar />

      {/* Main Content */}
      <div style={styles.content}>
        {/* Stats Row */}
        <div style={styles.statsGrid}>
          <div style={styles.statCard}>
            <div style={styles.statIcon}>💾</div>
            <div>
              <div style={styles.statValue}>{formatFileSize(stats.storageUsed)}</div>
              <div style={styles.statLabel}>Storage Used</div>
            </div>
          </div>
          <div style={styles.statCard}>
            <div style={styles.statIcon}>📁</div>
            <div>
              <div style={styles.statValue}>{stats.totalFiles}</div>
              <div style={styles.statLabel}>Total Files</div>
            </div>
          </div>
          <div style={styles.statCard}>
            <div style={styles.statIcon}>📥</div>
            <div>
              <div style={styles.statValue}>{stats.totalDownloads}</div>
              <div style={styles.statLabel}>Downloads</div>
            </div>
          </div>
          <div style={styles.statCard}>
            <div style={styles.statIcon}>🔗</div>
            <div>
              <div style={styles.statValue}>{stats.totalShareLinks}</div>
              <div style={styles.statLabel}>Share Links</div>
            </div>
          </div>
        </div>

        {/* Upload Section */}
        <div style={styles.uploadSection}>
          <div style={styles.uploadCard}>
            <div style={styles.uploadHeader}>
              <h2>📤 Upload Files</h2>
              <div style={styles.uploadActions}>
                <button 
                  onClick={() => document.getElementById('file-input').click()} 
                  style={styles.uploadBtn}
                >
                  Choose Files
                </button>
                <button 
                  onClick={() => setShowDragDrop(true)} 
                  style={styles.dragDropBtn}
                >
                  📂 Drag & Drop
                </button>
              </div>
            </div>
            <input
              id="file-input"
              type="file"
              onChange={(e) => {
                const file = e.target.files[0];
                if (file) {
                  handleUpload(file);
                }
              }}
              style={{ display: 'none' }}
            />
            <div style={styles.uploadInfo}>
              <span>📎 Supported: Images, PDFs, Documents, Videos</span>
              <span>🔒 Max size: 10MB</span>
            </div>
          </div>
        </div>

        {/* Search Bar */}
        <SearchBar onSearch={handleSearch} onClear={handleClearSearch} loading={isSearching} />

        {/* Debug Info
        <div style={styles.debugCard}>
          <h3>🔍 Debug Information</h3>
          <pre style={styles.debugText}>{debugInfo || 'Waiting for action...'}</pre>
        </div> */}
        {/* Files Section / Search Results */}
        {showSearchResults ? (
          <SearchResults
            results={searchResults}
            loading={isSearching}
            onDownload={handleDownload}
            onShare={handleShare}
            onDelete={handleDelete}
          />
        ) : (
          <>
            <div style={styles.sectionHeader}>
              <h2 style={styles.sectionTitle}>
                📂 {currentFolder === 'root' ? 'My Drive' : currentFolder}
                <span style={styles.fileCount}>({files.length} items)</span>
              </h2>
              <div style={styles.sectionActions}>
                <button onClick={loadAllItems} style={styles.refreshBtn}>🔄 Refresh</button>
              </div>
            </div>

            <div style={styles.fileGrid}>
              {files.map((file) => (
                <div key={file.id} style={styles.fileCard}>
                  <div style={styles.fileThumbnail}>
                    <span style={styles.fileIcon}>{getFileIcon(file)}</span>
                  </div>
                  <div style={styles.fileInfo}>
                    <div style={styles.fileName}>{file.fileName}</div>
                    <div style={styles.fileMeta}>
                      {formatFileSize(file.fileSize)} • {file.uploadedAt ? new Date(file.uploadedAt).toLocaleDateString() : 'Unknown'}
                    </div>
                    <div style={styles.fileActions}>
                      <Tooltip text="Preview File" position="top">
                        <button onClick={() => handlePreview(file)} style={styles.actionBtnPreview}>👁️</button>
                      </Tooltip>
                      
                      <Tooltip text="Download File" position="top">
                        <button onClick={() => handleDownload(file.id, file.fileName)} style={styles.actionBtnDownload}>↓</button>
                      </Tooltip>
                      
                      <Tooltip text="Share File" position="top">
                        <button onClick={() => handleShare(file.id)} style={styles.actionBtnShare}>🔗</button>
                      </Tooltip>
                      
                      <Tooltip text="Advanced Share" position="top">
                        <button onClick={() => handleAdvancedShare(file)} style={styles.actionBtnAdvanced}>🔒</button>
                      </Tooltip>
                      
                      <Tooltip text="Delete File" position="top">
                        <button onClick={() => handleDelete(file.id)} style={styles.actionBtnDelete}>🗑️</button>
                      </Tooltip>
                    </div>
                  </div>
                </div>
              ))}
            </div>

            {files.length === 0 && (
              <div style={styles.emptyState}>
                <div style={styles.emptyIcon}>🚀</div>
                <h3>No files yet!</h3>
                <p>Upload your first file to get started.</p>
              </div>
            )}
          </>
        )}
      </div>

      {/* Modals */}
      {showPreview && previewFile && (
        <FilePreview
          file={previewFile}
          onClose={handleClosePreview}
          onDownload={handleDownload}
          onShare={handleShare}
        />
      )}

      {showAdvancedShare && selectedFileForShare && (
        <AdvancedShareModal
          file={selectedFileForShare}
          onClose={handleCloseAdvancedShare}
          onShare={() => {}}
        />
      )}

      {showDragDrop && (
        <DragDropUpload
          onUpload={async (file) => {
            await handleUpload(file);
          }}
          onClose={() => setShowDragDrop(false)}
        />
      )}
    </div>
  );
}

function getFileIcon(file) {
  const fileType = file.fileType || '';
  if (fileType.startsWith('image/')) return '🖼️';
  if (fileType.startsWith('video/')) return '🎬';
  if (fileType.startsWith('audio/')) return '🎵';
  if (fileType.includes('pdf')) return '📄';
  if (fileType.includes('word') || fileType.includes('document')) return '📝';
  if (fileType.includes('excel') || fileType.includes('spreadsheet')) return '📊';
  return '📄';
}

const styles = {
  container: {
    minHeight: '100vh',
    background: 'linear-gradient(135deg, #f0f4ff 0%, #e8edf5 100%)',
  },
  content: {
    maxWidth: '1200px',
    margin: '0 auto',
    padding: '24px',
  },
  statsGrid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fit, minmax(180px, 1fr))',
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
  },
  statIcon: { fontSize: '32px' },
  statValue: { fontSize: '24px', fontWeight: '700', color: '#1f2937' },
  statLabel: { fontSize: '14px', color: '#6b7280' },
  uploadSection: { marginBottom: '24px' },
  uploadCard: {
    background: 'rgba(255,255,255,0.8)',
    backdropFilter: 'blur(10px)',
    borderRadius: '16px',
    padding: '24px',
    boxShadow: '0 4px 20px rgba(0,0,0,0.06)',
    border: '1px solid rgba(255,255,255,0.3)',
  },
  uploadHeader: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    flexWrap: 'wrap',
    gap: '12px',
  },
  uploadActions: { display: 'flex', gap: '12px' },
  uploadBtn: {
    backgroundColor: '#6366f1',
    color: 'white',
    border: 'none',
    padding: '10px 24px',
    borderRadius: '8px',
    cursor: 'pointer',
    fontSize: '14px',
    fontWeight: '600',
    transition: 'all 0.3s ease',
  },
  dragDropBtn: {
    backgroundColor: '#8b5cf6',
    color: 'white',
    border: 'none',
    padding: '10px 24px',
    borderRadius: '8px',
    cursor: 'pointer',
    fontSize: '14px',
    fontWeight: '600',
    transition: 'all 0.3s ease',
  },
  uploadInfo: {
    display: 'flex',
    gap: '20px',
    marginTop: '12px',
    fontSize: '13px',
    color: '#6b7280',
    flexWrap: 'wrap',
  },
  debugCard: {
    background: 'rgba(255,255,255,0.6)',
    backdropFilter: 'blur(10px)',
    borderRadius: '12px',
    padding: '16px',
    marginBottom: '24px',
    border: '1px solid rgba(255,255,255,0.2)',
  },
  debugText: {
    backgroundColor: '#1f2937',
    color: '#f9fafb',
    padding: '12px',
    borderRadius: '8px',
    fontSize: '12px',
    maxHeight: '100px',
    overflowY: 'auto',
    fontFamily: 'monospace',
  },
  sectionHeader: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: '16px',
  },
  sectionTitle: {
    fontSize: '20px',
    fontWeight: '600',
    color: '#1f2937',
  },
  fileCount: {
    fontSize: '14px',
    fontWeight: '400',
    color: '#6b7280',
    marginLeft: '8px',
  },
  sectionActions: { display: 'flex', gap: '12px' },
  refreshBtn: {
    backgroundColor: '#06b6d4',
    color: 'white',
    border: 'none',
    padding: '8px 16px',
    borderRadius: '8px',
    cursor: 'pointer',
    fontSize: '14px',
  },
  fileGrid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fill, minmax(220px, 1fr))',
    gap: '16px',
  },
  fileCard: {
    background: 'white',
    borderRadius: '12px',
    overflow: 'hidden',
    boxShadow: '0 2px 12px rgba(0,0,0,0.06)',
    transition: 'all 0.3s ease',
  },
  fileThumbnail: {
    height: '120px',
    background: 'linear-gradient(135deg, #eef2ff 0%, #e0e7ff 100%)',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    fontSize: '48px',
  },
  fileInfo: { padding: '12px 16px' },
  fileName: {
    fontSize: '14px',
    fontWeight: '500',
    color: '#1f2937',
    whiteSpace: 'nowrap',
    overflow: 'hidden',
    textOverflow: 'ellipsis',
  },
  fileMeta: {
    fontSize: '12px',
    color: '#6b7280',
    marginTop: '4px',
  },
  fileActions: {
    display: 'flex',
    gap: '6px',
    marginTop: '10px',
  },
  actionBtnPreview: {
    backgroundColor: '#8b5cf6',
    color: 'white',
    border: 'none',
    padding: '4px 8px',
    borderRadius: '4px',
    cursor: 'pointer',
    fontSize: '12px',
  },
  actionBtnDownload: {
    backgroundColor: '#22c55e',
    color: 'white',
    border: 'none',
    padding: '4px 8px',
    borderRadius: '4px',
    cursor: 'pointer',
    fontSize: '12px',
  },
  actionBtnShare: {
    backgroundColor: '#06b6d4',
    color: 'white',
    border: 'none',
    padding: '4px 8px',
    borderRadius: '4px',
    cursor: 'pointer',
    fontSize: '12px',
  },
  actionBtnAdvanced: {
    backgroundColor: '#f59e0b',
    color: 'white',
    border: 'none',
    padding: '4px 8px',
    borderRadius: '4px',
    cursor: 'pointer',
    fontSize: '12px',
  },
  actionBtnDelete: {
    backgroundColor: '#ef4444',
    color: 'white',
    border: 'none',
    padding: '4px 8px',
    borderRadius: '4px',
    cursor: 'pointer',
    fontSize: '12px',
  },
  emptyState: {
    textAlign: 'center',
    padding: '60px 20px',
    background: 'white',
    borderRadius: '16px',
  },
  emptyIcon: { fontSize: '64px', marginBottom: '16px' },
  loading: {
    textAlign: 'center',
    padding: '60px',
    fontSize: '18px',
    color: '#6b7280',
  },
};

export default Dashboard;