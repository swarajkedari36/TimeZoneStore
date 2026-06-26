import React, { useState } from 'react';
import { FiDownload, FiShare2, FiTrash2, FiEye } from 'react-icons/fi';

function FileCard({ file, onDownload, onShare, onDelete, onPreview }) {
  const [isHovered, setIsHovered] = useState(false);

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
    return '📄';
  };

  return (
    <div 
      style={styles.card}
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => setIsHovered(false)}
      className="file-card"
    >
      <div style={styles.thumbnail}>
        <span style={styles.iconLarge}>{getFileIcon(file)}</span>
        {isHovered && (
          <button style={styles.previewBtn} onClick={() => onPreview(file)}>
            👁️ Quick View
          </button>
        )}
      </div>
      
      <div style={styles.info}>
        <div style={styles.nameRow}>
          <span style={styles.name}>{file.fileName}</span>
        </div>
        <div style={styles.meta}>
          <span>{formatFileSize(file.fileSize)}</span>
          <span>•</span>
          <span>{file.uploadedAt ? new Date(file.uploadedAt).toLocaleDateString() : 'Unknown'}</span>
        </div>
        <div style={styles.actions}>
          <button style={styles.actionBtn} onClick={() => onDownload(file.id, file.fileName)} title="Download">
            <FiDownload size={18} />
          </button>
          <button style={styles.actionBtn} onClick={() => onShare(file.id)} title="Share">
            <FiShare2 size={18} />
          </button>
          <button style={styles.actionBtn} onClick={() => onDelete(file.id)} title="Delete">
            <FiTrash2 size={18} />
          </button>
        </div>
      </div>
    </div>
  );
}

const styles = {
  card: {
    backgroundColor: 'white',
    borderRadius: '14px',
    overflow: 'hidden',
    boxShadow: '0 2px 12px rgba(0,0,0,0.06)',
    transition: 'all 0.3s ease',
    cursor: 'pointer',
  },
  thumbnail: {
    height: '160px',
    backgroundColor: '#f3f4f6',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    position: 'relative',
  },
  iconLarge: {
    fontSize: '56px',
  },
  previewBtn: {
    position: 'absolute',
    bottom: '12px',
    left: '50%',
    transform: 'translateX(-50%)',
    backgroundColor: 'rgba(0,0,0,0.7)',
    color: 'white',
    border: 'none',
    padding: '8px 20px',
    borderRadius: '20px',
    fontSize: '14px',
    fontWeight: '500',
    cursor: 'pointer',
    opacity: 0,
    transition: 'all 0.3s ease',
  },
  info: {
    padding: '16px 20px',
  },
  nameRow: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  name: {
    fontWeight: '600',
    fontSize: '17px',
    color: '#1f2937',
    fontFamily: 'Poppins, sans-serif',
    overflow: 'hidden',
    textOverflow: 'ellipsis',
    whiteSpace: 'nowrap',
  },
  meta: {
    display: 'flex',
    gap: '8px',
    fontSize: '14px',
    color: '#6b7280',
    marginTop: '6px',
  },
  actions: {
    display: 'flex',
    gap: '10px',
    marginTop: '14px',
  },
  actionBtn: {
    padding: '8px 12px',
    border: 'none',
    borderRadius: '8px',
    backgroundColor: '#f3f4f6',
    cursor: 'pointer',
    fontSize: '14px',
    transition: 'all 0.2s ease',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    color: '#4b5563',
  },
};

// Add hover styles
const styleSheet = document.createElement("style");
styleSheet.textContent = `
  .file-card:hover {
    transform: translateY(-4px);
    box-shadow: 0 8px 30px rgba(0,0,0,0.12);
  }
  .file-card:hover .preview-btn {
    opacity: 1;
  }
  .action-btn:hover {
    background: #e5e7eb;
    transform: scale(1.05);
  }
`;
document.head.appendChild(styleSheet);

export default FileCard;