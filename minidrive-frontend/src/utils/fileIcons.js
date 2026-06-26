export const getFileIcon = (fileName, fileType) => {
  const ext = fileName?.split('.').pop()?.toLowerCase() || '';
  
  const iconMap = {
    // Images
    jpg: '🖼️', jpeg: '🖼️', png: '🖼️', gif: '🖼️', svg: '🖼️', webp: '🖼️',
    // Documents
    pdf: '📄', doc: '📝', docx: '📝', xls: '📊', xlsx: '📊', ppt: '📽️', pptx: '📽️',
    // Code
    js: '💻', jsx: '💻', ts: '💻', tsx: '💻', py: '🐍', java: '☕', html: '🌐', css: '🎨',
    // Video
    mp4: '🎬', webm: '🎬', mov: '🎬', avi: '🎬',
    // Audio
    mp3: '🎵', wav: '🎵', flac: '🎵', aac: '🎵',
    // Archive
    zip: '📦', rar: '📦', '7z': '📦', tar: '📦', gz: '📦',
    // Text
    txt: '📃', log: '📃', csv: '📃',
  };
  
  return iconMap[ext] || '📄';
};