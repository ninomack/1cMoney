
&НаСервере
Функция ПолучитьДанныеПараметраКоманды(Знач ПараметрКоманды)
	
	Результат = Новый Структура();
	Результат.Вставить("ИмяМетаданных", ПараметрКоманды.Метаданные().Имя);
	Результат.Вставить("ЭтоШаблон", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПараметрКоманды, "ЭтоШаблон"));
	Результат.Вставить("ПустаяСсылка", Документы[Результат.ИмяМетаданных].ПустаяСсылка());
	
	Возврат Результат;

КонецФункции
  

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ДанныеПараметра = ПолучитьДанныеПараметраКоманды(ПараметрКоманды);
	ПараметрыФормы = Новый Структура("ЗначениеКопирования, ЗначенияЗаполнения",
			ПараметрКоманды, Новый Структура("ЭтоШаблон", НЕ ДанныеПараметра.ЭтоШаблон));
	Если ПараметрыВыполненияКоманды.Источник.Параметры.Свойство("Ключ") И ПараметрыВыполненияКоманды.Источник.Открыта() Тогда
		ПараметрыВыполненияКоманды.Источник.Закрыть();
	КонецЕсли; 
	ОткрытьФорму("Документ." + ДанныеПараметра.ИмяМетаданных + ".ФормаОбъекта", ПараметрыФормы, , ДанныеПараметра.ПустаяСсылка);
	
КонецПроцедуры
