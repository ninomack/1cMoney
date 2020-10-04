#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда



#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ДанныеЗаполнения <> Неопределено И ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ОбщегоНазначенияДеньги.ЗаполнитьОбъектПоСтруктуре(ЭтотОбъект, ДанныеЗаполнения);
		
		ДополнительныеПараметрыСоздания = Неопределено;
		Если ДанныеЗаполнения.Свойство("ДополнительныеПараметрыСоздания", ДополнительныеПараметрыСоздания) Тогда
			Если ДополнительныеПараметрыСоздания.Свойство("Наименование") Тогда
				Наименование = ДополнительныеПараметрыСоздания.Наименование;
				ТекстЗаполнения = Наименование;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли; 
	
	Активность = Истина;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОтложеннаяЗапись = ДополнительныеСвойства.Свойство("ОтложеннаяЗапись");
	
	// Проверки перед записью
	ОбслуживаниеСправочников.ПроверкаИзмененияПредопределенныхЭлементовПередЗаписью(ЭтотОбъект, Отказ, "Наименование");
	Если Не Отказ И Не ОтложеннаяЗапись Тогда
		ОбслуживаниеСправочников.ПроверкаНаименованияСправочникаПередЗаписью(ЭтотОбъект, Отказ);
	КонецЕсли;
	Если Не Отказ И Не ОтложеннаяЗапись Тогда
		ОбслуживаниеСправочников.СогласованиеПометкиИАктивностиПередЗаписью(ЭтотОбъект, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОтложеннаяЗапись = ДополнительныеСвойства.Свойство("ОтложеннаяЗапись");
	Если Не ОтложеннаяЗапись Тогда
		ОбслуживаниеСправочников.ОбновлениеСвязаннойИнформацииПриЗаписи(ЭтотОбъект, Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции


#КонецОбласти


#КонецЕсли

