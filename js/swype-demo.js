(() => {
  const COMMON_WORDS = [
    'a', 'an', 'and', 'are', 'as', 'at', 'be', 'been', 'being', 'but', 'by', 'do', 'for', 'from', 'go',
    'he', 'her', 'here', 'hero', 'him', 'his', 'how', 'i', 'if', 'in', 'input', 'is', 'it', 'its', 'me',
    'music', 'my', 'naive', 'of', 'on', 'or', 'our', 'out', 'phone', 'quick', 'she', 'swipe', 'swype',
    'text', 'that', 'the', 'their', 'them', 'then', 'there', 'these', 'they', 'this', 'to', 'type',
    'typing', 'use', 'vocabulary', 'we', 'what', 'when', 'where', 'which', 'who', 'why', 'with', 'word',
    'words', 'world', 'you', 'your', 'doctor', 'architecture', 'agriculture', 'android', 'work'
  ];

  const FREQ_LINES = [
    '10000 THE',
    '9500 OF',
    '9000 AND',
    '8700 TO',
    '8600 A',
    '8500 IN',
    '8400 THAT',
    '8300 IS',
    '8200 IT',
    '8100 YOU',
    '8000 FOR',
    '7900 WITH',
    '7800 ON',
    '7700 AS',
    '7600 ARE',
    '7500 THIS',
    '7400 BE',
    '7300 OR',
    '7200 OUT',
    '7100 OUR',
    '7000 THEY',
    '6900 THERE',
    '6800 THEN',
    '6700 THEIR',
    '6600 THEM',
    '6500 HERE',
    '6400 HELLO',
    '6300 WORLD',
    '6200 QUICK',
    '6100 MUSIC',
    '6000 WORD',
    '5900 WORDS',
    '5800 TYPE',
    '5700 TYPING',
    '5600 SWYPE',
    '5500 SWIPE',
    '5400 INPUT',
    '5300 ANDROID',
    '5200 PHONE',
    '5100 TEXT',
    '5000 DOCTOR',
    '4900 ARCHITECTURE',
    '4800 AGRICULTURE',
    '4700 VOCABULARY',
    '4600 WORK'
  ];

  const sketch = (p) => {
    const MAX_WORD_COUNT = 12;
    let state;

    class Classification {
      constructor(freq = 0) {
        this._freq = freq;
      }
      frequency() { return this._freq; }
      isComplete() { return false; }
      isPartial() { return false; }
    }

    class Complete extends Classification {
      isComplete() { return true; }
    }

    class Partial extends Classification {
      isPartial() { return true; }
    }

    class Partialish extends Classification {
      isPartial() { return true; }
      isComplete() { return true; }
    }

    class Nothing extends Classification {
      isNothing() { return true; }
    }

    class WordSet {
      constructor() {
        this._map = new Map();
        this._partial = new Partial();
        this._nothing = new Nothing();
      }

      exists(s, klass) {
        const existing = this._map.get(s);
        if (existing != null && existing.isComplete()) {
          return new Partialish(existing.frequency());
        }
        return klass;
      }

      populateLines(lines) {
        for (const rawLine of lines) {
          const line = String(rawLine).trim();
          if (!line) continue;

          let word;
          let freq = 0.0;
          const parts = line.split(/\s+/, 2);
          word = parts[0].toUpperCase();

          if (parts.length === 2 && /^\d/.test(parts[0])) {
            freq = Number(parts[0]);
            word = parts[1].toUpperCase();
          }

          for (let j = 1; j < word.length; j++) {
            const partial = word.substring(0, j);
            this._map.set(partial, this.exists(partial, this._partial));
          }

          this._map.set(word, new Complete(freq));
        }
      }

      classify(word) {
        return this._map.get(word) ?? this._nothing;
      }
    }

    class Key {
      static dx = 4;
      static dy = 16;
      static boxDx = 28;
      static boxDy = 20;

      constructor(c, x, y) {
        this._c = c;
        this._x = x;
        this._y = y;
      }

      draw() {
        p.text(this._c, this._x, this._y);
        p.noFill();
        bezierRect(this._x - Key.dx, this._y - Key.dy, Key.boxDx, Key.boxDy, -2, -2);
      }

      left() { return this._x - Key.dx; }
      top() { return this._y - Key.dy; }
      right() { return this.left() + Key.boxDx; }
      bottom() { return this.top() + Key.boxDy; }
      c() { return this._c; }

      hit(x, y) {
        return x > this.left() && x < this.right() && y > this.top() && y < this.bottom();
      }
    }

    class Keyboard {
      static row1 = 'QWERTYUIOP[]\\';
      static row2 = "ASDFGHJKL;'";
      static row3 = 'ZXCVBNM,./';
      static keySpacing = 30;
      static rowSpacing = 25;
      static secondOffset = 15;
      static thirdOffset = Keyboard.secondOffset + 10;

      constructor(x, y) {
        this._row1Keys = [];
        this._row2Keys = [];
        this._row3Keys = [];

        this.populate(Keyboard.row1, this._row1Keys, x, y);
        this.populate(Keyboard.row2, this._row2Keys, x + Keyboard.secondOffset, y + Keyboard.rowSpacing);
        this.populate(Keyboard.row3, this._row3Keys, x + Keyboard.thirdOffset, y + 2 * Keyboard.rowSpacing);
      }

      populate(row, list, x, y) {
        for (let i = 0; i < row.length; i++) {
          list.push(new Key(row.substring(i, i + 1), x, y));
          x += Keyboard.keySpacing;
        }
      }

      drawRow(row) {
        for (const key of row) key.draw();
      }

      rowHit(row, x, y) {
        for (const key of row) {
          if (key.hit(x, y)) return key;
        }
        return null;
      }

      hit(x, y) {
        return this.rowHit(this._row1Keys, x, y)
          ?? this.rowHit(this._row2Keys, x, y)
          ?? this.rowHit(this._row3Keys, x, y)
          ?? null;
      }

      draw() {
        this.drawRow(this._row1Keys);
        this.drawRow(this._row2Keys);
        this.drawRow(this._row3Keys);
      }
    }

    class KeyHitCollector {
      constructor(keyboard, wordset) {
        this._lastKey = null;
        this._keyboard = keyboard;
        this._wordset = wordset;
        this._keys = [];
      }

      reset() {
        this._keys = [];
        this._lastKey = null;
      }

      detect(x, y) {
        const key = this._keyboard.hit(x, y);
        if (key != null && key !== this._lastKey) {
          this._keys.push(key.c());
        }
        this._lastKey = key;
      }

      words() {
        const complete = new Map();
        let prefixes = [];
        let list = [];

        if (this._keys.length === 0) return list;

        prefixes.push(this._keys[0]);
        let klass = this._wordset.classify(prefixes[0]);
        if (klass.isComplete()) {
          complete.set(prefixes[0], klass.frequency());
        }

        for (let i = 1; i < this._keys.length; i++) {
          const ch = this._keys[i];
          const newPrefixes = [];

          for (let j = 0; j < prefixes.length; j++) {
            const prefix = prefixes[j] + ch;
            klass = this._wordset.classify(prefix);

            if (klass.isComplete()) {
              complete.set(prefix, klass.frequency());
            }
            if (klass.isPartial()) {
              newPrefixes.push(prefix);
            }
          }

          prefixes = prefixes.concat(newPrefixes);
        }

        list = Array.from(complete.keys());
        list.sort((a, b) => b.length - a.length);
        while (list.length > MAX_WORD_COUNT) list.pop();
        list.sort((a, b) => (complete.get(b) ?? 0) - (complete.get(a) ?? 0));
        return list;
      }
    }

    class SwipeState {
      constructor() {
        this._keyboard = new Keyboard(30, 330);
        this._wordset = new WordSet();
        this._wordset.populateLines(COMMON_WORDS);
        this._wordset.populateLines(FREQ_LINES);
        this._keyCollector = new KeyHitCollector(this._keyboard, this._wordset);
        this._prevMouseX = -1;
        this._prevMouseY = -1;
        this._path = [];
        this._results = [];
      }

      mouseDragged(x, y) {
        if (this._prevMouseX === -1) {
          this._path.push({ x, y, px: x, py: y, point: true });
        } else {
          this._path.push({ x, y, px: this._prevMouseX, py: this._prevMouseY, point: false });
        }

        this._prevMouseX = x;
        this._prevMouseY = y;
        this._keyCollector.detect(x, y);
      }

      mouseReleased() {
        this._results = this._keyCollector.words();
        this._prevMouseX = -1;
        this._prevMouseY = -1;
        this._path = [];
        this._keyCollector.reset();
      }

      draw() {
        p.background(0);
        p.fill('#ffffff');
        p.stroke('#ffffff');
        p.strokeWeight(1);
        this._keyboard.draw();

        p.push();
        p.fill('#ff0000');
        p.stroke('#ff0000');
        p.strokeWeight(3);
        for (const seg of this._path) {
          if (seg.point) p.point(seg.x, seg.y);
          else p.line(seg.px, seg.py, seg.x, seg.y);
        }
        p.pop();

        p.noStroke();
        p.fill('#ffffff');
        let y = 30;
        for (const word of this._results) {
          p.text(word, 170, y);
          y += 20;
        }
      }
    }

    function bezierRect(x, y, w, h, xr, yr) {
      const w2 = w / 2.0;
      const h2 = h / 2.0;
      const cx = x + w2;
      const cy = y + h2;
      p.beginShape();
      p.vertex(cx, cy - h2);
      p.bezierVertex(cx + w2 - xr, cy - h2, cx + w2, cy - h2 + yr, cx + w2, cy);
      p.bezierVertex(cx + w2, cy + h2 - yr, cx + w2 - xr, cy + h2, cx, cy + h2);
      p.bezierVertex(cx - w2 + xr, cy + h2, cx - w2, cy + h2 - yr, cx - w2, cy);
      p.bezierVertex(cx - w2, cy - h2 + yr, cx - w2 + xr, cy - h2, cx, cy - h2);
      p.endShape();
    }

    p.setup = () => {
      const canvas = p.createCanvas(450, 400);
      canvas.parent('swype-sketch');
      p.frameRate(60);
      p.textFont('sans-serif');
      p.textSize(20);
      state = new SwipeState();
    };

    p.draw = () => {
      state.draw();
    };

    p.mouseDragged = () => {
      state.mouseDragged(p.mouseX, p.mouseY);
    };

    p.mouseReleased = () => {
      state.mouseReleased();
    };

    p.touchMoved = () => {
      state.mouseDragged(p.mouseX, p.mouseY);
      return false;
    };

    p.touchEnded = () => {
      state.mouseReleased();
      return false;
    };
  };

  function mount() {
    const container = document.getElementById('swype-sketch');
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
