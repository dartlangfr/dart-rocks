import 'dart:html';
import 'dart:math' as Math;

void main(){
  Slides slides = new Slides();
  slides.start();
  // Keybord 
  window.onKeyDown.listen((KeyboardEvent e) {
    var event = new KeyEvent(e);
    switch(event.keyCode){
      case KeyCode.RIGHT:
      case KeyCode.SPACE:
        slides.next();
        break;
      case KeyCode.LEFT:
        slides.previous();
        break;
      case KeyCode.NUM_ZERO:
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
  static final String _SUMMARY = "table-of-contents";
  
  static final SLIDE_CLASSES = const['distant-slide', 'far-past', 'past', 'current', 'future', 'far-future', 'distant-slide'];
  static final int DISTANCE = 3;
      
  start(){
    _loadSlides();
    // Init
    _currentPosition = 0;
    _slides = queryAll('.slide');
    _slidesNumbers = _slides.length;
    _counterBackground = query('#presentation-counter');
    _counterButton = query("#slide-no");
    query('.slides').style.display = 'block';
    _slides.forEach((element) => element.classes.add(SLIDE_CLASSES.last));
    _help = query('#help');
    // Summary
    _buildSummary();
    // Mouse binding
    _bindClick();
    // Go !
    goPosition(_currentPosition, 0);
  }
  
  _bindClick(){
    query('#nav-next').onClick.listen((e) => next());
    query('#nav-prev').onClick.listen((e) => previous());
    query('#nav-help').onClick.listen((e) => toggleHelp());
    query('#nav-toc').onClick.listen((e) => goId(_SUMMARY));
  }
  
  _buildSummary(){
    List<Element> transitionSlides = queryAll('.transitionSlide');
    StringBuffer buffer = new StringBuffer();
    transitionSlides.forEach((e) {
      ImageElement img = e.query('img');
      buffer.write('<li><a data-hash="${e.id}">${e.query('h2').innerHtml}</a>'); 
      buffer.write('<img src="${img.src.replaceAll('_64', '_32')}"></li>'); 
    });
    Element tocList =  query('#toc-list');
    tocList.innerHtml = buffer.toString();
    tocList.queryAll('li a').forEach((element) => element.onClick.listen((event) => goId(element.dataset['hash'])));
  }
  
  next(){
    if(_currentPosition < _slidesNumbers-1){
      goPosition(_currentPosition, 1);
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
    _counterBackground.innerHtml = displayPosition;
    _counterButton.innerHtml = displayPosition;
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
  
  goId(String id){
    Element element = _slides.firstWhere((e)  => e.id == id);
    int index = _slides.indexOf(element);
    // Neighboorhound become distant
    var from = Math.max(_currentPosition-DISTANCE, 0);
    var to = Math.min(_currentPosition+DISTANCE, _slidesNumbers-1); 
    for(int i = from; i<=to; i++){
      var lastValueIndex = i-_currentPosition+DISTANCE;
      if(lastValueIndex >0 && lastValueIndex<SLIDE_CLASSES.length){
        _slides[i].classes.remove(SLIDE_CLASSES[lastValueIndex]);
      }
      // Add
      _slides[i].classes.add(SLIDE_CLASSES.last);
    }
    // go
    goPosition(index, 0);
   }
  
  _loadSlides(){
   _loadLocalStorageMessage(); 
   _textWrapping();
   _cssColumns();
   _cssStroke();
   _cssOpacity();
   _cssColor();
   _roundedCorners();
   _cssGradient();
   _cssShadow();
   _logoDemo();
   _cssBackground();
  }
  
  _loadLocalStorageMessage(){
    TextAreaElement area = query('#ta');
    if(area.value.isEmpty){
      area.value = window.localStorage.$dom_getItem('value');
    }
    query('#save-ta').onClick.listen((e) {
      window.localStorage['value'] = area.value;
      var now = new DateTime.now();
      window.localStorage['timestamp'] = now.millisecondsSinceEpoch.toString();
    });
  }

  _textWrapping(){
    query('#tw-range').onChange.listen((event) {
      InputElement input =  event.target;
      num value = input.valueAsNumber;
      query('#wrapping').style.width = '$value%';
    });    
  }  
  
  _cssColumns(){
    query('#cco-range').onChange.listen((event) {
      InputElement input = event.target;
      var value = input.valueAsNumber.toInt().toString();
      query('#columns-no-value').text = value;
      var el = query('#columns-no-example');
      el.style.columnCount = value;
    }); 
   }
  
  _cssStroke(){
    InputElement input = query('#text-stroke');
    input.onChange.listen((event) {
      var width = input.valueAsNumber * 0.25;
      query('#text-stroke-example').style.textStrokeWidth = '${width}px';
      query('#text-stroke-value').text = width.toString();
    });
  }
    
    _cssOpacity(){
      query('#opacity-color').onChange.listen((e) => _changeCssOpacity(e));
      query('#opacity-background').onChange.listen(_changeCssOpacity); 
    }
    
  _changeCssOpacity(Event e){
      InputElement inputColor = query('#opacity-color');
      var textOpacity = inputColor.valueAsNumber / 100;
      InputElement inputBackground = query('#opacity-background');
      var backgroundOpacity = inputBackground.valueAsNumber / 100;
      var el = query('#opacity-example');
      
      el.style.color = 'rgba(255, 0, 0, $textOpacity)';
      el.style.background = 'rgba(0, 0, 255, $backgroundOpacity)';
      
      query('#opacity-color-value').text = textOpacity.toString();
      query('#opacity-background-value').text = backgroundOpacity.toString();
  }
  
  _cssColor(){
    query('#hsl-h').onChange.listen(_changeHSL);
    query('#hsl-s').onChange.listen(_changeHSL);
    query('#hsl-l').onChange.listen(_changeHSL);
    query('#hsl-a').onChange.listen(_changeHSL);              
  }
  
 _changeHSL(Event e) {
   InputElement input;
   input = query('#hsl-h');
   final h = (input.valueAsNumber * 1.0).toInt();
   input = query('#hsl-s');
   final s = (input.valueAsNumber * 1.0).toInt();
   input = query('#hsl-l');
   final l = (input.valueAsNumber * 1.0).toInt();
   input = query('#hsl-a');
   final a = input.valueAsNumber / 100;
   final el = query('#hsl-example');
   
   el.style.color = 'hsla($h, $s%, $l%, $a)';
   
   query('#hsl-h-value').text = '$h';
   query('#hsl-s-value').text = '$s%,';
   query('#hsl-l-value').text = '$l%,';
   query('#hsl-a-value').text = '$a);';
 }
 
 _roundedCorners(){
   query('#face-rounded-border').onChange.listen(_handleCorner);
   query('#lefteye-rounded-border').onChange.listen(_handleCorner);
   query('#righteye-rounded-border').onChange.listen(_handleCorner);
   query('#base_white-rounded-border').onChange.listen(_handleCorner);
   query('#mouth-rounded-border').onChange.listen(_handleCorner);
   query('#nose-rounded-border').onChange.listen(_handleCorner);
   query('#leftblackeye-rounded-border').onChange.listen(_handleCorner);
   query('#rightblackeye-rounded-border').onChange.listen(_handleCorner);  
 }

  _handleCorner(Event e) {
   final elements = ["face", "lefteye", "righteye", "base_white", "mouth", "nose", "leftblackeye", "rightblackeye"];
   for (final el in elements) {
     final element =  '$el-rounded-border';
     InputElement input = query('#$element');
     final borderVal = input.value;
     query('#$element-value').text = borderVal;
     final faceEl = query('#$el');
     faceEl.style.borderRadius =  '${borderVal}px';
   }
  } 
  
  _cssGradient(){
    query("#gradients-radial").onChange.listen((e) {
      var size = (query('#gradients-radial') as InputElement).value;
      query('#gradients-radial-example').style.background = '-webkit-gradient(radial, 430 50, 0, 430 50, $size, from(red), to(#000))';
      query('#gradients-radial-value').text = size;
      
    });
    
  }
  
  _cssShadow(){
    query('#shadows-text-x').onChange.listen(_changeShadow);
    query('#shadows-text-y').onChange.listen(_changeShadow);
    query('#shadows-text-size').onChange.listen(_changeShadow);
    query('#shadows-box-x').onChange.listen(_changeShadow);     
    query('#shadows-box-y').onChange.listen(_changeShadow);   
    query('#shadows-box-size').onChange.listen(_changeShadow);   
  }
  
  _changeShadow(e){
    var el = query('#shadow-example');

    var textXVal = (query('#shadows-text-x') as InputElement).value;
    var textYVal = (query('#shadows-text-y') as InputElement).value;
    var textSizeVal = (query('#shadows-text-size') as InputElement).value;

    query('#shadows-text-x-value').text = textXVal;
    query('#shadows-text-y-value').text = textYVal;
    query('#shadows-text-size-value').text = textSizeVal;

    var boxXVal = (query('#shadows-box-x') as InputElement).value;
    var boxYVal = (query('#shadows-box-y') as InputElement).value;
    var boxSizeVal = (query('#shadows-box-size') as InputElement).value;

    query('#shadows-box-x-value').text = boxXVal;
    query('#shadows-box-y-value').text = boxYVal;
    query('#shadows-box-size-value').text = boxSizeVal;

    el.style.textShadow = 'rgba(64, 64, 64, 0.5)  ${textXVal}px ${textYVal}px ${textSizeVal}px';
    el.style.boxShadow = 'rgba(0, 0, 128, 0.25) ${boxXVal}px ${boxYVal}px ${boxSizeVal}px';
  }
  
  _logoDemo(){
    query("#web20-shadow").onChange.listen(_changeWeb20);
    query("#web20-gradient").onChange.listen(_changeWeb20);
    query("#web20-border").onChange.listen(_changeWeb20);
    query("#web20-reflect").onChange.listen(_changeWeb20);
  }
  
  _changeWeb20(e){
    var el = query('#web20-google');

    var textShadowVal = (query('#web20-shadow') as InputElement).value;
    query('#web20-shadow-value-1').text = textShadowVal;
    query('#web20-shadow-value-2').text = textShadowVal;

    var gradientVal = int.parse((query('#web20-gradient') as InputElement).value) / 100;
    query('#web20-gradient-value-1').text = gradientVal.toString();
    query('#web20-gradient-value-2').text = gradientVal.toString();

    var borderVal = (query('#web20-border') as InputElement).value;
    query('#web20-border-value').text = borderVal;

    var reflectVal = int.parse((query('#web20-reflect') as InputElement).value) / 100;
    query('#web20-reflect-value').text = reflectVal.toString();

    el.style.textShadow = 'rgba(0, 0, 0, 0.5) 0 ${textShadowVal}px ${textShadowVal}px';
    el.style.background = '-webkit-gradient(linear, left top, left bottom, from(rgba(200, 200, 240, $gradientVal)), to(rgba(255, 255, 255, $gradientVal)))';
    el.style.borderRadius = '${borderVal}px';
    el.style.boxReflect = 'below 10px -webkit-gradient(linear, left top, left bottom, from(transparent), to(rgba(255, 255, 255, ${reflectVal})))';    
  }
  
  _cssBackground() =>
    query("#css-background-select").onChange.listen((Event e) =>
      query("#background-textarea").style.backgroundSize = (e.target as SelectElement).value);
 
}