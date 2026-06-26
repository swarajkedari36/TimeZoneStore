import React from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { ThemeProvider } from './context/ThemeContext';
import ToastContainer from './components/Toast';
import './styles/globals.css';
import './styles/animations.css';
import Login from './pages/Login';
import Dashboard from './pages/Dashboard';
import ShareView from './pages/ShareView';
import Profile from './pages/Profile';
import Analytics from './pages/Analytics';

function App() {
  const token = localStorage.getItem('token');

  return (
    <ThemeProvider>
      <BrowserRouter>
        <ToastContainer />
        <Routes>
          <Route path="/login" element={<Login />} />
          <Route path="/share/:token" element={<ShareView />} />
          <Route
            path="/dashboard"
            element={token ? <Dashboard /> : <Navigate to="/login" />}
          />
          <Route
            path="/analytics"
            element={token ? <Analytics /> : <Navigate to="/login" />}
          />
          <Route
            path="/profile"
            element={token ? <Profile /> : <Navigate to="/login" />}
          />
          <Route path="/" element={<Navigate to="/dashboard" />} />
        </Routes>
      </BrowserRouter>
    </ThemeProvider>
  );
}

export default App;