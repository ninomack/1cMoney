

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Заголовок         = Параметры.ЗаголовокФормы;
	ТекстСообщения    = Параметры.ТекстСообщения;
	ТекстРекомендаций = Параметры.ТекстРекомендаций;
	Если Параметры.НомерИконки = 1 Тогда
		Элементы.КартинкаОшибки.Картинка = БиблиотекаКартинок.Предупреждение32;
	КонецЕсли;
	ДополнительнаяИнформация = Параметры.ДополнительнаяИнформация;
	
	Если не ЗначениеЗаполнено(ТекстРекомендаций) Тогда
		Элементы.ТекстРекомендаций.Видимость = Ложь;
	КонецЕсли;
	
	// Сброс расположения и размеров формы
	ОбщегоНазначенияДеньги.СброситьРазмерИПоложениеФормы(ЭтотОбъект);
	
КонецПроцедуры


#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы



#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормы_ИмяТаблицы



#КонецОбласти


#Область ОбработчикиКомандФормы



#КонецОбласти


#Область СлужебныеПроцедурыИФункции


#КонецОбласти
