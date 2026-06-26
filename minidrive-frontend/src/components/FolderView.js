import React, { useState, useEffect } from 'react';
import api from '../services/api';

function FolderView({ folderName, onBack, onFileClick }) {
  const [items, setItems] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    loadFolderContents();
  }, [folderName]);

  const loadFolderContents = async () => {
    try {
      setLoading(true);
      const response = await api.get(`/files/folder/${folderName}`);
      setItems(response.data);
      setError('');
    } catch (error) {
      console.error('Failed to load folder:', error);
      setError('Failed to load folder contents');
    } finally {
      setLoading(false);
    }
  };

  const formatFileSize = (bytes) => {
    if (!bytes || bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
  };

  const getFileIcon = (item) => {
    if (item.folder) return '📁';
    const fileType = item.fileType || '';
    if (fileType.startsWith('image/')) return '🖼️';
    if (fileType.startsWith('video/')) return '🎬';
    if (fileType.startsWith('audio/')) return '🎵';
    if (fileType.includes('pdf')) return '📄';
    if (fileType.includes('word') || fileType.includes('document')) return '📝';
    return '📄';
  };

  if (loading) {
    return <div style={styles.loading}>Loading folder contents...</div>;
  }

  if (error) {
    return <div style={styles.error}>{error}</div>;
  }

  return (
    <div style={styles.container}>
      <div style={styles.header}>
        <button onClick={onBack} style={styles.backBtn}>← Back</button>
        <h3 style={styles.folderTitle}>📁 {folderName}</h3>
        <span style={styles.itemCount}>{items.length} items</span>
      </div>

      {items.length === 0 ? (
        <div style={styles.emptyState}>This folder is empty</div>
      ) : (
        <div style={styles.grid}>
          {items.map((item) => (
            <div
              key={item.id}
              style={styles.itemCard}
              onClick={() => onFileClick(item)}
            >
              <div style={styles.itemIcon}>{getFileIcon(item)}</div>
              <div style={styles.itemInfo}>
                <div style={styles.itemName}>{item.fileName}</div>
                <div style={styles.itemMeta}>
                  {item.folder ? 'Folder' : formatFileSize(item.fileSize)}
                </div>
              </div>
            </div>
          ))}
        </div>
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
    alignItems: 'center',
    gap: '15px',
    marginBottom: '20px',
    paddingBottom: '15px',
    borderBottom: '1px solid #eee',
  },
  backBtn: {
    backgroundColor: '#f0f0f0',
    border: 'none',
    padding: '8px 16px',
    borderRadius: '6px',
    cursor: 'pointer',
    fontSize: '14px',
  },
  folderTitle: {
    margin: 0,
    fontSize: '18px',
  },
  itemCount: {
    marginLeft: 'auto',
    color: '#888',
    fontSize: '14px',
  },
  grid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fill, minmax(150px, 1fr))',
    gap: '15px',
  },
  itemCard: {
    padding: '15px',
    borderRadius: '8px',
    backgroundColor: '#f8f9fa',
    cursor: 'pointer',
    textAlign: 'center',
    transition: 'all 0.2s ease',
  },
  itemIcon: {
    fontSize: '32px',
    marginBottom: '8px',
  },
  itemInfo: {
    textAlign: 'center',
  },
  itemName: {
    fontSize: '14px',
    fontWeight: '500',
    overflow: 'hidden',
    textOverflow: 'ellipsis',
    whiteSpace: 'nowrap',
  },
  itemMeta: {
    fontSize: '12px',
    color: '#888',
    marginTop: '4px',
  },
  loading: {
    textAlign: 'center',
    padding: '40px',
    color: '#888',
  },
  error: {
    textAlign: 'center',
    padding: '40px',
    color: '#e74c3c',
  },
  emptyState: {
    textAlign: 'center',
    padding: '40px',
    color: '#888',
  },
};

export default FolderView;