
&НаКлиенте
Процедура ПояснениеНажатие(Элемент)
	
	ОткрытьФорму("Обработка.ОбзорОсновныхВозможностей.Форма.Обучение");
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьНастройкиНажатие(Элемент)
	
	ОткрытьФорму("Обработка.ОбзорОсновныхВозможностей.Форма.ФормаНастроекИндикатораНачальнойСтраницы");
	
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РазрешенПоказ = ОбщегоНазначенияВызовСервера.ХранилищеСистемныхНастроекЗагрузить("Общее/ПросмотрКраткихПодсказок", "ПоказыватьОбучениеНаНачальнойСтранице", Истина);
	Если НЕ РазрешенПоказ Тогда
		Отказ = Истина;
	КонецЕсли; 
	
КонецПроцедуры

