﻿&Вместо("ОбработкаПроведения")
Процедура ит_ОбработкаПроведения(Отказ, РежимПроведения)
	_СтруктураРеквизитов = Новый Структура;
	_СтруктураРеквизитов.Вставить("ит_РозничныйВидЦен", "ит_РозничныйВидЦен");
	_СтруктураРеквизитов.Вставить("ит_ЗакупочныйВидЦен", "ит_ЗакупочныйВидЦен");
	_СтруктураРеквизитов.Вставить("ит_АкционныйВидЦен", "ит_АкционныйВидЦен");
	_СтруктураРеквизитов.Вставить("ЗакупочныйВидЦеныНДС", "ит_ЗакупочныйВидЦен.ЦенаВключаетНДС");
	_СтруктураРеквизитов.Вставить("РозничныйВидЦеныНДС", "ит_РозничныйВидЦен.ЦенаВключаетНДС");
	ВидыЦен = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Формат, _СтруктураРеквизитов);
	
	Валюта = Константы.ВалютаРегламентированногоУчета.Получить(); 
	
	_ВидЦенПоставщика = Справочники.ВидыЦенПоставщиков.НайтиСоздатьЦенуПоставщика(ЭтотОбъект.Поставщик);
	
	Для Каждого Стр Из Спецификация Цикл
		
		Если ЗначениеЗаполнено(Стр.Номенклатура) Тогда
			
			ДвижениеЗакупочнаяЦена = Движения.ЦеныНоменклатуры25.Добавить();
			ДвижениеЗакупочнаяЦена.Период 			= ДатаНачалаДействияСпецификации;
			ДвижениеЗакупочнаяЦена.Номенклатура 	= Стр.Номенклатура;
			ДвижениеЗакупочнаяЦена.ХарактеристикаЦО = Стр.Характеристика;
			ДвижениеЗакупочнаяЦена.ВидЦены 			= ВидыЦен.ит_ЗакупочныйВидЦен;
			ДвижениеЗакупочнаяЦена.Валюта 			= Валюта;
			
			Если ВидыЦен.ЗакупочныйВидЦеныНДС Тогда
				ДвижениеЗакупочнаяЦена.Цена 			= Стр.ЦенаТекущаяСНДС;
			Иначе
				ДвижениеЗакупочнаяЦена.Цена 			= Стр.ЦенаТекущаяБезНДС;
			КонецЕсли; 
			
			//++ { ИТ4.DIRachkovsky BLKA-62
			ДвижениеЗакупочнаяЦена = Движения.ЦеныНоменклатурыПоставщиков.Добавить();
			ДвижениеЗакупочнаяЦена.Период = ДатаНачалаДействияСпецификации;
			ДвижениеЗакупочнаяЦена.Номенклатура = Стр.Номенклатура;
			ДвижениеЗакупочнаяЦена.Характеристика = Стр.Характеристика;
			ДвижениеЗакупочнаяЦена.ВидЦеныПоставщика = _ВидЦенПоставщика;
			ДвижениеЗакупочнаяЦена.Валюта = Валюта;
			ДвижениеЗакупочнаяЦена.Партнер = ЭтотОбъект.Поставщик;
			Если ВидыЦен.ЗакупочныйВидЦеныНДС Тогда
				ДвижениеЗакупочнаяЦена.Цена 			= Стр.ЦенаТекущаяСНДС;
			Иначе
				ДвижениеЗакупочнаяЦена.Цена 			= Стр.ЦенаТекущаяБезНДС;
			КонецЕсли;
			//-- } ИТ4.DIRachkovsky
			
			Если Акция = Истина Тогда
				
				ДвижениеАкцияЦена = Движения.ЦеныНоменклатуры25.Добавить();
				ДвижениеАкцияЦена.Период 			= ДатаНачалаДействияСпецификации;
				ДвижениеАкцияЦена.Номенклатура 	    = Стр.Номенклатура;
				ДвижениеАкцияЦена.ХарактеристикаЦО 	= Стр.Характеристика;
				ДвижениеАкцияЦена.ВидЦены 			= ВидыЦен.ит_АкционныйВидЦен;
				ДвижениеАкцияЦена.Цена 			    = Стр.НоваяРозничнаяЦенаСНДС;
				ДвижениеАкцияЦена.Валюта 			= Валюта;
				
				ДвижениеАкцияЦена = Движения.ЦеныНоменклатуры25.Добавить();
				ДвижениеАкцияЦена.Период 			= ДатаОкончанияДействияСпецификации;
				ДвижениеАкцияЦена.Номенклатура 	    = Стр.Номенклатура;
				ДвижениеАкцияЦена.ХарактеристикаЦО 	= Стр.Характеристика;
				ДвижениеАкцияЦена.ВидЦены 			= ВидыЦен.ит_АкционныйВидЦен;
				ДвижениеАкцияЦена.Цена 			    = Стр.НоваяРозничнаяЦенаСНДС;
				ДвижениеАкцияЦена.Валюта 			= Валюта;
								
			Иначе
				
				ДвижениеРозничнаяЦена = Движения.ЦеныНоменклатуры25.Добавить();
				ДвижениеРозничнаяЦена.Период 			= ДатаНачалаДействияСпецификации;
				ДвижениеРозничнаяЦена.Номенклатура 	    = Стр.Номенклатура;
				ДвижениеРозничнаяЦена.ХарактеристикаЦО 	= Стр.Характеристика;
				ДвижениеРозничнаяЦена.ВидЦены 			= ВидыЦен.ит_РозничныйВидЦен;
				ДвижениеРозничнаяЦена.Цена 			    = Стр.НоваяРозничнаяЦенаСНДС;
				ДвижениеРозничнаяЦена.Валюта 			= Валюта;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Движения.ЦеныНоменклатуры25.Записывать = Истина;
	//++ { ИТ4.DIRachkovsky BLKA-62
	Движения.ЦеныНоменклатурыПоставщиков.Записывать = Истина;
	//-- } ИТ4.DIRachkovsky
	
КонецПроцедуры
