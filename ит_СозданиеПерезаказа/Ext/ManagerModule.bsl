﻿
#Область СлужебныеПроцедурыИФункции

	////////////////////////////////////////////////////////////////////////////////
	//
	// Процедура ит_ПерезаполнитьПриобретение
	//
	// Описание: Выполняет перезаполнение тч Товары ПТУ, оформленного на основании РТУ из Заказа торговой точки
	//
	//
	// Параметры (название, тип, дифференцированное значение)
	// Реализация - ДокументСсылка.РеализацияТоваровУслуг - Реализация основание
	// Приобретение - ДокументСсылка.ПриобретениеТоваровУслуг - Приобретение, которое перезаполняем
	//
	Процедура ит_ПерезаполнитьПриобретение(Реализация) Экспорт
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПриобретениеТоваровУслуг.Ссылка КАК Ссылка,
		|	РеализацияТоваровУслугТовары.Номенклатура КАК Номенклатура,
		|	РеализацияТоваровУслугТовары.КоличествоУпаковок КАК КоличествоУпаковок,
		|	РеализацияТоваровУслугТовары.Количество КАК Количество,
		|	РеализацияТоваровУслугТовары.Цена КАК Цена,
		|	РеализацияТоваровУслугТовары.Сумма КАК Сумма,
		|	РеализацияТоваровУслугТовары.СтавкаНДС КАК СтавкаНДС,
		|	РеализацияТоваровУслугТовары.СуммаНДС КАК СуммаНДС,
		|	РеализацияТоваровУслугТовары.СуммаСНДС КАК СуммаСНДС,
		|	РеализацияТоваровУслугТовары.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов
		|ИЗ
		|	Документ.ПриобретениеТоваровУслуг КАК ПриобретениеТоваровУслуг
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровУслугТовары
		|		ПО ПриобретениеТоваровУслуг.ит_РТУПерезаказа = РеализацияТоваровУслугТовары.Ссылка
		|ГДЕ
		|	НЕ РеализацияТоваровУслугТовары.Ссылка.ПометкаУдаления
		|	И ПриобретениеТоваровУслуг.ит_РТУПерезаказа = &Реализация
		|	И НЕ ПриобретениеТоваровУслуг.ПометкаУдаления
		|ИТОГИ ПО
		|	Ссылка";
		Запрос.УстановитьПараметр("Реализация", Реализация);
		РезультатЗапроса = Запрос.Выполнить();
		ВыборкаПоДокументу = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		ВыборкаПоДокументу.Следующий();
		
		ДокументПриобретения = ВыборкаПоДокументу.Ссылка.ПолучитьОбъект();
		ДокументПриобретения.Товары.Очистить();
		
		ВыборкаПоТоварам = ВыборкаПоДокументу.Выбрать();
		
		Пока ВыборкаПоТоварам.Следующий() Цикл
			НоваяСтрока = ДокументПриобретения.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаПоТоварам);
		КонецЦикла;
		
		Попытка
			ДокументПриобретения.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
		    Сообщить(ОписаниеОшибки());
		КонецПопытки;
				   
	КонецПроцедуры //ит_ПерезаполнитьПриобретение
	
	
#КонецОбласти
