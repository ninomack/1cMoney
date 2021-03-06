
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПолучитьШаблонДляНакопления(Долг) Экспорт

	ЗаписьРегистра = РегистрыСведений.ПараметрыГрафикаПогашенияДолгов.СоздатьМенеджерЗаписи();
	ЗаписьРегистра.Долг = Долг;
	ЗаписьРегистра.Прочитать();
	Возврат ЗаписьРегистра.ШаблонОперации;

КонецФункции


#КонецОбласти



#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	// Проверяем/устанавливаем стандартные параметры отбора
	ОбслуживаниеСправочников.ПроверитьСтандартныеПараметрыОтбора(Параметры);
	
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаОбъекта" Тогда
		
		Если НЕ Параметры.Свойство("Ключ") ИЛИ НЕ ЗначениеЗаполнено(Параметры.Ключ) Тогда
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = "Обработка.ПомощникСозданияФинансовойЦели.Форма";
		КонецЕсли;
		
	ИначеЕсли ВидФормы = "ФормаВыбора" ИЛИ ВидФормы = "ФормаВыбораГруппы" Тогда 
		
		ОбслуживаниеСправочников.ОбработкаПолученияФормыВыбора(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли





