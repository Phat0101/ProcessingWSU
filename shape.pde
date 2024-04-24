class Shape {
    float x, y, width, height;
    color c;
    boolean outline;
    float outlineThickness;
    boolean selected;
    
    Shape(float x, float y, float width, float height, color c, boolean outline, float outlineThickness) {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
        this.c = c;
        this.outline = outline;
        this.outlineThickness = outlineThickness;
        this.selected = false;
    }
    
    void draw() {
        // to be implemented in subclasses
    }
    boolean contains(float px, float py) {
        return false;
    }
    boolean intersects(float rx, float ry, float rw, float rh) {
        // This is a default implementation that always returns false.
        return false;
    }
    String toString() {
        return x + "," + y + "," + width + "," + height + "," + red(c) + "," + green(c) + "," + blue(c) + "," + outline + "," + outlineThickness;
    }
}

class Rectangle extends Shape {
    Rectangle(float x, float y, float width, float height, color c, boolean outline, float outlineThickness) {
        super(x, y, width, height, c, outline, outlineThickness);
    }
    
    void draw() {
        if (outline) {
            stroke(0); 
            strokeWeight(outlineThickness);
        } else {
            noStroke();
        }
        fill(c);
        rect(x, y, width, height);
    }
    @Override
    boolean contains(float px, float py) {
        return px >= x && px <= x + width && py >= y && py <= y + height;
    }
    @Override
    boolean intersects(float rx, float ry, float rw, float rh) {
        return !(x > rx + rw || x + width < rx || y > ry + rh || y + height < ry);
    }
    @Override
    String toString() {
        return "Rectangle," + super.toString();
    }
}

class Circle extends Shape {
    Circle(float x, float y, float diameter, color c, boolean outline, float outlineThickness) {
        super(x, y, diameter, diameter, c, outline, outlineThickness);
    }
    
    void draw() {
        if (outline) {
            stroke(0);
            strokeWeight(outlineThickness); 
        } else {
            noStroke();
        }
        fill(c);
        ellipse(x, y, width, height);
    }
    @Override
    boolean contains(float px, float py) {
        float dx = px - x;
        float dy = py - y;
        return dx * dx + dy * dy <= width * width / 4; 
    }
    @Override
    boolean intersects(float rx, float ry, float rw, float rh) {
        float closestX = constrain(x, rx, rx + rw);
        float closestY = constrain(y, ry, ry + rh);
        float dx = x - closestX;
        float dy = y - closestY;
        return dx * dx + dy * dy <= (width / 2) * (width / 2);
    }
    @Override
    String toString() {
        return "Circle," + super.toString();
    }
}

class Ellipse extends Shape {
    Ellipse(float x, float y, float width, float height, color c, boolean outline, float outlineThickness) {
        super(x, y, width, height, c, outline, outlineThickness);
    }
    
    void draw() {
        if (outline) {
            stroke(0); 
            strokeWeight(outlineThickness);
        } else {
            noStroke();
        }
        fill(c);
        ellipse(x, y, width, height);
    }
    @Override
    boolean contains(float px, float py) {
        float dx = 2 * (px - x) / width;
        float dy = 2 * (py - y) / height;
        return dx * dx + dy * dy <= 1;
    }
    @Override
    boolean intersects(float rx, float ry, float rw, float rh) {
        return !(x - width / 2 > rx + rw || x + width / 2 < rx || y - height / 2 > ry + rh || y + height / 2 < ry);
    } 
    @Override
    String toString() {
        return "Ellipse," + super.toString();
    }
}

class Line extends Shape {
    float x2, y2;
    Line(float x, float y, float x2, float y2, color c, boolean outline, float outlineThickness) {
        super(x, y, 0, 0, c, outline, outlineThickness);
        this.x2 = x2;
        this.y2 = y2;
    }
    
    void draw() {
        stroke(c);
        strokeWeight(outlineThickness);
        line(x, y, x2, y2);
        noStroke();
    }
    @Override
    boolean contains(float px, float py) {
        float d = dist(px, py, x, y) + dist(px, py, x2, y2) - dist(x, y, x2, y2);
        return abs(d) < 0.2; // allow for some margin of error
    }
    @Override
    boolean intersects(float rx, float ry, float rw, float rh) {
       return (x >= rx && x <= rx + rw && y >= ry && y <= ry + rh) || (x2 >= rx && x2 <= rx + rw && y2 >= ry && y2 <= ry + rh);
    }
    @Override
    String toString() {
        return "Line," + super.toString() + "," + x2 + "," + y2;
    }
}

class Text extends Shape {
    String text;
    PFont font;
    Text(float x, float y, color c, String text, boolean outline, float outlineThickness) {
        super(x, y, 0, 0, c, outline, outlineThickness);
        this.text = text;
    }
    
    void draw() {
        if (outline) {
            stroke(0); 
        } else {
            noStroke();
        }
        font = createFont("Arial", 20);
        textFont(font);
        fill(c);
        text(this.text, x, y);
    }
    @Override
    boolean contains(float px, float py) {
        float textWidth = textWidth(this.text);
        return px >= x && px <= x + textWidth && py >= y - 20 && py <= y;
    }
    @Override
    boolean intersects(float rx, float ry, float rw, float rh) {
        float textWidth = textWidth(this.text);
        return !(x > rx + rw || x + textWidth < rx || y - 20 > ry + rh || y < ry);
    } 
    @Override
    String toString() {
        return "Text," + super.toString() + "," + text;
    }
}

class ImageShape extends Shape {
    PImage img;
    String imagePath;
    boolean isTint;
    boolean isBlur;

    ImageShape(float x, float y, float width, float height, color c, boolean outline, float outlineThickness, PImage img, String imagePath, boolean isTint, boolean isBlur) {
        super(x, y, width, height, c, outline, outlineThickness);
        this.img = img;
        this.imagePath = imagePath;
        this.isTint = isTint;
        this.isBlur = isBlur;
    }

    void draw() {
    if (isTint) {
        tint(0, 153, 204, 126);
    } 
    if (isBlur) {
        PGraphics pg;
        pg = createGraphics((int)width, (int)height);
        pg.beginDraw();
        pg.image(img, 0, 0, width, height); 
        pg.endDraw();
        pg.filter(BLUR, 5);
        image(pg, x, y); 
    } else {
        image(img, x, y, width, height);
    }
    noTint();
}
    @Override
    boolean contains(float px, float py) {
        return px >= x && px <= x + width && py >= y && py <= y + height;
    }
    @Override
    boolean intersects(float rx, float ry, float rw, float rh) {
        return !(x > rx + rw || x + width < rx || y > ry + rh || y + height < ry);
    }
    @Override
    String toString() {
        return "Image," + super.toString() + "," + imagePath + "," + isTint + "," + isBlur;
    }

}

class Polygon extends Shape {
    int sides;
    float radius;

    Polygon(float x, float y, float width, float height, color colour, boolean outline, float outlineThickness, int sides) {
        super(x, y, width, height, colour, outline, outlineThickness);
        this.sides = sides;
        this.radius = width/2;
    }

    void draw() {
        fill(c);
        if (outline) {
        stroke(0);
        strokeWeight(outlineThickness);
        } else {
        noStroke();
        }
        beginShape();
        for (int i = 0; i < sides; i++) {
        float angle = map(i, 0, sides, 0, TWO_PI);
        float px = x + width/2 * cos(angle);
        float py = y + height/2 * sin(angle);
        vertex(px, py);
        }
        endShape(CLOSE);
    }
    @Override
    boolean contains(float px, float py){
        float angle = TWO_PI / sides;
        boolean odd = false;
        for (int i = 0; i < sides; i++) {
        float x1 = x + width/2 * cos(angle * i);
        float y1 = y + height/2 * sin(angle * i);
        float x2 = x + width/2 * cos(angle * (i + 1));
        float y2 = y + height/2 * sin(angle * (i + 1));
        if ((y1 > py) != (y2 > py) && (px < (x2 - x1) * (py - y1) / (y2 - y1) + x1)) {
            odd = !odd;
        }
        }
        return odd;
    }
    @Override
    boolean intersects(float rx, float ry, float rw, float rh) {
        return !(x - radius > rx + rw || x + radius < rx || y - radius > ry + rh || y + radius < ry);
    }
    @Override
    String toString() {
        return "Polygon," + super.toString() + "," + sides;
    }
}

Shape deepCopyShape(Shape original) {
    if (original instanceof Rectangle) {
        Rectangle rect = (Rectangle) original;
        return new Rectangle(rect.x, rect.y, rect.width, rect.height, rect.c, rect.outline, rect.outlineThickness);
    } else if (original instanceof Circle) {
        Circle circ = (Circle) original;
        return new Circle(circ.x, circ.y, circ.width, circ.c, circ.outline, circ.outlineThickness);
    } else if (original instanceof Ellipse) {
        Ellipse ellip = (Ellipse) original;
        return new Ellipse(ellip.x, ellip.y, ellip.width, ellip.height, ellip.c, ellip.outline, ellip.outlineThickness);
    } else if (original instanceof Line) {
        Line line = (Line) original;
        return new Line(line.x, line.y, line.x2, line.y2, line.c, line.outline, line.outlineThickness);
    } else if (original instanceof Text) {
        Text text = (Text) original;
        return new Text(text.x, text.y, text.c, text.text, text.outline, text.outlineThickness);
    } else if (original instanceof ImageShape) {
        ImageShape imgShape = (ImageShape) original;
        return new ImageShape(imgShape.x, imgShape.y, imgShape.width, imgShape.height, imgShape.c, imgShape.outline, imgShape.outlineThickness, imgShape.img, imgShape.imagePath, imgShape.isTint, imgShape.isBlur);
    } else if (original instanceof Polygon) {
        Polygon poly = (Polygon) original;
        return new Polygon(poly.x, poly.y, poly.width, poly.height, poly.c, poly.outline, poly.outlineThickness, poly.sides);
    } else 
    {
        return null;
    }
}