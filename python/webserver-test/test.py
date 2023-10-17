import http.server
import socketserver
import socket

PORT = 8080
Handler = http.server.SimpleHTTPRequestHandler

host_name = socket.gethostname()
host_ip = socket.gethostbyname(host_name)
print("Hostname :  ",host_name)
print("IP : ",host_ip)

with socketserver.TCPServer((host_ip, PORT), Handler) as httpd:
    print("serving at port", PORT)
    httpd.serve_forever()