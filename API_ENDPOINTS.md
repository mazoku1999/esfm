# API Endpoints - ESFM

Base URL: `https://esfm.vercel.app`

## 📡 Endpoints Disponibles

### 1. Obtener todos los códigos

```http
GET https://esfm.vercel.app/api/codes
```

**Parámetros:** Ninguno

**Respuesta exitosa (200):**
```json
[
  {
    "id": 1,
    "code": "codigo123",
    "password": "pass123",
    "created_at": "2026-01-18T10:00:00Z",
    "updated_at": "2026-01-18T10:00:00Z"
  },
  {
    "id": 2,
    "code": "codigo456",
    "password": "pass456",
    "created_at": "2026-01-18T11:00:00Z",
    "updated_at": "2026-01-18T11:00:00Z"
  }
]
```

---

### 2. Agregar nuevo código

```http
POST https://esfm.vercel.app/api/codes
```

**Headers requeridos:**
```
Content-Type: application/json
```

**Body (JSON):**
```json
{
  "code": "tu_codigo",
  "password": "tu_contraseña"
}
```

**Campos:**
- `code` (string, requerido): El código a guardar
- `password` (string, requerido): La contraseña asociada

**Respuesta exitosa (201):**
```json
{
  "id": 3,
  "code": "tu_codigo",
  "password": "tu_contraseña",
  "created_at": "2026-01-18T12:00:00Z",
  "updated_at": "2026-01-18T12:00:00Z"
}
```

**Respuesta de error (400):**
```json
{
  "error": "Código y contraseña son requeridos"
}
```

**Respuesta de error (500):**
```json
{
  "error": "Error al crear código"
}
```

---

## 🧪 Ejemplos de uso

### Con cURL

**Obtener códigos:**
```bash
curl https://esfm.vercel.app/api/codes
```

**Agregar código:**
```bash
curl -X POST https://esfm.vercel.app/api/codes \
  -H "Content-Type: application/json" \
  -d '{"code":"123456", "password":"mipassword"}'
```

### Con JavaScript/Fetch

**Obtener códigos:**
```javascript
fetch('https://esfm.vercel.app/api/codes')
  .then(response => response.json())
  .then(data => console.log(data))
  .catch(error => console.error('Error:', error));
```

**Agregar código:**
```javascript
fetch('https://esfm.vercel.app/api/codes', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    code: '123456',
    password: 'mipassword'
  })
})
  .then(response => response.json())
  .then(data => console.log('Código agregado:', data))
  .catch(error => console.error('Error:', error));
```

### Con Python (requests)

**Obtener códigos:**
```python
import requests

response = requests.get('https://esfm.vercel.app/api/codes')
codes = response.json()
print(codes)
```

**Agregar código:**
```python
import requests

data = {
    "code": "123456",
    "password": "mipassword"
}

response = requests.post(
    'https://esfm.vercel.app/api/codes',
    json=data
)
print(response.json())
```

### Con PowerShell

**Obtener códigos:**
```powershell
Invoke-RestMethod -Uri "https://esfm.vercel.app/api/codes" -Method Get
```

**Agregar código:**
```powershell
$body = @{
    code = "123456"
    password = "mipassword"
} | ConvertTo-Json

Invoke-RestMethod -Uri "https://esfm.vercel.app/api/codes" `
    -Method Post `
    -Body $body `
    -ContentType "application/json"
```

---

## 🌐 URLs de la aplicación

- **Página principal (descargar instalador):** https://esfm.vercel.app
- **Gestión de códigos:** https://esfm.vercel.app/codes
- **API Endpoint:** https://esfm.vercel.app/api/codes

---

## 📝 Notas

- Todos los datos se almacenan en una base de datos PostgreSQL (Supabase)
- Los códigos y contraseñas **NO están cifrados** (según especificaciones del proyecto)
- La API acepta y devuelve JSON
- No se requiere autenticación para usar los endpoints
