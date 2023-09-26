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
	
	Узел = Параметры.Узел;
	АдресСтруктурыУзла = Параметры.АдресСтруктурыУзла;
	
	ЭтоУзелАРМ = ОбменДаннымиПовтИсп.ЭтоУзелАвтономногоРабочегоМеста(Узел);
	
	ШаблонЗаголовка = НСтр("ru = 'Запись узла ""%1""'");
	Заголовок = СтрШаблон(ШаблонЗаголовка, Строка(Узел)); 
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ДлительнаяОперация = НачатьВыполнениеПроцедуры();
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбработатьРезультат", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания());

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаГотово(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПараметрыОжидания()
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ТекстСообщения = "";
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Ложь;
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.ВыводитьСообщения = Ложь;
	Возврат ПараметрыОжидания;
	
КонецФункции

&НаСервере
Функция НачатьВыполнениеПроцедуры()
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияПроцедуры();
	ШаблонНаименования = НСтр("ru = '""Длительная запись узла """"%1""""'");
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = СтрШаблон(ШаблонНаименования, Строка(Узел));
	ПараметрыВыполнения.КлючФоновогоЗадания = "ОтложеннаяЗаписьУзла";
	
	СтруктураУзла = ПолучитьИзВременногоХранилища(АдресСтруктурыУзла);
	Возврат ДлительныеОперации.ВыполнитьПроцедуру(ПараметрыВыполнения, "Обработки.ОтложеннаяЗаписьУзла.ЗаписатьУзел", Узел, СтруктураУзла);
		
КонецФункции

&НаКлиенте
Процедура ОбработатьРезультат(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.Статус = "Выполнено" Тогда
		
		Элементы.ПанельОсновная.ТекущаяСтраница = Элементы.СтраницаОкончание;
		
		Если ЭтоУзелАРМ Тогда
			Оповестить("Запись_АвтономноеРабочееМесто");
		Иначе
			Оповестить("Запись_УзелПланаОбмена");
		КонецЕсли;
		
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(Результат.КраткоеПредставлениеОшибки);
		
	КонецЕсли;
	
КонецПроцедуры 

#КонецОбласти
