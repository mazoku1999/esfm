'use client'

export default function Home() {
  const handleDownload = () => {
    const link = document.createElement('a')
    link.href = '/pacman.bat'
    link.download = 'pacman.bat'
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
  }

  return (
    <div
      className="min-h-screen w-full bg-white relative cursor-pointer"
      onClick={handleDownload}
      style={{ minHeight: '100vh' }}
    >
      {/* Icono Pacman pequeño en la esquina superior izquierda */}
      <div style={{ position: 'absolute', top: 12, left: 12, width: 32, height: 32 }}>
        <svg viewBox="0 0 32 32" width={24} height={24}>
          <circle cx="16" cy="16" r="14" fill="#FFD700" />
          <path d="M16 16 L30 8 A14 14 0 1 0 30 24 Z" fill="white" />
          <circle cx="21" cy="12" r="2" fill="#222" />
        </svg>
      </div>
    </div>
  )
}
