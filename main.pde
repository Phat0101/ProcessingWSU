ArrayList<Shape> shapes = new ArrayList<Shape>();
Menu menu = new Menu();
MenuExtra menuExtra = new MenuExtra();
Shape newShape;
boolean isDrawing = false;
Shape selectedShape = null;
Rectangle selectionRectangle = null;
ArrayList<Shape> selectedShapes = new ArrayList<Shape>();
ArrayList<Shape> copiedShapes = new ArrayList<Shape>();
float prevMouseX, prevMouseY;


void setup() {
    size(1000, 800);
    background(255);
}

void draw() {
    background(255);
    noStroke();
    menu.draw();
    menuExtra.draw();
    for (Shape shape : shapes) {
        shape.draw();
    }
    // If a shape is being drawn, draw it
    if (isDrawing && newShape != null) {
        newShape.draw();
    }  
    if (selectionRectangle != null) {
        selectionRectangle.draw();
    } 
}

void addShape(Shape shape) {
    shapes.add(shape);
}

void saveShapes() {
    String[] data = new String[shapes.size()];
    for (int i = 0; i < shapes.size(); i++) {
        Shape shape = shapes.get(i);
        data[i] = shape.toString();
    }
    saveStrings("shapes.txt", data);
}

void readShapes(String filename) {
    ReadShape read = new ReadShape(filename);
    shapes = read.readShapes();
}

void mousePressed() {
    prevMouseX = mouseX;
    prevMouseY = mouseY;
    menu.mousePressed();
    menuExtra.mousePressed();
    // Start drawing a new shape at the mouse position when the mouse is pressed
    if (menu.isMouseOutsideMenu() && menuExtra.isMouseOutsideMenu() && menu.currentShape != null) {
        if (menu.currentShape == "Rectangle") {
            newShape = new Rectangle(mouseX, mouseY, 0, 0, menu.currentColor, menu.currentOutline, menu.currentOutlineThickness);
        } else if (menu.currentShape == "Circle") {
            newShape = new Circle(mouseX, mouseY, 0, menu.currentColor, menu.currentOutline, menu.currentOutlineThickness);
        } else if (menu.currentShape == "Ellipse") {
            newShape = new Ellipse(mouseX, mouseY, 0, 0, menu.currentColor, menu.currentOutline, menu.currentOutlineThickness);
        } else if (menu.currentShape == "Line") {
            newShape = new Line(mouseX, mouseY, mouseX, mouseY, menu.currentColor, menu.currentOutline, menu.currentOutlineThickness);
        } else if (menu.currentShape == "Text") {
            newShape = new Text(mouseX, mouseY, menu.currentColor, "", menu.currentOutline, menu.currentOutlineThickness);
        } else if (menu.currentShape == "Polygon") {
            newShape = new Polygon(mouseX, mouseY, 100, 100, menu.currentColor, menu.currentOutline, menu.currentOutlineThickness, 6);
        }
        isDrawing = true;
    }
    // Select a shape if the mouse is pressed on it
    if (menuExtra.currentOption == "Move" || menuExtra.currentOption == "Resize" || menuExtra.currentOption == "Delete" || menuExtra.currentOption == "Tint" || menuExtra.currentOption == "Blur"){
        for (Shape shape : shapes) {
                if (shape.contains(mouseX, mouseY)) {
                    selectedShape = shape;
                    break;
                }
        }
        menu.currentShape = null;
    }

    if (menu.isMouseOutsideMenu() && menuExtra.isMouseOutsideMenu() && selectedShape == null && menuExtra.currentOption == "Area select") {
        selectionRectangle = new Rectangle(mouseX, mouseY, 0, 0, color(255,255,255, 63), true, 1.0);
        menu.currentShape = null;
        selectedShapes.clear();
    }
    if (menuExtra.currentOption == "Save") {
        saveShapes();
    }
    if (menuExtra.currentOption == "Read"){
        selectInput("Select a file to read:", "fileSelectedForRead");
    }
    if (menuExtra.currentOption == "Tint" && selectedShape instanceof ImageShape){
        for (Shape shape : shapes){
            if (shape.contains(mouseX, mouseY)){
                ((ImageShape) shape).isTint = !((ImageShape) selectedShape).isTint;

            }
        }
    }
    if (menuExtra.currentOption == "Blur" && selectedShape instanceof ImageShape){
        for (Shape shape : shapes){
            if (shape.contains(mouseX, mouseY)){
                ((ImageShape) shape).isBlur = !((ImageShape) selectedShape).isBlur;
            }
        }
    }

}

void mouseDragged() {
    // If a shape is being drawn, update its size
    if (isDrawing && newShape != null) {
        if (newShape instanceof Rectangle) {
            ((Rectangle) newShape).width = mouseX - newShape.x;
            ((Rectangle) newShape).height = mouseY - newShape.y;
        } else if (newShape instanceof Circle) {
            ((Circle) newShape).width = dist(newShape.x, newShape.y, mouseX, mouseY)*1.9;
            ((Circle) newShape).height = dist(newShape.x, newShape.y, mouseX, mouseY)*1.9;
        } else if (newShape instanceof Ellipse) {
            ((Ellipse) newShape).width = (mouseX - newShape.x)*1.9;
            ((Ellipse) newShape).height = (mouseY - newShape.y)*1.9;
        } else if (newShape instanceof Line) {
            ((Line) newShape).x2 = mouseX;
            ((Line) newShape).y2 = mouseY;
        } else if (newShape instanceof Polygon) {
            ((Polygon) newShape).width = (mouseX - newShape.x)*1.9;
            ((Polygon) newShape).height = (mouseY - newShape.y)*1.9;
        }
    }
    if (selectedShape != null && menuExtra.currentOption == "Move" && selectedShapes.size() == 0){
        selectedShape.x = mouseX - prevMouseX + selectedShape.x;
        selectedShape.y = mouseY - prevMouseY + selectedShape.y;
        if (selectedShape instanceof Line) {
            ((Line) selectedShape).x2 += mouseX - prevMouseX;
            ((Line) selectedShape).y2 += mouseY - prevMouseY;
        }
    }
    if (selectedShape != null && menuExtra.currentOption == "Resize") {
        if (selectedShape instanceof Rectangle) {
            ((Rectangle) selectedShape).width = mouseX - selectedShape.x;
            ((Rectangle) selectedShape).height = mouseY - selectedShape.y;
        } else if (selectedShape instanceof Circle) {
            ((Circle) selectedShape).width = dist(selectedShape.x, selectedShape.y, mouseX, mouseY)*1.9;
            ((Circle) selectedShape).height = dist(selectedShape.x, selectedShape.y, mouseX, mouseY)*1.9;
        } else if (selectedShape instanceof Ellipse) {
            ((Ellipse) selectedShape).width = (mouseX - selectedShape.x)*1.9;
            ((Ellipse) selectedShape).height = (mouseY - selectedShape.y)*1.9;
        } else if (selectedShape instanceof Line) {
            ((Line) selectedShape).x2 = mouseX;
            ((Line) selectedShape).y2 = mouseY;
        } else if (selectedShape instanceof ImageShape) {
            ((ImageShape) selectedShape).width = mouseX - selectedShape.x;
            ((ImageShape) selectedShape).height = mouseY - selectedShape.y;
        } else if (selectedShape instanceof Polygon) {
            ((Polygon) selectedShape).width = (mouseX - selectedShape.x)*1.9;
            ((Polygon) selectedShape).height = (mouseY - selectedShape.y)*1.9;
        }
    }
    if (selectionRectangle != null) {
        selectionRectangle.width = mouseX - selectionRectangle.x;
        selectionRectangle.height = mouseY - selectionRectangle.y;
    }
    if (menuExtra.currentOption == "Move") {
        for (Shape shape : shapes){
            if (selectedShapes.contains(shape)){
                shape.x += mouseX - prevMouseX;
                shape.y += mouseY - prevMouseY;
                if (shape instanceof Line) {
                    ((Line) shape).x2 += mouseX - prevMouseX;
                    ((Line) shape).y2 += mouseY - prevMouseY;
                }
            }
        }
    }
    if (selectedShapes.size() > 0 && menuExtra.currentOption == "Resize") {
        for (Shape shape : selectedShapes) {
            if (shape instanceof Rectangle) {
                ((Rectangle) shape).width += mouseX - prevMouseX;
                ((Rectangle) shape).height += mouseY - prevMouseY;
            } else if (shape instanceof Circle) {
                ((Circle) shape).width += (mouseX - prevMouseX + mouseY - prevMouseY) / 2;
                ((Circle) shape).height = ((Circle) shape).width;
            } else if (shape instanceof Ellipse) {
                ((Ellipse) shape).width += mouseX - prevMouseX;
                ((Ellipse) shape).height += mouseY - prevMouseY;
            } else if (shape instanceof Line) {
                ((Line) shape).x2 += mouseX - prevMouseX;
                ((Line) shape).y2 += mouseY - prevMouseY;
            } else if (selectedShape instanceof ImageShape) {
                ((ImageShape) selectedShape).width = mouseX - selectedShape.x;
                ((ImageShape) selectedShape).height = mouseY - selectedShape.y;
            } else if (shape instanceof Polygon) {
                ((Polygon) shape).width += mouseX - prevMouseX;
                ((Polygon) shape).height += mouseY - prevMouseY;
            }
        }
    }
  prevMouseX = mouseX;
  prevMouseY = mouseY;
}

void mouseReleased() {
    // Finish drawing the shape when the mouse is released
    if (isDrawing && newShape != null && !(newShape instanceof Text)) { // so not intefere with text input
        addShape(newShape);
        newShape = null;
        isDrawing = false;
    }
    if (menuExtra.currentOption == "Move" || menuExtra.currentOption == "Resize" ){
        selectedShape = null;
    }
    // Select shapes that are inside the selection rectangle
    if (selectionRectangle != null) {
        for (Shape shape : shapes) {
            if (shape.intersects(selectionRectangle.x, selectionRectangle.y, selectionRectangle.width, selectionRectangle.height)) {
                selectedShapes.add(shape);
            }
        }
        selectionRectangle = null;
    }
    if (selectedShape!=null && menuExtra.currentOption == "Delete") {
        shapes.remove(selectedShape);
        selectedShape = null;
    }
    if (selectedShapes.size() > 0 && menuExtra.currentOption == "Delete") {
        for (Shape shape : selectedShapes) {
            shapes.remove(shape);
        }
        selectedShapes.clear();
    }
}

void keyPressed() {
    if (isDrawing && key == ENTER) {
        addShape(newShape);
        newShape = null;
        isDrawing = false;
    } else if (isDrawing && key == BACKSPACE ) {
        if (newShape instanceof Text) {
            ((Text) newShape).text = ((Text) newShape).text.substring(0, ((Text) newShape).text.length() - 1);
        }
    } else
    if (isDrawing && newShape instanceof Text) {
        ((Text) newShape).text += key; 
    }
    if (selectedShapes.size() > 0 && key == ENTER){
        selectedShapes.clear();
    }
    // for open image
    if (key == 'i') {
        selectInput("Select an image file:", "imageSelected");
    }
    // for copy and paste
    if (key == 'c') {
        copiedShapes.clear();
        if (selectedShapes.size() > 0) {
            for (Shape shape : selectedShapes) {
                Shape copy = deepCopyShape(shape);
                copiedShapes.add(copy);
            }
        }
    }
    if (key == 'v') {
        selectedShapes.clear();
        for (Shape shape : copiedShapes) {
            shape.x +=10;
            shape.y +=10;
            shapes.add(shape);
            selectedShapes.add(shape);
        }
    }
}

void imageSelected(File selection) {
    if (selection == null) {
        println("No file was selected.");
    } else {
        PImage img = loadImage(selection.getAbsolutePath());
        float width = min(img.width, 200);
        float height = min(img.height, 200);
        ImageShape imageShape = new ImageShape(mouseX, mouseY, width, height, color(255), false, 1, img, selection.getAbsolutePath(), false, false);
        addShape(imageShape);
    }
}

void fileSelectedForRead(File selection) {
    if (selection == null) {
        println("No file was selected.");
    } else {
        readShapes(selection.getAbsolutePath());
    }
}