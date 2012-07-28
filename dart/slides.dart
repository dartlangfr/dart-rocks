#import('dart:html');

final int LEFT_KEY_CODE = 37;
final int RIGHT_KEY_CODE = 39;

void main(){
  print('running');
  Slides slides = new Slides();
  window.on.keyDown.add((KeyboardEvent event) {
    switch(event.keyCode){
      case RIGHT_KEY_CODE:
        slides.next();
        break;
      case LEFT_KEY_CODE:
        slides.previous();
        break;
    }
  });
}

class Slides {
  
  next(){
  }
  
  previous(){
  }
  
}