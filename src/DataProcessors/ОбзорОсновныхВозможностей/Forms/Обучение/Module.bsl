
&НаКлиенте
Перем ОбновитьИнтерфейс;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СуффиксИмен = "Такси";
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПоказатьПредупреждение(, НСтр("ru='Извините, обучающие материалы будут обновены в следующих версиях'"));
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если Не ЗавершениеРаботы Тогда
		ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ






////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

// СтандартныеПодсистемы.Пользователи
&НаКлиенте
Процедура СправочникВнешниеПользователи(Команда)
	ОткрытьФорму("Справочник.ВнешниеПользователи.ФормаСписка", , ЭтаФорма);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Пользователи

&НаКлиенте
Процедура Обучение1(Команда)
	
	ОткрытьФорму("Обработка.ОбзорОсновныхВозможностей.Форма.НачалоРаботы" + СуффиксИмен, , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Обучение2(Команда)
	
	ОткрытьФорму("Обработка.ОбзорОсновныхВозможностей.Форма.УстройствоГлавногоОкнаПрограммы" + СуффиксИмен, , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Обучение4(Команда)
	
	ОткрытьФорму("Обработка.ОбзорОсновныхВозможностей.Форма.ФормаОперации" + СуффиксИмен, , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Обучение5(Команда)
	
	ОткрытьФорму("Обработка.ОбзорОсновныхВозможностей.Форма.Календарь" + СуффиксИмен, , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Обучение6(Команда)
	
	ОткрытьФорму("Обработка.ОбзорОсновныхВозможностей.Форма.ФормаНакопления" + СуффиксИмен, , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Обучение7(Команда)
	
	ОткрытьФорму("Обработка.ОбзорОсновныхВозможностей.Форма.Шаблоны" + СуффиксИмен, , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Обучение8(Команда)
	
	ОткрытьФорму("Обработка.ОбзорОсновныхВозможностей.Форма.Бюджет" + СуффиксИмен, , ЭтаФорма);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	Результат = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	Если ОбновлятьИнтерфейс Тогда
		#Если НЕ ВебКлиент Тогда
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 1, Истина);
		ОбновитьИнтерфейс = Истина;
		#КонецЕсли
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	#Если НЕ ВебКлиент Тогда
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбновитьИнтерфейс();
	КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	Результат = Новый Структура;
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат);
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Процедура СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат;
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьНастройкиНажатие(Элемент)
	
	ОткрытьФорму("Обработка.ОбзорОсновныхВозможностей.Форма.ФормаНастроекИндикатораНачальнойСтраницы");
	
КонецПроцедуры




