// import axios from 'axios';

// const API_BASE_URL = 'http://localhost:8080/api';

// const api = axios.create({
//   baseURL: API_BASE_URL,
//   headers: {
//     'Content-Type': 'application/json',
//   },
//   timeout: 10000,
// });

// // Add token to requests
// api.interceptors.request.use(
//   (config) => {
//     const token = localStorage.getItem('token');
//     if (token) {
//       config.headers.Authorization = `Bearer ${token}`;
//     }
//     console.log(`📤 ${config.method.toUpperCase()} ${config.url}`);
//     if (config.data) {
//       console.log('📦 Request Data:', config.data);
//     }
//     return config;
//   },
//   (error) => {
//     console.error('❌ Request Error:', error);
//     return Promise.reject(error);
//   }
// );

// // Response interceptor
// api.interceptors.response.use(
//   (response) => {
//     console.log(`📥 Response ${response.status}:`, response.data);
//     return response;
//   },
//   (error) => {
//     if (error.response) {
//       console.error(`❌ Response Error ${error.response.status}:`, error.response.data);
//     } else if (error.request) {
//       console.error('❌ No Response Received:', error.request);
//     } else {
//       console.error('❌ Error:', error.message);
//     }
//     return Promise.reject(error);
//   }
// );

// export const authAPI = {
//   register: (userData) => {
//     console.log('🔐 Registering user:', userData.username);
//     return api.post('/auth/register', userData);
//   },
//   login: (userData) => {
//     console.log('🔐 Logging in user:', userData.username);
//     return api.post('/auth/login', userData);
//   },
// };

// export const fileAPI = {
//   upload: (file) => {
//     const formData = new FormData();
//     formData.append('file', file);
//     return api.post('/files/upload', formData, {
//       headers: { 'Content-Type': 'multipart/form-data' },
//     });
//   },
//   getMyFiles: () => api.get('/files/my-files'),
//   download: (fileId) => api.get(`/files/download/${fileId}`, {
//     responseType: 'blob',
//   }),
//   createShareLink: (fileId) => api.post(`/files/share/${fileId}`),
//   deleteFile: (fileId) => api.delete(`/files/${fileId}`),
// };

// export default api;



// import axios from 'axios';

// const API_BASE_URL = 'http://localhost:8080/api';

// const api = axios.create({
//   baseURL: API_BASE_URL,
//   headers: {
//     'Content-Type': 'application/json',
//     'Accept': 'application/json',
//   },
// });

// // Track if token is being refreshed
// let isRefreshing = false;
// let failedQueue = [];

// const processQueue = (error, token = null) => {
//   failedQueue.forEach(prom => {
//     if (error) {
//       prom.reject(error);
//     } else {
//       prom.resolve(token);
//     }
//   });
//   failedQueue = [];
// };

// // Add token to requests
// api.interceptors.request.use(
//   (config) => {
//     const token = localStorage.getItem('token');
//     if (token) {
//       config.headers.Authorization = `Bearer ${token}`;
//     }
//     // Log outgoing request for debugging
//     try {
//       const method = (config.method || '').toUpperCase();
//       const url = (config.baseURL || '') + (config.url || '');
//       console.log(`📤 ${method} ${url}`, config.params ?? config.data ?? {});
//     } catch (e) {
//       console.debug('Request log error', e);
//     }
//     return config;
//   },
//   (error) => Promise.reject(error)
// );

// // Handle 403/401 errors - Auto logout
// api.interceptors.response.use(
//   (response) => {
//     try {
//       console.log(`📥 Response ${response.status} ${response.config.url}`, response.data);
//     } catch (e) {
//       console.debug('Response log error', e);
//     }
//     return response;
//   },
//   async (error) => {
//     const originalRequest = error.config || {};

//     // Log error details to help debugging 400 responses
//     if (error.response) {
//       console.error(`❌ Response Error ${error.response.status} ${originalRequest.url || originalRequest.path || ''}:`, error.response.data);
//     } else if (error.request) {
//       console.error('❌ No response received:', error.request);
//     } else {
//       console.error('❌ Axios error:', error.message);
//     }

//     // If 403/401 and not already retried -> logout
//     if ((error.response?.status === 403 || error.response?.status === 401) && !originalRequest._retry) {
//       originalRequest._retry = true;
//       console.log('Token expired or invalid. Logging out...');
//       localStorage.removeItem('token');
//       localStorage.removeItem('username');
//       window.location.href = '/login';
//       return Promise.reject(error);
//     }

//     return Promise.reject(error);
//   }
// );

// // Auth APIs
// export const authAPI = {
//   register: (userData) => api.post('/auth/register', userData),
//   login: (userData) => api.post('/auth/login', userData),
// };

// // File APIs
// export const fileAPI = {
//   upload: (file) => {
//     const formData = new FormData();
//     formData.append('file', file);
//     return api.post('/files/upload', formData, {
//       headers: { 'Content-Type': 'multipart/form-data' },
//     });
//   },
//   getMyFiles: () => api.get('/files/my-files'),
//   download: (fileId) => api.get(`/files/download/${fileId}`, {
//     responseType: 'blob',
//   }),
//   createShareLink: (fileId) => api.post(`/files/share/${fileId}`),
//   deleteFile: (fileId) => api.delete(`/files/${fileId}`),
// };

// export default api;

import axios from 'axios';

const API_BASE_URL = 'http://localhost:8080/api';

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Add token to every request automatically
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

// Handle 403/401 errors - Auto logout
api.interceptors.response.use(
  (response) => response,
  async (error) => {
    if ((error.response?.status === 403 || error.response?.status === 401) && !error.config._retry) {
      error.config._retry = true;
      console.log('Token expired or invalid. Logging out...');
      localStorage.removeItem('token');
      localStorage.removeItem('username');
      window.location.href = '/login';
      return Promise.reject(error);
    }
    return Promise.reject(error);
  }
);

// Auth APIs
export const authAPI = {
  register: (userData) => api.post('/auth/register', userData),
  login: (userData) => api.post('/auth/login', userData),
};

// File APIs
export const fileAPI = {
  upload: (file) => {
    const formData = new FormData();
    formData.append('file', file);
    return api.post('/files/upload', formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
  },
  // NEW: Upload to specific folder
  uploadToFolder: (file, folderName) => {
    const formData = new FormData();
    formData.append('file', file);
    return api.post(`/files/upload/${folderName}`, formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
  },
  getMyFiles: () => api.get('/files/my-files'),
  download: (fileId) => api.get(`/files/download/${fileId}`, {
    responseType: 'blob',
  }),
  createShareLink: (fileId) => api.post(`/files/share/${fileId}`),
  deleteFile: (fileId) => api.delete(`/files/${fileId}`),
  
  // NEW: Folder APIs
  createFolder: (folderName) => api.post('/files/folder', { folderName }),
  getAllItems: () => api.get('/files/all-items'),
  getItemsByFolder: (folderName) => api.get(`/files/folder/${folderName}`),
  moveFileToFolder: (fileId, folderName) => api.put(`/files/move/${fileId}`, { folderName }),
  renameFolder: (oldName, newName) => api.put('/files/rename-folder', { oldName, newName }),
  deleteFolder: (folderName) => api.delete(`/files/folder/${folderName}`),
};

// Search APIs
export const searchAPI = {
  search: (params) => api.get('/search/advanced', { params }),
  searchByName: (keyword) => api.get('/search/by-name', { params: { keyword } }),
  searchByType: (fileType) => api.get('/search/by-type', { params: { fileType } }),
};

// Share APIs
export const shareAPI = {
  validate: (token, data = {}) => api.post(`/share/validate/${token}`, data),
  revoke: (token) => api.post(`/share/revoke/${token}`),
  getMyLinks: () => api.get('/share/my-links'),
  update: (token, data) => api.put(`/share/update/${token}`, data),
};

export default api;