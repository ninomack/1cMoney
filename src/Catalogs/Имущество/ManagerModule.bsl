#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПолучитьСтоимостьИмущества(Имущество, ДатаОстатка) Экспорт

	Результат = Новый Структура("Валюта, Сумма", Неопределено, 0);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаОстатка",    ДатаОстатка);
	Запрос.УстановитьПараметр("Имущество",      Имущество);
	
	СписокВидовСбк = Новый СписокЗначений;
	СписокВидовСбк.Добавить(ПланыВидовХарактеристик.ВидыСубконто.Имущество);
	Запрос.УстановитьПараметр("СписокВидовСбк",      СписокВидовСбк);
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	БУ.Субконто1 КАК Имущество,
	|	БУ.Валюта,
	|	БУ.ВалютнаяСуммаОстатокДт КАК Сумма
	|ИЗ
	|	РегистрБухгалтерии.ЖурналОпераций.Остатки(&ДатаОстатка, СЧЕТ = ЗНАЧЕНИЕ(ПланСчетов.РазделыУчета.Имущество), &СписокВидовСбк, Субконто1 В (&Имущество)) КАК БУ";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(Результат, Выборка);
	КонецЕсли; 
	
	Возврат Результат;

КонецФункции

// Обновляет информационные реквизиты по указанному или всему имуществу
//	в регистре сведений "СтатистикаСправочников".
//Перед использованием необходимо актуализировать ключи статей.
//
//Параметры:
//	Ссылка - СправочникСсылка или Неопределено 
//
Процедура ОбновитьРегистрСтатистики(Ссылка = Неопределено) Экспорт
	
	РегистрыСведений.СтатистикаСправочников.ОбновитьСтатистикуСправочника("Имущество", Ссылка);
	
КонецПроцедуры


#КонецОбласти



#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	// Проверяем/устанавливаем стандартные параметры отбора
	ОбслуживаниеСправочников.ПроверитьСтандартныеПараметрыОтбора(Параметры);
	
	// Если в параметрах есть необходимые ключи/значения будет выполнена расширенная обработка получения данных
	ОбслуживаниеСправочников.ВыполнитьРасширенноеПолучениеДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаОбъекта" Тогда
		
		Если НЕ Параметры.Свойство("Ключ") ИЛИ НЕ ЗначениеЗаполнено(Параметры.Ключ) Тогда
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = "Обработка.ПомощникСозданияИмущества.Форма";
		КонецЕсли;
		
	ИначеЕсли ВидФормы = "ФормаВыбора" ИЛИ ВидФормы = "ФормаВыбораГруппы" Тогда 
		
		ОбслуживаниеСправочников.ОбработкаПолученияФормыВыбора(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#КонецЕсли
