# Parallax scrolling on Android

| Metadata   | Value |
| ---------- | ----- |
| Date       | 2009-02-08 |
| Categories | android, processing, archive, archive-selection |

---

*SUMMARY: A note about the Android G1 home screen's parallax effect, updated with a browser-native p5.js reconstruction in place of the original Java applet.*

A while ago I heard about something called [*parallax scrolling*](https://en.wikipedia.org/wiki/Parallax_scrolling) being used on Google's [Android](https://en.wikipedia.org/wiki/Android_(operating_system)) platform, specifically on the [HTC Dream / G1](https://en.wikipedia.org/wiki/HTC_Dream). I had just gotten the G1 at that point and hadn't noticed that it was doing something special when scrolling between the three screens in the home application.

The idea is pretty simple: you have two surfaces that scroll at two different speeds, one is bigger or farther away, depending on how you look at it.

On the G1 it allows the background of the home screen to be smaller than the total viewable area that the three home screens cover. This is useful since the size of the home screen areas can change drastically when the phone is flipped open. It also creates the illusion of depth.

The [original post](https://csjam.blogspot.com/2009/02/parallax-scrolling-in-android.html) embedded a Java applet written with Processing. That approach is long dead in modern browsers, so below is a browser-native reconstruction using [p5.js](https://p5js.org/) instead.

<div style="max-width: 420px; margin: 1.5rem auto;">
  <div id="parallax-sketch"></div>
  <p style="margin-top: 0.5rem;"><small>Click and drag the light purple square left and right.</small></p>
</div>
<script src="https://cdn.jsdelivr.net/npm/p5@1.11.10/lib/p5.min.js"></script>
<script src="../js/parallax-demo.js"></script>

Source code (`parallax-demo.js`, also on [GitHub Gist](https://gist.github.com/silverjam/bdbb7ec2012580f2816a3c80f95b7b8d)):

```javascript
(() => {
  const sketch = (p) => {
    const canvasX = 400;
    const canvasY = 400;

    class Position {
      constructor() { this.x = 0; this.y = 0; }
    }

    class Delta {
      constructor() { this.dx = 0; this.dy = 0; }
    }

    class RectArea {
      constructor(fillColor, opacity) {
        this.position = new Position();
        this.delta = new Delta();
        this.fillColor = fillColor;
        this.opacity = opacity;
      }

      setSize(dx, dy) {
        this.delta.dx = dx;
        this.delta.dy = dy;
      }

      hitTest(posX, posY) {
        return posX >= this.position.x && posX <= (this.position.x + this.delta.dx) &&
               posY >= this.position.y && posY <= (this.position.y + this.delta.dy);
      }

      initialize() { placeAtCenter(this); }
      setX(x) { this.position.x = x; }
      moveX(dx) { this.position.x += dx; }
      maybeMoveX(dx) { return this.position.x + dx; }

      paint() {
        p.fill(p.red(this.fillColor), p.green(this.fillColor), p.blue(this.fillColor), this.opacity);
        p.rect(this.position.x, this.position.y, this.delta.dx, this.delta.dy);
      }
    }

    function placeAtCenter(area) {
      area.position.x = Math.floor(p.height / 2 - area.delta.dx / 2);
      area.position.y = Math.floor(p.width / 2 - area.delta.dy / 2);
    }

    let drag = false;
    let inDrag = false;

    let lastMouseX = 0;

    let viewableArea;
    let backgroundArea;

    let scaleBy = 0;
    let excessXs = 0;

    let scrollEdgeX1_b = 0;
    let scrollEdgeX2_b = 0;
    let scrollEdgeX1_v = 0;
    let scrollEdgeX2_v = 0;

    function putAtEdge(r, x) {
      r.setX(x);
      inDrag = false;
    }

    p.setup = () => {
      const canvas = p.createCanvas(canvasX, canvasY);
      canvas.parent('parallax-sketch');

      viewableArea = new RectArea(p.color('#93BAF7'), 200);
      backgroundArea = new RectArea(p.color('#CE7BCE'), 255);

      p.background(0);
      p.noStroke();

      p.frameRate(25);
      lastMouseX = p.mouseX;

      viewableArea.setSize(100, 200);
      backgroundArea.setSize(250, 200);

      backgroundArea.initialize();
      backgroundArea.paint();

      viewableArea.initialize();
      viewableArea.paint();

      const vdx = viewableArea.delta.dx;
      const bdx = backgroundArea.delta.dx;
      const slack = Math.floor((3 * vdx - bdx) / 2);
      scaleBy = Math.floor(vdx / slack);

      console.log(scaleBy);

      scrollEdgeX1_v = viewableArea.position.x - viewableArea.delta.dx;
      scrollEdgeX2_v = viewableArea.position.x + viewableArea.delta.dx;
      scrollEdgeX1_b = scrollEdgeX1_v;
      scrollEdgeX2_b = backgroundArea.position.x + slack;
    };

    p.draw = () => {
      if (drag) {
        p.background(0);
        backgroundArea.paint();

        const dx = -1 * (lastMouseX - p.mouseX);

        if (viewableArea.maybeMoveX(dx) < scrollEdgeX1_v) {
          putAtEdge(viewableArea, scrollEdgeX1_v);
          putAtEdge(backgroundArea, scrollEdgeX1_b);
        } else if (viewableArea.maybeMoveX(dx) > scrollEdgeX2_v) {
          putAtEdge(viewableArea, scrollEdgeX2_v);
          putAtEdge(backgroundArea, scrollEdgeX2_b);
        } else {
          viewableArea.moveX(dx);
          backgroundArea.moveX(Math.trunc((dx + excessXs) / scaleBy));
          excessXs = (dx + excessXs) % scaleBy;
        }

        viewableArea.paint();
      }

      lastMouseX = p.mouseX;
    };

    p.mouseDragged = () => {
      if (inDrag) return;

      drag = viewableArea.hitTest(p.mouseX, p.mouseY);
      if (drag) inDrag = true;
    };

    p.mouseReleased = () => {
      inDrag = false;
      drag = false;
    };
  };

  function mount() {
    const container = document.getElementById('parallax-sketch');
    if (container && window.p5) {
      new window.p5(sketch, container);
    }
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', mount, { once: true });
  } else {
    mount();
  }
})();
```

Turns out I was probably reading a Qt developer blog. Ariya Hidayat's post on [Android-like parallax sliding](https://ariya.io/2008/11/android-like-parallax-sliding) supports that conclusion.
