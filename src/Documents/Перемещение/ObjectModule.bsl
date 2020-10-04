#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ДанныеЗаполнения <> Неопределено И ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ОбщегоНазначенияДеньги.ЗаполнитьОбъектПоСтруктуре(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли; 
	
	// Проверяем реквизиты нового документа в соответствии с настройками пользователя
	ОбслуживаниеДокументов.ПроверитьЗаполнениеНовогоДокумента(ЭтотОбъект);
	
	Если НЕ ЗначениеЗаполнено(КошелекКуда) ИЛИ Не ЗначениеЗаполнено(КошелекОткуда) Тогда
		
		ОсновнойКошелек = ПользовательскиеНастройкиДеньгиСервер.ОсновнойКошелек();
		КошелекКуда   = ?(ЗначениеЗаполнено(КошелекКуда), КошелекКуда, ОсновнойКошелек);
		КошелекОткуда = ?(ЗначениеЗаполнено(КошелекОтКуда), КошелекОтКуда, ОсновнойКошелек);
		
	КонецЕсли; 
	
	// Заполняем незаполненные реквизиты значениями по умолчанию:
	Если ЗначениеЗаполнено(ФинансоваяЦельКуда) И ЗначениеЗаполнено(КошелекКуда) И НЕ КошелекКуда.ИспользоватьДляНакоплений Тогда
		КошелекКуда = РазделыУчета.ПолучитьКошелекДляНакоплений(ФинансоваяЦельКуда);
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(ФинансоваяЦельОткуда) И ЗначениеЗаполнено(КошелекОткуда) И НЕ КошелекОткуда.ИспользоватьДляНакоплений Тогда
		КошелекОткуда = РазделыУчета.ПолучитьКошелекДляНакоплений(ФинансоваяЦельОткуда);
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(КошелекОткуда) Тогда
		ВалютаОперации = КошелекОткуда.Валюта;
	КонецЕсли; 
	
	Если НЕ ЗначениеЗаполнено(СчетОткуда) Тогда
		Если КошелекОткуда.ИспользоватьДляНакоплений = Истина Тогда
			СчетОткуда = ПланыСчетов.РазделыУчета.Накопления;
		Иначе
			СчетОткуда = ПланыСчетов.РазделыУчета.СвободныеДеньги;
		КонецЕсли; 
	КонецЕсли; 
	
	Если НЕ ЗначениеЗаполнено(СчетКуда) Тогда
		Если КошелекКуда.ИспользоватьДляНакоплений = Истина Тогда
			СчетКуда = ПланыСчетов.РазделыУчета.Накопления;
		Иначе
			СчетКуда = ПланыСчетов.РазделыУчета.СвободныеДеньги;
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	// Общий функционал документов:
	ОбщегоНазначенияДеньги.ОбработкаСобытияПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗначениеЗаполнено(КошелекОткуда) И ЗначениеЗаполнено(КошелекКуда)
		И КошелекОткуда.Валюта <> КошелекКуда.Валюта Тогда
		ТекстСообщения = НСтр("ru = 'Валюта кошелька зачисления отличается от валюты кошелька списания'"); 
		ТекстСообщения = ДеньгиКлиентСервер.ПолучитьТекстСообщения(, "Корректность",
			НСтр("ru = 'Кошелек зачисления'"),,, ТекстСообщения);
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект,
			"КошелекКуда", "Объект", Отказ);
	КонецЕсли; 
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	Если ЭтоШаблон Тогда
		МассивНепроверяемыхРеквизитов.Добавить("КошелекОткуда");
		МассивНепроверяемыхРеквизитов.Добавить("КошелекКуда");
		МассивНепроверяемыхРеквизитов.Добавить("СуммаОперации");
	КонецЕсли; 
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 
	
	// Проверяем/заполняем итоговые и информационные реквизиты
	Документы.Перемещение.ОбновитьИтоговыеСуммыДокумента(ЭтотОбъект);
	
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
	Документы.Перемещение.ПроверитьДополнительныеСвойстваОперации(ЭтотОбъект, ДополнительныеСвойства, Истина);
	ОбслуживаниеДокументов.ПриЗаписиОбъектаДокумента(ЭтотОбъект);
	
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	
	Если ОбменДанными.Загрузка ИЛИ ЭтоШаблон Тогда
		Возврат;
	КонецЕсли; 
	
	Документы.Перемещение.СформироватьДвиженияДокумента(Ссылка, Движения, ДополнительныеСвойства);
	ПлановыеОперации.ПроверитьОборотыПлановойОоперацииПриПроведении(ЭтотОбъект);
	
	Движения.ЖурналОпераций.Записывать            = Истина;
	Движения.ФактическиеОборотыБюджета.Записывать = Истина;
	
КонецПроцедуры

#КонецОбласти


#КонецЕсли
