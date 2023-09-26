﻿
///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("ДанныеВыделенныхСтрок") Тогда
		
		ВызватьИсключение НСтр("ru ='Самостоятельное использование формы не предусмотрено.'", ОбщегоНазначения.КодОсновногоЯзыка());
		
	КонецЕсли;
	
	УсловноеОформлениеФормы();
	ЗаполнитьТаблицуФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПровестиДокументы(Команда)
	
	ПараметрыПроведения = Новый Структура;
	ПараметрыПроведения.Вставить("КоличествоПроведенные", 0);
	ПараметрыПроведения.Вставить("КоличествоВсего", 0);
	
	ПровестиДокументыНаСервере(ПараметрыПроведения);
	
	Если ПараметрыПроведения.КоличествоПроведенные > 0 Тогда
		
		Оповестить("ИсправлениеПредупрежденийСинхронизацииПроведенияДокументов");
		
	КонецЕсли;
	
	ОчиститьСообщения();
	Если ПараметрыПроведения.КоличествоПроведенные <> ПараметрыПроведения.КоличествоВсего Тогда
		
		СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Проведено документов %1 из %2.'"),
			Формат(ПараметрыПроведения.КоличествоПроведенные, "ЧН=; ЧГ=0"),
			Формат(ПараметрыПроведения.КоличествоВсего, "ЧН=; ЧГ=0"));
		
		ПоказатьПредупреждение(Неопределено, СообщениеОбОшибке);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	
	ИзменитьОтметкуСтрок(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВыделение(Команда)
	
	ИзменитьОтметкуСтрок(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроводитьВРежимеРазработчика(Команда)
	
	Элементы.ТаблицаОбъектовИсправленияПроводитьВРежимеРазработчика.Пометка 
		= НЕ Элементы.ТаблицаОбъектовИсправленияПроводитьВРежимеРазработчика.Пометка;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ИзменитьОтметкуСтрок(ЗначениеОтметки);
	
	Для Каждого ВыделеннаяСтрока Из ТаблицаОбъектовИсправления Цикл
		
		ВыделеннаяСтрока.ОбработатьСтроку = ЗначениеОтметки;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УсловноеОформлениеФормы()
	
	ОшибкиКрасным = УсловноеОформление.Элементы.Добавить();
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ОшибкиКрасным.Отбор, "ТаблицаОбъектовИсправления.НеудачнаяПопытка", ВидСравненияКомпоновкиДанных.Равно, Истина);
	ОшибкиКрасным.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.ТемноКрасный);
	
	ПолеОформления = ОшибкиКрасным.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("ТаблицаОбъектовИсправленияПроблемныйОбъект");
	ПолеОформления = ОшибкиКрасным.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("ТаблицаОбъектовИсправленияРезультатПроведения");
	ПолеОформления = ОшибкиКрасным.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("ТаблицаОбъектовИсправленияНеудачнаяПопытка");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуФормы()
	
	Если ТипЗнч(Параметры.ДанныеВыделенныхСтрок) <> Тип("Массив") Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Для каждого ПроблемныйОбъект Из Параметры.ДанныеВыделенныхСтрок Цикл
		
		НоваяСтрока = ТаблицаОбъектовИсправления.Добавить();
		НоваяСтрока.ОбработатьСтроку = Истина;
		НоваяСтрока.ПроблемныйОбъект = ПроблемныйОбъект;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПровестиДокументыНаСервере(ПараметрыПроведения)
	
	ШаблонПредупреждения = НСтр("ru ='Документ [%1] не проводился из-за ошибок проверки заполнения. 
		|Для устранения проблемы откройте документ и выполните проведение в ручном режиме.'", ОбщегоНазначения.КодОсновногоЯзыка());
	
	
	Для Каждого ВыделеннаяСтрока Из ТаблицаОбъектовИсправления Цикл
		
		Если НЕ ВыделеннаяСтрока.ОбработатьСтроку Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		ПараметрыПроведения.КоличествоВсего = ПараметрыПроведения.КоличествоВсего + 1;
		
		НачатьТранзакцию();
		Попытка
			
			ЗаблокироватьДанныеДляРедактирования(ВыделеннаяСтрока.ПроблемныйОбъект);
			
			ДокументОбъект = ВыделеннаяСтрока.ПроблемныйОбъект.ПолучитьОбъект();
			Если ДокументОбъект.ПроверитьЗаполнение() Тогда
				
				Если Элементы.ТаблицаОбъектовИсправленияПроводитьВРежимеРазработчика.Пометка Тогда
					
					ДокументОбъект.ОбменДанными.Загрузка = Истина;
					
				КонецЕсли;
				
				ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
				
				ВыделеннаяСтрока.РезультатИсправления = НСтр("ru ='Документ успешно проведен.'");
				ПараметрыПроведения.КоличествоПроведенные = ПараметрыПроведения.КоличествоПроведенные + 1;
				
			Иначе
				
				ВыделеннаяСтрока.РезультатИсправления = СтрШаблон(ШаблонПредупреждения, ВыделеннаяСтрока.ПроблемныйОбъект);
				ВыделеннаяСтрока.НеудачнаяПопытка = Истина;
				
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ВыделеннаяСтрока.РезультатИсправления = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			ВыделеннаяСтрока.НеудачнаяПопытка = Истина;
			
		КонецПопытки;
		
	КонецЦикла;
	
	
КонецПроцедуры

#КонецОбласти
