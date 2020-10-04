#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ДанныеЗаполнения <> Неопределено И ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		// Заполняем данными заполнения отмеченные в конфигураторе реквизиты
		ОбщегоНазначенияДеньги.ЗаполнитьОбъектПоСтруктуре(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли; 
	
	// Проверяем реквизиты нового документа в соответствии с настройками пользователя
	ОбслуживаниеДокументов.ПроверитьЗаполнениеНовогоДокумента(ЭтотОбъект);
	
	Если НЕ ЗначениеЗаполнено(Контакт) И ЗначениеЗаполнено(Долг) Тогда
		Контакт = Долг.Контакт;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	// Общий функционал документов:
	ОбщегоНазначенияДеньги.ОбработкаСобытияПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	Если ЭтоШаблон Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Кошелек");
		МассивНепроверяемыхРеквизитов.Добавить("Долг");
	КонецЕсли; 
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 
	
	// Проверяем/заполняем итоговые и информационные реквизиты
	Документы.МыДалиВДолг.ОбновитьИтоговыеСуммыДокумента(ЭтотОбъект);
	
	Если ЭтоШаблон Тогда
		Проведен = Ложь;
		Если РежимЗаписи <> РежимЗаписиДокумента.Запись Тогда
			РежимЗаписи = РежимЗаписиДокумента.Запись;
		КонецЕсли; 
		Возврат;
	КонецЕсли; 

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 
	
	// Заполняем дополнительные реквизиты информацией, необходимой для формирования записей в регистры
	Документы.МыДалиВДолг.ПроверитьДополнительныеСвойстваОперации(ЭтотОбъект, ДополнительныеСвойства, Истина);
	ОбслуживаниеДокументов.ПриЗаписиОбъектаДокумента(ЭтотОбъект);
	
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если ОбменДанными.Загрузка ИЛИ ЭтоШаблон Тогда
		Возврат;
	КонецЕсли; 
	
	Документы.МыДалиВДолг.СформироватьДвиженияДокумента(Ссылка, Движения, ДополнительныеСвойства);
	ПлановыеОперации.ПроверитьОборотыПлановойОоперацииПриПроведении(ЭтотОбъект);
	
	Движения.ЖурналОпераций.Записывать            = Истина;
	Движения.ФактическиеОборотыБюджета.Записывать = Истина;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ	

#КонецЕсли

