import React from 'react';

export default function QuickAccess({ items = [], onOpen }) {
  return (
    <div style={{ display: 'flex', gap: '12px', flexWrap: 'wrap' }}>
      {items.map((it) => (
        <button key={it.key} onClick={() => onOpen && onOpen(it.key)} style={{
          minWidth: '140px',
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'flex-start',
          gap: '6px',
          padding: '12px',
          borderRadius: '12px',
          border: '1px solid var(--border)',
          background: 'var(--glass-bg)',
          cursor: 'pointer'
        }} className="glass-card">
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
            <div style={{ fontSize: '20px' }}>{it.icon}</div>
            <div style={{ fontWeight: 600 }}>{it.title}</div>
          </div>
          <div style={{ fontSize: '12px', color: 'var(--text-secondary)' }}>{it.count} items</div>
        </button>
      ))}
    </div>
  );
}
