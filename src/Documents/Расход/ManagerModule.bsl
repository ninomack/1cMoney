#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


#Область ПрограммныйИнтерфейс

// Формирует и записывает движения в регистры учета
//
//Параметры:
//	СсылкаНаДокумент       - ДокументСсылка.Расход - регистратор движений
//	ДвиженияДокумента      - КоллекцияДвижений или иная коллекция - наборы записей регистров учета
//	ДополнительныеСвойства - Структура - сордержит дополнительные свойства документа
//
Процедура СформироватьДвиженияДокумента(СсылкаНаДокумент, ДвиженияДокумента, ДополнительныеСвойства) Экспорт

	// Получаем таблицу для формирования движений
	Если ТипЗнч(ДополнительныеСвойства) <> Тип("Структура") Или Не ДополнительныеСвойства.Свойство("ТаблицыДокумента") Тогда
		ПроверитьДополнительныеСвойстваОперации(СсылкаНаДокумент, ДополнительныеСвойства, Истина);
	КонецЕсли;
	ТаблицыДокумента = ДополнительныеСвойства.ТаблицыДокумента;
	
	ТипСтатьяРасходов = Тип("СправочникСсылка.СтатьиРасходов");
	
	// Проводки по табличной части документа
	Для Каждого СтрокаДокумента Из ТаблицыДокумента.Расходы Цикл
		
		// Добавляем проводки с учетом валют имущества и кошелька (долга):
		МассивПроводок = РазделыУчета.ДобавитьПроводкуВДвижения(ДвиженияДокумента.ЖурналОпераций, 
					СтрокаДокумента.Период, СтрокаДокумента.Регистратор, 
					// параметры дебетовой стороны проводки
					СтрокаДокумента.РазделПриемникаДенег, 
					СтрокаДокумента.ОбъектПриемникаДенег, 
					СтрокаДокумента.АналитикаСтатьи, 
					СтрокаДокумента.СуммаВВалютеРасхода, 
					СтрокаДокумента.ВалютаПриемникаДенег,
					// параметры кредитовой стороны проводки
					СтрокаДокумента.РазделИсточникаДенег,
					СтрокаДокумента.ОбъектИсточникаДенег,   
					СтрокаДокумента.ФинансоваяЦельОткуда,  
					СтрокаДокумента.СуммаВВалютеИсточника, 
					СтрокаДокумента.ВалютаИсточникаДенег,
					// дополнительная информация
					СтрокаДокумента.КомментарийСтроки);
			
		// Обороты по количеству для статей расходов
		Если МассивПроводок.Количество() > 0 И ТипЗнч(СтрокаДокумента.ОбъектПриемникаДенег) = ТипСтатьяРасходов И СтрокаДокумента.УчитыватьОборотыПоКоличеству Тогда
			Запись = ДвиженияДокумента.КоличественныеОборотыПоСтатьямРасходов.Добавить();
			ЗаполнитьЗначенияСвойств(Запись, СтрокаДокумента);
			Запись.СтатьяРасхода         = СтрокаДокумента.ОбъектПриемникаДенег;
			Запись.Валюта                = СтрокаДокумента.ВалютаИсточникаДенег;
			Запись.ВалютнаяСумма         = СтрокаДокумента.СуммаБезВычетаСкидки; 
			Запись.ВалютнаяСуммаСкидки   = СтрокаДокумента.Скидка;
			Запись.НомерСтрокиЖурнала    = ДвиженияДокумента.ЖурналОпераций.Количество();
		КонецЕсли;
		
	КонецЦикла; 
	
	Для Каждого СтрокаДокумента Из ТаблицыДокумента.РасходыНаЦель Цикл
		
		Если ЗначениеЗаполнено(СтрокаДокумента.ФинансоваяЦель) И ЗначениеЗаполнено(СтрокаДокумента.Валюта) Тогда
			ЗаписьРасхода = ДвиженияДокумента.ИспользованиеСуммФинансовыхЦелей.Добавить();
			ЗаполнитьЗначенияСвойств(ЗаписьРасхода, СтрокаДокумента);
		КонецЕсли; 
		
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
//	ПроверятьТаблицыДокумента - Булево - нужно ли выбирать записи документа для формирования движений
//
Процедура ПроверитьДополнительныеСвойстваОперации(Операция, ДополнительныеСвойства, ПроверятьТаблицыДокумента = Ложь) Экспорт

	// Выполняем проверку, одинаковую для всех документов
	ОбслуживаниеДокументов.ОбщаяПроверкаДополнительныхСвойствДокумента(Операция, ДополнительныеСвойства);
	
	Если НЕ ДополнительныеСвойства.Свойство("ВалютаОперации") ИЛИ НЕ ЗначениеЗаполнено(ДополнительныеСвойства.ВалютаОперации) Тогда
		Если ЗначениеЗаполнено(Операция.ВалютаОперации) Тогда
			ДополнительныеСвойства.Вставить("ВалютаОперации", Операция.ВалютаОперации)
		ИначеЕсли ЗначениеЗаполнено(Операция.КошелекДолг) Тогда
			ДополнительныеСвойства.Вставить("ВалютаОперации", Операция.КошелекДолг.Валюта)
		Иначе
			ДополнительныеСвойства.Вставить("ВалютаОперации", ДополнительныеСвойства.ВалютаУчета)
		КонецЕсли; 
	КонецЕсли;
	
	Если НЕ ДополнительныеСвойства.Свойство("Период") ИЛИ НЕ ЗначениеЗаполнено(ДополнительныеСвойства.Период) Тогда
		ДополнительныеСвойства.Вставить("Период", Операция.Дата)
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
	Поля.Добавить("СуммаОплаты");
	Поля.Добавить("ВалютаОперации");
	Поля.Добавить("КошелекДолг");
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Данные.ЭтоШаблон Тогда
		Представление = ДеньгиКлиентСервер.СокращенноеПредставление(Данные.ОписаниеОперации, 250, Ложь);
	Иначе
		Представление = НСтр("ru='Расход от'") + " " + Формат(Данные.Дата, "ДФ='дд.ММ.гггг (ЧЧ:мм)'")
				+ ": " + Формат(Данные.СуммаОплаты, "ЧДЦ=2; ЧН=0.00") + " " + Данные.ВалютаОперации
				+ " " + НСтр("ru='из'") + " " + ДеньгиКлиентСервер.СокращенноеПредставление(Строка(Данные.КошелекДолг)); 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаВыбора" Тогда
		
		РаботаСФормамиДокументов.ОпределитьФормуСпискаДляВыбора(Тип("ДокументСсылка.Расход"), Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Функция ПолучитьВыборкиДляФормированияДвижений(СсылкаНаДокумент, ДополнительныеСвойства) 

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка",          СсылкаНаДокумент);
	Запрос.УстановитьПараметр("ВалютаУчета",     ДополнительныеСвойства.ВалютаУчета);
	Запрос.УстановитьПараметр("ВалютаОперации",  ДополнительныеСвойства.ВалютаОперации);
	Запрос.УстановитьПараметр("ДатаОперации",    ДополнительныеСвойства.Период);
	Запрос.Текст =  
	"ВЫБРАТЬ
	|	РасходРасходы.Ссылка.Ссылка КАК Регистратор,
	|	РасходРасходы.Ссылка.Дата КАК Период,
	|	ВЫБОР
	|		КОГДА РасходРасходы.Ссылка.КошелекДолг ССЫЛКА Справочник.Долги 
	|			ТОГДА ЗНАЧЕНИЕ(ПланСчетов.РазделыУчета.ОсновныеСуммыДолгов)
	|		КОГДА ЕСТЬNULL(РасходРасходы.Ссылка.КошелекДолг.ИспользоватьДляНакоплений, ЛОЖЬ)
	|			ТОГДА ЗНАЧЕНИЕ(ПланСчетов.РазделыУчета.Накопления)
	|		ИНАЧЕ ЗНАЧЕНИЕ(ПланСчетов.РазделыУчета.СвободныеДеньги)
	|	КОНЕЦ КАК РазделИсточникаДенег,
	|	РасходРасходы.Ссылка.КошелекДолг КАК ОбъектИсточникаДенег,
	|	РасходРасходы.Ссылка.ВалютаОперации КАК ВалютаИсточникаДенег,
	|	ЕСТЬNULL(РасходРасходы.Ссылка.КошелекДолг.ИспользоватьДляНакоплений, ЛОЖЬ) КАК ИспользоватьДляНакоплений,
	|	РасходРасходы.НомерСтроки КАК НомерСтроки,
	|	ВЫБОР
	|		КОГДА РасходРасходы.СтатьяРасходаИмущество ССЫЛКА Справочник.Имущество
	|			ТОГДА ЗНАЧЕНИЕ(ПланСчетов.РазделыУчета.Имущество)
	|		ИНАЧЕ ЗНАЧЕНИЕ(ПланСчетов.РазделыУчета.Капитал)
	|	КОНЕЦ КАК РазделПриемникаДенег,
	|	РасходРасходы.СтатьяРасходаИмущество КАК ОбъектПриемникаДенег,
	|	ВЫБОР
	|		КОГДА РасходРасходы.СтатьяРасходаИмущество ССЫЛКА Справочник.Имущество
	|			ТОГДА РасходРасходы.СтатьяРасходаИмущество.Валюта
	|		ИНАЧЕ РасходРасходы.Ссылка.ВалютаОперации
	|	КОНЕЦ КАК ВалютаПриемникаДенег,
	|	РасходРасходы.Сумма КАК Сумма,
	|	РасходРасходы.Количество КАК Количество,
	|	РасходРасходы.АналитикаСтатьи КАК АналитикаСтатьи,
	|	РасходРасходы.КомментарийСтроки КАК КомментарийСтроки,
	|	РасходРасходы.Скидка КАК Скидка,
	|	РасходРасходы.Сумма + РасходРасходы.Скидка КАК СуммаБезВычетаСкидки,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(РасходРасходы.Ссылка.КошелекДолг.ИспользоватьДляНакоплений, ЛОЖЬ)
	|			ТОГДА ВЫБОР
	|					КОГДА РасходРасходы.Ссылка.ФинансоваяЦельОткуда <> ЗНАЧЕНИЕ(Справочник.ФинансовыеЦели.ПустаяСсылка)
	|						ТОГДА РасходРасходы.Ссылка.ФинансоваяЦельОткуда
	|					КОГДА РасходРасходы.ФинансоваяЦель <> ЗНАЧЕНИЕ(Справочник.ФинансовыеЦели.ПустаяСсылка)
	|						ТОГДА РасходРасходы.ФинансоваяЦель
	|					ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ФинансовыеЦели.ОбщиеНакопления)
	|				КОНЕЦ
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ФинансовыеЦели.ПустаяСсылка)
	|	КОНЕЦ КАК ФинансоваяЦельОткуда,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(РасходРасходы.Ссылка.КошелекДолг.ИспользоватьДляНакоплений, ЛОЖЬ)
	|			ТОГДА ВЫБОР
	|					КОГДА РасходРасходы.ФинансоваяЦель <> ЗНАЧЕНИЕ(Справочник.ФинансовыеЦели.ПустаяСсылка)
	|						ТОГДА РасходРасходы.ФинансоваяЦель
	|					ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ФинансовыеЦели.ОбщиеНакопления)
	|				КОНЕЦ
	|		КОГДА РасходРасходы.ФинансоваяЦель = ЗНАЧЕНИЕ(Справочник.ФинансовыеЦели.ОбщиеНакопления)
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ФинансовыеЦели.ПустаяСсылка)
	|		ИНАЧЕ РасходРасходы.ФинансоваяЦель
	|	КОНЕЦ КАК ФинансоваяЦель
	|ПОМЕСТИТЬ СтрокиОперации
	|ИЗ
	|	Документ.Расход.Расходы КАК РасходРасходы
	|ГДЕ
	|	РасходРасходы.Ссылка = &Ссылка
	|;
	|
	|//1//////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Расход.Ссылка КАК Регистратор,
	|	Расход.ПометкаУдаления,
	|	Расход.Дата КАК Период,
	|	Расход.ЭтоШаблон,
	|	Расход.Проведен,
	|	ВЫБОР
	|		КОГДА Расход.КошелекДолг ССЫЛКА Справочник.Долги 
	|			ТОГДА ЗНАЧЕНИЕ(ПланСчетов.РазделыУчета.ОсновныеСуммыДолгов)
	|		КОГДА ЕСТЬNULL(Расход.КошелекДолг.ИспользоватьДляНакоплений, ЛОЖЬ)
	|			ТОГДА ЗНАЧЕНИЕ(ПланСчетов.РазделыУчета.Накопления)
	|		ИНАЧЕ ЗНАЧЕНИЕ(ПланСчетов.РазделыУчета.СвободныеДеньги)
	|	КОНЕЦ КАК РазделУчета,
	|	Расход.КошелекДолг,
	|	Расход.ВалютаОперации,
	|	ЕСТЬNULL(Расход.КошелекДолг.ТипСчета, НЕОПРЕДЕЛЕНО) КАК ТипСчета,
	|	ЕСТЬNULL(Расход.КошелекДолг.ИспользоватьДляНакоплений, ЛОЖЬ) КАК ИспользоватьДляНакоплений
	|ИЗ
	|	Документ.Расход КАК Расход
	|ГДЕ
	|	Расход.Ссылка = &Ссылка
	|;
	|
	|//2//////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВалютыДокумента.ВалютаПриемникаДенег КАК Валюта,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(КурсыДокумента.Курс, 1) = 0
	|			ТОГДА 1
	|		ИНАЧЕ ЕСТЬNULL(КурсыДокумента.Курс, 1)
	|	КОНЕЦ КАК Курс,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(КурсыДокумента.Кратность, 1) = 0
	|			ТОГДА 1
	|		ИНАЧЕ ЕСТЬNULL(КурсыДокумента.Кратность, 1)
	|	КОНЕЦ КАК Кратность
	|ПОМЕСТИТЬ КурсыВалютОперации
	|ИЗ
	|	(ВЫБРАТЬ
	|		СтрокиОперации.ВалютаПриемникаДенег КАК ВалютаПриемникаДенег
	|	ИЗ
	|		СтрокиОперации КАК СтрокиОперации
	|	ГДЕ
	|		СтрокиОперации.ВалютаПриемникаДенег <> СтрокиОперации.ВалютаИсточникаДенег
	|		И СтрокиОперации.ВалютаПриемникаДенег <> &ВалютаОперации
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		&ВалютаОперации) КАК ВалютыДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&ДатаОперации, БазоваяВалюта = &ВалютаУчета) КАК КурсыДокумента
	|		ПО (КурсыДокумента.Валюта = ВалютыДокумента.ВалютаПриемникаДенег)
	|;
	|
	|//3//////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтрокиОперации.Регистратор,
	|	СтрокиОперации.Период,
	|	СтрокиОперации.НомерСтроки КАК НомерСтроки,
	|	СтрокиОперации.РазделИсточникаДенег,
	|	СтрокиОперации.ОбъектИсточникаДенег,
	|	СтрокиОперации.ВалютаИсточникаДенег,
	|	СтрокиОперации.Сумма КАК СуммаВВалютеИсточника,
	|	СтрокиОперации.СуммаБезВычетаСкидки КАК СуммаБезВычетаСкидки,
	|	СтрокиОперации.РазделПриемникаДенег,
	|	СтрокиОперации.ОбъектПриемникаДенег,
	|	СтрокиОперации.ВалютаПриемникаДенег,
	|	ВЫБОР
	|		КОГДА СтрокиОперации.ВалютаПриемникаДенег = СтрокиОперации.ВалютаИсточникаДенег
	|			ТОГДА СтрокиОперации.Сумма
	|		ИНАЧЕ СтрокиОперации.Сумма * ЕСТЬNULL(КурсИсточника.Курс, 0) * ЕСТЬNULL(КурсыРасходов.Кратность, 0) / (ЕСТЬNULL(КурсыРасходов.Курс, 1) * ЕСТЬNULL(КурсИсточника.Кратность, 1))
	|	КОНЕЦ КАК СуммаВВалютеРасхода,
	|	СтрокиОперации.Количество,
	|	СтрокиОперации.АналитикаСтатьи,
	|	СтрокиОперации.КомментарийСтроки,
	|	СтрокиОперации.Скидка,
	|	СтрокиОперации.ФинансоваяЦельОткуда КАК ФинансоваяЦельОткуда,
	|	СтрокиОперации.ФинансоваяЦель КАК ФинансоваяЦель,
	|	ВЫБОР
	|		КОГДА СтрокиОперации.Скидка <> 0
	|				ИЛИ СтрокиОперации.Количество <> 0
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК УчитыватьОборотыПоКоличеству
	|ИЗ
	|	СтрокиОперации КАК СтрокиОперации
	|		ЛЕВОЕ СОЕДИНЕНИЕ КурсыВалютОперации КАК КурсыРасходов
	|		ПО СтрокиОперации.ВалютаПриемникаДенег = КурсыРасходов.Валюта
	|		ЛЕВОЕ СОЕДИНЕНИЕ КурсыВалютОперации КАК КурсИсточника
	|		ПО СтрокиОперации.ВалютаИсточникаДенег = КурсИсточника.Валюта
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтрокиОперации.Регистратор,
	|	СтрокиОперации.Период,
	|	СтрокиОперации.ВалютаИсточникаДенег КАК Валюта,
	|	СтрокиОперации.ФинансоваяЦель,
	|	СУММА(ВЫБОР
	|			КОГДА СтрокиОперации.ИспользоватьДляНакоплений
	|				ТОГДА СтрокиОперации.Сумма
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ИспользованоНакоплений,
	|	СУММА(ВЫБОР
	|			КОГДА НЕ СтрокиОперации.ИспользоватьДляНакоплений
	|				ТОГДА СтрокиОперации.Сумма
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ИспользованоСвободныхСредств
	|ИЗ
	|	СтрокиОперации КАК СтрокиОперации
	|ГДЕ
	|	СтрокиОперации.ФинансоваяЦель <> ЗНАЧЕНИЕ(Справочник.ФинансовыеЦели.ПустаяСсылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	СтрокиОперации.Регистратор,
	|	СтрокиОперации.Период,
	|	СтрокиОперации.ВалютаИсточникаДенег,
	|	СтрокиОперации.ФинансоваяЦель";
	
	ПакетРезультатов = Запрос.ВыполнитьПакет();
	
	СтруктураТаблиц = СтруктураТаблицФормированияДвижений();
	СтруктураТаблиц.РеквизитыШапки = ПакетРезультатов[1].Выгрузить();
	СтруктураТаблиц.Расходы        = ПакетРезультатов[3].Выгрузить();
	СтруктураТаблиц.РасходыНаЦель  = ПакетРезультатов[4].Выгрузить();
	
	РеквизитыДокумента = СтруктураТаблиц.РеквизитыШапки[0];
	
	// Таблицы для записи объектов операции и фактических оборотов бюджета
	ТаблицаНабора = ОбслуживаниеДокументов.НоваяТаблицаРегистраОбъектыОпераций();
	Если СтруктураТаблиц.Расходы.Количество() > 0 И 
			(РеквизитыДокумента.ЭтоШаблон ИЛИ РеквизитыДокумента.Проведен ИЛИ ДополнительныеСвойства.ЭтоПлановаяОперация) Тогда
		ОборотыБюджета = ОбслуживаниеДокументов.НоваяТаблицаРегистровОборотовБюджета();
	Иначе
		ОборотыБюджета = Неопределено;
	КонецЕсли;
	
	Если СтруктураТаблиц.Расходы.Количество() > 0 Тогда
		
		ТаблицаДвижений = СтруктураТаблиц.Расходы.Скопировать(,"ФинансоваяЦельОткуда,ФинансоваяЦель,РазделИсточникаДенег,ОбъектИсточникаДенег,
						|РазделПриемникаДенег,ОбъектПриемникаДенег,СуммаВВалютеИсточника,ВалютаИсточникаДенег,КомментарийСтроки,
						|СуммаВВалютеРасхода,ВалютаПриемникаДенег");
		ТаблицаДвижений.Свернуть("ФинансоваяЦельОткуда,ФинансоваяЦель,РазделИсточникаДенег,ОбъектИсточникаДенег,
						|РазделПриемникаДенег,ОбъектПриемникаДенег,ВалютаИсточникаДенег,ВалютаПриемникаДенег,КомментарийСтроки",
				"СуммаВВалютеИсточника,СуммаВВалютеРасхода");
				
		ОплатаВСчетДолга = ТипЗнч(РеквизитыДокумента.КошелекДолг) = Тип("СправочникСсылка.Долги");
		РасходСКредитки = Не ОплатаВСчетДолга И (РеквизитыДокумента.ТипСчета = Перечисления.ТипыСчетов.БанковскаяКартаКредитная);
				
		// Детальные записи по предметам учета с финансовыми целями
		Для Каждого СтрокаДокумента Из ТаблицаДвижений Цикл
			
			Если СтрокаДокумента.РазделИсточникаДенег = ПланыСчетов.РазделыУчета.СвободныеДеньги 
				Или СтрокаДокумента.РазделИсточникаДенег = ПланыСчетов.РазделыУчета.ОсновныеСуммыДолгов Тогда
				ФинЦель = ?(СтрокаДокумента.ФинансоваяЦель = Справочники.ФинансовыеЦели.ОбщиеНакопления, Неопределено, СтрокаДокумента.ФинансоваяЦель);
				ФинЦельОткуда = Неопределено;
			Иначе
				ФинЦель = ?(Не ЗначениеЗаполнено(СтрокаДокумента.ФинансоваяЦель), Справочники.ФинансовыеЦели.ОбщиеНакопления, СтрокаДокумента.ФинансоваяЦель);
				ФинЦельОткуда = СтрокаДокумента.ФинансоваяЦельОткуда;
			КонецЕсли;
			
			// Списание
			ЗаписьСписания = ТаблицаНабора.Добавить();
			ЗаписьСписания.Дата           = РеквизитыДокумента.Период;
			ЗаписьСписания.ЭтоШаблон      = РеквизитыДокумента.ЭтоШаблон;
			ЗаписьСписания.Операция       = СсылкаНаДокумент;
			ЗаписьСписания.РазделУчета    = СтрокаДокумента.РазделИсточникаДенег;
			ЗаписьСписания.ПредметУчета   = СтрокаДокумента.ОбъектИсточникаДенег;
			ЗаписьСписания.ФинансоваяЦель = ФинЦель;
			ЗаписьСписания.ТипПоказателя  = Перечисления.ТипыБюджетныхПоказателей.Списание;
			ЗаписьСписания.СуммаСписания  = СтрокаДокумента.СуммаВВалютеИсточника;
			ЗаписьСписания.Валюта         = СтрокаДокумента.ВалютаИсточникаДенег;
			
			// Поступление
			ЗаписьПоступления = ТаблицаНабора.Добавить();
			ЗаписьПоступления.Дата              = РеквизитыДокумента.Период;
			ЗаписьПоступления.ЭтоШаблон         = РеквизитыДокумента.ЭтоШаблон;
			ЗаписьПоступления.Операция          = СсылкаНаДокумент;
			ЗаписьПоступления.РазделУчета       = СтрокаДокумента.РазделПриемникаДенег;
			ЗаписьПоступления.ПредметУчета      = СтрокаДокумента.ОбъектПриемникаДенег;
			ЗаписьПоступления.ФинансоваяЦель    = ФинЦель;
			ЗаписьПоступления.ТипПоказателя     = Перечисления.ТипыБюджетныхПоказателей.Списание;
			ЗаписьПоступления.СуммаСписания     = СтрокаДокумента.СуммаВВалютеРасхода;
			ЗаписьПоступления.Валюта            = СтрокаДокумента.ВалютаПриемникаДенег;
			
			Если ЗначениеЗаполнено(ФинЦель) Тогда
				
				ЗаписьНабора = ТаблицаНабора.Добавить();
				ЗаполнитьЗначенияСвойств(ЗаписьНабора, ЗаписьСписания);
				ЗаписьНабора.ФинансоваяЦель    = Неопределено;
				
				ЗаписьНабора = ТаблицаНабора.Добавить();
				ЗаполнитьЗначенияСвойств(ЗаписьНабора, ЗаписьПоступления);
				ЗаписьНабора.ФинансоваяЦель    = Неопределено;
				
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(ЗаписьСписания.РазделУчета) Тогда
				ЗаписьСписания.РазделУчета = ПланыСчетов.РазделыУчета.СвободныеДеньги;
			КонецЕсли; 
			
			Если НЕ ЗначениеЗаполнено(ЗаписьПоступления.РазделУчета) Тогда
				ЗаписьПоступления.РазделУчета = ПланыСчетов.РазделыУчета.СвободныеДеньги;
			КонецЕсли; 
			
			// Фактические обороты бюджета
			Если ОборотыБюджета <> Неопределено Тогда
				
				СтатьяБюджета = ?(ТипЗнч(СтрокаДокумента.ОбъектПриемникаДенег) = Тип("СправочникСсылка.Имущество"), 
						Справочники.ГрафыБюджета.ПокупкаИмущества, СтрокаДокумента.ОбъектПриемникаДенег);
				ВалютаИсточникаДенег = ?(ЗначениеЗаполнено(СтрокаДокумента.ВалютаИсточникаДенег), СтрокаДокумента.ВалютаИсточникаДенег, ДополнительныеСвойства.ВалютаУчета);
				ЭтоПереводИзСвободныхВНакопления  = СтрокаДокумента.РазделИсточникаДенег = ПланыСчетов.РазделыУчета.СвободныеДеньги И ЗначениеЗаполнено(ФинЦель);
				ЭтоПеремещениеПоРазделамБюджета   = ?(ЗначениеЗаполнено(ФинЦельОткуда), ФинЦельОткуда, Неопределено)  <> ?(ЗначениеЗаполнено(ФинЦель), ФинЦель, Неопределено);
				
				// Если расход оплачен с кредитной карты или в долг, авоматически фиксируем получениеи денег в кредит
				Если ОплатаВСчетДолга Тогда
					
					// Сначала зафиксируем получение денег в долг
					ЗаписьНабора = ОборотыБюджета.Добавить();
					ЗаписьНабора.Период           = РеквизитыДокумента.Период;
					ЗаписьНабора.Регистратор      = РеквизитыДокумента.Регистратор;
					ЗаписьНабора.РазделБюджета    = ?(ЭтоПереводИзСвободныхВНакопления Или ОплатаВСчетДолга, Справочники.ФинансовыеЦели.ПустаяСсылка(), ФинЦель);
					ЗаписьНабора.СтатьяБюджета    = Справочники.ГрафыБюджета.ПолучениеКредита;
					ЗаписьНабора.ТипПоказателя    = Перечисления.ТипыБюджетныхПоказателей.Поступление;
					ЗаписьНабора.Валюта           = ВалютаИсточникаДенег;
					ЗаписьНабора.Кошелек          = Неопределено;
					ЗаписьНабора.Сумма            = СтрокаДокумента.СуммаВВалютеИсточника;
					ЗаписьНабора.Комментарий      = НСтр("ru='Увеличение долга на сумму расхода, совершенного в долг'");
					
				ИначеЕсли РасходСКредитки Тогда
				
					ЗаписьНабора = ОборотыБюджета.Добавить();
					ЗаписьНабора.Период           = РеквизитыДокумента.Период;
					ЗаписьНабора.Регистратор      = РеквизитыДокумента.Регистратор;
					ЗаписьНабора.РазделБюджета    = ?(ЭтоПереводИзСвободныхВНакопления, Справочники.ФинансовыеЦели.ПустаяСсылка(), ФинЦель);
					ЗаписьНабора.СтатьяБюджета    = РеквизитыДокумента.КошелекДолг;
					ЗаписьНабора.ТипПоказателя    = Перечисления.ТипыБюджетныхПоказателей.Поступление;
					ЗаписьНабора.Валюта           = ВалютаИсточникаДенег;
					ЗаписьНабора.Кошелек          = Неопределено;
					ЗаписьНабора.Сумма            = СтрокаДокумента.СуммаВВалютеИсточника;
					ЗаписьНабора.Комментарий      = НСтр("ru='Учтена сумма оплаты кредитной карты'");
					
				КонецЕсли;
				
				// Если с обычного кошелька оплачиваются расходы на финансовые цели, автоматически регистрируется перевод денег в накопления
				Если ЭтоПеремещениеПоРазделамБюджета Тогда
					
					ТекстКомментария = СтрШаблон(НСтр("ru='Расход на фин.цель из %1'"), ?(ЗначениеЗаполнено(ФинЦельОткуда), 
									Строка(ФинЦельОткуда), НСтр("ru='св. денег'")));
					
					// Списание денег из раздела - источника денег
					ЗаписьНабора = ОборотыБюджета.Добавить();
					ЗаписьНабора.Период           = РеквизитыДокумента.Период;
					ЗаписьНабора.Регистратор      = РеквизитыДокумента.Регистратор;
					ЗаписьНабора.РазделБюджета    = ФинЦельОткуда;
					ЗаписьНабора.СтатьяБюджета    = ФинЦель;
					ЗаписьНабора.ТипПоказателя    = Перечисления.ТипыБюджетныхПоказателей.Списание;
					ЗаписьНабора.Валюта           = ВалютаИсточникаДенег;
					ЗаписьНабора.Кошелек          = РеквизитыДокумента.КошелекДолг;
					ЗаписьНабора.Сумма            = СтрокаДокумента.СуммаВВалютеИсточника;
					ЗаписьНабора.Комментарий      = ТекстКомментария;
					
					// Приход накопления на фин.цель
					ЗаписьНабора = ОборотыБюджета.Добавить();
					ЗаписьНабора.Период           = РеквизитыДокумента.Период;
					ЗаписьНабора.Регистратор      = РеквизитыДокумента.Регистратор;
					ЗаписьНабора.РазделБюджета    = ФинЦель;
					ЗаписьНабора.СтатьяБюджета    = ?(ЗначениеЗаполнено(ФинЦельОткуда), ФинЦельОткуда, Справочники.ГрафыБюджета.ФинЦельПереводВНакопление);
					ЗаписьНабора.ТипПоказателя    = Перечисления.ТипыБюджетныхПоказателей.Поступление;
					ЗаписьНабора.Валюта           = ВалютаИсточникаДенег;
					ЗаписьНабора.Кошелек          = РеквизитыДокумента.КошелекДолг;
					ЗаписьНабора.Сумма            = СтрокаДокумента.СуммаВВалютеИсточника;
					ЗаписьНабора.Комментарий      = ТекстКомментария;
					
				КонецЕсли;
				
				// Фиксируем расход по статье
				ЗаписьНабора = ОборотыБюджета.Добавить();
				ЗаписьНабора.Период           = РеквизитыДокумента.Период;
				ЗаписьНабора.Регистратор      = РеквизитыДокумента.Регистратор;
				ЗаписьНабора.РазделБюджета    = ФинЦель;
				ЗаписьНабора.СтатьяБюджета    = СтатьяБюджета;
				ЗаписьНабора.ТипПоказателя    = Перечисления.ТипыБюджетныхПоказателей.Списание;
				ЗаписьНабора.Валюта           = ВалютаИсточникаДенег;
				ЗаписьНабора.Кошелек          = ?(ОплатаВСчетДолга, Неопределено, РеквизитыДокумента.КошелекДолг);
				ЗаписьНабора.Сумма            = СтрокаДокумента.СуммаВВалютеИсточника;
				ЗаписьНабора.Комментарий      = СтрокаДокумента.КомментарийСтроки;
				
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе
			
		ЗаписьСписания = ТаблицаНабора.Добавить();
		ЗаписьСписания.Дата              = РеквизитыДокумента.Период;
		ЗаписьСписания.ЭтоШаблон         = РеквизитыДокумента.ЭтоШаблон;
		ЗаписьСписания.Операция          = СсылкаНаДокумент;
		ЗаписьСписания.РазделУчета       = РеквизитыДокумента.РазделУчета;
		ЗаписьСписания.ПредметУчета      = РеквизитыДокумента.КошелекДолг;
		ЗаписьСписания.ФинансоваяЦель    = Неопределено;
		ЗаписьСписания.ТипПоказателя     = Перечисления.ТипыБюджетныхПоказателей.Списание;
		ЗаписьСписания.СуммаСписания     = 0;
		ЗаписьСписания.Валюта            = РеквизитыДокумента.ВалютаОперации;
		
		Если НЕ ЗначениеЗаполнено(ЗаписьСписания.РазделУчета) Тогда
		 	ЗаписьСписания.РазделУчета = ПланыСчетов.РазделыУчета.СвободныеДеньги;
		КонецЕсли; 
		
	КонецЕсли; 
	
	ТаблицаНабора.Свернуть("Дата, ЭтоШаблон, Операция, РазделУчета, ПредметУчета, ФинансоваяЦель, ТипПоказателя, Валюта", "СуммаПоступления, СуммаСписания");
	СтруктураТаблиц.Вставить("ОбъектыОперации", ТаблицаНабора);
	
	Если ОборотыБюджета <> Неопределено Тогда
		ОборотыБюджета.Свернуть("Период,Регистратор,РазделБюджета,СтатьяБюджета,ТипПоказателя,Валюта,Кошелек,Комментарий", "Сумма");
		СтруктураТаблиц.Вставить("ОборотыБюджета", ОборотыБюджета);
	КонецЕсли;
	
	Возврат СтруктураТаблиц;

КонецФункции

Функция СтруктураТаблицФормированияДвижений() 

	Результат = Новый Структура;
	Результат.Вставить("Расходы", Неопределено);        // таблица для формирования проводок по регистру бухгалтерии
	Результат.Вставить("РасходыНаЦель", Неопределено);  // таблица для записи расходов на финансовые цели
	Результат.Вставить("РеквизитыШапки", Неопределено); // таблица с общей информацией о документе
	Результат.Вставить("ТаблицыДокумента", Неопределено); // таблица для формирования записей в регистр сведений "ОбъектыОперации"

	Возврат Результат;
	
КонецФункции


#КонецОбласти



#КонецЕсли