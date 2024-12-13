// 1 -> MultipleChoices , 2 -> Binary , 3 -> Slider , 4 -> Note , 5 -> MultipleAnswer

//"MultipleChoices" , "Binary" , "Slider", "Note", "MultipleAnswer"
class SurveyOptionTypes{
  static final Pair idMultipleChoices = Pair(1,'MultipleChoices');
  static final Pair idBinary = Pair(2,'Binary');
  static final Pair idSlider = Pair(3,'Slider');
  static final Pair idNote = Pair(4,'Note');
  static final Pair idMultipleAnswer = Pair(5,'MultipleAnswer');

  static List<Pair> get optionTypes => [idMultipleChoices,idBinary,idSlider,idNote,idMultipleAnswer];
}

class Pair{
  int id;
  String name;
  Pair(this.id,this.name);
}