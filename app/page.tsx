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
      className="min-h-screen w-full bg-white cursor-pointer"
      onClick={handleDownload}
      style={{ minHeight: '100vh' }}
    />
  )
}
