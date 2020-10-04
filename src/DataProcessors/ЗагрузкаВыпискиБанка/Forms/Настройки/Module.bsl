////////////////////////////////////////////////////////////////////////////////
//Обработка.ЗагрузкаВыписокБанка.Форма.Настройки
//  Изменяет настройки загрузки выписки банка
//  
//Параметры формы:
//  СтруктураНастроек - Структкра
//  
////////////////////////////////////////////////////////////////////////////////


#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтруктураНастроек = Параметры.СтруктураНастроек;
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтруктураНастроек);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГруппаДляНовыхКошельковОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ТипВыбранного = ТипЗнч(ВыбранноеЗначение);
	Если ТипВыбранного = Тип("Строка") Тогда
		ОбслуживаниеСправочниковКлиент.РасширенноеПолучениеДанныхОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаДляНовыхСтатейДоходовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ТипВыбранного = ТипЗнч(ВыбранноеЗначение);
	Если ТипВыбранного = Тип("Строка") Тогда
		ОбслуживаниеСправочниковКлиент.РасширенноеПолучениеДанныхОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаДляНовыхСтатейРасходовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ТипВыбранного = ТипЗнч(ВыбранноеЗначение);
	Если ТипВыбранного = Тип("Строка") Тогда
		ОбслуживаниеСправочниковКлиент.РасширенноеПолучениеДанныхОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	КонецЕсли; 
	
КонецПроцедуры



#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормы_ИмяТаблицы



#КонецОбласти


#Область ОбработчикиКомандФормы


&НаКлиенте
Процедура Ок(Команда)
	
	ЗаполнитьЗначенияСвойств(СтруктураНастроек, ЭтотОбъект);
	Закрыть(СтруктураНастроек);
	
КонецПроцедуры


#КонецОбласти


#Область СлужебныеПроцедурыИФункции


#КонецОбласти
