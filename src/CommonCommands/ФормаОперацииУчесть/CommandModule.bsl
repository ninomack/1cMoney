
// "Учесть" проводит документ и закрывает его форму
//	Если документ помечен на удаление и пользователь подтверждает его проведение, 
//	пометка на удаление снимается штатным образом до проведения документа
//
//Параметры: штатные параметры обработчика команды
//
//
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Форма  = ПараметрыВыполненияКоманды.Источник;
	Объект = Форма.Объект;
	
	Если Объект.ПометкаУдаления Тогда
		
		Кнопки = Новый СписокЗначений;
		
		Оповещение = Новый ОписаниеОповещения("ОбработкаКомандыПриПометкеУдаленияЗавершение", ЭтотОбъект, ПараметрыВыполненияКоманды);
		Если Объект.ЭтоШаблон Тогда
			ТекстВопроса = НСтр("ru='Снять пометку на удаление с этого шаблона?'");
			Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Снять пометку'"));
		Иначе
			ТекстВопроса = НСтр("ru='Операция помечена на удаление.
					|Снять пометку на удаление и учесть операцию?'");
			Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Снять пометку и учесть'"));
		КонецЕсли;
		 
		Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru='Отмена'"));
		ПоказатьВопрос(Оповещение, ТекстВопроса, Кнопки, , , Форма.Заголовок);
		
	Иначе
		
		ЗаписатьОперациюКлиент(Форма, Объект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКомандыПриПометкеУдаленияЗавершение(Ответ, ДополнительныеПараметры) Экспорт

	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		Форма  = ДополнительныеПараметры.Источник;
		Объект = Форма.Объект;
		
		Объект.ПометкаУдаления = Ложь;
		//Форма.ОбновитьСостояниеОперацииКлиент();
		РаботаСФормамиДокументовКлиентСервер.ОбновитьЭлементыФормыПоСостояниюОперации(Форма);
		ЗаписатьОперациюКлиент(Форма, Объект);
		
	КонецЕсли;

КонецПроцедуры


&НаКлиенте
Процедура ЗаписатьОперациюКлиент(Форма, Объект)

	// Шаблон записывается без проведения.
	// Проведенная, непроведенная и новая операция записываются с проведением.
	РежимЗаписи = ?(Объект.ЭтоШаблон, РежимЗаписиДокумента.Запись, РежимЗаписиДокумента.Проведение);
	ПараметрыЗаписи = Новый Структура("РежимЗаписи,ЗакрыватьФорму", РежимЗаписи, Истина);
	
	Если Форма.Записать(ПараметрыЗаписи) И Форма.Открыта() Тогда
		Форма.Закрыть(Объект.Ссылка);
	КонецЕсли;

КонецПроцедуры
