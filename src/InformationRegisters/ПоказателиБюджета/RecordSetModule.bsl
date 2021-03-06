
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


#Область ОбработчикиСобытий

// При записи контролируются курсы подчиненных валют.
//
Процедура ПередЗаписью(Отказ, Замещение)
	
	Для каждого Запись Из ЭтотОбъект Цикл
		
		// Для обеспечения обмена с мобильными приложениями на переходный период
		Если ЗначениеЗаполнено(Запись.ГрафаБюджета) И Не ЗначениеЗаполнено(Запись.ТипПоказателя) Тогда
			Запись.ТипПоказателя = Запись.ГрафаБюджета.ТипПоказателя;
			Если ЭтотОбъект.Количество() = 1 Тогда
				ЭтотОбъект.Отбор.ТипПоказателя.Установить(Запись.ТипПоказателя);
			КонецЕсли;
		ИначеЕсли Не ЗначениеЗаполнено(Запись.ГрафаБюджета) И ЗначениеЗаполнено(Запись.ТипПоказателя) Тогда
			Запись.ГрафаБюджета = БюджетированиеСервер.ГрафаБюжетаДляСтатьи(Запись.СтатьяБюджета, Запись.ТипПоказателя, Запись.РазделБюджета);
			Если ЭтотОбъект.Количество() = 1 Тогда
				ЭтотОбъект.Отбор.ГрафаБюджета.Установить(Запись.ГрафаБюджета);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	
КонецПроцедуры

#КонецОбласти


#КонецЕсли