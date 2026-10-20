$ErrorActionPreference = 'Stop'
try {
    py -m http.server 8080
} catch {
    Write-Host 'Python launcher (py) was not found. Install Python 3 or use a HTTPS host.' -ForegroundColor Yellow
    Read-Host 'Press Enter to close'
}
