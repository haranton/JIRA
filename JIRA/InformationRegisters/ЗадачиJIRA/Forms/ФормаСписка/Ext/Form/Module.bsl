﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МассивДанных = ПолучитьJSONЗадач();
	МассивОтбор = МассивДанных["issues"];

	Для каждого  ЭлементМассива Из МассивОтбор Цикл 
		                                                                                         
		СтруктураПолей = ЭлементМассива.fields;
		
		Описание = ?(СтруктураПолей.description = "null","",СтруктураПолей.description);
		НазваниеЗадачи = СтруктураПолей.summary;
		Статус = СтруктураПолей.status.name;
			
		МенеджерЗаписи = РегистрыСведений.ЗадачиJIRA.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.НазваниеЗадачи = НазваниеЗадачи;
		МенеджерЗаписи.Описание = Описание;
		МенеджерЗаписи.Статус = Статус;
		МенеджерЗаписи.Записать();
			
	КонецЦикла;
		
КонецПроцедуры

&НаСервере
Функция ПолучитьJSONЗадач()
	
	Токен = Константы.ТокенДляJIRAВBASE64.Получить();
	
	SSL = Новый ЗащищенноеСоединениеOpenSSL;

	Соединение = Новый HTTPСоединение("testtodolist.atlassian.net",443,,,,30,SSL);
	
	АдресРесурса = "/rest/api/2/search";
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json; charset=utf-8"); 
	Заголовки.Вставить("Authorization", "Basic "+ Токен); 
	
	ЗапросСЗаголовками = Новый HTTPЗапрос(АдресРесурса,Заголовки);
	
	Ответ = Соединение.ВызватьHTTPМетод("GET", ЗапросСЗаголовками);
	
	Если Ответ.КодСостояния = 200 Тогда
		
		ТелоОтвета = Ответ.ПолучитьТелоКакСтроку();
		Результат = РаботаСJSON.ПрочитатьТекстJSON(ТелоОтвета);
		Возврат Результат; 
		
	Иначе
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = СтрШаблон("Не удалось выполнить запрос, код состояния %1", Ответ.КодСостояния);
		Сообщение.Сообщить();
		Возврат Сообщение
	КонецЕсли
		
КонецФункции



