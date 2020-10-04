
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", Новый Структура);
	Если ЗначениеЗаполнено(ПараметрКоманды) Тогда
		ПараметрыФормы.Отбор.Вставить("ФинансоваяЦель", ПараметрКоманды);
	КонецЕсли;
	ПараметрыФормы.Вставить("КлючВарианта", "ОперацииПоЦели");
	ПараметрыФормы.Вставить("СформироватьПриОткрытии", ЗначениеЗаполнено(ПараметрКоманды));
	
	ОткрытьФорму("Отчет.ОтчетПоФинансовымЦелям.ФормаОбъекта", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры
