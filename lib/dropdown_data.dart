// dropdown_data.dart
final List<String> faculties = [
  'Faculty of Engineering',
  'Faculty of Science',
  'Faculty of Arts',
  'Faculty of Commerce',
  'Faculty of Education',
  'Faculty of Architecture',
  'DEI Technical College'
];

final Map<String, List<String>> subfaculties = {
  'Faculty of Engineering': ["1stYear","Electrical","Mechanical","Civil","Footwear","Agriculture","Electrical"],
  'Faculty of Science': ['Subfaculty 3', 'Subfaculty 4'],
  'Faculty of Arts': ['Subfaculty 5', 'Subfaculty 6'],
  'Faculty of Commerce': ['Subfaculty 7', 'Subfaculty 8'],
  'Faculty of Education': ['Subfaculty 9', 'Subfaculty 10'],
  'Faculty of Architecture': ['Subfaculty 11', 'Subfaculty 12'],
  'DEI Technical College': ['Subfaculty 13', 'Subfaculty 14'],
};

final Map<String, List<String>> semesters = {
  '1stYear': [
    'Semester 1',
    'Semester 2',
  ],
  'Electrical': [
    'Semester 1',
    'Semester 2',
    'Semester 3',
    'Semester 4',
    'Semester 5',
    'Semester 6',
    'Semester 7',
    'Semester 8'
  ],
  'Mechanical': [
    'Semester 1',
    'Semester 2',
    'Semester 3',
    'Semester 4',
    'Semester 5',
    'Semester 6',
    'Semester 7',
    'Semester 8'
  ],
  'Civil': [
    'Semester 1',
    'Semester 2',
    'Semester 3',
    'Semester 4',
    'Semester 5',
    'Semester 6',
    'Semester 7',
    'Semester 8'
  ],
  'Footwear': [
    'Semester 1',
    'Semester 2',
    'Semester 3',
    'Semester 4',
    'Semester 5',
    'Semester 6',
    'Semester 7',
    'Semester 8'
  ],
  'Agriculture': [
    'Semester 1',
    'Semester 2',
    'Semester 3',
    'Semester 4',
    'Semester 5',
    'Semester 6',
    'Semester 7',
    'Semester 8'
  ],
  // Add other subfaculties and their semesters here
};

final Map<String, List<String>> subbranches = {
  '1stYear_Semester 1': [
    'NIL',
    'NIL',
  ],
  '1stYear_Semester 2': [
    'NIL',
    'NIL',
  ],
  'Faculty of Engineering_1stYear_Semester 1': [
    'NIL',
  ],
  'Faculty of Engineering_1stYear_Semester 2': [
    'NIL',
  ],
  'Faculty of Engineering_Electrical_Semester 3': [
    'NIL',
  ],
  'Faculty of Engineering_Electrical_Semester 4': [
    'NIL',
  ],
  'Faculty of Engineering_Electrical_Semester 5': [
    'Subbranch 9',
    'Subbranch 10'
  ],
  'Faculty of Engineering_Electrical_Semester 6': [
    'Computer Science',
    'Subbranch 12'
  ],
  'Faculty of Engineering_Electrical_Semester 7': [
    'Subbranch 13',
    'Subbranch 14'
  ],
  'Faculty of Engineering_Electrical_Semester 8': [
    'Subbranch 15',
    'Subbranch 16'
  ],
  'Faculty of Engineering_Mechanical_Semester 3': [
    'NIL',
  ],
  'Faculty of Engineering_Mechanical_Semester 4': [
    'NIL',
  ],
  'Faculty of Engineering_Mechanical_Semester 5': [
    'Subbranch 13',
    'Subbranch 14'
  ],
  'Faculty of Engineering_Mechanical_Semester 6': [
    'Computer Science',
    'Subbranch 16'
  ],
  'Faculty of Engineering_Mechanical_Semester 7': [
    'Subbranch 17',
    'Subbranch 18'
  ],
  'Faculty of Engineering_Mechanical_Semester 8': [
    'Subbranch 19',
    'Subbranch 20'
  ],
  'Faculty of Engineering_Civil_Semester 3': [
    'Subbranch 19',
    'Subbranch 20'
  ],
  'Faculty of Engineering_Civil_Semester 4': [
    'Subbranch 21',
    'Subbranch 22'
  ],
  'Faculty of Engineering_Civil_Semester 5': [
    'Subbranch 23',
    'Subbranch 24'
  ],
  'Faculty of Engineering_Civil_Semester 6': [
    'Subbranch 25',
    'Subbranch 26'
  ],
  'Faculty of Engineering_Civil_Semester 7': [
    'Subbranch 27',
    'Subbranch 28'
  ],
  'Faculty of Engineering_Civil_Semester 8': [
    'Subbranch 29',
    'Subbranch 30'
  ],
  'Faculty of Engineering_Footwear_Semester 3': [
    'Subbranch 31',
    'Subbranch 32'
  ],
  'Faculty of Engineering_Footwear_Semester 4': [
    'Subbranch 33',
    'Subbranch 34'
  ],
  'Faculty of Engineering_Footwear_Semester 5': [
    'Subbranch 35',
    'Subbranch 36'
  ],
  'Faculty of Engineering_Footwear_Semester 6': [
    'Subbranch 37',
    'Subbranch 38'
  ],
  'Faculty of Engineering_Footwear_Semester 7': [
    'Subbranch 39',
    'Subbranch 40'
  ],
  'Faculty of Engineering_Footwear_Semester 8': [
    'Subbranch 41',
    'Subbranch 42'
  ],
  'Faculty of Engineering_Agriculture_Semester 3': [
    'Subbranch 43',
    'Subbranch 44'
  ],
  'Faculty of Engineering_Agriculture_Semester 4': [
    'Subbranch 45',
    'Subbranch 46'
  ],
  'Faculty of Engineering_Agriculture_Semester 5': [
    'Subbranch 47',
    'Subbranch 48'
  ],
  'Faculty of Engineering_Agriculture_Semester 6': [
    'Subbranch 49',
    'Subbranch 50'
  ],
  'Faculty of Engineering_Agriculture_Semester 7': [
    'Subbranch 51',
    'Subbranch 52'
  ],
  'Faculty of Engineering_Agriculture_Semester 8': [
    'Subbranch 53',
    'Subbranch 54'
  ]
  // Add other combinations of faculty, subfaculty, and semester here
};
