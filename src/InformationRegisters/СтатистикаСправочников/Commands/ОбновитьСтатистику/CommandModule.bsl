
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ОбработатьКомандуНаСервере(ПараметрКоманды);
	Сообщить(НСтр("ru='Статистика справочника обновлена. Нажмите F5 для обновления списка'"));
КонецПроцедуры

&НаСервере
Процедура ОбработатьКомандуНаСервере(Ссылка)
	
	БюджетированиеСервер.ОбновитьВсеКлючиСтатейБюджета();
	Если Не ЗначениеЗаполнено(Ссылка) Или Не ОбщегоНазначения.ЭтоСсылка(ТипЗнч(Ссылка)) Тогда
		РегистрыСведений.СтатистикаСправочников.ОбновитьВсюСтатистикуСправочников();
	Иначе
		РегистрыСведений.СтатистикаСправочников.ОбновитьСтатистикуСправочника(Ссылка.Метаданные().Имя, Неопределено);
	КонецЕсли;
	
КонецПроцедуры
