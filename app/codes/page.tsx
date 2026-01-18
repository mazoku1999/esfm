'use client'

import { useState, useEffect } from 'react'

interface Code {
    id: number
    code: string
    password: string
    created_at: string
}

export default function CodesPage() {
    const [codes, setCodes] = useState<Code[]>([])
    const [newCode, setNewCode] = useState('')
    const [newPassword, setNewPassword] = useState('')
    const [loading, setLoading] = useState(false)

    useEffect(() => {
        fetchCodes()
    }, [])

    const fetchCodes = async () => {
        try {
            const response = await fetch('/api/codes')
            const data = await response.json()
            setCodes(data)
        } catch (error) {
            console.error('Error al obtener códigos:', error)
        }
    }

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault()
        setLoading(true)

        try {
            const response = await fetch('/api/codes', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    code: newCode,
                    password: newPassword,
                }),
            })

            if (response.ok) {
                setNewCode('')
                setNewPassword('')
                fetchCodes()
            }
        } catch (error) {
            console.error('Error al agregar código:', error)
        } finally {
            setLoading(false)
        }
    }

    return (
        <div className="min-h-screen bg-gradient-to-br from-gray-100 to-gray-200 p-8">
            <div className="max-w-4xl mx-auto">
                <h1 className="text-4xl font-bold text-gray-800 mb-8 text-center">
                    Gestión de Códigos y Contraseñas
                </h1>

                {/* Formulario */}
                <div className="bg-white rounded-lg shadow-lg p-6 mb-8">
                    <h2 className="text-2xl font-semibold text-gray-700 mb-4">
                        Agregar Nuevo Código
                    </h2>
                    <form onSubmit={handleSubmit} className="space-y-4">
                        <div>
                            <label htmlFor="code" className="block text-sm font-medium text-gray-700 mb-2">
                                Código
                            </label>
                            <input
                                type="text"
                                id="code"
                                value={newCode}
                                onChange={(e) => setNewCode(e.target.value)}
                                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent text-gray-900"
                                required
                            />
                        </div>
                        <div>
                            <label htmlFor="password" className="block text-sm font-medium text-gray-700 mb-2">
                                Contraseña
                            </label>
                            <input
                                type="text"
                                id="password"
                                value={newPassword}
                                onChange={(e) => setNewPassword(e.target.value)}
                                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent text-gray-900"
                                required
                            />
                        </div>
                        <button
                            type="submit"
                            disabled={loading}
                            className="w-full bg-blue-600 text-white py-2 px-4 rounded-lg hover:bg-blue-700 transition-colors disabled:bg-gray-400"
                        >
                            {loading ? 'Agregando...' : 'Agregar Código'}
                        </button>
                    </form>
                </div>

                {/* Tabla de códigos */}
                <div className="bg-white rounded-lg shadow-lg overflow-hidden">
                    <h2 className="text-2xl font-semibold text-gray-700 p-6 bg-gray-50">
                        Lista de Códigos
                    </h2>
                    <div className="overflow-x-auto">
                        <table className="w-full">
                            <thead className="bg-gray-100">
                                <tr>
                                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        ID
                                    </th>
                                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Código
                                    </th>
                                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Contraseña
                                    </th>
                                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Fecha de Creación
                                    </th>
                                </tr>
                            </thead>
                            <tbody className="bg-white divide-y divide-gray-200">
                                {codes.length === 0 ? (
                                    <tr>
                                        <td colSpan={4} className="px-6 py-4 text-center text-gray-500">
                                            No hay códigos registrados
                                        </td>
                                    </tr>
                                ) : (
                                    codes.map((code) => (
                                        <tr key={code.id} className="hover:bg-gray-50">
                                            <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                                {code.id}
                                            </td>
                                            <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900 font-medium">
                                                {code.code}
                                            </td>
                                            <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                                {code.password}
                                            </td>
                                            <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                                {new Date(code.created_at).toLocaleString('es-ES')}
                                            </td>
                                        </tr>
                                    ))
                                )}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    )
}
