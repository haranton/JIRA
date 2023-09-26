﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭлектроннаяПодписьСлужебный.НастроитьПояснениеВводаПароля(ЭтотОбъект,
		Элементы.УсиленнаяЗащитаЗакрытогоКлюча.Имя);
	
	СертификатОблачнойПодписи = ИнформацияОблачнойПодписи(Объект.Программа);
	ЗаполнитьСписокПрограммСервер();
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЭлектроннаяОблачнаяПодпись")
		И ЭлектроннаяПодписьСлужебный.ИспользоватьСервисОблачнойПодписи() Тогда
		Элементы.Программа.Заголовок = НСтр("ru = 'Программа или сервис'");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	Если Метаданные.Обработки.Найти("ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата") <> Неопределено Тогда
		ОбработкаЗаявлениеНаВыпускНовогоКвалифицированногоСертификата =
			ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(
				"Обработка.ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата");
		ОбработкаЗаявлениеНаВыпускНовогоКвалифицированногоСертификата.ПриСозданииНаСервере(
			Объект, ОткрытьЗаявление);
		ИмяФормыЗаявления = "Обработка.ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата.Форма.Форма";
		ВозможноОткрытьЗаявление = Истина;
	КонецЕсли;
	
	ПрограммаОблачногоСервиса = ЭлектроннаяПодписьСлужебный.ПрограммаОблачногоСервиса();
	ОбновитьВидимостьЭлементаУсиленнаяЗащитаЗакрытогоКлюча(ЭтотОбъект);
	
	ЕстьОрганизации = Не Метаданные.ОпределяемыеТипы.Организация.Тип.СодержитТип(Тип("Строка"));
	ПриСозданииНаСервереПриЧтенииНаСервере();
	
	Если Элементы.АвтоПоляИзДанныхСертификата.Видимость Тогда
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "НестандартныйСертификат");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Отказ = Истина;
		СтандартныеПодсистемыКлиент.УстановитьХранениеФормы(ЭтотОбъект, Истина);
		ПодключитьОбработчикОжидания("ОбработчикОжиданияДобавитьСертификат", 0.1, Истина);
		Возврат;
		
	ИначеЕсли ОткрытьЗаявление Тогда
		Отказ = Истина;
		СтандартныеПодсистемыКлиент.УстановитьХранениеФормы(ЭтотОбъект, Истина);
		ПодключитьОбработчикОжидания("ОбработчикОжиданияОткрытьЗаявление", 0.1, Истина);
		Возврат;
	КонецЕсли;
	
	ОформитьСписокПользователей();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если АдресСертификата <> Неопределено Тогда
		ПриСозданииНаСервереПриЧтенииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("ЭтоНовый", Не ЗначениеЗаполнено(Объект.Ссылка));
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ДополнительныеПараметры = Новый Структура;
	Если ПараметрыЗаписи.ЭтоНовый Тогда
		ДополнительныеПараметры.Вставить("ЭтоНовый");
	КонецЕсли;
	
	Оповестить("Запись_СертификатыКлючейЭлектроннойПодписиИШифрования", ДополнительныеПараметры, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ПрограммыЭлектроннойПодписиИШифрования"
		ИЛИ ИмяСобытия = "Запись_УчетнойЗаписиDSS" Тогда
		ЗаполнитьСписокПрограммСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// Проверка уникальности наименования.
	Если Не Элементы.Наименование.ТолькоПросмотр Тогда
		ЭлектроннаяПодписьСлужебный.ПроверитьУникальностьПредставления(
			Объект.Наименование, Объект.Ссылка, "Объект.Наименование", Отказ);
	КонецЕсли;
	
	Если ТипЗнч(ПараметрыРеквизитов) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого КлючИЗначение Из ПараметрыРеквизитов Цикл
		ИмяРеквизита = КлючИЗначение.Ключ;
		Свойства     = КлючИЗначение.Значение;
		
		Если Не Свойства.ПроверкаЗаполнения
		 Или ЗначениеЗаполнено(Объект[ИмяРеквизита]) Тогда
			
			Продолжить;
		КонецЕсли;
		
		Элемент = Элементы[ИмяРеквизита]; // ПолеФормы
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Поле %1 не заполнено.'"),
			Элемент.Заголовок);
		
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, ИмяРеквизита,, Отказ);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПрограммаПриИзменении(Элемент)
	
	ОбновитьВидимостьЭлементаУсиленнаяЗащитаЗакрытогоКлюча(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьСписокПользователей(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьСписокПользователей(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьАвтозаполняемыеРеквизиты(Команда)
	
	Показать = Не Элементы.ФормаПоказатьАвтозаполняемыеРеквизиты.Пометка;
	
	Элементы.ФормаПоказатьАвтозаполняемыеРеквизиты.Пометка = Показать;
	Элементы.АвтоПоляИзДанныхСертификата.Видимость = Показать;
	
	Если ЕстьОрганизации Тогда
		Элементы.Организация.Видимость = Показать;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьДанныеСертификата(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ОткрытиеИзФормыЭлементаСертификата");
	ПараметрыФормы.Вставить("АдресСертификата", АдресСертификата);
	
	ОткрытьФорму("ОбщаяФорма.Сертификат", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьЗаявлениеПоКоторомуБылПолученСертификат(Команда)
	
	Если ВозможноОткрытьЗаявление Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("СертификатСсылка", Объект.Ссылка);
		ОткрытьФорму(ИмяФормыЗаявления, ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСертификат(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Сертификат еще не записан.'"));
		Возврат;
	КонецЕсли;
	
	Если Модифицированность И Не Записать() Тогда
		Возврат;
	КонецЕсли;
	
	ЭлектроннаяПодписьКлиент.ПроверитьСертификатСправочника(Объект.Ссылка,
		Новый Структура("БезПодтверждения", Истина));
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьДанныеСертификатаВФайл(Команда)
	
	ЭлектроннаяПодписьСлужебныйКлиент.СохранитьСертификат(Неопределено, АдресСертификата);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатОтозван(Команда)
	
	Объект.Отозван = Не Объект.Отозван;
	Элементы.ФормаСертификатОтозван.Пометка = Объект.Отозван;
	
	Если Объект.Отозван Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'После записи отменить отзыв будет невозможно.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Скопировать(Команда)
	
	ПараметрыСоздания = Новый Структура;
	ПараметрыСоздания.Вставить("СоздатьЗаявление", Истина);
	ПараметрыСоздания.Вставить("СертификатОснование", Объект.Ссылка);
	
	ЭлектроннаяПодписьСлужебныйКлиент.ДобавитьСертификат(ПараметрыСоздания);
	
КонецПроцедуры

&НаКлиенте
Процедура СброситьПароль(Команда)
	
	ЭлектроннаяПодписьСлужебныйКлиент.СброситьПарольВПамяти(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура СменитьПинКод(Команда)
	
	МодульСервисКриптографииDSSКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSКлиентСервер");
	МодульСервисКриптографииDSSКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSКлиент");
	
	ПредставлениеОтпечатка = МодульСервисКриптографииDSSКлиентСервер.ТрансформироватьОтпечаток(Объект.Отпечаток);
	ОписаниеСледующее = Новый ОписаниеОповещения("ПослеСменыПинКода", ЭтотОбъект);
	МодульСервисКриптографииDSSКлиент.СменитьПинКодСертификата(
			ОписаниеСледующее,
			Объект.Программа,
			Новый Структура("Отпечаток", ПредставлениеОтпечатка));
	
КонецПроцедуры
		
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииНаСервереПриЧтенииНаСервере()
	
	Если Метаданные.Обработки.Найти("ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата") <> Неопределено Тогда
		ОбработкаЗаявлениеНаВыпускНовогоКвалифицированногоСертификата =
			ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(
				"Обработка.ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата");
		ОбработкаЗаявлениеНаВыпускНовогоКвалифицированногоСертификата.ПриСозданииНаСервереПриЧтенииНаСервере(
			Объект, Элементы);
	КонецЕсли;
	
	ДвоичныеДанныеСертификата = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
		Объект.Ссылка, "ДанныеСертификата").Получить();
	
	Если ТипЗнч(ДвоичныеДанныеСертификата) = Тип("ДвоичныеДанные") Тогда
		Сертификат = Новый СертификатКриптографии(ДвоичныеДанныеСертификата);
		Если ЗначениеЗаполнено(АдресСертификата) Тогда
			ПоместитьВоВременноеХранилище(ДвоичныеДанныеСертификата, АдресСертификата);
		Иначе
			АдресСертификата = ПоместитьВоВременноеХранилище(ДвоичныеДанныеСертификата, УникальныйИдентификатор);
		КонецЕсли;
		ЭлектроннаяПодписьСлужебныйКлиентСервер.ЗаполнитьОписаниеДанныхСертификата(ОписаниеДанныхСертификата,
			ЭлектроннаяПодпись.СвойстваСертификата(Сертификат));
	Иначе
		АдресСертификата = "";
		Элементы.ПоказатьДанныеСертификата.Доступность  = Ложь;
		Элементы.ФормаПроверитьСертификат.Доступность = ЗначениеЗаполнено(ДвоичныеДанныеСертификата);
		Элементы.ФормаСохранитьДанныеСертификатаВФайл.Доступность = Ложь;
		Элементы.АвтоПоляИзДанныхСертификата.Видимость = Истина;
		Элементы.ФормаПоказатьАвтозаполняемыеРеквизиты.Пометка = Истина;
		Если ЗначениеЗаполнено(ДвоичныеДанныеСертификата) Тогда
			// Поддержка отображения основных свойств нестандартных сертификатов (система iBank2).
			ЭлектроннаяПодписьСлужебныйКлиентСервер.ЗаполнитьОписаниеДанныхСертификата(ОписаниеДанныхСертификата, Объект);
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ФормаСертификатОтозван.Пометка = Объект.Отозван;
	Если Объект.Отозван Тогда
		Элементы.ФормаСертификатОтозван.Доступность = Ложь;
	КонецЕсли;
	
	Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		ЭтоАвтор = Объект.Добавил = Пользователи.ТекущийПользователь();
		СертификатДоступен = СертификатДоступенПользователю();
		
		Если НЕ ЭтоАвтор И НЕ СертификатДоступен Тогда
			// Обычный пользователь может изменять только свои сертификаты.
			ТолькоПросмотр = Истина;
		Иначе
			// Обычный пользователь не может изменить права доступа.
			Элементы.Добавил.ТолькоПросмотр = Истина;
			Если НЕ СертификатДоступен Тогда
				// Обычный пользователь не может изменять реквизит Пользователь,
				// если не он добавил сертификат.
				Элементы.Пользователи.ТолькоПросмотр = Истина;
				Элементы.Пользователи.КнопкаОткрытия = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ЕстьОрганизации = Не Метаданные.ОпределяемыеТипы.Организация.Тип.СодержитТип(Тип("Строка"));
	Элементы.Организация.Видимость = ЕстьОрганизации;
	
	Если Не ЗначениеЗаполнено(АдресСертификата) Тогда
		Возврат; // Сертификат = Неопределено.
	КонецЕсли;
	
	СвойстваСубъекта = ЭлектроннаяПодпись.СвойстваСубъектаСертификата(Сертификат);
	Если СвойстваСубъекта.Фамилия <> Неопределено Тогда
		Элементы.Фамилия.ТолькоПросмотр = Истина;
	КонецЕсли;
	Если СвойстваСубъекта.Имя <> Неопределено Тогда
		Элементы.Имя.ТолькоПросмотр = Истина;
	КонецЕсли;
	Если СвойстваСубъекта.Свойство("Отчество") И СвойстваСубъекта.Отчество <> Неопределено Тогда
		Элементы.Отчество.ТолькоПросмотр = Истина;
	КонецЕсли;
	Если СвойстваСубъекта.Организация <> Неопределено Тогда
		Элементы.Фирма.ТолькоПросмотр = Истина;
	КонецЕсли;
	Если СвойстваСубъекта.Свойство("Должность") И СвойстваСубъекта.Должность <> Неопределено Тогда
		Элементы.Должность.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	ПараметрыРеквизитов = Неопределено;
	ЭлектроннаяПодписьСлужебный.ПередНачаломРедактированияСертификатаКлюча(
		Объект.Ссылка, Сертификат, ПараметрыРеквизитов);
	
	Для каждого КлючИЗначение Из ПараметрыРеквизитов Цикл
		ИмяРеквизита = КлючИЗначение.Ключ;
		Свойства     = КлючИЗначение.Значение;
		
		Если Не Свойства.Видимость Тогда
			Элементы[ИмяРеквизита].Видимость = Ложь;
			
		ИначеЕсли Свойства.ТолькоПросмотр Тогда
			Элементы[ИмяРеквизита].ТолькоПросмотр = Истина
		КонецЕсли;
		Если Свойства.ПроверкаЗаполнения Тогда
			Элементы[ИмяРеквизита].АвтоОтметкаНезаполненного = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Элементы.АвтоПоляИзДанныхСертификата.Видимость =
		    Не Элементы.Фамилия.ТолькоПросмотр   И Не ЗначениеЗаполнено(Объект.Фамилия)
		Или Не Элементы.Имя.ТолькоПросмотр       И Не ЗначениеЗаполнено(Объект.Имя)
		Или Не Элементы.Отчество.ТолькоПросмотр  И Не ЗначениеЗаполнено(Объект.Отчество);
	
	Элементы.ФормаПоказатьАвтозаполняемыеРеквизиты.Пометка =
		Элементы.АвтоПоляИзДанныхСертификата.Видимость;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияДобавитьСертификат()
	
	СтандартныеПодсистемыКлиент.УстановитьХранениеФормы(ЭтотОбъект, Ложь);
	
	ПараметрыСоздания = Новый Структура;
	ПараметрыСоздания.Вставить("ВЛичныйСписок", Истина);
	ПараметрыСоздания.Вставить("Организация", Объект.Организация);
	ПараметрыСоздания.Вставить("СкрытьЗаявление", Ложь);
	
	ЭлектроннаяПодписьСлужебныйКлиент.ДобавитьСертификат(ПараметрыСоздания);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияОткрытьЗаявление()
	
	СтандартныеПодсистемыКлиент.УстановитьХранениеФормы(ЭтотОбъект, Ложь);
	
	Если ВозможноОткрытьЗаявление Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("СертификатСсылка", Объект.Ссылка);
		ОткрытьФорму(ИмяФормыЗаявления, ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьВидимостьЭлементаУсиленнаяЗащитаЗакрытогоКлюча(Форма)
	
	Форма.Элементы.УсиленнаяЗащитаЗакрытогоКлюча.Видимость =
		Форма.Объект.Программа <> Форма.ПрограммаОблачногоСервиса
		И НЕ Форма.СертификатОблачнойПодписи.ОблачнаяПодпись;
	
	Форма.Элементы.ФормаСменитьПинКод.Видимость = Форма.СертификатОблачнойПодписи.ОблачнаяПодпись;
	
КонецПроцедуры

&НаКлиенте
Процедура ОформитьСписокПользователей()
	
	КоличествоПользователей = Объект.Пользователи.Количество();
	Если КоличествоПользователей = 1 Тогда
		ПредставлениеПользователей = СокрЛП(Объект.Пользователи[0].Пользователь);
	ИначеЕсли КоличествоПользователей > 1 Тогда
		ПредставлениеПользователей = НСтр("ru = 'Несколько пользователей'", ОбщегоНазначенияКлиент.КодОсновногоЯзыка()) 
									 + " (" + Формат(КоличествоПользователей, "ЧГ=0") +  ")";
	ИначеЕсли ЗначениеЗаполнено(Объект.Пользователь) Тогда
		ПредставлениеПользователей = СокрЛП(Объект.Пользователь);
	Иначе
		ПредставлениеПользователей = НСтр("ru = 'Не указаны'", ОбщегоНазначенияКлиент.КодОсновногоЯзыка());
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура СписокПользователейЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора <> Неопределено И ТипЗнч(РезультатВыбора) = Тип("Структура") Тогда
		Объект.Пользователи.Очистить();
		Объект.Пользователь = РезультатВыбора.Пользователь;
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицуИзМассива(Объект.Пользователи, РезультатВыбора.Пользователи, "Пользователь");
		ОформитьСписокПользователей();
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеСменыПинКода(РезультатВызова, ДополнительныеПараметры) Экспорт
	
	МодульСервисКриптографииDSSКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSКлиентСервер");
	МодульСервисКриптографииDSSКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSКлиент");
	
	Если РезультатВызова.Выполнено Тогда
		ПоказатьПредупреждение(Неопределено, 
				НСтр("ru = 'Смена пин-кода выполнена успешно.'", ОбщегоНазначенияКлиент.КодОсновногоЯзыка()), 30);
				
	ИначеЕсли НЕ МодульСервисКриптографииDSSКлиентСервер.ЭтоОшибкаОтказа(РезультатВызова.Ошибка) Тогда
		МодульСервисКриптографииDSSКлиент.ВывестиОшибку(Неопределено, РезультатВызова.Ошибка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокПользователей(РежимПросмотра)
	
	МассивПользователей = Новый Массив;
	Для Каждого СтрокаТаблицы Из Объект.Пользователи Цикл
		МассивПользователей.Добавить(СтрокаТаблицы.Пользователь);
	КонецЦикла;	
	
	ОповещениеЗавершения = Новый ОписаниеОповещения("СписокПользователейЗавершение", ЭтотОбъект);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Пользователь", Объект.Пользователь);
	ПараметрыФормы.Вставить("Пользователи", МассивПользователей);
	ПараметрыФормы.Вставить("РежимПросмотра", РежимПросмотра ИЛИ ТолькоПросмотр);
	
	ОткрытьФорму("Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования.Форма.СписокПользователей", 
			ПараметрыФормы, ЭтотОбъект, , , , ОповещениеЗавершения);
			
КонецПроцедуры

&НаСервере
Функция СертификатДоступенПользователю()
	
	ТекПользователь = Пользователи.ТекущийПользователь();
	НашлиСтроки = Объект.Пользователи.НайтиСтроки(Новый Структура("Пользователь", ТекПользователь));
	Результат = НашлиСтроки.Количество() > 0 ИЛИ Объект.Пользователь = ТекПользователь;
		
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокПрограммСервер()
	
	СписокВыбора = Элементы.Программа.СписокВыбора;
	СписокВыбора.Очистить();
	ВесьСписок = ЗаполнитьСписокПрограмм(Объект.Программа);
	
	Для каждого СтрокаСписка Из ВесьСписок Цикл
		НоваяСтрока = СписокВыбора.Добавить(СтрокаСписка.Значение);
		НоваяСтрока.Картинка = СтрокаСписка.Картинка;
		НоваяСтрока.Представление = СтрокаСписка.Представление;
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИнформацияОблачнойПодписи(ТекущаяПрограмма)
	
	Результат = Новый Структура();
	Результат.Вставить("ОблачнаяПодпись", Ложь);
	Результат.Вставить("МенятьПинКод", Ложь);
	
	Если ЗначениеЗаполнено(ТекущаяПрограмма) 
		И ТипЗнч(ТекущаяПрограмма) = ЭлектроннаяПодписьСлужебный.ПолучитьТипОблачнойПодписи() Тогда
		МодульСервисКриптографииDSSСлужебныйВызовСервера = ОбщегоНазначения.ОбщийМодуль("СервисКриптографииDSSСлужебныйВызовСервера");
		ДанныеУчетнойЗаписи = МодульСервисКриптографииDSSСлужебныйВызовСервера.ПолучитьНастройкиПользователя(ТекущаяПрограмма);
		Результат.ОблачнаяПодпись = Истина;
		Результат.МенятьПинКод = ДанныеУчетнойЗаписи.Политика.РежимПинКода <> "Запрещено";
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции	

&НаСервереБезКонтекста
Функция ЗаполнитьСписокПрограмм(Знач ВыбраннаяПрограмма)
	
	ДобавитьКартинку = ЭлектроннаяПодписьСлужебный.ИспользоватьСервисОблачнойПодписи() ИЛИ ЭлектроннаяПодписьСлужебный.ИспользоватьЭлектроннуюПодписьВМоделиСервиса();
	КартинкаКомпьютера = Новый Картинка;
	КартинкаСервиса = Новый Картинка;
	КартинкаОблака = Новый Картинка;
	Если ЭлектроннаяПодписьСлужебный.ИспользоватьСервисОблачнойПодписи() Тогда
		МодульСервисКриптографииDSS = ОбщегоНазначения.ОбщийМодуль("СервисКриптографииDSS");
		КартинкаКомпьютера = МодульСервисКриптографииDSS.ПолучитьКартинкуПодсистемы("КомпьютерКлиент");
		КартинкаСервиса = МодульСервисКриптографииDSS.ПолучитьКартинкуПодсистемы("ПодписьСервиса");
		КартинкаОблака = МодульСервисКриптографииDSS.ПолучитьКартинкуПодсистемы("ПодписьОблако");
	КонецЕсли;
	
	Результат = Новый СписокЗначений;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ПрограммыЭлектроннойПодписиИШифрования.Ссылка КАК Ссылка,
	|	ПрограммыЭлектроннойПодписиИШифрования.ЭтоПрограммаОблачногоСервиса КАК ЭтоПрограммаОблачногоСервиса,
	|	ПрограммыЭлектроннойПодписиИШифрования.ТипПрограммы КАК ТипПрограммы,
	|	ЛОЖЬ КАК ОблачнаяПодпись
	|ИЗ
	|	Справочник.ПрограммыЭлектроннойПодписиИШифрования КАК ПрограммыЭлектроннойПодписиИШифрования";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Результат.Добавить(Выборка.Ссылка);
		Если Выборка.ЭтоПрограммаОблачногоСервиса И ДобавитьКартинку Тогда
			НоваяСтрока.Картинка = КартинкаСервиса;
		ИначеЕсли ДобавитьКартинку Тогда
			НоваяСтрока.Картинка = КартинкаКомпьютера;
		КонецЕсли;	
	КонецЦикла;
	
	Если ЭлектроннаяПодписьСлужебный.ИспользоватьСервисОблачнойПодписи() Тогда
		МодульСервисКриптографииDSSСлужебный = ОбщегоНазначения.ОбщийМодуль("СервисКриптографииDSSСлужебный");
		МодульСервисКриптографииDSS = ОбщегоНазначения.ОбщийМодуль("СервисКриптографииDSS");
		МассивУчетныхЗаписей = МодульСервисКриптографииDSSСлужебный.ПолучитьВсеУчетныеЗаписи();
		
		Для каждого СтрокаМассива Из МассивУчетныхЗаписей Цикл
			НоваяСтрока = Результат.Добавить(СтрокаМассива.Ссылка);
			Если ДобавитьКартинку Тогда
				НоваяСтрока.Картинка = КартинкаОблака;
			КонецЕсли;	
		КонецЦикла;
			
	КонецЕсли;	
	
	Если Результат.НайтиПоЗначению(ВыбраннаяПрограмма) = Неопределено Тогда
		ПредставлениеПрограммы = ?(ЗначениеЗаполнено(ВыбраннаяПрограмма),
								СокрЛ(ВыбраннаяПрограмма),
								НСтр("ru = 'Не выбрана'"));
		Результат.Добавить(ВыбраннаяПрограмма, ПредставлениеПрограммы);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
