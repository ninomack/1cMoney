#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Функция ПараметрыСобытийОтчета() Экспорт
	
	ВерсияСобытийОтчета = "1";  // номер версии универсального механизма, с которой совместим отчет
	ПараметрыСобытийОтчета = ОтчетыКлиентСервер.ПараметрыСобытийОтчетаПоУмолчанию(ВерсияСобытийОтчета);
	
	ПараметрыСобытийОтчета.ВыполнятьПриОбработкеПараметраФормыОтбор = Истина;
	
	Возврат ПараметрыСобытийОтчета;
	
КонецФункции

// Вызывается один раз после создания формы, когда уже заполнен Отчет.КомпоновщикНастроек.
//
Процедура ПриОбработкеПараметраФормыОтбор(Отбор, ЭтаФорма) Экспорт
	
	Перем КомпоновщикНастроек;
	
	КомпоновщикНастроек = ЭтаФорма.Отчет.КомпоновщикНастроек;
	
	// Если есть отбор по кошельку, надо проверить вид сравнения 
	Если Отбор.Свойство("Кошелек") Тогда
		ЭлементыОтбора = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(КомпоновщикНастроек.ФиксированныеНастройки.Отбор, "Кошелек");
		Для каждого ЭлементОтбора Из ЭлементыОтбора Цикл
			Если ТипЗнч(ЭлементОтбора.ПравоеЗначение) = Тип("СправочникСсылка.КошелькиИСчета") И ЭлементОтбора.ПравоеЗначение.ЭтоГруппа Тогда
				ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если Отбор.Свойство("ИсточникПоступления") Тогда
		ЭлементыОтбора = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(КомпоновщикНастроек.ФиксированныеНастройки.Отбор, "ИсточникДохода");
		Для каждого ЭлементОтбора Из ЭлементыОтбора Цикл
			ТипЗначенияОтбора = ТипЗнч(ЭлементОтбора.ПравоеЗначение);
			Если ТипЗначенияОтбора = Тип("СправочникСсылка.СтатьиДоходов")
				Или ТипЗначенияОтбора = Тип("СправочникСсылка.КошелькиИСчета") И ЭлементОтбора.ПравоеЗначение.ЭтоГруппа
				Или ТипЗначенияОтбора = Тип("СправочникСсылка.Имущество") И ЭлементОтбора.ПравоеЗначение.ЭтоГруппа Тогда
				ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#КонецЕсли
