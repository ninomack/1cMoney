#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


#Область ПрограммныйИнтерфейс

// Формирует и записывает движения в регистры учета
//
//Параметры:
//	СсылкаНаДокумент       - ДокументСсылка.ОбменВалюты - регистратор движений
//	ДвиженияДокумента      - КоллекцияДвижений или иная коллекция - наборы записей регистров учета
//	ДополнительныеСвойства - Структура - сордержит дополнительные свойства документа
//	ПроверятьТаблицыДокумента - Булево - заполнять ли таблицы для формирования движений
//
Процедура СформироватьДвиженияДокумента(СсылкаНаДокумент, ДвиженияДокумента, ДополнительныеСвойства) Экспорт

	// Получаем таблицу для формирования движений
	Если ТипЗнч(ДополнительныеСвойства) <> Тип("Структура") Или Не ДополнительныеСвойства.Свойство("ТаблицыДокумента") Тогда
		ПроверитьДополнительныеСвойстваОперации(СсылкаНаДокумент, ДополнительныеСвойства, Истина);
	КонецЕсли;
	ТаблицыДокумента = ДополнительныеСвойства.ТаблицыДокумента;
	
	// Проводки для самого перевода
	Для Каждого СтрокаДокумента Из ТаблицыДокумента.Основное Цикл
		
		СчетОткуда = ?(СтрокаДокумента.ИспользоватьДляНакопленийОткуда, ПланыСчетов.РазделыУчета.Накопления, ПланыСчетов.РазделыУчета.СвободныеДеньги);
		СчетКуда   = ?(СтрокаДокумента.ИспользоватьДляНакопленийКуда,   ПланыСчетов.РазделыУчета.Накопления, ПланыСчетов.РазделыУчета.СвободныеДеньги);
		// Добавляем проводки с учетом валют кредита и кошелька:
		РазделыУчета.ДобавитьПроводкуВДвижения(ДвиженияДокумента.ЖурналОпераций, СтрокаДокумента.Период, СтрокаДокумента.Регистратор,
			СчетКуда, СтрокаДокумента.КошелекКуда, СтрокаДокумента.ФинансоваяЦельКуда, СтрокаДокумента.СуммаПолучено, СтрокаДокумента.ВалютаКуда,
			СчетОткуда, СтрокаДокумента.КошелекОткуда, СтрокаДокумента.ФинансоваяЦельОткуда, СтрокаДокумента.СуммаВыдано, СтрокаДокумента.ВалютаОткуда,
			СтрокаДокумента.Комментарий);
		
	КонецЦикла; 

	// Проводки по доп.расходам на перевод средств
	Для Каждого СтрокаДокумента Из ТаблицыДокумента.ДополнительныеРасходы Цикл
		
		СчетДенег   = ?(СтрокаДокумента.ИспользоватьДляНакоплений = Истина,   ПланыСчетов.РазделыУчета.Накопления, ПланыСчетов.РазделыУчета.СвободныеДеньги);
		// Добавляем проводки с учетом валют кошельков:
		РазделыУчета.ДобавитьПроводкуВДвижения(ДвиженияДокумента.ЖурналОпераций, СтрокаДокумента.Период, СтрокаДокумента.Регистратор,
			ПланыСчетов.РазделыУчета.Капитал, СтрокаДокумента.СтатьяРасхода, СтрокаДокумента.АналитикаСтатьи, СтрокаДокумента.СуммаРасхода, СтрокаДокумента.ВалютаКошелька,
			СчетДенег, СтрокаДокумента.КошелекРасхода, СтрокаДокумента.ФинансоваяЦель, СтрокаДокумента.СуммаРасхода, СтрокаДокумента.ВалютаКошелька,
			СтрокаДокумента.Комментарий);
		
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
	
	Если ПроверятьТаблицыДокумента <> Ложь И Не ДополнительныеСвойства.Свойство("ТаблицыДокумента") Тогда
		ДополнительныеСвойства.Вставить("ТаблицыДокумента", ПолучитьВыборкиДляФормированияДвижений(Операция.Ссылка, ДополнительныеСвойства));
	КонецЕсли;
	
КонецПроцедуры

// Обновляет итоговые суммы и описание операции
Процедура ОбновитьИтоговыеСуммыДокумента(ДокументОбъект) Экспорт
	
	ДокументОбъект.ВалютаСписания    = ?(ЗначениеЗаполнено(ДокументОбъект.КошелекОткуда), 
					ДокументОбъект.КошелекОткуда.Валюта, Константы.ВалютаУчета.Получить());
	ДокументОбъект.ВалютаПоступления = ?(ЗначениеЗаполнено(ДокументОбъект.КошелекКуда),   
					ДокументОбъект.КошелекКуда.Валюта,   ДокументОбъект.ВалютаСписания);
	ДокументОбъект.РасходыИзКошелькаСписания      = 0;
	ДокументОбъект.РасходыИзКошелькаПоступления   = 0;
	
	Если НЕ ЗначениеЗаполнено(ДокументОбъект.ФинансоваяЦельОткуда) Тогда
		ДокументОбъект.ФинансоваяЦельОткуда = Справочники.ФинансовыеЦели.ОбщиеНакопления;
	КонецЕсли; 
	Если НЕ ЗначениеЗаполнено(ДокументОбъект.ФинансоваяЦельКуда) Тогда
		ДокументОбъект.ФинансоваяЦельКуда = Справочники.ФинансовыеЦели.ОбщиеНакопления;
	КонецЕсли; 
	
	СписокСтатей = Новый Соответствие;
	Для Каждого СтрокаРасхода Из ДокументОбъект.ДополнительныеРасходы Цикл
		Если СтрокаРасхода.КошелекРасхода = ДокументОбъект.КошелекОткуда И СтрокаРасхода.СуммаРасхода <> 0 Тогда
			ДокументОбъект.РасходыИзКошелькаСписания = ДокументОбъект.РасходыИзКошелькаСписания + СтрокаРасхода.СуммаРасхода;
			СписокСтатей.Вставить(СтрокаРасхода.СтатьяРасхода);
		ИначеЕсли СтрокаРасхода.КошелекРасхода = ДокументОбъект.КошелекКуда И СтрокаРасхода.СуммаРасхода <> 0 Тогда
			ДокументОбъект.РасходыИзКошелькаПоступления = ДокументОбъект.РасходыИзКошелькаПоступления + СтрокаРасхода.СуммаРасхода;
			СписокСтатей.Вставить(СтрокаРасхода.СтатьяРасхода);
		КонецЕсли; 
	КонецЦикла; 
	
	КомиссияПолученияПоКурсу = ДокументОбъект.РасходыИзКошелькаПоступления * ?(ДокументОбъект.СуммаПолучено = 0, 0, ДокументОбъект.СуммаВыдано / ДокументОбъект.СуммаПолучено);
	ДокументОбъект.СписаноСУчетомКомиссии   = ДокументОбъект.СуммаВыдано + ДокументОбъект.РасходыИзКошелькаСписания + КомиссияПолученияПоКурсу;
	ДокументОбъект.ПолученоСУчетомКомиссии  = ДокументОбъект.СуммаПолучено - ДокументОбъект.РасходыИзКошелькаПоступления;
	
	Если ДокументОбъект.ЭтоШаблон Тогда
		Возврат;
	КонецЕсли; 
	
	ДокументОбъект.ОписаниеОперации = НСтр("ru = 'Обмен валюты %1 из кошелька [%2] на %3 в кошелек [%4]'"); 
	ДокументОбъект.ОписаниеОперации = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ДокументОбъект.ОписаниеОперации, 
			ДокументОбъект.ВалютаСписания, ДокументОбъект.КошелекОткуда, ДокументОбъект.ВалютаПоступления, ДокументОбъект.КошелекКуда);
	
	Если ДокументОбъект.ДополнительныеРасходы.Количество() > 0 Тогда
		
		ОписаниеРасходов = "";
		
		Для Каждого СтрокаРасхода Из ДокументОбъект.ДополнительныеРасходы Цикл
			Если ЗначениеЗаполнено(СтрокаРасхода.СтатьяРасхода) Тогда
				ОписаниеРасходов = ОписаниеРасходов + ?(ОписаниеРасходов = "", "", ", ") 
					+ СтрокаРасхода.СтатьяРасхода;
			КонецЕсли; 
			Если НЕ ЗначениеЗаполнено(СтрокаРасхода.ФинансоваяЦель) Тогда
				Если СтрокаРасхода.КошелекРасхода = ДокументОбъект.КошелекОткуда Тогда
					СтрокаРасхода.ФинансоваяЦель = ДокументОбъект.ФинансоваяЦельОткуда;
				Иначе
					СтрокаРасхода.ФинансоваяЦель = ДокументОбъект.ФинансоваяЦельКуда;
				КонецЕсли; 
			КонецЕсли; 
		КонецЦикла; 
		
		Если ЗначениеЗаполнено(ОписаниеРасходов) Тогда
			ДокументОбъект.ОписаниеОперации = ДокументОбъект.ОписаниеОперации + ". " + НСтр("ru = 'Доп. расходы'") + ": " + ОписаниеРасходов;
		КонецЕсли; 
		
	КонецЕсли; 
	
	ДокументОбъект.ОписаниеОперации = ДокументОбъект.ОписаниеОперации + ?(ЗначениеЗаполнено(ДокументОбъект.Комментарий), " (" + ДокументОбъект.Комментарий + ")", "");
	
КонецПроцедуры


#КонецОбласти


#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Поля.Добавить("Дата");
	Поля.Добавить("ЭтоШаблон");
	Поля.Добавить("ОписаниеОперации");
	Поля.Добавить("КошелекОткуда");
	Поля.Добавить("КошелекКуда");
	Поля.Добавить("СуммаПолучено");
	Поля.Добавить("ВалютаПоступления");
	Поля.Добавить("СуммаВыдано");
	Поля.Добавить("ВалютаСписания");
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Данные.ЭтоШаблон Тогда
		
		Представление = ДеньгиКлиентСервер.СокращенноеПредставление(Данные.ОписаниеОперации, 250, Ложь);
		
	Иначе
		
		Представление = НСтр("ru='Обмен валюты от'") + " " + Формат(Данные.Дата, "ДФ='дд.ММ.гггг (ЧЧ:мм)'")
				+ ": " + Формат(Данные.СуммаВыдано, "ЧДЦ=2; ЧН=0.00") + " " + Данные.ВалютаСписания
				+ " " + НСтр("ru='из'") + " " + ДеньгиКлиентСервер.СокращенноеПредставление(Строка(Данные.КошелекОткуда))
				+ ", " + Формат(Данные.СуммаПолучено, "ЧДЦ=2; ЧН=0.00") + " " + Данные.ВалютаПоступления
				+ " " + НСтр("ru='в'") + " " + ДеньгиКлиентСервер.СокращенноеПредставление(Строка(Данные.КошелекКуда)); 
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаВыбора" Тогда
		
		РаботаСФормамиДокументов.ОпределитьФормуСпискаДляВыбора(Тип("ДокументСсылка.ОбменВалюты"), Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Функция ПолучитьВыборкиДляФормированияДвижений(СсылкаНаДокумент, ДополнительныеСвойства) 

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", СсылкаНаДокумент);
	Запрос.УстановитьПараметр("ВалютаУчета", ДополнительныеСвойства.ВалютаУчета);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РеквизитыДокумента.Ссылка КАК Регистратор,
	|	РеквизитыДокумента.Дата КАК Период,
	|	РеквизитыДокумента.КошелекКуда,
	|	РеквизитыДокумента.ФинансоваяЦельКуда,
	|	ЕСТЬNULL(РеквизитыДокумента.КошелекКуда.ИспользоватьДляНакоплений, ЛОЖЬ) КАК ИспользоватьДляНакопленийКуда,
	|	ЕСТЬNULL(РеквизитыДокумента.КошелекКуда.ТипСчета, НЕОПРЕДЕЛЕНО) КАК ТипСчетаКуда,
	|	РеквизитыДокумента.КошелекОткуда,
	|	РеквизитыДокумента.ФинансоваяЦельОткуда,
	|	ЕСТЬNULL(РеквизитыДокумента.КошелекОткуда.ИспользоватьДляНакоплений, ЛОЖЬ) КАК ИспользоватьДляНакопленийОткуда,
	|	ЕСТЬNULL(РеквизитыДокумента.КошелекОткуда.ТипСчета, НЕОПРЕДЕЛЕНО) КАК ТипСчетаОткуда,
	|	РеквизитыДокумента.СуммаВыдано,
	|	РеквизитыДокумента.СуммаПолучено,
	|	РеквизитыДокумента.ВалютаСписания КАК ВалютаОткуда,
	|	РеквизитыДокумента.ВалютаПоступления КАК ВалютаКуда,
	|	РеквизитыДокумента.Комментарий,
	|	РеквизитыДокумента.ЭтоШаблон,
	|	ЕСТЬNULL(РеквизитыДокумента.КошелекОткуда.ТипСчета, ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.Наличность)) КАК ОткудаТипСчета,
	|	ЕСТЬNULL(РеквизитыДокумента.КошелекКуда.ТипСчета, ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.Наличность)) КАК КудаТипСчета,
	|	РеквизитыДокумента.Проведен
	|ИЗ
	|	Документ.ОбменВалюты КАК РеквизитыДокумента
	|ГДЕ
	|	РеквизитыДокумента.Ссылка В(&Ссылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДопРасходы.Ссылка КАК Регистратор,
	|	ДопРасходы.Ссылка.Дата КАК Период,
	|	ДопРасходы.КошелекРасхода,
	|	ЕСТЬNULL(ДопРасходы.КошелекРасхода.ТипСчета, НЕОПРЕДЕЛЕНО) КАК ТипСчета,
	|	ЕСТЬNULL(ДопРасходы.КошелекРасхода.ИспользоватьДляНакоплений, ЛОЖЬ) КАК ИспользоватьДляНакоплений,
	|	ДопРасходы.СтатьяРасхода,
	|	ДопРасходы.ФинансоваяЦель,
	|	ДопРасходы.СуммаРасхода,
	|	ЕСТЬNULL(ДопРасходы.КошелекРасхода.Валюта, &ВалютаУчета) КАК ВалютаКошелька,
	|	ЕСТЬNULL(ДопРасходы.Ссылка.Комментарий, """") КАК Комментарий,
	|	ДопРасходы.АналитикаСтатьи,
	|	ЕСТЬNULL(ДопРасходы.Ссылка.ЭтоШаблон, ЛОЖЬ) КАК ЭтоШаблон
	|ИЗ
	|	Документ.ОбменВалюты.ДополнительныеРасходы КАК ДопРасходы
	|ГДЕ
	|	ДопРасходы.Ссылка В(&Ссылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДопРасходы.НомерСтроки";
	
	ПакетРезультатов = Запрос.ВыполнитьПакет();
	СтруктураТаблиц = Новый Структура("Основное, ДополнительныеРасходы, ОбъектыОперации");
	СтруктураТаблиц.Основное              = ПакетРезультатов[0].Выгрузить();
	СтруктураТаблиц.ДополнительныеРасходы = ПакетРезультатов[1].Выгрузить();
	
	// Таблицы для записи объектов операции и фактических оборотов бюджета
	ТаблицаНабора = ОбслуживаниеДокументов.НоваяТаблицаРегистраОбъектыОпераций();
	Если СтруктураТаблиц.Основное.Количество() > 0 И 
		(СтруктураТаблиц.Основное[0].ЭтоШаблон ИЛИ СтруктураТаблиц.Основное[0].Проведен ИЛИ ДополнительныеСвойства.ЭтоПлановаяОперация) Тогда
		ОборотыБюджета = ОбслуживаниеДокументов.НоваяТаблицаРегистровОборотовБюджета();
	Иначе
		ОборотыБюджета = Неопределено;
	КонецЕсли;
	
	// Таблица для формирования движений шаблонов и плановой операции
	// В перемещении и обмене валют для формирования движений плановых операций невозможно использовать фактические обороты бюджета, т.к. они не 
	//	учитывают перемещения между кошельками в пределах одного раздела бюджета, а для кредитных карт создают дополнительные обороты.
	ЭтоШаблон = СтруктураТаблиц.Основное.Количество() > 0 И СтруктураТаблиц.Основное[0].ЭтоШаблон;
	ОборотыПлановыхОпераций = ОбслуживаниеДокументов.НоваяТаблицаРегистровОборотовБюджета();
	
	КошелекОткуда = Неопределено;
	КошелекКуда   = Неопределено;
	
	Для Каждого СтрокаДокумента Из СтруктураТаблиц.Основное Цикл
		
		КошелекОткуда = СтрокаДокумента.КошелекОткуда;
		КошелекКуда   = СтрокаДокумента.КошелекКуда;
		
		СчетДенегОткуда = ?(СтрокаДокумента.ИспользоватьДляНакопленийОткуда, ПланыСчетов.РазделыУчета.Накопления, ПланыСчетов.РазделыУчета.СвободныеДеньги);
		Если СтрокаДокумента.ИспользоватьДляНакопленийОткуда Тогда
			ФинЦельОткуда = ?(Не ЗначениеЗаполнено(СтрокаДокумента.ФинансоваяЦельОткуда), Справочники.ФинансовыеЦели.ОбщиеНакопления, СтрокаДокумента.ФинансоваяЦельОткуда);
		Иначе
			ФинЦельОткуда = Справочники.ФинансовыеЦели.ПустаяСсылка();
		КонецЕсли;
		ВалютаКуда      = ?(ЗначениеЗаполнено(СтрокаДокумента.ВалютаКуда), СтрокаДокумента.ВалютаКуда, ДополнительныеСвойства.ВалютаУчета);
		
		СчетДенегКуда   = ?(СтрокаДокумента.ИспользоватьДляНакопленийКуда, ПланыСчетов.РазделыУчета.Накопления, ПланыСчетов.РазделыУчета.СвободныеДеньги);
		Если СтрокаДокумента.ИспользоватьДляНакопленийКуда Тогда
			ФинЦельКуда = ?(Не ЗначениеЗаполнено(СтрокаДокумента.ФинансоваяЦельКуда), Справочники.ФинансовыеЦели.ОбщиеНакопления, СтрокаДокумента.ФинансоваяЦельКуда);
		Иначе
			ФинЦельКуда = Справочники.ФинансовыеЦели.ПустаяСсылка();
		КонецЕсли;
		ВалютаОткуда    = ?(ЗначениеЗаполнено(СтрокаДокумента.ВалютаОткуда), СтрокаДокумента.ВалютаОткуда, ДополнительныеСвойства.ВалютаУчета);
			
		// сам обмен в разрезе кошельков
		// списание суммы
		ЗаписьНабора1 = ТаблицаНабора.Добавить();
		ЗаписьНабора1.Дата              = СтрокаДокумента.Период;
		ЗаписьНабора1.ЭтоШаблон         = СтрокаДокумента.ЭтоШаблон;
		ЗаписьНабора1.Операция          = СсылкаНаДокумент;
		ЗаписьНабора1.РазделУчета       = СчетДенегОткуда;
		ЗаписьНабора1.ПредметУчета      = КошелекОткуда;
		ЗаписьНабора1.ФинансоваяЦель    = ФинЦельОткуда;
		ЗаписьНабора1.ТипПоказателя     = Перечисления.ТипыБюджетныхПоказателей.Перемещение;
		ЗаписьНабора1.СуммаСписания     = СтрокаДокумента.СуммаВыдано;
		ЗаписьНабора1.Валюта            = ВалютаОткуда;
		
		// Оборот плановой операции
		Если ЭтоШаблон Или ДополнительныеСвойства.ЭтоПлановаяОперация Тогда
			
			СтрокаПлановойОперации = ОборотыПлановыхОпераций.Добавить();
			СтрокаПлановойОперации.Период          = СтрокаДокумента.Период;
			СтрокаПлановойОперации.Регистратор     = СсылкаНаДокумент;
			СтрокаПлановойОперации.РазделБюджета   = ФинЦельОткуда;
			СтрокаПлановойОперации.Валюта          = ВалютаОткуда;
			СтрокаПлановойОперации.Кошелек         = КошелекОткуда;
			СтрокаПлановойОперации.ТипПоказателя   = Перечисления.ТипыБюджетныхПоказателей.Списание;
			
			// Статья бюджета зависит от типа счета и перемещения между финансовыми целями
			Если ЗначениеЗаполнено(ФинЦельКуда) И ФинЦельОткуда <> ФинЦельКуда Тогда
				
				СтрокаПлановойОперации.СтатьяБюджета = ФинЦельКуда;
				
			ИначеЕсли ЗначениеЗаполнено(ФинЦельОткуда) И Не ЗначениеЗаполнено(ФинЦельКуда) Тогда
				
				СтрокаПлановойОперации.СтатьяБюджета = Справочники.ГрафыБюджета.ФинЦельВозвратИзНакопления;
				
			Иначе
				
				СтрокаПлановойОперации.СтатьяБюджета   = КошелекКуда;
				
			КонецЕсли;
			
			СтрокаПлановойОперации.Сумма = СтрокаДокумента.СуммаВыдано;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ФинЦельОткуда) Тогда
			ЗаписьНабора = ТаблицаНабора.Добавить();
			ЗаполнитьЗначенияСвойств(ЗаписьНабора, ЗаписьНабора1);
			ЗаписьНабора.ФинансоваяЦель = Неопределено;
		КонецЕсли; 
		
		// получение суммы в другой валюте
		ЗаписьНабора2 = ТаблицаНабора.Добавить();
		ЗаписьНабора2.Дата              = СтрокаДокумента.Период;
		ЗаписьНабора2.ЭтоШаблон         = СтрокаДокумента.ЭтоШаблон;
		ЗаписьНабора2.Операция          = СсылкаНаДокумент;
		ЗаписьНабора2.РазделУчета       = СчетДенегКуда;
		ЗаписьНабора2.ПредметУчета      = КошелекКуда;
		ЗаписьНабора2.ФинансоваяЦель    = ФинЦельКуда;
		ЗаписьНабора2.ТипПоказателя     = Перечисления.ТипыБюджетныхПоказателей.Перемещение;
		ЗаписьНабора2.СуммаПоступления  = СтрокаДокумента.СуммаПолучено;
		ЗаписьНабора2.Валюта            = ВалютаКуда;
		
		// Оборот плановой операции
		Если ЭтоШаблон Или ДополнительныеСвойства.ЭтоПлановаяОперация Тогда
			
			СтрокаПлановойОперации = ОборотыПлановыхОпераций.Добавить();
			СтрокаПлановойОперации.Период          = СтрокаДокумента.Период;
			СтрокаПлановойОперации.Регистратор     = СсылкаНаДокумент;
			СтрокаПлановойОперации.РазделБюджета   = ФинЦельКуда;
			СтрокаПлановойОперации.Валюта          = ВалютаКуда;
			СтрокаПлановойОперации.Кошелек         = КошелекКуда;
			СтрокаПлановойОперации.ТипПоказателя   = Перечисления.ТипыБюджетныхПоказателей.Поступление;
			
			// Статья бюджета зависит от типа счета и перемещения между финансовыми целями
			Если ЗначениеЗаполнено(ФинЦельОткуда) Тогда
				
				СтрокаПлановойОперации.СтатьяБюджета = ФинЦельОткуда;
				
			ИначеЕсли ЗначениеЗаполнено(ФинЦельКуда) И Не ЗначениеЗаполнено(ФинЦельОткуда) Тогда
				
				СтрокаПлановойОперации.СтатьяБюджета = Справочники.ГрафыБюджета.ФинЦельПереводВНакопление;
				
			Иначе
				
				// Типы счетов и финансовые цели одинаковы: это перемещение не бюджетируется.
				//Статьей является кошелек назначения
				СтрокаПлановойОперации.СтатьяБюджета   = КошелекОткуда;
				
			КонецЕсли;
			
			СтрокаПлановойОперации.Сумма = СтрокаДокумента.СуммаПолучено;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ФинЦельКуда) Тогда
			ЗаписьНабора = ТаблицаНабора.Добавить();
			ЗаполнитьЗначенияСвойств(ЗаписьНабора, ЗаписьНабора2);
			ЗаписьНабора.ФинансоваяЦель = Неопределено;
		КонецЕсли; 
		
		// Добавляем строки с обменом валют
		ЗаписьНабора1 = ТаблицаНабора.Добавить();
		ЗаписьНабора1.Дата              = СтрокаДокумента.Период;
		ЗаписьНабора1.ЭтоШаблон         = СтрокаДокумента.ЭтоШаблон;
		ЗаписьНабора1.Операция          = СсылкаНаДокумент;
		ЗаписьНабора1.РазделУчета       = ПланыСчетов.РазделыУчета.Капитал;
		ЗаписьНабора1.ПредметУчета      = Справочники.СтатьиДоходов.ОбменВалюты;
		ЗаписьНабора1.ФинансоваяЦель    = ФинЦельОткуда;
		ЗаписьНабора1.ТипПоказателя     = Перечисления.ТипыБюджетныхПоказателей.Перемещение;
		ЗаписьНабора1.СуммаПоступления  = СтрокаДокумента.СуммаПолучено;
		ЗаписьНабора1.Валюта            = ВалютаКуда;
		Если ЗначениеЗаполнено(ФинЦельОткуда) Тогда
			ЗаписьНабора = ТаблицаНабора.Добавить();
			ЗаполнитьЗначенияСвойств(ЗаписьНабора, ЗаписьНабора1);
			ЗаписьНабора.ФинансоваяЦель = Неопределено;
		КонецЕсли; 
		
		ЗаписьНабора1 = ТаблицаНабора.Добавить();
		ЗаписьНабора1.Дата              = СтрокаДокумента.Период;
		ЗаписьНабора1.ЭтоШаблон         = СтрокаДокумента.ЭтоШаблон;
		ЗаписьНабора1.Операция          = СсылкаНаДокумент;
		ЗаписьНабора1.РазделУчета       = ПланыСчетов.РазделыУчета.Капитал;
		ЗаписьНабора1.ПредметУчета      = Справочники.СтатьиРасходов.ОбменВалюты;
		ЗаписьНабора1.ФинансоваяЦель    = ФинЦельОткуда;
		ЗаписьНабора1.ТипПоказателя     = Перечисления.ТипыБюджетныхПоказателей.Перемещение;
		ЗаписьНабора1.СуммаСписания     = СтрокаДокумента.СуммаВыдано;
		ЗаписьНабора1.Валюта            = ВалютаОткуда;
		Если ЗначениеЗаполнено(ФинЦельОткуда) Тогда
			ЗаписьНабора = ТаблицаНабора.Добавить();
			ЗаполнитьЗначенияСвойств(ЗаписьНабора, ЗаписьНабора1);
			ЗаписьНабора.ФинансоваяЦель = Неопределено;
		КонецЕсли; 
		
		// Фактические обороты бюджета
		Если ОборотыБюджета <> Неопределено Тогда
			
			КредиткаИсточник   = СтрокаДокумента.ОткудаТипСчета = Перечисления.ТипыСчетов.БанковскаяКартаКредитная;
			КредиткаПолучатель = СтрокаДокумента.КудаТипСчета = Перечисления.ТипыСчетов.БанковскаяКартаКредитная;
			
			Если СчетДенегОткуда <> СчетДенегКуда  Или ФинЦельОткуда <> ФинЦельКуда Тогда
				
				// Регистрируем перемещение денег межу разделами бюджета (между фин.целями или финцелями и свободными деньгами)
				
				// Расход из свободных денег или накоплений на цель-источник
				ЗаписьНабора = ОборотыБюджета.Добавить();
				ЗаписьНабора.Период           = СтрокаДокумента.Период;
				ЗаписьНабора.Регистратор      = СтрокаДокумента.Регистратор;
				ЗаписьНабора.РазделБюджета    = ФинЦельОткуда;
				ЗаписьНабора.СтатьяБюджета    = ?(ЗначениеЗаполнено(ФинЦельКуда), ФинЦельКуда, Справочники.ГрафыБюджета.ФинЦельВозвратИзНакопления);
				ЗаписьНабора.ТипПоказателя    = Перечисления.ТипыБюджетныхПоказателей.Списание;
				ЗаписьНабора.Валюта           = ВалютаОткуда;
				ЗаписьНабора.Кошелек          = СтрокаДокумента.КошелекОткуда;
				ЗаписьНабора.Сумма            = СтрокаДокумента.СуммаВыдано;
				ЗаписьНабора.Комментарий      = СтрокаДокумента.Комментарий;
				
				// Если используется кредитная карта, автоматически добавляем перевод с кредитки в доступные деньги
				Если КредиткаИсточник И Не КредиткаПолучатель Тогда
					ЗаписьНабора = ОборотыБюджета.Добавить();
					ЗаписьНабора.Период           = СтрокаДокумента.Период;
					ЗаписьНабора.Регистратор      = СтрокаДокумента.Регистратор;
					ЗаписьНабора.РазделБюджета    = ФинЦельОткуда;
					ЗаписьНабора.СтатьяБюджета    = СтрокаДокумента.КошелекОткуда;
					ЗаписьНабора.ТипПоказателя    = Перечисления.ТипыБюджетныхПоказателей.Поступление;
					ЗаписьНабора.Валюта           = ВалютаОткуда;
					ЗаписьНабора.Кошелек          = Неопределено;
					ЗаписьНабора.Сумма            = СтрокаДокумента.СуммаВыдано;
					ЗаписьНабора.Комментарий      = СтрокаДокумента.Комментарий;
				КонецЕсли;
				
				// Приход в свободные деньги или в накопления на цель-получатель
				ЗаписьНабора = ОборотыБюджета.Добавить();
				ЗаписьНабора.Период           = СтрокаДокумента.Период;
				ЗаписьНабора.Регистратор      = СтрокаДокумента.Регистратор;
				ЗаписьНабора.РазделБюджета    = ФинЦельКуда;
				ЗаписьНабора.СтатьяБюджета    = ?(ЗначениеЗаполнено(ФинЦельОткуда), ФинЦельОткуда, Справочники.ГрафыБюджета.ФинЦельПереводВНакопление);
				ЗаписьНабора.ТипПоказателя    = Перечисления.ТипыБюджетныхПоказателей.Поступление;
				ЗаписьНабора.Валюта           = ВалютаКуда;
				ЗаписьНабора.Кошелек          = СтрокаДокумента.КошелекКуда;
				ЗаписьНабора.Сумма            = СтрокаДокумента.СуммаПолучено;
				ЗаписьНабора.Комментарий      = СтрокаДокумента.Комментарий;
				
				// Если используется кредитная карта, автоматически добавляем перевод из доступных денег на кредитку
				Если КредиткаПолучатель И Не КредиткаИсточник Тогда
					ЗаписьНабора = ОборотыБюджета.Добавить();
					ЗаписьНабора.Период           = СтрокаДокумента.Период;
					ЗаписьНабора.Регистратор      = СтрокаДокумента.Регистратор;
					ЗаписьНабора.РазделБюджета    = ФинЦельКуда;
					ЗаписьНабора.СтатьяБюджета    = СтрокаДокумента.КошелекКуда;
					ЗаписьНабора.ТипПоказателя    = Перечисления.ТипыБюджетныхПоказателей.Списание;
					ЗаписьНабора.Валюта           = ВалютаКуда;
					ЗаписьНабора.Кошелек          = Неопределено;
					ЗаписьНабора.Сумма            = СтрокаДокумента.СуммаПолучено;
					ЗаписьНабора.Комментарий      = СтрокаДокумента.Комментарий;
				КонецЕсли;
				
			Иначе
				
				
				Если КредиткаИсточник Тогда
					ЗаписьНабора = ОборотыБюджета.Добавить();
					ЗаписьНабора.Период           = СтрокаДокумента.Период;
					ЗаписьНабора.Регистратор      = СтрокаДокумента.Регистратор;
					ЗаписьНабора.РазделБюджета    = СтрокаДокумента.ФинансоваяЦельКуда;
					ЗаписьНабора.СтатьяБюджета    = СтрокаДокумента.КошелекОткуда;
					ЗаписьНабора.ТипПоказателя    = Перечисления.ТипыБюджетныхПоказателей.Поступление;
					ЗаписьНабора.Валюта           = ВалютаКуда;
					ЗаписьНабора.Кошелек          = СтрокаДокумента.КошелекКуда;
					ЗаписьНабора.Сумма            = СтрокаДокумента.СуммаПолучено;
					ЗаписьНабора.Комментарий      = СтрокаДокумента.Комментарий;
				КонецЕсли;
				
				Если КредиткаПолучатель Тогда
					ЗаписьНабора = ОборотыБюджета.Добавить();
					ЗаписьНабора.Период           = СтрокаДокумента.Период;
					ЗаписьНабора.Регистратор      = СтрокаДокумента.Регистратор;
					ЗаписьНабора.РазделБюджета    = СтрокаДокумента.ФинансоваяЦельОткуда;
					ЗаписьНабора.СтатьяБюджета    = СтрокаДокумента.КошелекКуда;
					ЗаписьНабора.ТипПоказателя    = Перечисления.ТипыБюджетныхПоказателей.Списание;
					ЗаписьНабора.Валюта           = ВалютаОткуда;
					ЗаписьНабора.Кошелек          = СтрокаДокумента.КошелекОткуда;
					ЗаписьНабора.Сумма            = СтрокаДокумента.СуммаВыдано;
					ЗаписьНабора.Комментарий      = СтрокаДокумента.Комментарий;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Дополнительные расходы по обмену валюты
	Для Каждого СтрокаДокумента Из СтруктураТаблиц.ДополнительныеРасходы Цикл
		
		СчетДенег = ?(СтрокаДокумента.ИспользоватьДляНакоплений = Истина, ПланыСчетов.РазделыУчета.Накопления, ПланыСчетов.РазделыУчета.СвободныеДеньги);
		ФинЦель = ?(ЗначениеЗаполнено(СтрокаДокумента.ФинансоваяЦель) И СтрокаДокумента.ФинансоваяЦель <> Справочники.ФинансовыеЦели.ОбщиеНакопления, 
			СтрокаДокумента.ФинансоваяЦель, Неопределено);
		ВалютаКошелька    = ?(ЗначениеЗаполнено(СтрокаДокумента.ВалютаКошелька), СтрокаДокумента.ВалютаКошелька, ДополнительныеСвойства.ВалютаУчета);
			
		ЗаписьНабора1 = ТаблицаНабора.Добавить();
		ЗаписьНабора1.Дата              = СтрокаДокумента.Период;
		ЗаписьНабора1.ЭтоШаблон         = СтрокаДокумента.ЭтоШаблон;
		ЗаписьНабора1.Операция          = СсылкаНаДокумент;
		ЗаписьНабора1.РазделУчета       = СчетДенег;
		ЗаписьНабора1.ПредметУчета      = СтрокаДокумента.КошелекРасхода;
		ЗаписьНабора1.ФинансоваяЦель    = Финцель;
		ЗаписьНабора1.ТипПоказателя     = Перечисления.ТипыБюджетныхПоказателей.Перемещение;
		ЗаписьНабора1.СуммаСписания     = СтрокаДокумента.СуммаРасхода;
		ЗаписьНабора1.Валюта            = ВалютаКошелька;
		
		ЗаписьНабора2 = ТаблицаНабора.Добавить();
		ЗаписьНабора2.Дата              = СтрокаДокумента.Период;
		ЗаписьНабора2.ЭтоШаблон         = СтрокаДокумента.ЭтоШаблон;
		ЗаписьНабора2.Операция          = СсылкаНаДокумент;
		ЗаписьНабора2.РазделУчета       = ПланыСчетов.РазделыУчета.Капитал;
		ЗаписьНабора2.ПредметУчета      = СтрокаДокумента.СтатьяРасхода;
		ЗаписьНабора2.ФинансоваяЦель    = Финцель;
		ЗаписьНабора2.ТипПоказателя     = Перечисления.ТипыБюджетныхПоказателей.Перемещение;
		ЗаписьНабора2.СуммаСписания     = СтрокаДокумента.СуммаРасхода;
		ЗаписьНабора2.Валюта            = ВалютаКошелька;
		
		// Оборот плановой операции
		Если ЭтоШаблон Или ДополнительныеСвойства.ЭтоПлановаяОперация Тогда
			
			СтрокаПлановойОперации = ОборотыПлановыхОпераций.Добавить();
			СтрокаПлановойОперации.Период          = СтрокаДокумента.Период;
			СтрокаПлановойОперации.Регистратор     = СсылкаНаДокумент;
			СтрокаПлановойОперации.РазделБюджета   = Финцель;
			СтрокаПлановойОперации.Валюта          = ВалютаКошелька;
			СтрокаПлановойОперации.Кошелек         = СтрокаДокумента.КошелекРасхода;
			СтрокаПлановойОперации.ТипПоказателя   = Перечисления.ТипыБюджетныхПоказателей.Списание;
			СтрокаПлановойОперации.СтатьяБюджета   = СтрокаДокумента.СтатьяРасхода;
			СтрокаПлановойОперации.Сумма           = СтрокаДокумента.СуммаРасхода;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ФинЦель) Тогда
			ЗаписьНабора = ТаблицаНабора.Добавить();
			ЗаполнитьЗначенияСвойств(ЗаписьНабора, ЗаписьНабора1);
			ЗаписьНабора.ФинансоваяЦель = Неопределено;
			
			ЗаписьНабора = ТаблицаНабора.Добавить();
			ЗаполнитьЗначенияСвойств(ЗаписьНабора, ЗаписьНабора2);
			ЗаписьНабора.ФинансоваяЦель = Неопределено;
		КонецЕсли; 
		
		// Фактические обороты бюджета
		Если ОборотыБюджета <> Неопределено Тогда
			
			ЗаписьНабора = ОборотыБюджета.Добавить();
			ЗаписьНабора.Период           = СтрокаДокумента.Период;
			ЗаписьНабора.Регистратор      = СтрокаДокумента.Регистратор;
			ЗаписьНабора.РазделБюджета    = ФинЦель;
			ЗаписьНабора.СтатьяБюджета    = ?(ЗначениеЗаполнено(СтрокаДокумента.СтатьяРасхода), СтрокаДокумента.СтатьяРасхода, Справочники.СтатьиРасходов.ПрочиеРасходы);
			ЗаписьНабора.ТипПоказателя    = Перечисления.ТипыБюджетныхПоказателей.Списание;
			ЗаписьНабора.Валюта           = ВалютаКошелька;
			ЗаписьНабора.Кошелек          = СтрокаДокумента.КошелекРасхода;
			ЗаписьНабора.Сумма            = СтрокаДокумента.СуммаРасхода;
			ЗаписьНабора.Комментарий      = СтрокаДокумента.Комментарий;
			
			// Если оплата произошла с кредитной карты, автоматически добавляем перевод с кредитки в доступные деньги
			Если СтрокаДокумента.ТипСчета = Перечисления.ТипыСчетов.БанковскаяКартаКредитная Тогда
				ЗаписьНабора = ОборотыБюджета.Добавить();
				ЗаписьНабора.Период           = СтрокаДокумента.Период;
				ЗаписьНабора.Регистратор      = СтрокаДокумента.Регистратор;
				ЗаписьНабора.РазделБюджета    = ФинЦель;
				ЗаписьНабора.СтатьяБюджета    = СтрокаДокумента.КошелекРасхода;
				ЗаписьНабора.ТипПоказателя    = Перечисления.ТипыБюджетныхПоказателей.Поступление;
				ЗаписьНабора.Валюта           = ВалютаКошелька;
				ЗаписьНабора.Кошелек          = Неопределено;
				ЗаписьНабора.Сумма            = СтрокаДокумента.СуммаРасхода;
				ЗаписьНабора.Комментарий      = СтрокаДокумента.Комментарий;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ТаблицаНабора.Свернуть("Дата, ЭтоШаблон, Операция, РазделУчета, ПредметУчета, ФинансоваяЦель, ТипПоказателя, Валюта", "СуммаПоступления, СуммаСписания");
	СтруктураТаблиц.Вставить("ОбъектыОперации", ТаблицаНабора);
	
	// Обороты плановой операции
	Если ЭтоШаблон Или ДополнительныеСвойства.ЭтоПлановаяОперация Тогда
		
		ОборотыПлановыхОпераций.Свернуть("Период,Регистратор,РазделБюджета,СтатьяБюджета,ТипПоказателя,Валюта,Кошелек", "Сумма");
		СтруктураТаблиц.Вставить("ОборотыПлановыхОпераций", ОборотыПлановыхОпераций);
		
	КонецЕсли;
	
	
	Если ОборотыБюджета <> Неопределено Тогда
		ОборотыБюджета.Свернуть("Период,Регистратор,РазделБюджета,СтатьяБюджета,ТипПоказателя,Валюта,Кошелек,Комментарий", "Сумма");
		СтруктураТаблиц.Вставить("ОборотыБюджета", ОборотыБюджета);
	КонецЕсли;
	
	Возврат СтруктураТаблиц;

КонецФункции

#КонецОбласти

#КонецЕсли