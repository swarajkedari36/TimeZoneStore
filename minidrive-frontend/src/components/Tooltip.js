import React, { useState } from 'react';

function Tooltip({ children, text, position = 'top' }) {
  const [show, setShow] = useState(false);

  // Only show after 1 second of hovering
  let timeoutId = null;

  const handleMouseEnter = () => {
    timeoutId = setTimeout(() => {
      setShow(true);
    }, 800); // 800ms delay (almost 1 second)
  };

  const handleMouseLeave = () => {
    if (timeoutId) {
      clearTimeout(timeoutId);
      timeoutId = null;
    }
    setShow(false);
  };

  const getPositionStyles = () => {
    switch (position) {
      case 'top':
        return { bottom: 'calc(100% + 8px)', left: '50%', transform: 'translateX(-50%)' };
      case 'bottom':
        return { top: 'calc(100% + 8px)', left: '50%', transform: 'translateX(-50%)' };
      case 'left':
        return { right: 'calc(100% + 8px)', top: '50%', transform: 'translateY(-50%)' };
      case 'right':
        return { left: 'calc(100% + 8px)', top: '50%', transform: 'translateY(-50%)' };
      default:
        return { bottom: 'calc(100% + 8px)', left: '50%', transform: 'translateX(-50%)' };
    }
  };

  return (
    <div 
      style={styles.container}
      onMouseEnter={handleMouseEnter}
      onMouseLeave={handleMouseLeave}
    >
      {children}
      {show && (
        <div style={{...styles.tooltip, ...getPositionStyles()}}>
          {text}
          <div style={styles.arrow} />
        </div>
      )}
    </div>
  );
}

const styles = {
  container: {
    position: 'relative',
    display: 'inline-flex',
  },
  tooltip: {
    position: 'absolute',
    backgroundColor: '#1f2937',
    color: 'white',
    padding: '6px 12px',
    borderRadius: '6px',
    fontSize: '12px',
    fontWeight: '500',
    whiteSpace: 'nowrap',
    zIndex: 999,
    boxShadow: '0 4px 12px rgba(0,0,0,0.2)',
    pointerEvents: 'none',
    animation: 'fadeIn 0.2s ease',
  },
  arrow: {
    position: 'absolute',
    bottom: '-6px',
    left: '50%',
    transform: 'translateX(-50%)',
    width: '0',
    height: '0',
    borderLeft: '6px solid transparent',
    borderRight: '6px solid transparent',
    borderTop: '6px solid #1f2937',
  },
};

// Add animation
const styleSheet = document.createElement("style");
styleSheet.textContent = `
  @keyframes fadeIn {
    from { opacity: 0; transform: translateY(4px); }
    to { opacity: 1; transform: translateY(0); }
  }
`;
document.head.appendChild(styleSheet);

export default Tooltip;