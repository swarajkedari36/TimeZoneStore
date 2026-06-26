import React from 'react';

export default function StatsCard({ title, value, subtitle, accent }) {
  return (
    <div style={{
      padding: '16px',
      borderRadius: '12px',
      background: 'linear-gradient(135deg, rgba(255,255,255,0.6), rgba(255,255,255,0.5))',
      display: 'flex',
      flexDirection: 'column',
      gap: '8px',
      minWidth: '160px',
      boxShadow: '0 6px 18px rgba(2,6,23,0.06)'
    }} className="glass-card">
      <div style={{ height: '6px', width: '48px', borderRadius: '8px', background: accent }} />
      <div style={{ fontSize: '14px', color: 'var(--text-secondary)' }}>{title}</div>
      <div style={{ fontSize: '20px', fontWeight: 700 }}>{value}</div>
      {subtitle && <div style={{ fontSize: '12px', color: 'var(--text-secondary)' }}>{subtitle}</div>}
    </div>
  );
}
