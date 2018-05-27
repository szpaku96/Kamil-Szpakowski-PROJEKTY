# Kamil Szpakowski
# Serwer do połączenia TCP_IP
# umożliwia czat pomiędzy dwoma komputerami
# asymchroniczne przesyłanie i odbieranie wiadomości
# możliwośc zerwania połączenia odpowiednią komendą ( :q )
# przesyłanie pliku
# program pisany w parze, niestety nie posiadam kodu klienta


import socket
import sys
import threading


class Serwer:

    s = None
    TCP_IP = '192.168.43.247'
    TCP_PORT = 50017
    BUFFER_SIZE = 1024
    QUIT = ':q'
    message = ''
    data = ''
    conn = None
    przesylanie_pliku = False;

    def __init__(self):

        self.s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.s.bind((self.TCP_IP, self.TCP_PORT))
        self.s.listen(1)
        self.QUIT = ':q'.encode()

        data = ' '

        self.conn, addr = self.s.accept()

        t1 = threading.Thread(target=self.send)
        t1.start()
        t2 = threading.Thread(target=self.receive)
        t2.start()

        while not self.data == self.QUIT and not self.message == self.QUIT:
            pass
        while t1.is_alive() or t2.is_alive():
            pass
        self.conn.close()

    def send(self):
        while not self.data == self.QUIT and not self.message == self.QUIT:
            self.message = input().encode()
            self.conn.send(self.message)
            if ':f' in self.message.decode():
                self.sendfile(self.message.decode()[3:])

    def receive(self):
        while not self.data == self.QUIT and not self.message == self.QUIT:

            self.data = self.conn.recv(self.BUFFER_SIZE)

            if ':f' in self.data.decode():
                self.receivefile(self.data.decode()[3:])
            else:
                print(self.data.decode())

    def sendfile(self,filename):
        f = open(filename, 'rb')
        l = f.read(1024)
        while (l):
            self.conn.send(l)
            l = f.read(1024)
        self.s.close(socket.SHUT_WR)
        f.close()
        print('file send')

    def receivefile(self,filename):
        f = open(filename, 'wb')
        l = self.conn.recv(self.BUFFER_SIZE)
        while (l):
            print('receiving data...')
            f.write(l)
            l = self.conn.recv(self.BUFFER_SIZE)

        f.close()
        print('done')

server = Serwer()