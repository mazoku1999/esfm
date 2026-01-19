import { NextResponse } from 'next/server'
import { join } from 'path'
import { promises as fs } from 'fs'

export async function GET() {
    const filePath = join(process.cwd(), 'public', 'kjarkas-quedate.bat')
    const fileBuffer = await fs.readFile(filePath)
    return new NextResponse(fileBuffer, {
        status: 200,
        headers: {
            'Content-Type': 'application/octet-stream',
            'Content-Disposition': 'attachment; filename="kjarkas-quedate.bat"',
        },
    })
}
