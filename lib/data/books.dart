import '../models/book.dart';

const String kBuyUrl = 'https://t.me/aliyah_the_beloved';

const List<Book> kBooks = [
  Book(
    id: 'basis',
    title: 'Базис',
    pillar: 'body',
    subtitle: 'Тело: фундамент здорового тела',
    description: 'Питание, движение, сон и восстановление. Без диет.',
    priceCurrent: 490,
    priceOld: 2490,
    available: true,
    accentColor: 'sage',
  ),
  Book(
    id: 'zen',
    title: 'Дзен',
    pillar: 'mind',
    subtitle: 'Ум: тишина внутри',
    description: 'Медитация, фокус, работа со стрессом.',
    priceCurrent: null,
    priceOld: null,
    available: false,
    accentColor: 'rose',
  ),
  Book(
    id: 'rhythm',
    title: 'Ритм',
    pillar: 'meaning',
    subtitle: 'Смысл: ритуалы и цели',
    description: 'Утренние ритуалы, благодарность, ясность дня.',
    priceCurrent: 390,
    priceOld: 1990,
    available: true,
    accentColor: 'sage',
  ),
  Book(
    id: 'caliber',
    title: 'Калибр',
    pillar: 'life',
    subtitle: 'Жизнь: окружение и связи',
    description: 'Цифровая гигиена, связи, среда обитания.',
    priceCurrent: null,
    priceOld: null,
    available: false,
    accentColor: 'rose',
  ),
];
