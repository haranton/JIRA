﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив();
	Для каждого ЗаписьВерсии Из ЭтотОбъект Цикл
		Если Не ПустаяСтрока(ЗаписьВерсии.Версия) И Не ЭтоПолныйНомерВерсии(ЗаписьВерсии.Версия) Тогда
			ОбщегоНазначения.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Некорректный номер версии: %1 (ожидалось значение в виде ""1.2.3.4"")'"), ЗаписьВерсии.Версия));
			Отказ = Истина; 
	    	НепроверяемыеРеквизиты.Добавить("Версия"); 
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЭтоПолныйНомерВерсии(Знач НомерВерсии)
	
	ЧастиВерсии = СтрРазделить(НомерВерсии, ".");
	Если ЧастиВерсии.Количество() <> 4 Тогда
		Возврат Ложь;	
	КонецЕсли;
	
	ТипЧисло = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10, 0, ДопустимыйЗнак.Неотрицательный));
 	Для Разряд = 0 По 3 Цикл
		ЧастьВерсии = ЧастиВерсии[Разряд];
		Если ТипЧисло.ПривестиЗначение(ЧастьВерсии) = 0 И ЧастьВерсии <> "0" Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	Возврат Истина;
		
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли