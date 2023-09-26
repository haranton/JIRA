﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив из Строка
//
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("Важность");
	Результат.Добавить("Ответственный");
	Результат.Добавить("ВзаимодействиеОснование");
	Результат.Добавить("Комментарий");
	Результат.Добавить("ПолучателиПисьма.Представление");
	Результат.Добавить("ПолучателиПисьма.Контакт");
	Результат.Добавить("ПолучателиКопий.Представление");
	Результат.Добавить("ПолучателиКопий.Контакт");
	Результат.Добавить("ПолучателиОтвета.Представление");
	Результат.Добавить("ПолучателиОтвета.Контакт");
	Результат.Добавить("ПолучателиСкрытыхКопий.Представление");
	Результат.Добавить("ПолучателиСкрытыхКопий.Контакт");
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.Взаимодействия

// Получает адресатов электронного письма.
//
// Параметры:
//  Ссылка  - ДокументСсылка.ЭлектронноеПисьмоИсходящее - документ, абонента которого необходимо получить.
//
// Возвращаемое значение:
//   ТаблицаЗначений   - таблица, содержащая колонки "Контакт", "Представление" и "Адрес".
//
Функция ПолучитьКонтакты(Ссылка) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ЭлектронноеПисьмоИсходящееПолучателиПисьма.Адрес,
	|	ЭлектронноеПисьмоИсходящееПолучателиПисьма.Представление,
	|	ЭлектронноеПисьмоИсходящееПолучателиПисьма.Контакт
	|ИЗ
	|	Документ.ЭлектронноеПисьмоИсходящее.ПолучателиПисьма КАК ЭлектронноеПисьмоИсходящееПолучателиПисьма
	|ГДЕ
	|	ЭлектронноеПисьмоИсходящееПолучателиПисьма.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЭлектронноеПисьмоИсходящееПолучателиКопий.Адрес,
	|	ЭлектронноеПисьмоИсходящееПолучателиКопий.Представление,
	|	ЭлектронноеПисьмоИсходящееПолучателиКопий.Контакт
	|ИЗ
	|	Документ.ЭлектронноеПисьмоИсходящее.ПолучателиКопий КАК ЭлектронноеПисьмоИсходящееПолучателиКопий
	|ГДЕ
	|	ЭлектронноеПисьмоИсходящееПолучателиКопий.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЭлектронноеПисьмоИсходящееПолучателиОтвета.Адрес,
	|	ЭлектронноеПисьмоИсходящееПолучателиОтвета.Представление,
	|	ЭлектронноеПисьмоИсходящееПолучателиОтвета.Контакт
	|ИЗ
	|	Документ.ЭлектронноеПисьмоИсходящее.ПолучателиОтвета КАК ЭлектронноеПисьмоИсходящееПолучателиОтвета
	|ГДЕ
	|	ЭлектронноеПисьмоИсходящееПолучателиОтвета.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЭлектронноеПисьмоИсходящееПолучателиСкрытыхКопий.Адрес,
	|	ЭлектронноеПисьмоИсходящееПолучателиСкрытыхКопий.Представление,
	|	ЭлектронноеПисьмоИсходящееПолучателиСкрытыхКопий.Контакт
	|ИЗ
	|	Документ.ЭлектронноеПисьмоИсходящее.ПолучателиСкрытыхКопий КАК ЭлектронноеПисьмоИсходящееПолучателиСкрытыхКопий
	|ГДЕ
	|	ЭлектронноеПисьмоИсходящееПолучателиСкрытыхКопий.Ссылка = &Ссылка";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	ТаблицаКонтактов = Запрос.Выполнить().Выгрузить();
	
	Возврат Взаимодействия.ПреобразоватьТаблицуКонтактовВМассив(ТаблицаКонтактов);
	
КонецФункции

// Конец СтандартныеПодсистемы.Взаимодействия

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Ответственный, Отключено КАК Ложь)
	|	ИЛИ ЗначениеРазрешено(Автор, Отключено КАК Ложь)
	|	ИЛИ ЗначениеРазрешено(УчетнаяЗапись, Отключено КАК Ложь)";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.ПодключаемыеКоманды

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	Документы.Встреча.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	Документы.ЗапланированноеВзаимодействие.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	Документы.СообщениеSMS.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	Документы.ТелефонныйЗвонок.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
КонецПроцедуры

// Для использования в процедуре ДобавитьКомандыСозданияНаОсновании других модулей менеджеров объектов.
// Добавляет в список команд создания на основании этот объект.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//  СтрокаТаблицыЗначений, Неопределено - описание добавленной команды.
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Команда = СозданиеНаОсновании.ДобавитьКомандуСозданияНаОсновании(КомандыСозданияНаОсновании, Метаданные.Документы.ЭлектронноеПисьмоИсходящее);
	Если Команда <> Неопределено Тогда
		Команда.Важность = "СмТакже";
	КонецЕсли;
	
	Возврат Команда;
	
КонецФункции

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ВзаимодействияСобытия.ОбработкаПолученияДанныхВыбора(Метаданные.Документы.ЭлектронноеПисьмоИсходящее.Имя,
		ДанныеВыбора, Параметры, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиОбновления

// Регистрирует на плане обмена ОбновлениеИнформационнойБазы объекты,
// которые необходимо обновить на новую версию.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ТекстЗапроса ="
	|ВЫБРАТЬ
	|	ЭлектронноеПисьмоИсходящее.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ЭлектронноеПисьмоИсходящее КАК ЭлектронноеПисьмоИсходящее
	|ГДЕ
	|	ЭлектронноеПисьмоИсходящее.УдалитьИдентификаторСообщенияОтправкаIMAP <> """"
	|
	|ОБЪЕДИНИТЬ 
	|
	|ВЫБРАТЬ
	|	ТаблицаДокумента.Ссылка КАК Ссылка
	|ИЗ
	|	ЖурналДокументов.Взаимодействия КАК Взаимодействия
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЭлектронноеПисьмоИсходящее КАК ТаблицаДокумента
	|		ПО Взаимодействия.ИдентификаторСообщения = ТаблицаДокумента.ИдентификаторОснования
	|			И Взаимодействия.УчетнаяЗапись = ТаблицаДокумента.УчетнаяЗапись
	|			И Взаимодействия.Ссылка <> ТаблицаДокумента.ВзаимодействиеОснование
	|			И (Взаимодействия.ИдентификаторСообщения <> """")
	|			И (ТаблицаДокумента.ВзаимодействиеОснование <> """")";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Дата", Дата(2016, 7, 1));
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

// Обработчик обновления на версию 2.3.6.69:
// - переносит данные о идентификаторе письма IMAP из одного реквизита в другой для
// - предотвращения потери информации при обновлении на последующие релизы.
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяОбъекта = "Документ.ЭлектронноеПисьмоИсходящее";
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ТаблицаДокумента.Ссылка КАК Ссылка,
	|	Взаимодействия.Ссылка КАК ПисьмоОснование,
	|	ВЫБОР
	|		КОГДА Взаимодействия.Ссылка ЕСТЬ NULL
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ТребуетсяУказаниеПисьмаОснования,
	|	ТаблицаДокумента.УдалитьИдентификаторСообщенияОтправкаIMAP КАК УдалитьИдентификаторСообщенияОтправкаIMAP
	|ИЗ
	|	&ВТДокументыДляОбработки КАК СсылкиДляОбработки
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЭлектронноеПисьмоИсходящее КАК ТаблицаДокумента
	|		ПО (ТаблицаДокумента.Ссылка = СсылкиДляОбработки.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ЖурналДокументов.Взаимодействия КАК Взаимодействия
	|		ПО (Взаимодействия.ИдентификаторСообщения = ТаблицаДокумента.ИдентификаторОснования)
	|			И (Взаимодействия.УчетнаяЗапись = ТаблицаДокумента.УчетнаяЗапись)
	|			И (Взаимодействия.Ссылка <> ТаблицаДокумента.ВзаимодействиеОснование)
	|			И (Взаимодействия.ИдентификаторСообщения <> """")
	|			И (ТаблицаДокумента.ВзаимодействиеОснование <> """")";
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Результат = ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуСсылокДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта, МенеджерВременныхТаблиц);
	Если НЕ Результат.ЕстьДанныеДляОбработки Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	Если НЕ Результат.ЕстьЗаписиВоВременнойТаблице Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли; 
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ВТДокументыДляОбработки", Результат.ИмяВременнойТаблицы);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	ОбъектыДляОбработки = Запрос.Выполнить().Выбрать();
	
	Пока ОбъектыДляОбработки.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			// Устанавливаем управляемую блокировку, чтобы провести ответственное чтение объекта.
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ОбъектыДляОбработки.Ссылка);
			
			Блокировка.Заблокировать();
			
			Объект = ОбъектыДляОбработки.Ссылка.ПолучитьОбъект();
			
			Если Объект = Неопределено Тогда
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(ОбъектыДляОбработки.Ссылка);
			Иначе
				
				Если ЗначениеЗаполнено(ОбъектыДляОбработки.УдалитьИдентификаторСообщенияОтправкаIMAP) Тогда
					Объект.ИдентификаторСообщенияОтправкаIMAP        = Объект.УдалитьИдентификаторСообщенияОтправкаIMAP;
					Объект.УдалитьИдентификаторСообщенияОтправкаIMAP = "";
				КонецЕсли;
				
				Если ОбъектыДляОбработки.ТребуетсяУказаниеПисьмаОснования Тогда
					
					Объект.ВзаимодействиеОснование = ОбъектыДляОбработки.ПисьмоОснование;
					
				КонецЕсли;
			
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			МетаданныеОбъекта = Метаданные.НайтиПоПолномуИмени(ПолноеИмяОбъекта);
			
			ТекстСообщения = НСтр("ru = 'Не удалось обработать %ИмяОбъекта%: %Ссылка% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ИмяОбъекта%", ПолноеИмяОбъекта);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%",     ОбъектыДляОбработки.Ссылка);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%",    ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
										УровеньЖурналаРегистрации.Предупреждение,
										МетаданныеОбъекта,
										ОбъектыДляОбработки.Ссылка,
										ТекстСообщения);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
