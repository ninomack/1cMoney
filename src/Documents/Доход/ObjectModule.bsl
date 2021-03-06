#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ВалютаОперации = Константы.ВалютаУчета.Получить();
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		// Заполняем данными заполнения отмеченные в конфигураторе реквизиты
		ОбщегоНазначенияДеньги.ЗаполнитьОбъектПоСтруктуре(ЭтотОбъект, ДанныеЗаполнения);
		
		Если Доходы.Количество() = 0  Тогда
			
			// В данных заполнения могут быть заданы реквизиты для табличной части "Доходы",
			//	тогда нужно добавить первую строку
			
			КошелекДляНовойСтроки = Неопределено;
			ДанныеЗаполнения.Свойство("Кошелек", КошелекДляНовойСтроки);
			КошелекДляНовойСтроки = ?(КошелекДляНовойСтроки = Неопределено, ПользовательскиеНастройкиДеньгиСервер.ОсновнойКошелек(), КошелекДляНовойСтроки);
			СтатьяДляНовойСтроки = Неопределено;
			ДанныеЗаполнения.Свойство("СтатьяДохода", СтатьяДляНовойСтроки);
			ФинансоваяЦельДляНовойСтроки = Неопределено;
			ДанныеЗаполнения.Свойство("ФинансоваяЦель", ФинансоваяЦельДляНовойСтроки);
			СуммаДоходаДляНовойСтроки = Неопределено;
			ДанныеЗаполнения.Свойство("СуммаДохода", СуммаДоходаДляНовойСтроки);
			
			Если ЗначениеЗаполнено(КошелекДляНовойСтроки) ИЛИ ЗначениеЗаполнено(СтатьяДляНовойСтроки) 
				ИЛИ ЗначениеЗаполнено(ФинансоваяЦельДляНовойСтроки) ИЛИ ЗначениеЗаполнено(СуммаДоходаДляНовойСтроки) Тогда
				
				НоваяСтрока = Доходы.Добавить();
				НоваяСтрока.Кошелек        = КошелекДляНовойСтроки;
				НоваяСтрока.СтатьяДохода   = СтатьяДляНовойСтроки;
				НоваяСтрока.ФинансоваяЦель = ФинансоваяЦельДляНовойСтроки;
				Если ЗначениеЗаполнено(НоваяСтрока.ФинансоваяЦель) И НЕ НоваяСтрока.Кошелек.ИспользоватьДляНакоплений Тогда
					НоваяСтрока.Кошелек = РазделыУчета.ПолучитьКошелекДляНакоплений(ФинансоваяЦельДляНовойСтроки);
				КонецЕсли;
				Если ЗначениеЗаполнено(НоваяСтрока.Кошелек) И НоваяСтрока.Кошелек.Валюта <> ВалютаОперации Тогда
					КурсИКратность          = РаботаСКурсамиВалют.ПолучитьКурсВалюты(КошелекДляНовойСтроки.Валюта, Дата, ВалютаОперации);
					НоваяСтрока.Курс        = КурсИКратность.Курс;
					НоваяСтрока.Кратность   = КурсИКратность.Кратность;
				Иначе
					НоваяСтрока.Курс           = 1;
					НоваяСтрока.Кратность      = 1;
				КонецЕсли; 
				Если ЗначениеЗаполнено(СуммаДоходаДляНовойСтроки) Тогда
					НоваяСтрока.СуммаВВалютеОперации = СуммаДоходаДляНовойСтроки;
					НоваяСтрока.СуммаДохода = НоваяСтрока.СуммаВВалютеОперации * НоваяСтрока.Курс / НоваяСтрока.Кратность;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли; 
		
	КонецЕсли;
	
	// Проверяем реквизиты нового документа в соответствии с настройками пользователя
	ОбслуживаниеДокументов.ПроверитьЗаполнениеНовогоДокумента(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	// Общий функционал документов:
	ОбщегоНазначенияДеньги.ОбработкаСобытияПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
	// Обслуживание плановых операций:
	ПлановыеОперации.ОбработкаСобытияПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
	// Обновляем курсы валют на новую дату
	Для Каждого СтрокаДокумента Из Доходы Цикл
		Если СтрокаДокумента.Кошелек.Валюта <> ВалютаОперации Тогда
			КурсИКратность            = РаботаСКурсамиВалют.ПолучитьКурсВалюты(СтрокаДокумента.Кошелек.Валюта, Дата, ВалютаОперации);
			СтрокаДокумента.Курс      = КурсИКратность.Курс;
			СтрокаДокумента.Кратность = КурсИКратность.Кратность;
		Иначе
			СтрокаДокумента.Курс      = 1;
			СтрокаДокумента.Кратность = 1;
		КонецЕсли; 
		СтрокаДокумента.СуммаВВалютеОперации = СтрокаДокумента.СуммаДохода * СтрокаДокумента.Курс / ?(ЗначениеЗаполнено(СтрокаДокумента.Кратность), СтрокаДокумента.Кратность, 1);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	Если ЭтоШаблон Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Доходы.Кошелек");
		МассивНепроверяемыхРеквизитов.Добавить("Доходы.СтатьяДохода");
	КонецЕсли; 
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Проверим финансовые цели
	ОбщиеНакопления = Справочники.ФинансовыеЦели.ОбщиеНакопления;
	Для Каждого Строка Из Доходы Цикл
		Если ЗначениеЗаполнено(Строка.Кошелек) И Строка.Кошелек.ИспользоватьДляНакоплений Тогда
			Если НЕ ЗначениеЗаполнено(Строка.ФинансоваяЦель) Тогда
				Строка.ФинансоваяЦель = ОбщиеНакопления;
			КонецЕсли; 
		Иначе
			Строка.ФинансоваяЦель = Неопределено;
		КонецЕсли; 
	КонецЦикла;
	
	Если ЭтоШаблон Тогда
		Проведен = Ложь;
		Если РежимЗаписи <> РежимЗаписиДокумента.Запись Тогда
			РежимЗаписи = РежимЗаписиДокумента.Запись;
		КонецЕсли; 
	КонецЕсли; 
	
	ЗаполнитьИнформационныеРеквизиты();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 
	
	// Заполняем дополнительные реквизиты информацией, необходимой для формирования записей в регистры
	Документы.Доход.ПроверитьДополнительныеСвойстваОперации(ЭтотОбъект, ДополнительныеСвойства, Истина);
	ОбслуживаниеДокументов.ПриЗаписиОбъектаДокумента(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если ОбменДанными.Загрузка ИЛИ ЭтоШаблон Тогда
		Возврат;
	КонецЕсли; 
	
	Документы.Доход.СформироватьДвиженияДокумента(Ссылка, Движения, ДополнительныеСвойства);
	ПлановыеОперации.ПроверитьОборотыПлановойОоперацииПриПроведении(ЭтотОбъект);
	
	Движения.ЖурналОпераций.Записывать            = Истина;
	Движения.ФактическиеОборотыБюджета.Записывать = Истина;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

// Заполняет информационные реквизиты документа, с помощью которых 
//	обеспечивается краткое и подробное представление документа в списках
Процедура ЗаполнитьИнформационныеРеквизиты()
	
	СуммаОперации = Доходы.Итог("СуммаВВалютеОперации");
	
	Кошельки      = Новый Соответствие;
	Статьи        = Новый Соответствие;
	Аналитики     = Новый Соответствие;
	
	Для Каждого СтрокаДохода Из Доходы Цикл
		
		ЭлементКошелька = Кошельки.Получить(СтрокаДохода.Кошелек);
		
		Если ЗначениеЗаполнено(СтрокаДохода.Кошелек) Тогда
			
			Если ЭлементКошелька = Неопределено Тогда
				Кошельки.Вставить(СтрокаДохода.Кошелек, Новый Соответствие);
				ЭлементКошелька = Кошельки.Получить(СтрокаДохода.Кошелек);
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаДохода.СтатьяДохода) Тогда
			
			Статьи.Вставить(СтрокаДохода.СтатьяДохода, Строка(СтрокаДохода.СтатьяДохода));
			
			Если ЭлементКошелька <> Неопределено Тогда
				
				ЭлементСтатьи = ЭлементКошелька.Получить(СтрокаДохода.СтатьяДохода);
				Если ЭлементСтатьи = Неопределено Тогда
					ЭлементКошелька.Вставить(СтрокаДохода.СтатьяДохода, Новый Структура("Аналитика, Комментарий", "", ""));
					ЭлементСтатьи = ЭлементКошелька.Получить(СтрокаДохода.СтатьяДохода);
				КонецЕсли;
				
			Иначе
				ЭлементСтатьи = Неопределено;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СтрокаДохода.АналитикаСтатьи) Тогда
				
				Аналитики.Вставить(СтрокаДохода.АналитикаСтатьи, Строка(СтрокаДохода.АналитикаСтатьи));
				
				Если ЭлементСтатьи <> Неопределено Тогда
					ЭлементСтатьи.Аналитика = ЭлементСтатьи.Аналитика + ?(ЗначениеЗаполнено(ЭлементСтатьи.Аналитика), ", ", "") + Строка(СтрокаДохода.АналитикаСтатьи);
				КонецЕсли;
				
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СтрокаДохода.Комментарий) И ЭлементСтатьи <> Неопределено Тогда
				ЭлементСтатьи.Комментарий = ЭлементСтатьи.Комментарий + ?(ЗначениеЗаполнено(ЭлементСтатьи.Комментарий), ", ", "") + СтрокаДохода.Комментарий;
			КонецЕсли;
			
			
		КонецЕсли;
		
	КонецЦикла;
	
	ПредставлениеКошельков = "";
	Для каждого Кошелек Из Кошельки Цикл
		ПредставлениеКошельков = ПредставлениеКошельков + ?(ПредставлениеКошельков = "", "", ", ") + ДеньгиКлиентСервер.СокращенноеПредставление(Строка(Кошелек.Ключ),30, Ложь);
	КонецЦикла;
	
	ПредставлениеСтатей = "";
	Для каждого Статья Из Статьи Цикл
		ПредставлениеСтатей = ПредставлениеСтатей + ?(ПредставлениеСтатей = "", "", ", ") + ДеньгиКлиентСервер.СокращенноеПредставление(Строка(Статья.Значение), 30, Ложь);
	КонецЦикла;
	
	ПредставлениеАналитики = "";
	Для каждого Аналитика Из Аналитики Цикл
		ПредставлениеАналитики = ПредставлениеАналитики + ?(ПредставлениеАналитики = "", "", ", ") + ДеньгиКлиентСервер.СокращенноеПредставление(Строка(Аналитика.Значение), 30, Ложь);
	КонецЦикла;
	
	Если Не ЭтоШаблон Тогда
		
		ОписаниеОперации = "";
		
		ТекстОбщейАналитики = "";
		
		ОбщаяАналитика = АналитикаДокумента.Выгрузить();
		Для Каждого СтрокаАналитики Из ОбщаяАналитика Цикл
			Если ЗначениеЗаполнено(СтрокаАналитики.ЗначениеАналитикиВШапке) Тогда
				ТекстОбщейАналитики = ТекстОбщейАналитики + ?(ТекстОбщейАналитики = "", "", ", ");
				ТекстОбщейАналитики = ТекстОбщейАналитики + СтрокаАналитики.ЗначениеАналитикиВШапке; 
			КонецЕсли; 
		КонецЦикла; 
		
		СтрокаДляОписания = "";
		Для Каждого НаборКошелька Из Кошельки Цикл
			СтрокаДляОписания = СтрокаДляОписания + ?(СтрокаДляОписания = "", "", "; ") + НСтр("ru = 'в кошелек [%1]'");
			СтрокаДляОписания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаДляОписания, НаборКошелька.Ключ);
			ТекстСтатьи = "";
			Для Каждого СтруктураСтатьи Из НаборКошелька.Значение Цикл
				НазваниеСтатьи = ?(ЗначениеЗаполнено(СтруктураСтатьи.Ключ), СокрЛП(СтруктураСтатьи.Ключ), НСтр("ru = 'без статьи'") );
				ТекстСтатьи = ТекстСтатьи + ?(ТекстСтатьи = "", "", ", ") + НазваниеСтатьи;
				Если ЗначениеЗаполнено(СтруктураСтатьи.Значение.Комментарий) Тогда
					ТекстСтатьи = ТекстСтатьи + " (" + СтруктураСтатьи.Значение.Комментарий + ")";
				КонецЕсли; 
			КонецЦикла; 
			СтрокаДляОписания = СтрокаДляОписания + ?(ТекстСтатьи = "", "", ": " + ТекстСтатьи);
		КонецЦикла; 
		
		СтрокаДляОписания = НСтр("ru = 'Доход'") + " " + СтрокаДляОписания;
		
		Если ЗначениеЗаполнено(СтрокаДляОписания) ИЛИ ЗначениеЗаполнено(ТекстОбщейАналитики) Тогда
			ОписаниеОперации = СтрокаДляОписания + ?(ТекстОбщейАналитики = "", "", " (" + ТекстОбщейАналитики + ")");
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти


#КонецЕсли
