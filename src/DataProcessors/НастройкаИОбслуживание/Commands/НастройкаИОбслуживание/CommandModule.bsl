
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму(
		"Обработка.НастройкаИОбслуживание.Форма.НастройкаИОбслуживание",
		Новый Структура,
		ПараметрыВыполненияКоманды.Источник,
		"Обработка.НастройкаИОбслуживание.Форма.НастройкаИОбслуживание" + ?(ПараметрыВыполненияКоманды.Окно = Неопределено, ".ОтдельноеОкно", ""),
		ПараметрыВыполненияКоманды.Окно);
		
КонецПроцедуры
