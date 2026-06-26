import React, { useState } from 'react';
import AdvancedShareModal from './AdvancedShareModal';

function SearchResults({ results, loading, onDownload, onShare, onDelete }) {
  const [showAdvancedShare, setShowAdvancedShare] = useState(false);
  const [selectedFileForShare, setSelectedFileForShare] = useState(null);
  const formatFileSize = (bytes) => {
    if (!bytes || bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
  };

  const formatDate = (dateString) => {
    if (!dateString) return 'Unknown';
    const date = new Date(dateString);
    const now = new Date();
    const diff = Math.floor((now - date) / (1000 * 60 * 60 * 24));
    
    if (diff === 0) return 'Today';
    if (diff === 1) return 'Yesterday';
    if (diff < 7) return `${diff} days ago`;
    return date.toLocaleDateString();
  };

  const getFileIcon = (file) => {
    const fileType = file.fileType || '';
    if (fileType.startsWith('image/')) return '🖼️';
    if (fileType.startsWith('video/')) return '🎬';
    if (fileType.startsWith('audio/')) return '🎵';
    if (fileType.includes('pdf')) return '📄';
    if (fileType.includes('word') || fileType.includes('document')) return '📝';
    if (fileType.includes('excel') || fileType.includes('spreadsheet')) return '📊';
    return '📄';
  };

  if (loading) {
    return <div style={styles.loading}>Searching files...</div>;
  }

  if (!results || results.length === 0) {
    return <div style={styles.empty}>No files found matching your search</div>;
  }

  return (
    <div style={styles.container}>
      <div style={styles.header}>
        <h3 style={styles.title}>📋 Search Results</h3>
        <span style={styles.count}>{results.length} files found</span>
      </div>

      <div style={styles.list}>
        {results.map((file) => (
          <div key={file.id} style={styles.item}>
            <div style={styles.itemInfo}>
              <span style={styles.itemIcon}>{getFileIcon(file)}</span>
              <div style={styles.itemDetails}>
                <div style={styles.itemName}>{file.fileName}</div>
                <div style={styles.itemMeta}>
                  {formatFileSize(file.fileSize)} • {formatDate(file.uploadedAt)} • 
                  {file.folderName !== 'root' ? ` 📁 ${file.folderName}` : ' 📁 Root'}
                </div>
              </div>
            </div>
            <div style={styles.actions}>
              <button onClick={() => onDownload(file.id, file.fileName)} style={styles.downloadBtn} title="Download">
                ↓
              </button>
              <button
                onClick={() => {
                  setSelectedFileForShare(file);
                  setShowAdvancedShare(true);
                }}
                style={styles.shareBtn}
                title="Advanced Share"
              >
                🔗
              </button>
              <button onClick={() => onDelete(file.id)} style={styles.deleteBtn} title="Delete">
                🗑️
              </button>
            </div>
          </div>
        ))}
      </div>
      {showAdvancedShare && selectedFileForShare && (
        <AdvancedShareModal
          file={selectedFileForShare}
          onClose={() => setShowAdvancedShare(false)}
          onShare={(data) => {
            console.log('Share created:', data);
            alert('Share link created successfully!');
            setShowAdvancedShare(false);
            setSelectedFileForShare(null);
          }}
        />
      )}
    </div>
  );
}

const styles = {
  container: {
    backgroundColor: 'white',
    borderRadius: '12px',
    padding: '20px',
    marginTop: '20px',
    boxShadow: '0 2px 8px rgba(0,0,0,0.08)',
  },
  header: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: '16px',
    paddingBottom: '12px',
    borderBottom: '1px solid #eee',
  },
  title: {
    margin: 0,
    fontSize: '18px',
  },
  count: {
    fontSize: '14px',
    color: '#888',
  },
  list: {
    display: 'flex',
    flexDirection: 'column',
    gap: '10px',
  },
  item: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: '12px 16px',
    backgroundColor: '#f8f9fa',
    borderRadius: '8px',
    transition: 'background-color 0.2s',
  },
  itemInfo: {
    display: 'flex',
    alignItems: 'center',
    gap: '12px',
    flex: 1,
  },
  itemIcon: {
    fontSize: '28px',
  },
  itemDetails: {
    flex: 1,
  },
  itemName: {
    fontWeight: '500',
    fontSize: '14px',
  },
  itemMeta: {
    fontSize: '12px',
    color: '#888',
    marginTop: '2px',
  },
  actions: {
    display: 'flex',
    gap: '8px',
  },
  downloadBtn: {
    backgroundColor: '#28a745',
    color: 'white',
    border: 'none',
    padding: '6px 10px',
    borderRadius: '5px',
    cursor: 'pointer',
  },
  shareBtn: {
    backgroundColor: '#17a2b8',
    color: 'white',
    border: 'none',
    padding: '6px 10px',
    borderRadius: '5px',
    cursor: 'pointer',
  },
  deleteBtn: {
    backgroundColor: '#dc3545',
    color: 'white',
    border: 'none',
    padding: '6px 10px',
    borderRadius: '5px',
    cursor: 'pointer',
  },
  loading: {
    textAlign: 'center',
    padding: '40px',
    color: '#888',
  },
  empty: {
    textAlign: 'center',
    padding: '40px',
    color: '#888',
    backgroundColor: 'white',
    borderRadius: '12px',
  },
};

export default SearchResults;
