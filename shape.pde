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
    boolean intersects(float rx, float ry, float rw, float rh) {
       return (x >= rx && x <= rx + rw && y >= ry && y <= ry + rh) || (x2 >= rx && x2 <= rx + rw && y2 >= ry && y2 <= ry + rh);
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
}

class ImageShape extends Shape {
    PImage img;

    ImageShape(float x, float y, float width, float height, color c, boolean outline, float outlineThickness, PImage img) {
        super(x, y, width, height, c, outline, outlineThickness);
        this.img = img;
    }

    void draw() {
        this.img.resize((int)width, (int)height);
        image(img, x, y, width, height);
    }
    @Override
    boolean contains(float px, float py) {
        return px >= x && px <= x + width && py >= y && py <= y + height;
    }
    @Override
    boolean intersects(float rx, float ry, float rw, float rh) {
        return !(x > rx + rw || x + width < rx || y > ry + rh || y + height < ry);
    }
}