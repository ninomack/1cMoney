#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда



#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	// Проверяем/устанавливаем стандартные параметры отбора
	ОбслуживаниеСправочников.ПроверитьСтандартныеПараметрыОтбора(Параметры);
	
	// Если в параметрах есть необходимые ключи/значения будет выполнена расширенная обработка получения данных
	ОбслуживаниеСправочников.ВыполнитьРасширенноеПолучениеДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка);
	
КонецПроцедуры


#КонецОбласти


#КонецЕсли

