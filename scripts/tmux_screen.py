try:
    from PIL import Image
except:
    from sys import stderr, exit
    stderr.write('[E] PIL not installed')
    exit(1)
import curses, os
import math
from drawille import Canvas
from StringIO import StringIO
import urllib2

screen = curses.initscr()

def image2term(image, threshold=128, ratio=None, invert=False, x=None):
    if image.startswith('http://') or image.startswith('https://'):
        i = Image.open(StringIO(urllib2.urlopen(image).read())).convert('L')
    else:
        i = Image.open(open(image)).convert('L')
    img_w, img_h = i.size
    w = int(x)
    h = int(math.floor(float(img_h)/float(img_w)*float(x)))
    i = i.resize((w, h), Image.ANTIALIAS)
    can = Canvas()
    x = y = 0
    # tw, th = getTerminalSize()
    # tw *= 2
    # th *= 2
    # if tw < w:
    #     ratio = tw / float(w)
    #     w = tw
    #     h = int(h * ratio)
    #     i = i.resize((w, h), Image.ANTIALIAS)

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
    return can.frame(0, 0)

# curses.noecho()
print "asdasdasda"
curses.curs_set(0)
screen.keypad(1)
# screen.addstr(0, 0, "x")
y, x = screen.getmaxyx()
# screen.addstr(0, x - 1, "x")
# screen.addstr(str(tw))

# f = image2term(os.path.dirname(os.path.realpath(__file__)) + "/../images/abstract.png", x=x-1)

# screen.addstr(f)

# screen.addstr(0, 0, '{0}\n'.format(f))

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
