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
