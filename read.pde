import java.io.IOException;

class ReadShape {
    String filePath;

    ReadShape(String filePath) {
        this.filePath = filePath;
    } 

    ArrayList<Shape> readShapes() { 
        ArrayList<Shape> shapes = new ArrayList<Shape>(); 
        try {
            String[] lines = loadStrings("shapes.txt"); 
            for (String line : lines) { 
                String[] parts = line.split(","); 
                String shapeType = parts[0]; 
                float x = Float.parseFloat(parts[1]); 
                float y = Float.parseFloat(parts[2]);
                float width = Float.parseFloat(parts[3]);
                float height = Float.parseFloat(parts[4]);
                color colour = color(Float.parseFloat(parts[5]), Float.parseFloat(parts[6]), Float.parseFloat(parts[7]));
                boolean outline = Boolean.parseBoolean(parts[8]);
                float outlineThickness = Float.parseFloat(parts[9]);
                if (shapeType.equals("Rectangle")) {
                    shapes.add(new Rectangle(x, y, width, height, colour, outline, outlineThickness));
                } else if (shapeType.equals("Circle")) {
                    shapes.add(new Circle(x, y, width, colour, outline, outlineThickness));
                } else if (shapeType.equals("Ellipse")) {
                    shapes.add(new Ellipse(x, y, width, height, colour, outline, outlineThickness));
                } else if (shapeType.equals("Text")) {
                    String text = parts[10];
                    shapes.add(new Text(x, y, colour, text, outline, outlineThickness));
                } else if (shapeType.equals("Line")) {
                    float x2 = Float.parseFloat(parts[10]);
                    float y2 = Float.parseFloat(parts[11]);
                    shapes.add(new Line(x, y, x2, y2, colour, outline, outlineThickness));
                } else if (shapeType.equals("Image")) {
                    String imagePath = parts[10];
                    boolean isTint = Boolean.parseBoolean(parts[11]);
                    boolean isBlur = Boolean.parseBoolean(parts[12]);
                    PImage img = loadImage(imagePath);
                    shapes.add(new ImageShape(x, y, width, height, colour, outline, outlineThickness, img, imagePath, isTint, isBlur));
                } else if (shapeType.equals("Polygon")) {
                    int sides = Integer.parseInt(parts[10]);
                    shapes.add(new Polygon(x, y, width, height, colour, outline, outlineThickness, sides));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return shapes;
    }
}
