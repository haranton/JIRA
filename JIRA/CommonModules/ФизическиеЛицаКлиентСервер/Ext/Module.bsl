﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Раскладывает полное имя физического лица на составные части - фамилию, имя и отчество.
// Если в конце полного имени встречаются "оглы", "улы", "уулу", "кызы" или "гызы",
// то они также считаются частью отчества.
//
// Параметры:
//  ФамилияИмяОтчество - Строка - полное имя в виде "Фамилия Имя Отчество".
//
// Возвращаемое значение:
//  Структура:
//   * Фамилия  - Строка - фамилия;
//   * Имя      - Строка - имя;
//   * Отчество - Строка - отчество.
//
// Пример:
//   1. ФизическиеЛицаКлиентСервер.ЧастиИмени("Иванов Иван Иванович") 
//   вернет структуру со значениями свойств: "Иванов", "Иван", "Иванович".
//   2. ФизическиеЛицаКлиентСервер.ЧастиИмени("Смит Джон") 
//   вернет структуру со значениями свойств: "Смит", "Джон", "".
//   3. ФизическиеЛицаКлиентСервер.ЧастиИмени("Алиев Ахмед Октай оглы") 
//   вернет структуру со значениями свойств: "Алиев", "Ахмед", "Октай оглы".
//
Функция ЧастиИмени(ФамилияИмяОтчество) Экспорт
	
	Результат = Новый Структура("Фамилия,Имя,Отчество");
	
	ЧастиИмени = СтрРазделить(ФамилияИмяОтчество, " ", Ложь);
	
	Если ЧастиИмени.Количество() >= 1 Тогда
		Результат.Фамилия = ЧастиИмени[0];
	КонецЕсли;
	
	Если ЧастиИмени.Количество() >= 2 Тогда
		Результат.Имя = ЧастиИмени[1];
	КонецЕсли;
	
	Если ЧастиИмени.Количество() >= 3 Тогда
		Результат.Отчество = ЧастиИмени[2];
	КонецЕсли;
	
	Если ЧастиИмени.Количество() > 3 Тогда
		ДополнительныеЧастиОтчества = Новый Массив;
		ДополнительныеЧастиОтчества.Добавить(НСтр("ru = 'оглы'"));
		ДополнительныеЧастиОтчества.Добавить(НСтр("ru = 'улы'"));
		ДополнительныеЧастиОтчества.Добавить(НСтр("ru = 'уулу'"));
		ДополнительныеЧастиОтчества.Добавить(НСтр("ru = 'кызы'"));
		ДополнительныеЧастиОтчества.Добавить(НСтр("ru = 'гызы'"));
		ДополнительныеЧастиОтчества.Добавить(НСтр("ru = 'угли'"));
		
		Если ДополнительныеЧастиОтчества.Найти(НРег(ЧастиИмени[3])) <> Неопределено Тогда
			Результат.Отчество = Результат.Отчество + " " + ЧастиИмени[3];
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Формирует краткое представление из полного имени физического лица.
//
// Параметры:
//  ФамилияИмяОтчество - Строка - полное имя в виде "Фамилия Имя Отчество";
//                     - Структура:
//                        * Фамилия  - Строка - фамилия;
//                        * Имя      - Строка - имя;
//                        * Отчество - Строка - отчество.
//
// Возвращаемое значение:
//  Строка - фамилия и инициалы. Например, "Пупкин В. И.".
//
// Пример:
//  Результат = ФизическиеЛицаКлиентСервер.ФамилияИнициалыФизЛица("Пупкин Василий Иванович"); 
//  - возвращает "Пупкин В. И.".
//
Функция ФамилияИнициалы(Знач ФамилияИмяОтчество) Экспорт
	
	Если ТипЗнч(ФамилияИмяОтчество) = Тип("Строка") Тогда
		ФамилияИмяОтчество = ЧастиИмени(ФамилияИмяОтчество);
	КонецЕсли;
	
	Фамилия = ФамилияИмяОтчество.Фамилия;
	Имя = ФамилияИмяОтчество.Имя;
	Отчество = ФамилияИмяОтчество.Отчество;
	
	Если ПустаяСтрока(Имя) Тогда
		Возврат Фамилия;
	КонецЕсли;
	
	Если ПустаяСтрока(Отчество) Тогда
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 %2.", Фамилия, Лев(Имя, 1));
	КонецЕсли;
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 %2. %3.", Фамилия, Лев(Имя, 1), Лев(Отчество, 1));
	
КонецФункции

// Проверяет, верно ли написано ФИО физического лица. 
// ФИО считается верным, если содержит только кириллицу, либо только латиницу.
//
// Параметры:
//  ФИО - Строка - фамилия, имя и отчество. Например, "Пупкин Василий Иванович".
//  ТолькоКириллица - Булево - при проверке допустимой будет только кириллица в ФИО.
//
// Возвращаемое значение:
//  Булево - Истина, если ФИО написано верно.
//
Функция ФИОНаписаноВерно(Знач ФИО, ТолькоКириллица = Ложь) Экспорт
	
	ДопустимыеСимволы = "-";
	
	Возврат (Не ТолькоКириллица И СтроковыеФункцииКлиентСервер.ТолькоЛатиницаВСтроке(ФИО, Ложь, ДопустимыеСимволы))
		Или СтроковыеФункцииКлиентСерверРФ.ТолькоКириллицаВСтроке(ФИО, Ложь, ДопустимыеСимволы);
	
КонецФункции

#КонецОбласти
