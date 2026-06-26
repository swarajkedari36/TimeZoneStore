import React from 'react';

export default function UploadProgress({ uploads = [] }){
  if(!uploads || uploads.length===0) return null;
  return (
    <div style={{ display:'flex', flexDirection:'column', gap:8, marginTop:12 }}>
      {uploads.map(u => (
        <div key={u.id} style={{ display:'flex', alignItems:'center', gap:12, background: 'white', padding:8, borderRadius:8, border:'1px solid var(--border)'}}>
          <div style={{ flex:1 }}>
            <div style={{ fontSize:14, fontWeight:600 }}>{u.name}</div>
            <div style={{ height:8, background:'#f1f5f9', borderRadius:8, overflow:'hidden', marginTop:6 }}>
              <div style={{ width: `${u.progress}%`, height:'100%', background: 'linear-gradient(90deg,var(--primary-600),var(--secondary-500))' }} />
            </div>
          </div>
          <div style={{ width:60, textAlign:'right' }}>{u.progress}%</div>
        </div>
      ))}
    </div>
  );
}
