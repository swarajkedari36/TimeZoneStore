import React, { useState } from 'react';
import { FiSearch, FiX, FiFilter } from 'react-icons/fi';

function SearchBar({ onSearch, onClear, loading }) {
  const [keyword, setKeyword] = useState('');
  const [fileType, setFileType] = useState('All');
  const [dateRange, setDateRange] = useState('All');
  const [sizeRange, setSizeRange] = useState('All');
  const [showFilters, setShowFilters] = useState(false);
  const [sortBy, setSortBy] = useState('date');
  const [sortOrder, setSortOrder] = useState('desc');

  const fileTypes = ['All', 'image', 'video', 'audio', 'pdf', 'document', 'spreadsheet', 'text', 'archive'];
  const dateRanges = ['All', 'Today', 'This Week', 'This Month', 'Last 3 Months', 'This Year'];
  const sizeRanges = ['All', '< 1 MB', '1-5 MB', '5-10 MB', '10-50 MB', '> 50 MB'];

  const handleSearch = () => {
    // Don't search if keyword is empty and no filters are applied
    if (!keyword.trim() && fileType === 'All' && dateRange === 'All' && sizeRange === 'All') {
      alert('Please enter a search keyword or apply filters');
      return;
    }
    
    const filters = {
      keyword: keyword.trim(),
      fileType: fileType === 'All' ? null : fileType,
      dateRange: dateRange === 'All' ? null : dateRange,
      sizeRange: sizeRange === 'All' ? null : sizeRange,
      sortBy,
      sortOrder,
    };
    onSearch(filters);
  };

  const handleClear = () => {
    setKeyword('');
    setFileType('All');
    setDateRange('All');
    setSizeRange('All');
    setSortBy('date');
    setSortOrder('desc');
    onClear();
  };

  const handleKeyPress = (e) => {
    if (e.key === 'Enter') {
      handleSearch();
    }
  };

  return (
    <div style={styles.container}>
      {/* Search Input */}
      <div style={styles.searchRow}>
        <div style={styles.searchInputWrapper}>
          <FiSearch style={styles.searchIcon} />
          <input
            type="text"
            placeholder="Search files by name..."
            value={keyword}
            onChange={(e) => setKeyword(e.target.value)}
            onKeyPress={handleKeyPress}
            style={styles.searchInput}
            id="search-input"
          />
          {keyword && (
            <button onClick={() => setKeyword('')} style={styles.clearBtn}>
              <FiX />
            </button>
          )}
        </div>
        
        <button 
          onClick={handleSearch} 
          style={styles.searchBtn} 
          disabled={loading}
        >
          {loading ? 'Searching...' : '🔍 Search'}
        </button>
        
        <button 
          onClick={() => setShowFilters(!showFilters)} 
          style={styles.filterToggleBtn}
        >
          <FiFilter /> Filters
        </button>
        
        <button onClick={handleClear} style={styles.clearAllBtn}>
          Clear All
        </button>
      </div>

      {/* Filters */}
      {showFilters && (
        <div style={styles.filtersRow}>
          <div style={styles.filterGroup}>
            <label style={styles.filterLabel}>File Type</label>
            <select value={fileType} onChange={(e) => setFileType(e.target.value)} style={styles.filterSelect}>
              {fileTypes.map(type => (
                <option key={type} value={type}>{type}</option>
              ))}
            </select>
          </div>

          <div style={styles.filterGroup}>
            <label style={styles.filterLabel}>Date</label>
            <select value={dateRange} onChange={(e) => setDateRange(e.target.value)} style={styles.filterSelect}>
              {dateRanges.map(range => (
                <option key={range} value={range}>{range}</option>
              ))}
            </select>
          </div>

          <div style={styles.filterGroup}>
            <label style={styles.filterLabel}>Size</label>
            <select value={sizeRange} onChange={(e) => setSizeRange(e.target.value)} style={styles.filterSelect}>
              {sizeRanges.map(range => (
                <option key={range} value={range}>{range}</option>
              ))}
            </select>
          </div>

          <div style={styles.filterGroup}>
            <label style={styles.filterLabel}>Sort By</label>
            <select value={sortBy} onChange={(e) => setSortBy(e.target.value)} style={styles.filterSelect}>
              <option value="date">Date</option>
              <option value="name">Name</option>
              <option value="size">Size</option>
              <option value="type">Type</option>
            </select>
          </div>

          <div style={styles.filterGroup}>
            <label style={styles.filterLabel}>Order</label>
            <select value={sortOrder} onChange={(e) => setSortOrder(e.target.value)} style={styles.filterSelect}>
              <option value="desc">Descending</option>
              <option value="asc">Ascending</option>
            </select>
          </div>
        </div>
      )}
    </div>
  );
}

const styles = {
  container: {
    backgroundColor: 'white',
    padding: '20px',
    borderRadius: '12px',
    marginBottom: '20px',
    boxShadow: '0 2px 8px rgba(0,0,0,0.08)',
  },
  searchRow: {
    display: 'flex',
    gap: '12px',
    alignItems: 'center',
    flexWrap: 'wrap',
  },
  searchInputWrapper: {
    flex: 1,
    position: 'relative',
    minWidth: '200px',
  },
  searchIcon: {
    position: 'absolute',
    left: '12px',
    top: '50%',
    transform: 'translateY(-50%)',
    color: '#888',
  },
  searchInput: {
    width: '100%',
    padding: '10px 16px 10px 40px',
    border: '1px solid #ddd',
    borderRadius: '8px',
    fontSize: '14px',
    outline: 'none',
    transition: 'border-color 0.2s',
  },
  clearBtn: {
    position: 'absolute',
    right: '12px',
    top: '50%',
    transform: 'translateY(-50%)',
    backgroundColor: 'transparent',
    border: 'none',
    cursor: 'pointer',
    color: '#888',
  },
  searchBtn: {
    backgroundColor: '#6366f1',
    color: 'white',
    border: 'none',
    padding: '10px 24px',
    borderRadius: '8px',
    cursor: 'pointer',
    fontSize: '14px',
    fontWeight: '500',
  },
  filterToggleBtn: {
    backgroundColor: '#f8f9fa',
    color: '#333',
    border: '1px solid #ddd',
    padding: '10px 16px',
    borderRadius: '8px',
    cursor: 'pointer',
    fontSize: '14px',
    display: 'flex',
    alignItems: 'center',
    gap: '6px',
  },
  clearAllBtn: {
    backgroundColor: '#dc3545',
    color: 'white',
    border: 'none',
    padding: '10px 16px',
    borderRadius: '8px',
    cursor: 'pointer',
    fontSize: '14px',
  },
  filtersRow: {
    display: 'flex',
    gap: '16px',
    marginTop: '16px',
    paddingTop: '16px',
    borderTop: '1px solid #eee',
    flexWrap: 'wrap',
  },
  filterGroup: {
    display: 'flex',
    flexDirection: 'column',
    gap: '4px',
    minWidth: '120px',
    flex: '1',
  },
  filterLabel: {
    fontSize: '12px',
    fontWeight: '600',
    color: '#666',
    textTransform: 'uppercase',
    letterSpacing: '0.5px',
  },
  filterSelect: {
    padding: '8px 12px',
    border: '1px solid #ddd',
    borderRadius: '6px',
    fontSize: '14px',
    backgroundColor: 'white',
    outline: 'none',
  },
};

export default SearchBar;