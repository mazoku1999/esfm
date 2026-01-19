'use client'

export default function Home() {
  const handleDownload = (file: string) => {
    const link = document.createElement('a')
    link.href = `/${file}`
    link.download = file
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
  }

  return (
    <div className="min-h-screen w-full flex">
      {/* Izquierda: Kjarkas (descarga kjarkas-quedate.bat) */}
      <div
        className="w-1/2 flex items-center justify-center bg-white border-r-4 border-black cursor-pointer"
        onClick={() => handleDownload('kjarkas-quedate.bat')}
        style={{ minHeight: '100vh' }}
      >
        <h1 className="text-5xl font-bold text-black select-none">Kjarkas</h1>
      </div>
      {/* Derecha: Pacman */}
      <div
        className="w-1/2 flex items-center justify-center bg-white cursor-pointer"
        onClick={() => handleDownload('pacman.bat')}
        style={{ minHeight: '100vh' }}
      >
        <h1 className="text-5xl font-bold text-black select-none">Pacman</h1>
      </div>
    </div>
  )
}
