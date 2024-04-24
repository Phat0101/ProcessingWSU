class Menu {
    String currentShape = "Rectangle";
    color currentColor = color(0, 0, 0);
    boolean currentOutline = false;
    float currentOutlineThickness = 1.0;
    String[] shapes = {"Rectangle", "Circle", "Ellipse", "Polygon", "Line", "Text"}; 
    color[] colors = {color(255, 0, 0), color(0, 255, 0), color(0, 0, 255), color(255, 255, 255)}; // add more colors as needed
    boolean[] outlines = {true, false};
    float[] outlineThicknesses = {1.0, 2.0, 3.0};
    PFont font;
    
    void draw() {
      stroke(0);
      strokeWeight(1);
      // draw options for shapes
      for (int i = 0; i < shapes.length; i++) {
          if (currentShape == shapes[i]) {
              fill(200); // highlight the selected shape
          } else {
              fill(255);
          }
          rect(0, i * 50, 100, 50); // draw a button for each shape
          fill(0);
          if (shapes[i] == "Rectangle") {
              rect(25, i * 50 + 15, 50, 20);
          } else if (shapes[i] == "Circle") {
              ellipse(50, i * 50 + 25, 30, 30);
          } else if (shapes[i] == "Ellipse") {
              ellipse(50, i * 50 + 25, 40, 20); 
          } else if (shapes[i] == "Line") {
              line(25, i * 50 + 25, 75, i * 50 + 25); 
          } else if (shapes[i] == "Text") {
              font = createFont("Arial", 20);
              textFont(font);
              text("T", 45, i * 50 + 30);
          } if (shapes[i] == "Polygon") {
              beginShape();
              for (int j = 0; j < 6; j++) {
                float angle = map(j, 0, 6, 0, TWO_PI);
                float px = 50 + 20 * cos(angle);
                float py = i * 50 + 25 + 20 * sin(angle);
                vertex(px, py);
              }
              endShape(CLOSE);
          }
      }
      // draw options for colors
      for (int i = 0; i < colors.length; i++) {
        fill(colors[i]);
        rect(0, (shapes.length + i) * 50, 100, 50); // draw a button for each color
        if (currentColor == colors[i]) {
            fill(0); 
            line(25, (shapes.length + i) * 50 + 25, 40, (shapes.length + i) * 50 + 35);
            line(40, (shapes.length + i) * 50 + 35, 60, (shapes.length + i) * 50 + 15);
        }
      }
      // draw options for outlines
      for (int i = 0; i < outlines.length; i++) {
        fill(255);
        rect(0, (shapes.length + colors.length + i) * 50, 100, 50);
        fill(0); 
        textFont(createFont("Arial", 15));
        text(outlines[i] ? "Outline" : "No Outline", 10, (shapes.length + colors.length + i) * 50 + 30);
        if (currentOutline == outlines[i]) {
          ellipse(90, (shapes.length + colors.length + i) * 50 + 25, 10, 10); // draw a small circle as an indicator
        }
      } 
      // draw options for outline thickness
      for (int i = 0; i < outlineThicknesses.length; i++) {
        fill(outlineThicknesses[i] == currentOutlineThickness ? 200 : 255);
        rect(0, (shapes.length + colors.length + outlines.length + i) * 50, 100, 50);
        stroke(0); 
        strokeWeight(outlineThicknesses[i]); // set the thickness of the line
        line(10, (shapes.length + colors.length + outlines.length + i) * 50 + 25, 90, (shapes.length + colors.length + outlines.length + i) * 50 + 25); // draw a line
        if (currentOutlineThickness == outlineThicknesses[i]) {
            fill(0); 
            ellipse(90, (shapes.length + colors.length + outlines.length + i) * 50 + 25, 10, 10); // draw a small circle as an indicator
        }
        strokeWeight(1); 
      }  
      noStroke();
    }
    
    void selectShape(String shape) {
        currentShape = shape;
    }
    
    void selectColor(color c) {
        currentColor = c;
    }

     void selectOutline(boolean outline) {
        currentOutline = outline;
    }

    void selectOutlineThickness(float thickness) {
        currentOutlineThickness = thickness;
    }
    
    boolean isMouseOutsideMenu() {
        return mouseX > 100 ;
    }

    void mousePressed() {
    for (int i = 0; i < shapes.length; i++) {
      if (mouseY > i * 50 && mouseY < (i + 1) * 50 && mouseX > 0 && mouseX < 100) {
        selectShape(shapes[i]);
      }
    }
    for (int i = 0; i < colors.length; i++) {
      if (mouseY > (shapes.length + i) * 50 && mouseY < (shapes.length + i + 1) * 50 && mouseX > 0 && mouseX < 100) {
        selectColor(colors[i]);
      }
    }
    for (int i = 0; i < outlines.length; i++) {
        if (mouseY > (shapes.length + colors.length + i) * 50 && mouseY < (shapes.length + colors.length + i + 1) * 50 && mouseX > 0 && mouseX < 100) {
          selectOutline(outlines[i]);
        }
    }
    for (int i = 0; i < outlineThicknesses.length; i++) {
            if (mouseY > (shapes.length + colors.length + outlines.length + i) * 50 && mouseY < (shapes.length + colors.length + outlines.length + i + 1) * 50 && mouseX > 0 && mouseX < 100) {
              selectOutlineThickness(outlineThicknesses[i]);
            }
      }
  }
}

class MenuExtra {
  String[] options = {"Area select","Move", "Resize", "Delete", "Save", "Read", "Tint", "Blur"};
  String currentOption = null;

  void draw() {
    stroke(0);
    strokeWeight(1);
    // draw options
    for (int i = 0; i < options.length; i++) {
      if (currentOption == options[i]) {
        fill(200); 
      } else {
        fill(255);
      }
      rect((i+1) * 100, 0, 100, 50); // draw a button for each option
      fill(0);
      textFont(createFont("Arial", 15));
      text(options[i], (i+1) * 100 + 20, 30);
    }
    noStroke();
  }

  void selectOption(String option) {
    currentOption = option;
  }

  boolean isMouseOutsideMenu() {
    return mouseY > 50;
  }

  void mousePressed() {
    for (int i = 0; i < options.length; i++) {
      if (mouseX > (i+1) * 100 && mouseX < (i + 2) * 100 && mouseY > 0 && mouseY < 50) {
        if (currentOption == options[i]) {
          currentOption = null;
        } else {
          selectOption(options[i]);
        }
      }
    }
  }
}