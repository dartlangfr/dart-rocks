#import('dart:html');

final int LEFT_KEY_CODE = 37;
final int RIGHT_KEY_CODE = 39;
final int SPACE_KEY_CODE = 32;
final int ZERO_KEY_CODE = 48;

void main(){
  Slides slides = new Slides();
  slides.start();
  // Keybord 
  window.on.keyDown.add((KeyboardEvent event) {
    switch(event.keyCode){
      case RIGHT_KEY_CODE:
      case SPACE_KEY_CODE:
        slides.next();
        break;
      case LEFT_KEY_CODE:
        slides.previous();
        break;
      case ZERO_KEY_CODE:
        slides.toggleHelp();
        break;
    }
  });
}

class Slides {
  
  
  String _currentToken;
  int _currentPosition;
  int _slidesNumbers; 
  List<Element> _slides;
  Element _counterBackground;
  Element _counterButton;
  Element _help;
  static final String _CURRENT_CLASS = 'current';
  static final List<String> _PREVIOUS_CLASSES = const ['past', 'far-past', 'distant-slide'];
  static final List<String> _NEXT_CLASSES =  const ['future', 'far-future', 'distant-slide'];
  //static final String START_TOKEN = '#landing-slide';
  
  static final SLIDE_CLASSES = const['distant-slide', 'far-past', 'past', 'current', 'future', 'far-future', 'distant-slide'];
  static final int DISTANCE = 3;
      
  start(){
    // Init
    _currentPosition = 0;
    _slides = document.queryAll('.slide');
    _slidesNumbers = _slides.length;
    _counterBackground = document.query('#presentation-counter');
    _counterButton = document.query("#slide-no");
    document.query('.slides').style.display = 'block';
    _slides.forEach((element) => element.classes.add(SLIDE_CLASSES.last()));
    _help = document.query('#help');
    // Mouse binding
    _bindClick();
    // Go !
   // var elementToken = document.query(token);
    //_currentToken = (elementToken == null) ? START_TOKEN : token;
    //window.location.hash = _currentToken;
    goPosition(_currentPosition, 0);
  }
  
  _bindClick(){
    document.query("#nav-next").on.click.add((e) => next());
    document.query("#nav-prev").on.click.add((e) => previous());
    document.query("#nav-help").on.click.add((e) => toggleHelp());
  }
  
  next(){
    if(_currentPosition < _slidesNumbers-1){
      goPosition(_currentPosition, +1);
    }
  }
  
  previous(){
    if(_currentPosition > 0){
      goPosition(_currentPosition, -1);
    }    
  }
  
  toggleHelp(){
    if(_help.classes.contains('invisible')){
      _help.classes.remove('invisible');
    } else {
      _help.classes.add('invisible');
    }
  }
  
  goPosition(int position, int direction){
    _currentPosition = position+direction;
    // Token
    _currentToken = _slides[_currentPosition].id;
    window.location.hash = '#${_currentToken}';
    // Display current position
    var displayPosition =  (_currentPosition + 1).toString();
    _counterBackground.innerHTML = displayPosition;
    _counterButton.innerHTML = displayPosition;
    // Change slide classes
    var from = Math.max(_currentPosition-DISTANCE, 0);
    var to = Math.min(_currentPosition+DISTANCE, _slidesNumbers-1);
    for(int i = from; i<=to; i++){
      var lastValueIndex = i-_currentPosition+DISTANCE+direction;
      if(lastValueIndex >0 && lastValueIndex<SLIDE_CLASSES.length){
        // Remove
        _slides[i].classes.remove(SLIDE_CLASSES[lastValueIndex]);
      }
      // Add
      _slides[i].classes.add(SLIDE_CLASSES[i-_currentPosition+DISTANCE]);
    }
  }
  
}