import React, { useState, useEffect } from 'react';
import { FiX, FiDownload, FiShare2, FiFile, FiImage, FiVideo, FiMusic, FiCode, FiFileText } from 'react-icons/fi';
import { Document, Page } from 'react-pdf';
import { pdfjs } from 'react-pdf';
import ReactPlayer from 'react-player';
import SyntaxHighlighter from 'react-syntax-highlighter';
import { vs2015 } from 'react-syntax-highlighter/dist/esm/styles/hljs';
import api from '../services/api';

pdfjs.GlobalWorkerOptions.workerSrc = `//cdnjs.cloudflare.com/ajax/libs/pdf.js/${pdfjs.version}/pdf.worker.min.js`;

function FilePreview({ file, onClose, onDownload, onShare }) {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [fileContent, setFileContent] = useState(null);
  const [numPages, setNumPages] = useState(null);
  const [pageNumber, setPageNumber] = useState(1);
  const [isPlaying, setIsPlaying] = useState(false);
  const [imageUrl, setImageUrl] = useState('');

  const getFileTypeName = (fileName, fileType) => {
    if (!fileName) return 'unknown';
    const ext = fileName.split('.').pop().toLowerCase();
    const imageTypes = ['jpg', 'jpeg', 'png', 'gif', 'svg', 'webp', 'bmp', 'ico'];
    const videoTypes = ['mp4', 'webm', 'ogg', 'mov', 'avi', 'mkv'];
    const audioTypes = ['mp3', 'wav', 'ogg', 'flac', 'aac', 'm4a'];
    const documentTypes = ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx'];
    const codeTypes = ['js', 'jsx', 'ts', 'tsx', 'py', 'java', 'c', 'cpp', 'h', 'cs', 'php', 'rb', 'go', 'rs', 'swift', 'kt', 'html', 'css', 'scss', 'less', 'json', 'xml', 'yaml', 'yml', 'sh', 'bash', 'sql', 'md'];
    const textTypes = ['txt', 'log', 'csv', 'tsv'];

    if (imageTypes.includes(ext)) return 'image';
    if (videoTypes.includes(ext)) return 'video';
    if (audioTypes.includes(ext)) return 'audio';
    if (documentTypes.includes(ext)) return 'document';
    if (codeTypes.includes(ext)) return 'code';
    if (textTypes.includes(ext)) return 'text';
    if (ext === 'pdf') return 'pdf';
    return 'unknown';
  };

  const fileType = getFileTypeName(file.fileName, file.fileType);

  // Load image with authentication
  useEffect(() => {
    if (fileType === 'image') {
      // Create authenticated URL
      const token = localStorage.getItem('token');
      const url = `http://localhost:8080/api/files/download/${file.id}`;
      const headers = new Headers();
      if (token) {
        headers.append('Authorization', `Bearer ${token}`);
      }
      
      fetch(url, { headers })
        .then(response => {
          if (!response.ok) throw new Error('Failed to load image');
          return response.blob();
        })
        .then(blob => {
          const objectUrl = URL.createObjectURL(blob);
          setImageUrl(objectUrl);
          setLoading(false);
        })
        .catch(err => {
          console.error('Image load error:', err);
          setError('Failed to load image');
          setLoading(false);
        });
    } else {
      setLoading(false);
    }
  }, [file.id, fileType]);

  // Load file content for text/code preview
  useEffect(() => {
    const loadFileContent = async () => {
      if (fileType === 'code' || fileType === 'text') {
        try {
          const response = await api.get(`/files/download/${file.id}`, {
            responseType: 'blob',
          });
          const text = await response.data.text();
          setFileContent(text);
        } catch (error) {
          console.error('Failed to load file content:', error);
          setError('Failed to load file content');
        }
      }
    };
    loadFileContent();
  }, [file.id, fileType]);

  const getLanguage = (fileName) => {
    const ext = fileName.split('.').pop().toLowerCase();
    const languageMap = {
      js: 'javascript', jsx: 'javascript', ts: 'typescript', tsx: 'typescript',
      py: 'python', java: 'java', c: 'c', cpp: 'cpp', cs: 'csharp',
      php: 'php', rb: 'ruby', go: 'go', rs: 'rust', swift: 'swift',
      kt: 'kotlin', html: 'html', css: 'css', scss: 'scss',
      json: 'json', xml: 'xml', yaml: 'yaml', yml: 'yaml',
      sh: 'bash', bash: 'bash', sql: 'sql', md: 'markdown'
    };
    return languageMap[ext] || 'text';
  };

  const formatFileSize = (bytes) => {
    if (!bytes || bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
  };

  const getFileIcon = () => {
    const icons = {
      image: <FiImage size={32} />,
      video: <FiVideo size={32} />,
      audio: <FiMusic size={32} />,
      code: <FiCode size={32} />,
      text: <FiFileText size={32} />,
      document: <FiFile size={32} />,
      pdf: <FiFile size={32} />,
    };
    return icons[fileType] || <FiFile size={32} />;
  };

  const renderPreview = () => {
    if (loading) {
      return (
        <div style={styles.loadingContainer}>
          <div style={styles.spinner}>⏳</div>
          <p>Loading preview...</p>
        </div>
      );
    }

    if (error) {
      return (
        <div style={styles.errorContainer}>
          <p>❌ {error}</p>
        </div>
      );
    }

    const ext = file.fileName.split('.').pop().toLowerCase();

    if (fileType === 'image') {
      return (
        <div style={styles.imageContainer}>
          {imageUrl ? (
            <img src={imageUrl} alt={file.fileName} style={styles.image} />
          ) : (
            <p>Loading image...</p>
          )}
        </div>
      );
    }

    if (fileType === 'video') {
      return (
        <div style={styles.videoContainer}>
          <ReactPlayer
            url={`http://localhost:8080/api/files/download/${file.id}`}
            controls
            width="100%"
            height="100%"
            playing={isPlaying}
            onPlay={() => setIsPlaying(true)}
            onPause={() => setIsPlaying(false)}
          />
        </div>
      );
    }

    if (fileType === 'audio') {
      return (
        <div style={styles.audioContainer}>
          <div style={styles.audioIcon}>🎵</div>
          <p style={styles.audioName}>{file.fileName}</p>
          <ReactPlayer
            url={`http://localhost:8080/api/files/download/${file.id}`}
            controls
            width="100%"
            height="60px"
            playing={isPlaying}
            onPlay={() => setIsPlaying(true)}
            onPause={() => setIsPlaying(false)}
          />
        </div>
      );
    }

    if (fileType === 'pdf' || ext === 'pdf') {
      return (
        <div style={styles.pdfContainer}>
          <Document
            file={`http://localhost:8080/api/files/download/${file.id}`}
            onLoadSuccess={({ numPages }) => setNumPages(numPages)}
            onLoadError={() => setError('Failed to load PDF')}
            loading={<div style={styles.loadingText}>Loading PDF...</div>}
          >
            <Page pageNumber={pageNumber} />
          </Document>
          {numPages > 1 && (
            <div style={styles.pdfControls}>
              <button onClick={() => setPageNumber(Math.max(1, pageNumber - 1))} disabled={pageNumber <= 1} style={styles.pdfButton}>◀ Previous</button>
              <span style={styles.pdfPageInfo}>Page {pageNumber} of {numPages}</span>
              <button onClick={() => setPageNumber(Math.min(numPages, pageNumber + 1))} disabled={pageNumber >= numPages} style={styles.pdfButton}>Next ▶</button>
            </div>
          )}
        </div>
      );
    }

    if (fileType === 'code') {
      const language = getLanguage(file.fileName);
      return (
        <div style={styles.codeContainer}>
          <div style={styles.codeHeader}>
            <span>💻 {file.fileName}</span>
            <span style={styles.codeLang}>{language}</span>
          </div>
          <SyntaxHighlighter language={language} style={vs2015} showLineNumbers wrapLines customStyle={styles.codeBlock}>
            {fileContent || '// No content to display'}
          </SyntaxHighlighter>
        </div>
      );
    }

    if (fileType === 'text') {
      return (
        <div style={styles.textContainer}>
          <div style={styles.textHeader}>📄 {file.fileName}</div>
          <pre style={styles.textContent}>{fileContent || 'No content to display'}</pre>
        </div>
      );
    }

    return (
      <div style={styles.unsupportedContainer}>
        <div style={styles.unsupportedIcon}>📄</div>
        <p style={styles.unsupportedText}>Preview not available for this file type</p>
        <p style={styles.unsupportedSubtext}>File: {file.fileName} ({file.fileType || 'unknown'})</p>
        <p style={styles.unsupportedHint}>Click Download to view the file locally</p>
      </div>
    );
  };

  return (
    <div style={styles.modalOverlay} onClick={onClose}>
      <div style={styles.modal} onClick={(e) => e.stopPropagation()}>
        <div style={styles.header}>
          <div style={styles.fileInfo}>
            <span style={styles.fileIcon}>{getFileIcon()}</span>
            <div>
              <h3 style={styles.fileName}>{file.fileName}</h3>
              <p style={styles.fileMeta}>
                {formatFileSize(file.fileSize)} • {file.uploadedAt ? new Date(file.uploadedAt).toLocaleDateString() : 'Unknown date'}
              </p>
            </div>
          </div>
          <div style={styles.headerActions}>
            <button onClick={() => onDownload(file.id, file.fileName)} style={styles.downloadBtn} title="Download"><FiDownload /> Download</button>
            <button onClick={() => onShare(file.id)} style={styles.shareBtn} title="Share"><FiShare2 /> Share</button>
            <button onClick={onClose} style={styles.closeBtn}>✕</button>
          </div>
        </div>
        <div style={styles.content}>{renderPreview()}</div>
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
    backgroundColor: 'rgba(0,0,0,0.7)',
    display: 'flex',
    justifyContent: 'center',
    alignItems: 'center',
    zIndex: 10000,
    padding: '20px',
  },
  modal: {
    backgroundColor: 'white',
    borderRadius: '12px',
    width: '90%',
    maxWidth: '1200px',
    maxHeight: '90vh',
    display: 'flex',
    flexDirection: 'column',
    overflow: 'hidden',
    boxShadow: '0 20px 60px rgba(0,0,0,0.3)',
  },
  header: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: '16px 24px',
    borderBottom: '1px solid #eee',
    flexWrap: 'wrap',
    gap: '10px',
  },
  fileInfo: { display: 'flex', alignItems: 'center', gap: '12px' },
  fileIcon: { fontSize: '28px' },
  fileName: { margin: 0, fontSize: '18px', fontWeight: '600' },
  fileMeta: { margin: '4px 0 0', fontSize: '13px', color: '#888' },
  headerActions: { display: 'flex', alignItems: 'center', gap: '10px' },
  downloadBtn: { backgroundColor: '#28a745', color: 'white', border: 'none', padding: '8px 16px', borderRadius: '6px', cursor: 'pointer', display: 'flex', alignItems: 'center', gap: '6px', fontSize: '14px' },
  shareBtn: { backgroundColor: '#17a2b8', color: 'white', border: 'none', padding: '8px 16px', borderRadius: '6px', cursor: 'pointer', display: 'flex', alignItems: 'center', gap: '6px', fontSize: '14px' },
  closeBtn: { backgroundColor: '#dc3545', color: 'white', border: 'none', padding: '8px 16px', borderRadius: '6px', cursor: 'pointer', fontSize: '16px' },
  content: { flex: 1, padding: '20px', overflow: 'auto', display: 'flex', justifyContent: 'center', alignItems: 'center', minHeight: '400px', backgroundColor: '#f8f9fa' },
  imageContainer: { display: 'flex', justifyContent: 'center', alignItems: 'center', width: '100%', height: '100%' },
  image: { maxWidth: '100%', maxHeight: '70vh', objectFit: 'contain', borderRadius: '4px' },
  videoContainer: { width: '100%', height: '500px', maxHeight: '70vh' },
  audioContainer: { textAlign: 'center', width: '100%', padding: '40px 20px' },
  audioIcon: { fontSize: '64px', marginBottom: '10px' },
  audioName: { fontSize: '18px', fontWeight: '600', marginBottom: '20px' },
  pdfContainer: { width: '100%', display: 'flex', flexDirection: 'column', alignItems: 'center' },
  pdfControls: { display: 'flex', alignItems: 'center', gap: '20px', marginTop: '15px', padding: '10px', backgroundColor: '#f0f0f0', borderRadius: '8px' },
  pdfButton: { padding: '6px 16px', border: '1px solid #ddd', borderRadius: '4px', backgroundColor: 'white', cursor: 'pointer' },
  pdfPageInfo: { fontSize: '14px', color: '#666' },
  codeContainer: { width: '100%', maxHeight: '70vh', overflow: 'auto', borderRadius: '8px', backgroundColor: '#1e1e1e' },
  codeHeader: { display: 'flex', justifyContent: 'space-between', padding: '10px 16px', backgroundColor: '#2d2d2d', color: '#e0e0e0', fontSize: '14px', borderTopLeftRadius: '8px', borderTopRightRadius: '8px' },
  codeLang: { color: '#888', fontSize: '12px' },
  codeBlock: { margin: 0, padding: '16px', fontSize: '14px', lineHeight: '1.6' },
  textContainer: { width: '100%', maxHeight: '70vh', overflow: 'auto', backgroundColor: 'white', borderRadius: '8px', border: '1px solid #ddd' },
  textHeader: { padding: '10px 16px', backgroundColor: '#f5f5f5', borderBottom: '1px solid #ddd', fontSize: '14px', fontWeight: '600' },
  textContent: { padding: '16px', margin: 0, fontSize: '14px', lineHeight: '1.6', whiteSpace: 'pre-wrap', wordWrap: 'break-word', maxHeight: '60vh', overflow: 'auto', fontFamily: 'monospace' },
  unsupportedContainer: { textAlign: 'center', padding: '40px' },
  unsupportedIcon: { fontSize: '48px', marginBottom: '10px' },
  unsupportedText: { fontSize: '18px', color: '#666' },
  unsupportedSubtext: { fontSize: '14px', color: '#999', marginTop: '10px' },
  unsupportedHint: { fontSize: '14px', color: '#888', marginTop: '20px' },
  loadingContainer: { textAlign: 'center', padding: '40px' },
  loadingText: { textAlign: 'center', padding: '20px', color: '#666' },
  errorContainer: { textAlign: 'center', padding: '40px', color: '#dc3545' },
  spinner: { fontSize: '40px', animation: 'spin 1s linear infinite', marginBottom: '20px' },
};

const styleSheet = document.createElement("style");
styleSheet.textContent = `@keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }`;
document.head.appendChild(styleSheet);

export default FilePreview;