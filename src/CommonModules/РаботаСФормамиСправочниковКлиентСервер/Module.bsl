////////////////////////////////////////////////////////////////////////////////
// РаботаСФормамиСправочниковКлиентСервер: общий функционал по обслуживанию справочников
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает строку, в которой формальное описание отбора по актуальности заменено
//	на более понятный текст.
//Только для русского языка!
Функция УпроститьСтрокуОтбораНаРусском(ТекстОписания) Экспорт

	Результат = СокрЛП(ТекстОписания);
	Результат = СтрЗаменить(Результат, "Актуально Равно ""Да""", "Только актуальные");
	Результат = СтрЗаменить(Результат, "Актуальна Равно ""Да""", "Только актуальные");
	Результат = СтрЗаменить(Результат, "Актуален Равно ""Да""", "Только актуальные");
	
	Результат = СтрЗаменить(Результат, "Актуально Равно ""Нет""", "Только неактуальные");
	Результат = СтрЗаменить(Результат, "Актуальна Равно ""Нет""", "Только неактуальные");
	Результат = СтрЗаменить(Результат, "Актуален Равно ""Нет""", "Только неактуальные");

	Возврат Результат;
	
КонецФункции


// Автонаименование долга

Функция АвтоНаименованиеДолгаПоУмолчанию(Долг, ДатаВозникновения) Экспорт
	
	Если Долг.ИспользоватьДляУчетаВзятыхДолгов И НЕ Долг.ИспользоватьДляУчетаВыданныхДолгов Тогда
		ШаблонНаименования = НСтр("ru = '%1 дал(а) в долг %2'");
	ИначеЕсли НЕ Долг.ИспользоватьДляУчетаВзятыхДолгов И Долг.ИспользоватьДляУчетаВыданныхДолгов Тогда
		ШаблонНаименования = НСтр("ru = '%1 взял(а) в долг %2'");
	ИначеЕсли Долг.ИспользоватьДляУчетаВзятыхДолгов И Долг.ИспользоватьДляУчетаВыданныхДолгов Тогда
		ШаблонНаименования = НСтр("ru = '%1 взаимные расчеты'");
	КонецЕсли; 
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонНаименования, 
		?(ЗначениеЗаполнено(Долг.Контакт), Долг.Контакт, НСтр("ru = '<Контакт не задан>'")),
		Формат(ДатаВозникновения, "ДЛФ=D"));
	
КонецФункции

Процедура ОбслужитьАвтоНаименованиеДолга(Форма) Экспорт

	Объект = Форма.Объект;
	ЭлементНаименование = Форма.Элементы.НаименованиеДолга;
	
	// Найдем элемент списка, из которого было выбрано наименование
	РазмерПрежнегоСписка = ЭлементНаименование.СписокВыбора.Количество();
	ПрежнийЭлементСписка = ЭлементНаименование.СписокВыбора.НайтиПоЗначению(Объект.Наименование);
	Если ПрежнийЭлементСписка <> Неопределено Тогда
		ИндексПрежнегоЭлемента = ЭлементНаименование.СписокВыбора.Индекс(ПрежнийЭлементСписка);
	Иначе
		ИндексПрежнегоЭлемента = Неопределено;
	КонецЕсли;
	Если ПустаяСтрока(Объект.Наименование) Тогда
		ИндексПрежнегоЭлемента = 0;
	КонецЕсли;
	
	// Переформируем список
	СформироватьСписокВыбораНаименования(ЭлементНаименование, Объект, Форма);
	
	// Заменим наименование на новое значение
	Если ИндексПрежнегоЭлемента <> Неопределено Тогда
		
		РазмерНовогоСписка = ЭлементНаименование.СписокВыбора.Количество();
		
		// Для взаиморасчетов в списке на 1 элемент меньше
		Если РазмерНовогоСписка < РазмерПрежнегоСписка Тогда
			Если ИндексПрежнегоЭлемента = 1 Тогда
				ИндексПрежнегоЭлемента = 0;
			ИначеЕсли ИндексПрежнегоЭлемента = 2 Тогда
				ИндексПрежнегоЭлемента = 1;
			КонецЕсли;
		ИначеЕсли РазмерНовогоСписка > РазмерПрежнегоСписка Тогда
			Если ИндексПрежнегоЭлемента = 1 Тогда
				ИндексПрежнегоЭлемента = 2;
			КонецЕсли;
		КонецЕсли;
		
		Объект.Наименование = ЭлементНаименование.СписокВыбора[ИндексПрежнегоЭлемента].Значение;
		
	КонецЕсли;

КонецПроцедуры

Процедура СформироватьСписокВыбораНаименования(Элемент, Объект, Форма) Экспорт
	
	// Важно! 
	// При изменении алгоритма формирования списка выбора 
	// возможно потребуется внести изменения в процедуру ОбслужитьАвтоНаименованиеДолга().
	
	Элемент.СписокВыбора.Очистить();
	
	Элемент.СписокВыбора.Добавить(АвтоНаименованиеДолгаПоУмолчанию(Объект, Форма.ПараметрыГрафика.ДатаВозникновенияДолга));
							
	СтрКонтакт = ?(ЗначениеЗаполнено(Объект.Контакт), Объект.Контакт, НСтр("ru = '<Контакт не задан>'"));
	СтрСумма   = Формат(Форма.ПараметрыГрафика.СуммаДолга, ?(Форма.ПараметрыГрафика.СуммаДолга % 1 = 0, "ЧДЦ=0; ЧН=0", "ЧДЦ=2")) + " " + Объект.Валюта;
	
	ШаблонНаименования = НСтр("ru = '%1 %2 %3'");
	
	Если Объект.ИспользоватьДляУчетаВыданныхДолгов И НЕ Объект.ИспользоватьДляУчетаВзятыхДолгов Тогда
		Элемент.СписокВыбора.Добавить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонНаименования, 
			СтрКонтакт, СтрСумма, НСтр("ru = 'взял(а) в долг'")));
	ИначеЕсли НЕ Объект.ИспользоватьДляУчетаВыданныхДолгов И Объект.ИспользоватьДляУчетаВзятыхДолгов Тогда
		Элемент.СписокВыбора.Добавить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонНаименования, 
			СтрКонтакт, СтрСумма, НСтр("ru = 'дал(а) в долг'")));
	КонецЕсли; 
	
	Если Объект.ИспользоватьДляУчетаВыданныхДолгов И НЕ Объект.ИспользоватьДляУчетаВзятыхДолгов Тогда
		Элемент.СписокВыбора.Добавить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонНаименования, 
			СтрКонтакт, НСтр("ru = 'Заем'"), Объект.Валюта));
	ИначеЕсли НЕ Объект.ИспользоватьДляУчетаВыданныхДолгов И Объект.ИспользоватьДляУчетаВзятыхДолгов Тогда
		Элемент.СписокВыбора.Добавить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонНаименования, 
			СтрКонтакт, НСтр("ru = 'Кредит'"), Объект.Валюта));
	Иначе
		Элемент.СписокВыбора.Добавить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонНаименования, 
			СтрКонтакт, НСтр("ru = 'Долг'"), Объект.Валюта));
	КонецЕсли; 
	
КонецПроцедуры // СформироватьСписокВыбораНаименования()


#КонецОбласти

