#import('dart:html');

final int LEFT_KEY_CODE = 37;
final int RIGHT_KEY_CODE = 39;

void main(){
  Slides slides = new Slides();
  slides.start();
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
  
  int _currentPosition;
  int _slidesNumbers; 
  List<Element> _slides;
  Element _counter;
  //List<String> _states = const ['distant-slide', 'far-past', ];
      
  start(){
    _currentPosition = 0;
    _slides = document.queryAll('.slide');
    _slidesNumbers = _slides.length;
    _counter = document.query('#presentation-counter');
    document.query('.slides').style.display = 'block';
    goPosition(_currentPosition, _currentPosition);
  }
  
  next(){
    if(_currentPosition < _slidesNumbers-1){
      goPosition(_currentPosition, _currentPosition+1);
    }
  }
  
  previous(){
    if(_currentPosition > 0){
      goPosition(_currentPosition, _currentPosition-1);
    }    
  }
  
  goPosition(int _fromPosition, int _toPosition){
    _currentPosition = _toPosition;
    _counter.innerHTML = (_currentPosition + 1).toString();
    _slides[_fromPosition].classes.remove('current');
    _slides[_currentPosition].classes.add('current');
  }
  
}