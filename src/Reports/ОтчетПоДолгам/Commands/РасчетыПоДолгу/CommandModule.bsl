
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", Новый Структура);
	Если ЗначениеЗаполнено(ПараметрКоманды) Тогда
		ПараметрыФормы.Отбор.Вставить("Долг", ПараметрКоманды);
	КонецЕсли;
	ПараметрыФормы.Вставить("КлючВарианта", "Основной");
	ПараметрыФормы.Вставить("СформироватьПриОткрытии", ЗначениеЗаполнено(ПараметрКоманды));
	
	ОткрытьФорму("Отчет.ОтчетПоДолгам.Форма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры
