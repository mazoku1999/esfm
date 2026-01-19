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
      {/* Izquierda: Kjarkas */}
      <div
        className="w-1/3 flex items-center justify-center bg-white border-r-4 border-black cursor-pointer"
        onClick={() => handleDownload('kjarkas.bat')}
        style={{ minHeight: '100vh' }}
      >
        <h1 className="text-6xl font-bold text-black select-none">Kjarkas</h1>
      </div>
      {/* Centro: Incos */}
      <div
        className="w-1/3 flex items-center justify-center bg-white border-r-4 border-black border-l-4 cursor-pointer"
        onClick={() => handleDownload('incos.bat')}
        style={{ minHeight: '100vh' }}
      >
        <h1 className="text-6xl font-bold text-black select-none">Incos</h1>
      </div>
      {/* Derecha: Kjarkas Quedate */}
      <div
        className="w-1/3 flex items-center justify-center bg-white border-l-4 border-black cursor-pointer"
        onClick={() => handleDownload('kjarkas-quedate.bat')}
        style={{ minHeight: '100vh' }}
      >
        <h1 className="text-6xl font-bold text-black select-none">Kjarkas Quedate</h1>
      </div>
    </div>
  )
}
