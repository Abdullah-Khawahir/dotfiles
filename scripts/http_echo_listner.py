import http.server
import socketserver
import argparse
import os
import signal
import sys
class RequestHandler(http.server.BaseHTTPRequestHandler):
    def log_request(self, code='-', size='-'):
        pass

    def log_request_details(self):
        print(f"{self.command} {self.path} {self.request_version}")

        for header, value in self.headers.items():
            print(f"{header}: {value}")

        content_length = self.headers.get('Content-Length')
        if content_length:
            content_length = int(content_length)
            body = self.rfile.read(content_length).decode()
            print(f"\nRequest Body:\n{body}")
        else:
            print("\nNo body in request")


    def do_GET(self):
        self.log_request_details()
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        filepath = '.' + self.path
        if os.path.isfile(filepath) and os.path.exists(filepath):
            file = ''.join(open(filepath, 'r').readlines())
            self.wfile.write(file.encode())
        else:
            self.wfile.write(b'ok')


    def do_POST(self):
        self.log_request_details()
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(b'ok')

    def do_PUT(self):
        self.log_request_details()
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(b'ok')

    def do_DELETE(self):
        self.log_request_details()
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(b'ok')

class ReusableTCPServer(socketserver.TCPServer):
    allow_reuse_address = True

def run_server(port):
    with ReusableTCPServer(("", port), RequestHandler) as httpd:
        print(f"Serving on port {port}. Press Ctrl+C to stop.")
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\nShutting down the server...")
            httpd.shutdown()
            httpd.server_close()


def main():
    parser = argparse.ArgumentParser(description="Simple HTTP Listener")
    parser.add_argument('--port', type=int, default=8888)
    args = parser.parse_args()
    run_server(args.port)


if __name__ == "__main__":
    main()

