#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	СинхронизацияАвтономныхКопий.УзелОбменаПередЗаписью(ЭтотОбъект, Отказ);
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый() И Не ЗначениеЗаполнено(ВерсияФорматаОбмена) Тогда
		ВерсияОбмена            = СинхронизацияАвтономныхКопийКлиентСервер.МинимальнаяВерсияФормата();
		ВерсияФорматаОбмена     = ВерсияОбмена;
	КонецЕсли;
	
	Если Не Ссылка.Пустая() Тогда
		
		Если ПометкаУдаления И Активность И НЕ Ссылка.Активность Тогда
			ПометкаУдаления = Ложь;
		ИначеЕсли ПометкаУдаления И НЕ Ссылка.ПометкаУдаления И Активность Тогда
			Активность = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ДанныеЗаполнения = Неопределено Тогда
		Активность              = Истина;
		ВерсияОбмена            = СинхронизацияАвтономныхКопийКлиентСервер.МинимальнаяВерсияФормата();
		ВерсияФорматаОбмена     = ВерсияОбмена;
		МобильноеУстройство     = Истина;
		РегистрироватьИзменения = Истина;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЗаписьНовогоУзла", ЭтоНовый());
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	СинхронизацияАвтономныхКопий.УзелОбменаПриЗаписи(ЭтотОбъект, Отказ);
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ОбменДаннымиСервер.НастройкаСинхронизацииЗавершена(Ссылка) Тогда
		ОбменДаннымиСервер.ЗавершитьНастройкуСинхронизацииДанных(Ссылка);
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ПолучениеСообщенияОбмена") Тогда
		БюджетированиеСервер.ОбновитьВсеКлючиСтатейБюджета();
		РегистрыСведений.СтатистикаСправочников.ОбновитьВсюСтатистикуСправочников();
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#КонецЕсли
