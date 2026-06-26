import React, { useCallback, useState } from 'react';
import { useDropzone } from 'react-dropzone';
import { FiUpload, FiFile, FiX, FiCheckCircle, FiAlertCircle } from 'react-icons/fi';
import { toast } from '../Toast';

function DragDropUpload({ onUpload, onClose }) {
  const [files, setFiles] = useState([]);
  const [uploading, setUploading] = useState(false);
  const [progress, setProgress] = useState(0);
  const [uploadStatus, setUploadStatus] = useState(null);

  const onDrop = useCallback((acceptedFiles, rejectedFiles) => {
    // Check for rejected files (size limit, etc.)
    if (rejectedFiles.length > 0) {
      toast.error(`${rejectedFiles.length} file(s) rejected. Max size: 10MB`);
    }
    
    setFiles(prev => [...prev, ...acceptedFiles]);
  }, []);

  const { getRootProps, getInputProps, isDragActive } = useDropzone({
    onDrop,
    multiple: true,
    maxSize: 10485760, // 10MB
    accept: {
      'image/*': [],
      'application/pdf': [],
      'application/msword': [],
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document': [],
      'application/vnd.ms-excel': [],
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet': [],
      'text/plain': [],
      'video/*': [],
      'audio/*': [],
    }
  });

  const handleUpload = async () => {
    if (files.length === 0) return;
    
    setUploading(true);
    setUploadStatus('uploading');
    let uploaded = 0;
    let failed = 0;
    
    for (const file of files) {
      try {
        await onUpload(file);
        uploaded++;
        setProgress(Math.round((uploaded / files.length) * 100));
      } catch (error) {
        failed++;
        toast.error(`Failed to upload: ${file.name}`);
      }
    }
    
    setUploadStatus(failed === 0 ? 'success' : 'partial');
    toast.success(`Uploaded ${uploaded} file${uploaded > 1 ? 's' : ''} successfully!`);
    
    setTimeout(() => {
      setFiles([]);
      setProgress(0);
      setUploadStatus(null);
      if (onClose) onClose();
    }, 2000);
  };

  const removeFile = (index) => {
    setFiles(prev => prev.filter((_, i) => i !== index));
  };

  const formatFileSize = (bytes) => {
    if (!bytes || bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
  };

  return (
    <div style={styles.modalOverlay} onClick={onClose}>
      <div style={styles.modal} onClick={(e) => e.stopPropagation()}>
        <button onClick={onClose} style={styles.closeBtn}>✕</button>
        <h3 style={styles.title}>📤 Drag & Drop Upload</h3>

        {/* Dropzone */}
        <div {...getRootProps()} style={{
          ...styles.dropzone,
          ...(isDragActive ? styles.dropzoneActive : {}),
          ...(uploadStatus === 'success' ? styles.dropzoneSuccess : {}),
        }}>
          <input {...getInputProps()} />
          {uploadStatus === 'success' ? (
            <div style={styles.successContent}>
              <FiCheckCircle size={48} color="#22c55e" />
              <p>Upload Complete!</p>
            </div>
          ) : (
            <>
              <FiUpload size={48} style={styles.dropIcon} />
              {isDragActive ? (
                <p style={styles.dropText}>Drop your files here...</p>
              ) : (
                <>
                  <p style={styles.dropText}>Drag & drop files here, or click to select</p>
                  <p style={styles.dropSubtext}>Supported: Images, PDFs, Documents, Videos, Audio</p>
                  <p style={styles.dropSubtext}>Max size: 10MB</p>
                </>
              )}
            </>
          )}
        </div>

        {/* File List */}
        {files.length > 0 && (
          <div style={styles.fileList}>
            <h4 style={styles.fileListTitle}>Files to upload ({files.length})</h4>
            {files.map((file, index) => (
              <div key={index} style={styles.fileItem}>
                <FiFile style={styles.fileItemIcon} />
                <span style={styles.fileItemName}>{file.name}</span>
                <span style={styles.fileItemSize}>{formatFileSize(file.size)}</span>
                <button onClick={() => removeFile(index)} style={styles.removeBtn}>
                  <FiX />
                </button>
              </div>
            ))}
          </div>
        )}

        {/* Progress Bar */}
        {uploading && (
          <div style={styles.progressContainer}>
            <div style={styles.progressBar}>
              <div style={{...styles.progressFill, width: `${progress}%`}} />
            </div>
            <span style={styles.progressText}>{progress}%</span>
          </div>
        )}

        {/* Actions */}
        <div style={styles.actionContainer}>
          <button
            onClick={() => {
              setFiles([]);
              if (onClose) onClose();
            }}
            style={styles.cancelBtn}
          >
            Cancel
          </button>
          <button
            onClick={handleUpload}
            disabled={files.length === 0 || uploading}
            style={{
              ...styles.uploadBtn,
              ...(files.length === 0 || uploading ? styles.uploadBtnDisabled : {})
            }}
          >
            {uploading ? 'Uploading...' : `Upload ${files.length} File${files.length > 1 ? 's' : ''}`}
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
    maxWidth: '550px',
    width: '90%',
    maxHeight: '80vh',
    overflow: 'auto',
    position: 'relative',
    boxShadow: '0 20px 60px rgba(0,0,0,0.3)',
  },
  closeBtn: {
    position: 'absolute',
    top: '12px',
    right: '16px',
    background: 'none',
    border: 'none',
    fontSize: '20px',
    cursor: 'pointer',
    color: '#888',
  },
  title: {
    marginTop: 0,
    marginBottom: '20px',
    fontSize: '20px',
    fontWeight: '600',
  },
  dropzone: {
    border: '2px dashed #ccc',
    borderRadius: '12px',
    padding: '40px',
    textAlign: 'center',
    cursor: 'pointer',
    transition: 'all 0.3s ease',
    minHeight: '180px',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
  },
  dropzoneActive: {
    borderColor: '#6366f1',
    backgroundColor: 'rgba(99, 102, 241, 0.05)',
  },
  dropzoneSuccess: {
    borderColor: '#22c55e',
    backgroundColor: 'rgba(34, 197, 94, 0.05)',
  },
  dropIcon: {
    color: '#6366f1',
    marginBottom: '10px',
  },
  dropText: {
    fontSize: '16px',
    color: '#333',
    margin: '8px 0',
  },
  dropSubtext: {
    fontSize: '13px',
    color: '#888',
    margin: '4px 0',
  },
  successContent: {
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    gap: '8px',
  },
  fileList: {
    marginTop: '16px',
    maxHeight: '200px',
    overflow: 'auto',
  },
  fileListTitle: {
    marginBottom: '8px',
    fontSize: '14px',
    color: '#666',
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
  fileItemIcon: { color: '#6366f1' },
  fileItemName: { flex: 1, fontSize: '14px', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' },
  fileItemSize: { fontSize: '12px', color: '#888' },
  removeBtn: {
    background: 'none',
    border: 'none',
    cursor: 'pointer',
    color: '#dc3545',
    padding: '4px',
  },
  progressContainer: {
    marginTop: '16px',
  },
  progressBar: {
    height: '8px',
    backgroundColor: '#e9ecef',
    borderRadius: '4px',
    overflow: 'hidden',
  },
  progressFill: {
    height: '100%',
    backgroundColor: '#6366f1',
    borderRadius: '4px',
    transition: 'width 0.3s ease',
  },
  progressText: {
    fontSize: '12px',
    color: '#888',
    marginTop: '4px',
    display: 'block',
    textAlign: 'center',
  },
  actionContainer: {
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
    fontSize: '14px',
  },
  uploadBtn: {
    flex: 2,
    padding: '12px',
    backgroundColor: '#6366f1',
    color: 'white',
    border: 'none',
    borderRadius: '8px',
    cursor: 'pointer',
    fontSize: '14px',
    fontWeight: '600',
  },
  uploadBtnDisabled: {
    backgroundColor: '#ccc',
    cursor: 'not-allowed',
  },
};

export default DragDropUpload;