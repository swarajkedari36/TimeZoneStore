// import React, { useState } from 'react';
// import { useNavigate, useLocation } from 'react-router-dom';
// import { FiLogOut, FiUser, FiBarChart2, FiHome, FiSun, FiMoon, FiSearch, FiBell, FiSettings } from 'react-icons/fi';
// import { useTheme } from '../context/ThemeContext';
// import Tooltip from './Tooltip';

// function Navbar({ onSearch, searchQuery, setSearchQuery }) {
//   const navigate = useNavigate();
//   const location = useLocation();
//   const { darkMode, toggleDarkMode } = useTheme();
//   const username = localStorage.getItem('username');
//   const [showNotifications, setShowNotifications] = useState(false);
//   const [showUserMenu, setShowUserMenu] = useState(false);

//   const handleLogout = () => {
//     localStorage.removeItem('token');
//     localStorage.removeItem('username');
//     navigate('/login');
//   };

//   const isActive = (path) => location.pathname === path;

//   const handleSearch = (e) => {
//     e.preventDefault();
//     if (onSearch && searchQuery) {
//       onSearch(searchQuery);
//     }
//   };

//   // Mock notifications
//   const notifications = [
//     { id: 1, message: 'File "report.pdf" was downloaded', time: '2 min ago' },
//     { id: 2, message: 'New share link created for "photo.jpg"', time: '15 min ago' },
//     { id: 3, message: 'Storage is 85% full', time: '1 hour ago' },
//   ];

//   return (
//     <nav style={{...styles.navbar, ...(darkMode ? styles.navbarDark : {})}}>
//       <div style={styles.navContent}>
//         {/* Logo */}
//         <div style={styles.logo} onClick={() => navigate('/dashboard')}>
//           <span style={styles.logoIcon}>📁</span>
//           <span style={styles.logoText}>Mini Drive</span>
//         </div>

//         {/* Search Bar */}
//         {onSearch && (
//           <form onSubmit={handleSearch} style={styles.searchForm}>
//             <div style={{...styles.searchWrapper, ...(darkMode ? styles.searchWrapperDark : {})}}>
//               <FiSearch style={{...styles.searchIcon, ...(darkMode ? styles.searchIconDark : {})}} />
//               <input
//                 type="text"
//                 placeholder="Search files..."
//                 value={searchQuery || ''}
//                 onChange={(e) => setSearchQuery && setSearchQuery(e.target.value)}
//                 style={{...styles.searchInput, ...(darkMode ? styles.searchInputDark : {})}}
//               />
//             </div>
//           </form>
//         )}

//         {/* Navigation Links */}
//         <div style={styles.navLinks}>
//           <Tooltip text="Dashboard" position="bottom">
//             <button
//               onClick={() => navigate('/dashboard')}
//               style={{
//                 ...styles.navBtn,
//                 ...(isActive('/dashboard') ? styles.activeNavBtn : {}),
//                 ...(darkMode ? styles.navBtnDark : {})
//               }}
//             >
//               <FiHome /> Dashboard
//             </button>
//           </Tooltip>

//           <Tooltip text="Analytics" position="bottom">
//             <button
//               onClick={() => navigate('/analytics')}
//               style={{
//                 ...styles.navBtn,
//                 ...(isActive('/analytics') ? styles.activeNavBtn : {}),
//                 ...(darkMode ? styles.navBtnDark : {})
//               }}
//             >
//               <FiBarChart2 /> Analytics
//             </button>
//           </Tooltip>

//           {/* Profile Button - Direct link */}
//           <Tooltip text="Profile & Settings" position="bottom">
//             <button
//               onClick={() => {
//                 console.log('🔵 Navigating to profile...');
//                 navigate('/profile');
//               }}
//               style={{
//                 ...styles.navBtn,
//                 ...(isActive('/profile') ? styles.activeNavBtn : {}),
//                 ...(darkMode ? styles.navBtnDark : {})
//               }}
//             >
//               <FiUser /> Profile
//             </button>
//           </Tooltip>

//           {/* Notification Bell */}
//           <div style={styles.notificationWrapper}>
//             <Tooltip text="Notifications" position="bottom">
//               <button
//                 onClick={() => setShowNotifications(!showNotifications)}
//                 style={{...styles.iconBtn, ...(darkMode ? styles.iconBtnDark : {})}}
//               >
//                 <FiBell size={20} />
//                 {notifications.length > 0 && (
//                   <span style={styles.notificationDot}>{notifications.length}</span>
//                 )}
//               </button>
//             </Tooltip>
            
//             {showNotifications && (
//               <div style={{...styles.notificationDropdown, ...(darkMode ? styles.notificationDropdownDark : {})}}>
//                 <div style={styles.notificationHeader}>
//                   <span>Notifications</span>
//                   <button onClick={() => setShowNotifications(false)} style={styles.closeDropdown}>✕</button>
//                 </div>
//                 {notifications.length === 0 ? (
//                   <p style={styles.noNotifications}>No notifications</p>
//                 ) : (
//                   notifications.map(notif => (
//                     <div key={notif.id} style={{...styles.notificationItem, ...(darkMode ? styles.notificationItemDark : {})}}>
//                       <p style={styles.notificationMessage}>{notif.message}</p>
//                       <span style={styles.notificationTime}>{notif.time}</span>
//                     </div>
//                   ))
//                 )}
//               </div>
//             )}
//           </div>

//           {/* Dark Mode Toggle */}
//           <Tooltip text={darkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode'} position="bottom">
//             <button
//               onClick={toggleDarkMode}
//               style={{...styles.iconBtn, ...(darkMode ? styles.iconBtnDark : {})}}
//             >
//               {darkMode ? <FiSun size={20} /> : <FiMoon size={20} />}
//             </button>
//           </Tooltip>

//           {/* User Menu - Clicking username opens dropdown */}
//           <div style={styles.userMenuWrapper}>
//             <button
//               onClick={() => setShowUserMenu(!showUserMenu)}
//               style={{...styles.userMenuBtn, ...(darkMode ? styles.userMenuBtnDark : {})}}
//             >
//               <FiUser size={18} />
//               <span style={{...(darkMode ? styles.userTextDark : {})}}>{username || 'User'}</span>
//               <span style={styles.dropdownArrow}>▼</span>
//             </button>
            
//             {showUserMenu && (
//               <div style={{...styles.userDropdown, ...(darkMode ? styles.userDropdownDark : {})}}>
//                 <button 
//                   onClick={() => { 
//                     console.log('🔵 Navigating to profile from dropdown...');
//                     setShowUserMenu(false); 
//                     navigate('/profile'); 
//                   }} 
//                   style={styles.dropdownItem}
//                 >
//                   <FiUser /> Profile
//                 </button>
//                 <button 
//                   onClick={() => { 
//                     setShowUserMenu(false); 
//                     navigate('/dashboard'); 
//                   }} 
//                   style={styles.dropdownItem}
//                 >
//                   <FiHome /> Dashboard
//                 </button>
//                 <button 
//                   onClick={() => { 
//                     setShowUserMenu(false); 
//                     navigate('/analytics'); 
//                   }} 
//                   style={styles.dropdownItem}
//                 >
//                   <FiBarChart2 /> Analytics
//                 </button>
//                 <div style={styles.dropdownDivider} />
//                 <button 
//                   onClick={() => { 
//                     setShowUserMenu(false); 
//                     handleLogout(); 
//                   }} 
//                   style={{...styles.dropdownItem, ...styles.dropdownItemDanger}}
//                 >
//                   <FiLogOut /> Logout
//                 </button>
//               </div>
//             )}
//           </div>
//         </div>
//       </div>
//     </nav>
//   );
// }

// const styles = {
//   navbar: {
//     backgroundColor: '#6366f1',
//     color: 'white',
//     padding: '10px 24px',
//     boxShadow: '0 4px 20px rgba(99, 102, 241, 0.3)',
//     position: 'sticky',
//     top: 0,
//     zIndex: 1000,
//     transition: 'all 0.3s ease',
//   },
//   navbarDark: {
//     backgroundColor: '#1f2937',
//     boxShadow: '0 4px 20px rgba(0, 0, 0, 0.5)',
//   },
//   navContent: {
//     maxWidth: '1400px',
//     margin: '0 auto',
//     display: 'flex',
//     alignItems: 'center',
//     gap: '20px',
//     flexWrap: 'wrap',
//   },
//   logo: {
//     display: 'flex',
//     alignItems: 'center',
//     gap: '8px',
//     cursor: 'pointer',
//     fontSize: '20px',
//     fontWeight: '700',
//     fontFamily: 'Poppins, sans-serif',
//   },
//   logoIcon: { fontSize: '24px' },
//   logoText: { color: 'white' },
//   searchForm: {
//     flex: 1,
//     minWidth: '150px',
//     maxWidth: '400px',
//   },
//   searchWrapper: {
//     display: 'flex',
//     alignItems: 'center',
//     backgroundColor: 'rgba(255,255,255,0.15)',
//     borderRadius: '10px',
//     padding: '6px 14px',
//     transition: 'all 0.3s ease',
//   },
//   searchWrapperDark: {
//     backgroundColor: 'rgba(255,255,255,0.08)',
//   },
//   searchIcon: {
//     color: 'rgba(255,255,255,0.7)',
//     marginRight: '10px',
//   },
//   searchIconDark: {
//     color: 'rgba(255,255,255,0.5)',
//   },
//   searchInput: {
//     flex: 1,
//     background: 'transparent',
//     border: 'none',
//     padding: '8px 0',
//     color: 'white',
//     fontSize: '14px',
//     outline: 'none',
//   },
//   searchInputDark: {
//     color: '#e5e7eb',
//   },
//   navLinks: {
//     display: 'flex',
//     alignItems: 'center',
//     gap: '8px',
//     flexWrap: 'wrap',
//   },
//   navBtn: {
//     backgroundColor: 'transparent',
//     color: 'white',
//     border: 'none',
//     padding: '8px 14px',
//     borderRadius: '8px',
//     cursor: 'pointer',
//     fontSize: '14px',
//     display: 'flex',
//     alignItems: 'center',
//     gap: '6px',
//     transition: 'all 0.2s ease',
//   },
//   navBtnDark: {
//     color: '#d1d5db',
//   },
//   activeNavBtn: {
//     backgroundColor: 'rgba(255,255,255,0.2)',
//     fontWeight: '600',
//   },
//   iconBtn: {
//     backgroundColor: 'transparent',
//     color: 'white',
//     border: 'none',
//     padding: '8px',
//     borderRadius: '8px',
//     cursor: 'pointer',
//     fontSize: '18px',
//     display: 'flex',
//     alignItems: 'center',
//     justifyContent: 'center',
//     position: 'relative',
//     transition: 'all 0.2s ease',
//   },
//   iconBtnDark: {
//     color: '#d1d5db',
//   },
//   notificationWrapper: {
//     position: 'relative',
//   },
//   notificationDot: {
//     position: 'absolute',
//     top: '2px',
//     right: '2px',
//     backgroundColor: '#ef4444',
//     color: 'white',
//     fontSize: '10px',
//     fontWeight: '700',
//     borderRadius: '50%',
//     width: '18px',
//     height: '18px',
//     display: 'flex',
//     alignItems: 'center',
//     justifyContent: 'center',
//   },
//   notificationDropdown: {
//     position: 'absolute',
//     top: 'calc(100% + 8px)',
//     right: '0',
//     backgroundColor: 'white',
//     borderRadius: '12px',
//     boxShadow: '0 10px 40px rgba(0,0,0,0.15)',
//     minWidth: '300px',
//     maxWidth: '350px',
//     maxHeight: '400px',
//     overflow: 'auto',
//     padding: '8px 0',
//     zIndex: 1001,
//   },
//   notificationDropdownDark: {
//     backgroundColor: '#1f2937',
//     boxShadow: '0 10px 40px rgba(0,0,0,0.4)',
//   },
//   notificationHeader: {
//     display: 'flex',
//     justifyContent: 'space-between',
//     alignItems: 'center',
//     padding: '12px 16px',
//     borderBottom: '1px solid #e5e7eb',
//     fontWeight: '600',
//     fontSize: '14px',
//   },
//   closeDropdown: {
//     background: 'none',
//     border: 'none',
//     cursor: 'pointer',
//     color: '#888',
//     fontSize: '16px',
//   },
//   noNotifications: {
//     padding: '20px',
//     textAlign: 'center',
//     color: '#888',
//     fontSize: '14px',
//   },
//   notificationItem: {
//     padding: '12px 16px',
//     borderBottom: '1px solid #f3f4f6',
//     cursor: 'pointer',
//     transition: 'background 0.2s ease',
//   },
//   notificationItemDark: {
//     borderBottom: '1px solid #374151',
//   },
//   notificationMessage: {
//     margin: 0,
//     fontSize: '13px',
//     color: '#333',
//   },
//   notificationTime: {
//     fontSize: '11px',
//     color: '#888',
//     display: 'block',
//     marginTop: '4px',
//   },
//   userMenuWrapper: {
//     position: 'relative',
//     marginLeft: 'auto',
//   },
//   userMenuBtn: {
//     display: 'flex',
//     alignItems: 'center',
//     gap: '18px',
//     backgroundColor: 'rgba(255,255,255,0.12)',
//     border: 'none',
//     borderRadius: '8px',
//     padding: '6px 12px',
//     cursor: 'pointer',
//     color: 'white',
//     fontSize: '14px',
//     transition: 'all 0.2s ease',
//   },
//   userMenuBtnDark: {
//     backgroundColor: 'rgba(255,255,255,0.06)',
//   },
//   dropdownArrow: {
//     fontSize: '10px',
//     opacity: 0.7,
//   },
//   userDropdown: {
//     position: 'absolute',
//     top: 'calc(100% + 8px)',
//     right: '0',
//     backgroundColor: 'white',
//     borderRadius: '12px',
//     boxShadow: '0 10px 40px rgba(0,0,0,0.15)',
//     minWidth: '180px',
//     padding: '8px 0',
//     zIndex: 1001,
//   },
//   userDropdownDark: {
//     backgroundColor: '#1f2937',
//     boxShadow: '0 10px 40px rgba(0,0,0,0.4)',
//   },
//   dropdownItem: {
//     display: 'flex',
//     alignItems: 'center',
//     gap: '10px',
//     padding: '10px 16px',
//     width: '100%',
//     border: 'none',
//     backgroundColor: 'transparent',
//     cursor: 'pointer',
//     fontSize: '14px',
//     color: '#1f2937',
//     transition: 'background 0.2s ease',
//   },
//   dropdownItemDanger: {
//     color: '#dc2626',
//   },
//   dropdownDivider: {
//     height: '1px',
//     backgroundColor: '#e5e7eb',
//     margin: '4px 0',
//   },
//   userTextDark: {
//     color: '#d1d5db',
//   },
//   logoutBtn: {
//     backgroundColor: '#ef4444',
//     color: 'white',
//     border: 'none',
//     padding: '8px 16px',
//     borderRadius: '8px',
//     cursor: 'pointer',
//     fontSize: '14px',
//     display: 'flex',
//     alignItems: 'center',
//     gap: '6px',
//     transition: 'background 0.2s ease',
//   },
// };

// export default Navbar;


import React, { useState } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { FiLogOut, FiUser, FiBarChart2, FiHome, FiSun, FiMoon, FiSearch, FiBell } from 'react-icons/fi';
import { useTheme } from '../context/ThemeContext';
import Tooltip from './Tooltip';

function Navbar({ onSearch, searchQuery, setSearchQuery }) {
  const navigate = useNavigate();
  const location = useLocation();
  const { darkMode, toggleDarkMode } = useTheme();
  const username = localStorage.getItem('username');
  const [showNotifications, setShowNotifications] = useState(false);
  const [showUserMenu, setShowUserMenu] = useState(false);

  const handleLogout = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('username');
    navigate('/login');
  };

  const isActive = (path) => location.pathname === path;

  const handleSearch = (e) => {
    e.preventDefault();
    if (onSearch && searchQuery) {
      onSearch(searchQuery);
    }
  };

  const notifications = [
    { id: 1, message: 'File "report.pdf" was downloaded', time: '2 min ago' },
    { id: 2, message: 'New share link created for "photo.jpg"', time: '15 min ago' },
    { id: 3, message: 'Storage is 85% full', time: '1 hour ago' },
  ];

  return (
    <nav style={{...styles.navbar, ...(darkMode ? styles.navbarDark : {})}}>
      <div style={styles.navContent}>
        {/* Logo - Left */}
        <div style={styles.logo} onClick={() => navigate('/dashboard')}>
          <span style={styles.logoIcon}>📁</span>
          <span style={styles.logoText}>Mini Drive</span>
        </div>

        {/* Search - Center */}
        {onSearch && (
          <form onSubmit={handleSearch} style={styles.searchForm}>
            <div style={{...styles.searchWrapper, ...(darkMode ? styles.searchWrapperDark : {})}}>
              <FiSearch style={styles.searchIcon} />
              <input
                type="text"
                placeholder="Search files..."
                value={searchQuery || ''}
                onChange={(e) => setSearchQuery && setSearchQuery(e.target.value)}
                style={{...styles.searchInput, ...(darkMode ? styles.searchInputDark : {})}}
              />
            </div>
          </form>
        )}

        {/* Right Section */}
        <div style={styles.rightSection}>
          {/* Dashboard Button */}
          <Tooltip text="Dashboard" position="bottom">
            <button
              onClick={() => navigate('/dashboard')}
              style={{
                ...styles.navBtn,
                ...(isActive('/dashboard') ? styles.activeNavBtn : {})
              }}
            >
              <FiHome size={18} />
              <span style={styles.navBtnText}>Dashboard</span>
            </button>
          </Tooltip>

          {/* Analytics Button */}
          <Tooltip text="Analytics" position="bottom">
            <button
              onClick={() => navigate('/analytics')}
              style={{
                ...styles.navBtn,
                ...(isActive('/analytics') ? styles.activeNavBtn : {})
              }}
            >
              <FiBarChart2 size={18} />
              <span style={styles.navBtnText}>Analytics</span>
            </button>
          </Tooltip>

          {/* Vertical Divider */}
          <div style={styles.divider} />

          {/* Notification Bell */}
          <div style={styles.notificationWrapper}>
            <button
              onClick={() => setShowNotifications(!showNotifications)}
              style={styles.iconBtn}
            >
              <FiBell size={20} />
              {notifications.length > 0 && (
                <span style={styles.notificationDot}>{notifications.length}</span>
              )}
            </button>
            
            {showNotifications && (
              <div style={{...styles.notificationDropdown, ...(darkMode ? styles.notificationDropdownDark : {})}}>
                <div style={styles.notificationHeader}>
                  <span>Notifications</span>
                  <button onClick={() => setShowNotifications(false)} style={styles.closeDropdown}>✕</button>
                </div>
                {notifications.length === 0 ? (
                  <p style={styles.noNotifications}>No notifications</p>
                ) : (
                  notifications.map(notif => (
                    <div key={notif.id} style={styles.notificationItem}>
                      <p style={styles.notificationMessage}>{notif.message}</p>
                      <span style={styles.notificationTime}>{notif.time}</span>
                    </div>
                  ))
                )}
              </div>
            )}
          </div>

          {/* Dark Mode Toggle */}
          <button onClick={toggleDarkMode} style={styles.iconBtn}>
            {darkMode ? <FiSun size={20} /> : <FiMoon size={20} />}
          </button>

          {/* User Menu */}
          <div style={styles.userMenuWrapper}>
            <button
              onClick={() => setShowUserMenu(!showUserMenu)}
              style={styles.userMenuBtn}
            >
              <FiUser size={16} />
              <span style={styles.usernameText}>{username || 'User'}</span>
              <span style={styles.dropdownArrow}>▼</span>
            </button>
            
            {showUserMenu && (
              <div style={{...styles.userDropdown, ...(darkMode ? styles.userDropdownDark : {})}}>
                <button onClick={() => { setShowUserMenu(false); navigate('/profile'); }} style={styles.dropdownItem}>
                  <FiUser /> Profile
                </button>
                <button onClick={() => { setShowUserMenu(false); navigate('/dashboard'); }} style={styles.dropdownItem}>
                  <FiHome /> Dashboard
                </button>
                <button onClick={() => { setShowUserMenu(false); navigate('/analytics'); }} style={styles.dropdownItem}>
                  <FiBarChart2 /> Analytics
                </button>
                <div style={styles.dropdownDivider} />
                <button onClick={() => { setShowUserMenu(false); handleLogout(); }} style={{...styles.dropdownItem, ...styles.dropdownItemDanger}}>
                  <FiLogOut /> Logout
                </button>
              </div>
            )}
          </div>
        </div>
      </div>
    </nav>
  );
}

const styles = {
  navbar: {
    backgroundColor: '#6366f1',
    color: 'white',
    padding: '10px 32px',
    boxShadow: '0 4px 20px rgba(99, 102, 241, 0.3)',
    position: 'sticky',
    top: 0,
    zIndex: 1000,
    transition: 'all 0.3s ease',
  },
  navbarDark: {
    backgroundColor: '#1f2937',
    boxShadow: '0 4px 20px rgba(0, 0, 0, 0.5)',
  },
  navContent: {
    maxWidth: '1400px',
    margin: '0 auto',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'space-between',
    gap: '20px',
  },
  logo: {
    display: 'flex',
    alignItems: 'center',
    gap: '8px',
    cursor: 'pointer',
    fontSize: '20px',
    fontWeight: '700',
    fontFamily: 'Poppins, sans-serif',
    whiteSpace: 'nowrap',
    minWidth: 'fit-content',
    marginRight: '20px',
  },
  logoIcon: { fontSize: '24px' },
  logoText: { color: 'white' },
  searchForm: {
    flex: 1,
    maxWidth: '450px',
    minWidth: '150px',
  },
  searchWrapper: {
    display: 'flex',
    alignItems: 'center',
    backgroundColor: 'rgba(255,255,255,0.15)',
    borderRadius: '10px',
    padding: '6px 14px',
    transition: 'all 0.3s ease',
  },
  searchWrapperDark: {
    backgroundColor: 'rgba(255,255,255,0.08)',
  },
  searchIcon: {
    color: 'rgba(255,255,255,0.7)',
    marginRight: '10px',
    fontSize: '16px',
  },
  searchInput: {
    flex: 1,
    background: 'transparent',
    border: 'none',
    padding: '8px 0',
    color: 'white',
    fontSize: '14px',
    outline: 'none',
  },
  searchInputDark: {
    color: '#e5e7eb',
  },
  rightSection: {
    display: 'flex',
    alignItems: 'center',
    gap: '8px',
  },
  navBtn: {
    display: 'flex',
    alignItems: 'center',
    gap: '6px',
    backgroundColor: 'transparent',
    color: 'white',
    border: 'none',
    padding: '8px 12px',
    borderRadius: '8px',
    cursor: 'pointer',
    fontSize: '14px',
    transition: 'all 0.2s ease',
  },
  navBtnText: {
    fontWeight: '500',
  },
  activeNavBtn: {
    backgroundColor: 'rgba(255,255,255,0.2)',
    fontWeight: '600',
  },
  iconBtn: {
    backgroundColor: 'transparent',
    color: 'white',
    border: 'none',
    padding: '8px 10px',
    borderRadius: '8px',
    cursor: 'pointer',
    fontSize: '18px',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    position: 'relative',
    transition: 'all 0.2s ease',
  },
  divider: {
    width: '1px',
    height: '28px',
    backgroundColor: 'rgba(255,255,255,0.2)',
    margin: '0 4px',
  },
  notificationWrapper: {
    position: 'relative',
  },
  notificationDot: {
    position: 'absolute',
    top: '2px',
    right: '2px',
    backgroundColor: '#ef4444',
    color: 'white',
    fontSize: '10px',
    fontWeight: '700',
    borderRadius: '50%',
    width: '18px',
    height: '18px',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
  },
  notificationDropdown: {
    position: 'absolute',
    top: 'calc(100% + 8px)',
    right: '0',
    backgroundColor: 'white',
    borderRadius: '12px',
    boxShadow: '0 10px 40px rgba(0,0,0,0.15)',
    minWidth: '280px',
    maxWidth: '320px',
    maxHeight: '400px',
    overflow: 'auto',
    padding: '8px 0',
    zIndex: 1001,
  },
  notificationDropdownDark: {
    backgroundColor: '#1f2937',
    boxShadow: '0 10px 40px rgba(0,0,0,0.4)',
  },
  notificationHeader: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: '12px 16px',
    borderBottom: '1px solid #e5e7eb',
    fontWeight: '600',
    fontSize: '14px',
  },
  closeDropdown: {
    background: 'none',
    border: 'none',
    cursor: 'pointer',
    color: '#888',
    fontSize: '16px',
  },
  noNotifications: {
    padding: '20px',
    textAlign: 'center',
    color: '#888',
    fontSize: '14px',
  },
  notificationItem: {
    padding: '12px 16px',
    borderBottom: '1px solid #f3f4f6',
    cursor: 'pointer',
    transition: 'background 0.2s ease',
  },
  notificationMessage: {
    margin: 0,
    fontSize: '13px',
    color: '#333',
  },
  notificationTime: {
    fontSize: '11px',
    color: '#888',
    display: 'block',
    marginTop: '4px',
  },
  userMenuWrapper: {
    position: 'relative',
  },
  userMenuBtn: {
    display: 'flex',
    alignItems: 'center',
    gap: '6px',
    backgroundColor: 'rgba(255,255,255,0.12)',
    border: 'none',
    borderRadius: '8px',
    padding: '6px 12px',
    cursor: 'pointer',
    color: 'white',
    fontSize: '14px',
    transition: 'all 0.2s ease',
  },
  usernameText: {
    fontWeight: '500',
  },
  dropdownArrow: {
    fontSize: '10px',
    opacity: 0.7,
  },
  userDropdown: {
    position: 'absolute',
    top: 'calc(100% + 8px)',
    right: '0',
    backgroundColor: 'white',
    borderRadius: '12px',
    boxShadow: '0 10px 40px rgba(0,0,0,0.15)',
    minWidth: '180px',
    padding: '8px 0',
    zIndex: 1001,
  },
  userDropdownDark: {
    backgroundColor: '#1f2937',
    boxShadow: '0 10px 40px rgba(0,0,0,0.4)',
  },
  dropdownItem: {
    display: 'flex',
    alignItems: 'center',
    gap: '10px',
    padding: '10px 16px',
    width: '100%',
    border: 'none',
    backgroundColor: 'transparent',
    cursor: 'pointer',
    fontSize: '14px',
    color: '#1f2937',
    transition: 'background 0.2s ease',
  },
  dropdownItemDanger: {
    color: '#dc2626',
  },
  dropdownDivider: {
    height: '1px',
    backgroundColor: '#e5e7eb',
    margin: '4px 0',
  },
};

export default Navbar;