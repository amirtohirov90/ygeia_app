import 'package:flutter/material.dart';
import '../models/emotion_sector.dart';

const List<EmotionSector> kEmotions = [
  // Светлые (верх) — оттенки шалфейного
  EmotionSector(name: 'Спокойствие',   color: Color(0xFF8FA89A)),
  EmotionSector(name: 'Радость',       color: Color(0xFF7A9683)),
  EmotionSector(name: 'Благодарность', color: Color(0xFF5B7F6A)),
  EmotionSector(name: 'Любовь',        color: Color(0xFF8A8B7C)),
  EmotionSector(name: 'Интерес',       color: Color(0xFFA89B8E)),
  // Тяжёлые (низ) — оттенки пыльно-розового
  EmotionSector(name: 'Усталость',     color: Color(0xFFB0A0A0)),
  EmotionSector(name: 'Грусть',        color: Color(0xFFC9A8A8)),
  EmotionSector(name: 'Тревога',       color: Color(0xFFD4A5A5)),
  EmotionSector(name: 'Страх',         color: Color(0xFFC59595)),
  EmotionSector(name: 'Гнев',          color: Color(0xFFB58585)),
];
