#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


#Область ПрограммныйИнтерфейс

// Формирует и записывает движения в регистры учета
//
//Параметры:
//	СсылкаНаДокумент       - ДокументСсылка.Доход - регистратор движений
//	ДвиженияДокумента      - КоллекцияДвижений или иная коллекция - наборы записей регистров учета
//	ДополнительныеСвойства - Структура - сордержит дополнительные свойства документа
//
Процедура СформироватьДвиженияДокумента(СсылкаНаДокумент, ДвиженияДокумента, ДополнительныеСвойства) Экспорт

	// Получаем таблицу для формирования движений
	Если ТипЗнч(ДополнительныеСвойства) <> Тип("Структура") Или Не ДополнительныеСвойства.Свойство("ТаблицыДокумента") Тогда
		ПроверитьДополнительныеСвойстваОперации(СсылкаНаДокумент, ДополнительныеСвойства);
	КонецЕсли;
	ТаблицыДокумента = ДополнительныеСвойства.ТаблицыДокумента;
	
	// Записываем движения в регистр бухгалтерии
	Для Каждого СтрокаДокумента Из ТаблицыДокумента.Доходы Цикл
	
		НоваяПроводка = ДвиженияДокумента.ЖурналОпераций.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяПроводка, СтрокаДокумента);
		НоваяПроводка.СубконтоДт.Вставить(СтрокаДокумента.ВидСубконтоДт1, СтрокаДокумента.СубконтоДт1);
		Если СтрокаДокумента.ИспользоватьДляНакоплений Тогда
			НоваяПроводка.СубконтоДт.Вставить(СтрокаДокумента.ВидСубконтоДт2, СтрокаДокумента.СубконтоДт2);
		КонецЕсли; 
		НоваяПроводка.СубконтоКт.Вставить(СтрокаДокумента.ВидСубконтоКт1, СтрокаДокумента.СубконтоКт1);
		НоваяПроводка.СубконтоКт.Вставить(СтрокаДокумента.ВидСубконтоКт2, СтрокаДокумента.СубконтоКт2);
	
	КонецЦикла;
	
	// Записываем движения в регистр фактических оборотов бюджета
	Если ТаблицыДокумента.Свойство("ОборотыБюджета") Тогда
		ДвиженияДокумента.ФактическиеОборотыБюджета.Загрузить(ТаблицыДокумента.ОборотыБюджета);
	КонецЕсли;
	
КонецПроцедуры

// Заполняет структуру ДополнительныеСвойства значениями, необходимыми для дальнейшей обработки документа
//
//Параметры:
//	Операция               - ссылка или объект документа, зависит от контекста вызова этой процедуры
//	ДополнительныеСвойства - Структура или Неопределено - сордержит дополнительные свойства документа
//	ПроверятьТаблицыДокумента - Булево - заполнять ли таблицы для формирования движений
//
Процедура ПроверитьДополнительныеСвойстваОперации(Операция, ДополнительныеСвойства, ПроверятьТаблицыДокумента = Ложь) Экспорт

	// Выполняем проверку, одинаковую для всех документов
	ОбслуживаниеДокументов.ОбщаяПроверкаДополнительныхСвойствДокумента(Операция, ДополнительныеСвойства);
	
	Если НЕ ДополнительныеСвойства.Свойство("ВалютаОперации") ИЛИ НЕ ЗначениеЗаполнено(ДополнительныеСвойства.ВалютаОперации) Тогда
		ДополнительныеСвойства.Вставить("ВалютаОперации", Операция.ВалютаОперации)
	КонецЕсли;
	
	Если ПроверятьТаблицыДокумента И Не ДополнительныеСвойства.Свойство("ТаблицыДокумента") Тогда
		ДополнительныеСвойства.Вставить("ТаблицыДокумента", ПолучитьВыборкиДляФормированияДвижений(Операция.Ссылка, ДополнительныеСвойства));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Поля.Добавить("Дата");
	Поля.Добавить("ЭтоШаблон");
	Поля.Добавить("ОписаниеОперации");
	Поля.Добавить("СуммаОперации");
	Поля.Добавить("ВалютаОперации");
	Поля.Добавить("ПредставлениеКошельков");
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Данные.ЭтоШаблон Тогда
		Представление = ДеньгиКлиентСервер.СокращенноеПредставление(Данные.ОписаниеОперации, 250, Ложь);
	Иначе
		Представление = НСтр("ru='Доход от'") + " " + Формат(Данные.Дата, "ДФ='дд.ММ.гггг (ЧЧ:мм)'")
				+ ": " + Формат(Данные.СуммаОперации, "ЧДЦ=2; ЧН=0.00") + " " + Данные.ВалютаОперации + " в " + ДеньгиКлиентСервер.СокращенноеПредставление(Строка(Данные.ПредставлениеКошельков));
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаВыбора" Тогда
		
		РаботаСФормамиДокументов.ОпределитьФормуСпискаДляВыбора(Тип("ДокументСсылка.Доход"), Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Функция ПолучитьВыборкиДляФормированияДвижений(СсылкаНаДокумент, ДополнительныеСвойства) 

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка",      СсылкаНаДокумент);
	Запрос.УстановитьПараметр("ВалютаУчета", ДополнительныеСвойства.ВалютаУчета);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Шапка.Ссылка КАК Регистратор,
	|	Шапка.Ссылка КАК Операция,
	|	Шапка.Дата КАК Период,
	|	Шапка.ЭтоШаблон КАК ЭтоШаблон,
	|	Шапка.Проведен,
	|	ЕСТЬNULL(ТабЧасть.Кошелек.ИспользоватьДляНакоплений, ЛОЖЬ) КАК ИспользоватьДляНакоплений,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ТабЧасть.Кошелек.ИспользоватьДляНакоплений, ЛОЖЬ)
	|			ТОГДА ЗНАЧЕНИЕ(ПланСчетов.РазделыУчета.Накопления)
	|		ИНАЧЕ ЗНАЧЕНИЕ(ПланСчетов.РазделыУчета.СвободныеДеньги)
	|	КОНЕЦ КАК СчетДт,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконто.КошелькиИсчета) КАК ВидСубконтоДт1,
	|	ЕСТЬNULL(ТабЧасть.Кошелек, ЗНАЧЕНИЕ(Справочник.КошелькиИсчета.ПустаяСсылка)) КАК СубконтоДт1,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконто.ФинансовыеЦели) КАК ВидСубконтоДт2,
	|	ЕСТЬNULL(ТабЧасть.ФинансоваяЦель, ЗНАЧЕНИЕ(Справочник.ФинансовыеЦели.ПустаяСсылка)) КАК СубконтоДт2,
	|	ЗНАЧЕНИЕ(ПланСчетов.РазделыУчета.Капитал) КАК СчетКт,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконто.СтатьиДоходовРасходов) КАК ВидСубконтоКт1,
	|	ЕСТЬNULL(ТабЧасть.СтатьяДохода, ЗНАЧЕНИЕ(Справочник.СтатьиДоходов.ПустаяСсылка)) КАК СубконтоКт1,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконто.Аналитика) КАК ВидСубконтоКт2,
	|	ЕСТЬNULL(ТабЧасть.АналитикаСтатьи, НЕОПРЕДЕЛЕНО) КАК СубконтоКт2,
	|	ЕСТЬNULL(ТабЧасть.СуммаДохода, 0) КАК ВалютнаяСумма,
	|	ЕСТЬNULL(ТабЧасть.Кошелек.Валюта, &ВалютаУчета) КАК Валюта,
	|	ЕСТЬNULL(ТабЧасть.Комментарий, """") КАК Содержание,
	|	ЕСТЬNULL(ТабЧасть.Кошелек.ТипСчета, ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.Наличность)) КАК ТипСчета
	|ИЗ
	|	Документ.Доход КАК Шапка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Доход.Доходы КАК ТабЧасть
	|		ПО (ТабЧасть.Ссылка = Шапка.Ссылка)
	|ГДЕ
	|	Шапка.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	Регистратор,
	|	ТабЧасть.НомерСтроки";
	
	ПакетРезультатов = Запрос.ВыполнитьПакет();
	СтруктураТаблиц         = Новый Структура("Доходы,ОбъектыОперации");
	
	// Таблица для формирования проводок
	СтруктураТаблиц.Доходы  = ПакетРезультатов[0].Выгрузить();
	
	// Таблицы для записи объектов операции и фактических оборотов бюджета
	ОбъектыОперации = ОбслуживаниеДокументов.НоваяТаблицаРегистраОбъектыОпераций();
	Если СтруктураТаблиц.Доходы.Количество() > 0 И 
			(СтруктураТаблиц.Доходы[0].ЭтоШаблон ИЛИ СтруктураТаблиц.Доходы[0].Проведен ИЛИ ДополнительныеСвойства.ЭтоПлановаяОперация) Тогда
		ОборотыБюджета = ОбслуживаниеДокументов.НоваяТаблицаРегистровОборотовБюджета();
	Иначе
		ОборотыБюджета = Неопределено;
	КонецЕсли;
	
	Для Каждого СтрокаДокумента Из СтруктураТаблиц.Доходы Цикл
		
		Если СтрокаДокумента.ИспользоватьДляНакоплений Тогда
			ФинЦель = ?(Не ЗначениеЗаполнено(СтрокаДокумента.СубконтоДт2), Справочники.ФинансовыеЦели.ОбщиеНакопления, 
					СтрокаДокумента.СубконтоДт2);
		Иначе
			ФинЦель = Справочники.ФинансовыеЦели.ПустаяСсылка(); 
		КонецЕсли;
		
		// Списание
		ЗаписьСписания = ОбъектыОперации.Добавить();
		ЗаписьСписания.Дата              = СтрокаДокумента.Период;
		ЗаписьСписания.ЭтоШаблон         = СтрокаДокумента.ЭтоШаблон;
		ЗаписьСписания.Операция          = СтрокаДокумента.Регистратор;
		ЗаписьСписания.РазделУчета       = СтрокаДокумента.СчетДт;
		ЗаписьСписания.ПредметУчета      = СтрокаДокумента.СубконтоДт1;
		ЗаписьСписания.ФинансоваяЦель    = ФинЦель;
		ЗаписьСписания.ТипПоказателя     = Перечисления.ТипыБюджетныхПоказателей.Поступление;
		ЗаписьСписания.СуммаПоступления  = СтрокаДокумента.ВалютнаяСумма;
		ЗаписьСписания.Валюта            = СтрокаДокумента.Валюта;
		
		// Поступление
		ЗаписьПоступления = ОбъектыОперации.Добавить();
		ЗаписьПоступления.Дата              = СтрокаДокумента.Период;
		ЗаписьПоступления.ЭтоШаблон         = СтрокаДокумента.ЭтоШаблон;
		ЗаписьПоступления.Операция          = СтрокаДокумента.Регистратор;
		ЗаписьПоступления.РазделУчета       = СтрокаДокумента.СчетКт;
		ЗаписьПоступления.ПредметУчета      = СтрокаДокумента.СубконтоКт1;
		ЗаписьПоступления.ФинансоваяЦель    = ФинЦель; 
		ЗаписьПоступления.ТипПоказателя     = Перечисления.ТипыБюджетныхПоказателей.Поступление;
		ЗаписьПоступления.СуммаПоступления  = СтрокаДокумента.ВалютнаяСумма;
		ЗаписьПоступления.Валюта            = СтрокаДокумента.Валюта;
		
		Если ЗначениеЗаполнено(ФинЦель) Тогда
			ЗаписьНабора = ОбъектыОперации.Добавить();
			ЗаполнитьЗначенияСвойств(ЗаписьНабора, ЗаписьСписания);
			ЗаписьНабора.ФинансоваяЦель    = Неопределено;
			
			ЗаписьНабора = ОбъектыОперации.Добавить();
			ЗаполнитьЗначенияСвойств(ЗаписьНабора, ЗаписьПоступления);
			ЗаписьНабора.ФинансоваяЦель    = Неопределено;
		КонецЕсли;
		
		// Фактические обороты бюджета
		Если ОборотыБюджета <> Неопределено Тогда
			
			ЗаписьНабора = ОборотыБюджета.Добавить();
			ЗаписьНабора.Период           = СтрокаДокумента.Период;
			ЗаписьНабора.Регистратор      = СтрокаДокумента.Регистратор;
			ЗаписьНабора.РазделБюджета    = ФинЦель;
			ЗаписьНабора.СтатьяБюджета    = СтрокаДокумента.СубконтоКт1;
			ЗаписьНабора.ТипПоказателя    = Перечисления.ТипыБюджетныхПоказателей.Поступление;
			ЗаписьНабора.Валюта           = СтрокаДокумента.Валюта;
			ЗаписьНабора.Кошелек          = СтрокаДокумента.СубконтоДт1;
			ЗаписьНабора.Сумма            = СтрокаДокумента.ВалютнаяСумма;
			ЗаписьНабора.Комментарий      = СтрокаДокумента.Содержание;
			
			// Для кредитных карт записываем еще одну операцию факта: пополнение кредитной карты
			Если СтрокаДокумента.ТипСчета = Перечисления.ТипыСчетов.БанковскаяКартаКредитная Тогда
				ЗаписьНабора = ОборотыБюджета.Добавить();
				ЗаписьНабора.Период           = СтрокаДокумента.Период;
				ЗаписьНабора.Регистратор      = СтрокаДокумента.Регистратор;
				ЗаписьНабора.РазделБюджета    = ФинЦель;
				ЗаписьНабора.СтатьяБюджета    = СтрокаДокумента.СубконтоДт1;
				ЗаписьНабора.ТипПоказателя    = Перечисления.ТипыБюджетныхПоказателей.Списание;
				ЗаписьНабора.Валюта           = СтрокаДокумента.Валюта;
				ЗаписьНабора.Кошелек          = Неопределено;
				ЗаписьНабора.Сумма            = СтрокаДокумента.ВалютнаяСумма;
				ЗаписьНабора.Комментарий      = СтрокаДокумента.Содержание;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ОбъектыОперации.Свернуть("Дата, ЭтоШаблон, Операция, РазделУчета, ПредметУчета, ФинансоваяЦель, ТипПоказателя, Валюта", "СуммаПоступления, СуммаСписания");
	СтруктураТаблиц.Вставить("ОбъектыОперации", ОбъектыОперации);
	
	Если ОборотыБюджета <> Неопределено Тогда
		ОборотыБюджета.Свернуть("Период,Регистратор,РазделБюджета,СтатьяБюджета,ТипПоказателя,Валюта,Кошелек,Комментарий", "Сумма");
		СтруктураТаблиц.Вставить("ОборотыБюджета", ОборотыБюджета);
	КонецЕсли;
	
	Возврат СтруктураТаблиц;

КонецФункции

#КонецОбласти



#КонецЕсли