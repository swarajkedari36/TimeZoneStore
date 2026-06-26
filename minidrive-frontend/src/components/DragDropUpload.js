import React, { useCallback, useState } from 'react';
import { useDropzone } from 'react-dropzone';
import { FiUpload, FiFile, FiX } from 'react-icons/fi';
import { toast } from './Toast';

function DragDropUpload({ onUpload, onClose }) {
  const [files, setFiles] = useState([]);
  const [uploading, setUploading] = useState(false);
  const [progress, setProgress] = useState(0);

  const onDrop = useCallback((acceptedFiles) => {
    setFiles(prev => [...prev, ...acceptedFiles]);
  }, []);

  const { getRootProps, getInputProps, isDragActive } = useDropzone({
    onDrop,
    multiple: true,
  });

  const handleUpload = async () => {
    if (files.length === 0) return;
    
    setUploading(true);
    let uploaded = 0;
    
    for (const file of files) {
      try {
        await onUpload(file);
        uploaded++;
        setProgress(Math.round((uploaded / files.length) * 100));
      } catch (error) {
        toast.error(`Failed to upload: ${file.name}`);
      }
    }
    
    setUploading(false);
    toast.success(`Uploaded ${uploaded} files successfully!`);
    setFiles([]);
    setProgress(0);
    if (onClose) onClose();
  };

  const removeFile = (index) => {
    setFiles(prev => prev.filter((_, i) => i !== index));
  };

  return (
    <div style={styles.modalOverlay} onClick={onClose}>
      <div style={styles.modal} onClick={(e) => e.stopPropagation()}>
        <button onClick={onClose} style={styles.closeBtn}>✕</button>
        <h3 style={styles.title}>📤 Drag & Drop Upload</h3>

        <div {...getRootProps()} style={{
          ...styles.dropzone,
          ...(isDragActive ? styles.dropzoneActive : {})
        }}>
          <input {...getInputProps()} />
          <FiUpload size={48} style={styles.dropIcon} />
          {isDragActive ? (
            <p>Drop the files here...</p>
          ) : (
            <p>Drag & drop files here, or click to select</p>
          )}
        </div>

        {files.length > 0 && (
          <div style={styles.fileList}>
            {files.map((file, index) => (
              <div key={index} style={styles.fileItem}>
                <FiFile />
                <span style={styles.fileName}>{file.name}</span>
                <span style={styles.fileSize}>
                  {(file.size / 1024).toFixed(1)} KB
                </span>
                <button onClick={() => removeFile(index)} style={styles.removeBtn}>
                  <FiX />
                </button>
              </div>
            ))}
          </div>
        )}

        {uploading && (
          <div style={styles.progressContainer}>
            <div style={styles.progressBar}>
              <div style={{...styles.progressFill, width: `${progress}%`}} />
            </div>
            <span style={styles.progressText}>{progress}%</span>
          </div>
        )}

        <button
          onClick={handleUpload}
          disabled={files.length === 0 || uploading}
          style={{
            ...styles.uploadBtn,
            ...(files.length === 0 || uploading ? styles.uploadBtnDisabled : {})
          }}
        >
          {uploading ? 'Uploading...' : `Upload ${files.length} Files`}
        </button>
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
    backgroundColor: 'rgba(0,0,0,0.5)',
    display: 'flex',
    justifyContent: 'center',
    alignItems: 'center',
    zIndex: 99999,
  },
  modal: {
    backgroundColor: 'white',
    padding: '30px',
    borderRadius: '16px',
    maxWidth: '500px',
    width: '90%',
    maxHeight: '80vh',
    overflow: 'auto',
    position: 'relative',
  },
  closeBtn: {
    position: 'absolute',
    top: '10px',
    right: '15px',
    background: 'none',
    border: 'none',
    fontSize: '20px',
    cursor: 'pointer',
  },
  title: { marginTop: 0, marginBottom: '20px' },
  dropzone: {
    border: '2px dashed #ccc',
    borderRadius: '12px',
    padding: '40px',
    textAlign: 'center',
    cursor: 'pointer',
    transition: 'all 0.3s ease',
  },
  dropzoneActive: {
    borderColor: '#667eea',
    backgroundColor: 'rgba(102, 126, 234, 0.05)',
  },
  dropIcon: { color: '#667eea', marginBottom: '10px' },
  fileList: {
    marginTop: '15px',
    maxHeight: '200px',
    overflow: 'auto',
  },
  fileItem: {
    display: 'flex',
    alignItems: 'center',
    gap: '10px',
    padding: '8px 12px',
    backgroundColor: '#f5f5f5',
    borderRadius: '6px',
    marginBottom: '6px',
  },
  fileName: { flex: 1, fontSize: '14px' },
  fileSize: { fontSize: '12px', color: '#888' },
  removeBtn: {
    background: 'none',
    border: 'none',
    cursor: 'pointer',
    color: '#dc3545',
  },
  progressContainer: {
    marginTop: '15px',
  },
  progressBar: {
    height: '8px',
    backgroundColor: '#e9ecef',
    borderRadius: '4px',
    overflow: 'hidden',
  },
  progressFill: {
    height: '100%',
    backgroundColor: '#667eea',
    borderRadius: '4px',
    transition: 'width 0.3s ease',
  },
  progressText: {
    fontSize: '12px',
    color: '#888',
    marginTop: '4px',
    display: 'block',
  },
  uploadBtn: {
    width: '100%',
    padding: '12px',
    marginTop: '15px',
    backgroundColor: '#667eea',
    color: 'white',
    border: 'none',
    borderRadius: '8px',
    cursor: 'pointer',
    fontSize: '16px',
  },
  uploadBtnDisabled: {
    backgroundColor: '#ccc',
    cursor: 'not-allowed',
  },
};

export default DragDropUpload;