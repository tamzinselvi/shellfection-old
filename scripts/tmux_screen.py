try:
    from PIL import Image
except:
    from sys import stderr, exit
    stderr.write('[E] PIL not installed')
    exit(1)
import curses, os
from drawille import Canvas
from StringIO import StringIO
import urllib2


def getTerminalSize():
    import os
    env = os.environ

    def ioctl_GWINSZ(fd):
        import fcntl
        import termios
        import struct
        cr = struct.unpack('hh', fcntl.ioctl(fd, termios.TIOCGWINSZ, '1234'))
        return cr
    cr = ioctl_GWINSZ(0) or ioctl_GWINSZ(1) or ioctl_GWINSZ(2)
    if not cr:
        try:
            fd = os.open(os.ctermid(), os.O_RDONLY)
            cr = ioctl_GWINSZ(fd)
            os.close(fd)
        except:
            pass
    if not cr:
        cr = (env.get('LINES', 25), env.get('COLUMNS', 80))
    return int(cr[1]), int(cr[0])


def image2term(image, threshold=128, ratio=None, invert=False):
    if image.startswith('http://') or image.startswith('https://'):
        i = Image.open(StringIO(urllib2.urlopen(image).read())).convert('L')
    else:
        i = Image.open(open(image)).convert('L')
    w, h = i.size
    if ratio:
        w = int(w * ratio)
        h = int(h * ratio)
        i = i.resize((w, h), Image.ANTIALIAS)
    else:
        tw, th = getTerminalSize()
        tw *= 2
        th *= 2
        if tw < w:
            ratio = tw / float(w)
            w = tw
            h = int(h * ratio)
            i = i.resize((w, h), Image.ANTIALIAS)
    can = Canvas()
    x = y = 0

    try:
         i_converted = i.tobytes()
    except AttributeError:
         i_converted = i.tostring()

    for pix in i_converted:
        if invert:
            if ord(pix) > threshold:
                can.set(x, y)
        else:
            if ord(pix) < threshold:
                can.set(x, y)
        x += 1
        if x >= w:
            y += 1
            x = 0
    tw, th = getTerminalSize()
    return can.frame(0, 0)

screen = curses.initscr()

curses.noecho()
curses.curs_set(0)
screen.keypad(1)
tw, th = getTerminalSize()
# screen.addstr(str(tw))

# screen.addstr(0, 0, image2term(os.path.dirname(os.path.realpath(__file__)) + "/../images/abstract.png"))

# print(image2term(os.path.dirname(os.path.realpath(__file__)) + "/../images/abstract.png"))

while True: 
   event = screen.getch() 
   if event == ord("q"): break 
   elif event == ord("p"): 
      screen.clear() 
      screen.addstr("The User Pressed Lower Case p") 
   elif event == ord("P"): 
      screen.clear() 
      screen.addstr("The User Pressed Upper Case P") 
   elif event == ord("3"): 
      screen.clear() 
      screen.addstr("The User Pressed 3") 
   elif event == ord(" "): 
      screen.clear() 
      screen.addstr("The User Pressed The Space Bar")
