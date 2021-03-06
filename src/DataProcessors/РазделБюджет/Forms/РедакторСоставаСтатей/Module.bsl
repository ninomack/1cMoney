////////////////////////////////////////////////////////////////////////////////
//Обработка.РазделБюджет.Форма.РедакторСоставаСтатей
//  Предназначен для произвольного изменения статей в настройках бюджета
//  
//Параметры формы:
//  ВариантБюджета
//  РазделБюджета
//  ГрафаБюджета
//  СтатьяБюджета
//  МинимальнаяДата - наименьшая дата, за которую нужно проверить наличие сумм в показателях бюджета. 
//					Начиная с этой даты будут очищены показатели по статьям, с которых снимут видимость в бюджете
//  МаксимальнаяДата - наименьшая дата, за которую нужно проверить наличие сумм в показателях бюджета
//  
////////////////////////////////////////////////////////////////////////////////

&НаСервере 
Перем ОбъектОбработки;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МинимальнаяДата               = Параметры.МинимальнаяДата;
	МинимальнаяДатаПросмотра      = Параметры.МинимальнаяДатаПросмотра;
	МаксимальнаяДата              = Параметры.МаксимальнаяДата;
	КалендарноеОкончаниеВыборки   = Параметры.КалендарноеОкончаниеВыборки;
	
	ВариантБюджета    = Параметры.ВариантБюджета;
	РазделБюджета     = Параметры.РазделБюджета;
	
	ПериодБюджета = БюджетированиеСервер.НоваяСтрукрураБюджетногоПериода(ВариантБюджета, МинимальнаяДата);
	МинимальнаяДата = ПериодБюджета.КалендарноеНачало;
	
	Заголовок = НСтр("ru='Состав статей бюджета: %1'");
	Заголовок = СтрШаблон(Заголовок, ?(ЗначениеЗаполнено(РазделБюджета), РазделБюджета, НСтр("ru='Бюджет свободных денег'")));
	
	ГрафаБюджета      = Параметры.ГрафаБюджета;
	СтатьяБюджета     = Параметры.СтатьяБюджета;
	Если ЗначениеЗаполнено(ГрафаБюджета) Тогда
		
		СтруктураПоиска = Новый Структура("ГрафаБюджета", ГрафаБюджета);
		СтруктураПоиска.Вставить("СтатьяБюджета", СтатьяБюджета);
		
	Иначе
		
		СтруктураПоиска = Неопределено;
		
	КонецЕсли;
	
	ОбновитьДеревьяСтатей(СтруктураПоиска);
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры


#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы



#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормы_ИмяТаблицы

&НаКлиенте
Процедура ДеревоДоходовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИзменитьВидимостьВыделенныхСтрок(Элемент.ВыделенныеСтроки, ДеревоДоходов);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоДоходовВидимостьПриИзменении(Элемент)
	ИзменитьВидимостьВыделенныхСтрок(Элементы.ДеревоДоходов.ВыделенныеСтроки, ДеревоДоходов, Элементы.ДеревоДоходов.ТекущиеДанные.Видимость);
КонецПроцедуры


&НаКлиенте
Процедура ДеревоРасходовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИзменитьВидимостьВыделенныхСтрок(Элемент.ВыделенныеСтроки, ДеревоРасходов);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоРасходовВидимостьПриИзменении(Элемент)
	ИзменитьВидимостьВыделенныхСтрок(Элементы.ДеревоРасходов.ВыделенныеСтроки, ДеревоРасходов, Элементы.ДеревоРасходов.ТекущиеДанные.Видимость);
КонецПроцедуры
 
#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	ИзменитьВидимостьУзлаДерева(?(Элементы.СтраницыДоходовРасходов.ТекущаяСтраница = Элементы.СтраницаДоходов, ДеревоДоходов, ДеревоРасходов), Истина);
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсеОтметки(Команда)
	ИзменитьВидимостьУзлаДерева(?(Элементы.СтраницыДоходовРасходов.ТекущаяСтраница = Элементы.СтраницаДоходов, ДеревоДоходов, ДеревоРасходов), Ложь);
КонецПроцедуры

&НаКлиенте
Процедура Ок(Команда)
	
	Состояние(НСтр("ru='Обновление состава статей в текущем и будущих периодах...'"));
	Если ЗаписатьНастройкиСтатей() Тогда
		Закрыть(Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсеПоГруппе(Команда)
	
	УзелДерева = ?(Элементы.СтраницыДоходовРасходов.ТекущаяСтраница = Элементы.СтраницаДоходов,
					Элементы.ДеревоДоходов.ТекущиеДанные, Элементы.ДеревоРасходов.ТекущиеДанные);
	Если УзелДерева <> Неопределено Тогда
		ИзменитьВидимостьУзлаДерева(УзелДерева, Истина, Истина);
		ИзменитьВидимостьСтроки(УзелДерева, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсеОтметкиПоГруппе(Команда)
	
	УзелДерева = ?(Элементы.СтраницыДоходовРасходов.ТекущаяСтраница = Элементы.СтраницаДоходов,
					Элементы.ДеревоДоходов.ТекущиеДанные, Элементы.ДеревоРасходов.ТекущиеДанные);
	Если УзелДерева <> Неопределено Тогда
		ИзменитьВидимостьУзлаДерева(УзелДерева, Ложь, Истина);
		ИзменитьВидимостьСтроки(УзелДерева, Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть(Ложь);
	
КонецПроцедуры


#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция НовоеДеревоСтатей()

	Результат = Новый ДеревоЗначений;
	Результат.Колонки.Добавить("Наименование");
	Результат.Колонки.Добавить("ГрафаБюджета");
	Результат.Колонки.Добавить("СтатьяБюджета");
	Результат.Колонки.Добавить("АктивностьСтатьи", Новый ОписаниеТипов("Булево"));
	Результат.Колонки.Добавить("Видимость", Новый ОписаниеТипов("Булево"));
	Результат.Колонки.Добавить("ТолькоПросмотр", Новый ОписаниеТипов("Булево"));
	Результат.Колонки.Добавить("Порядок");
	Результат.Колонки.Добавить("ВидимостьПоУмолчанию");
	Результат.Колонки.Добавить("ПорядокПоУмолчанию");
	Результат.Колонки.Добавить("ОбщийПорядок");
	Результат.Колонки.Добавить("КоличествоПометок", Новый ОписаниеТипов("Число"));

	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ОбновитьДеревьяСтатей(РеквизитыТекущейСтроки)

	// Для удобного обращения к результатам запроса создаем структуру, 
	//	ключи которой будут соответствовать именам таблиц или выборок, 
	//	а значения - индексам выборок в пакете результатов
	СтруктураЗапросов = Новый Структура;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ВариантБюджета",             ВариантБюджета);
	Запрос.УстановитьПараметр("РазделБюджета",              РазделБюджета);
	Запрос.УстановитьПараметр("КалендарноеНачалоРедактируемогоПериода",     МинимальнаяДата);
	Запрос.УстановитьПараметр("БюджетноеОкончаниеВыборки",                  МаксимальнаяДата);
	Запрос.УстановитьПараметр("КалендарноеОкончаниеВыборки",                КалендарноеОкончаниеВыборки);
	Запрос.УстановитьПараметр("ДатаОтбораСоставаСтатей",  
				БюджетированиеСервер.МаксимальноеКалендарноеНачалоВарианта(ВариантБюджета, РазделБюджета, КалендарноеОкончаниеВыборки));
	
	БюджетированиеСервер.ДобавитьВЗапросКлючиСтатейБюджета(Запрос.Текст, СтруктураЗапросов);
	БюджетированиеСервер.ДобавитьВЗапросАктуальныеСтатьиБюджета(Запрос.Текст, СтруктураЗапросов);
	
	СтруктураЗапросов.Вставить("Выборка_ВсеСтатьиВарианта", СтруктураЗапросов.Количество());
	Запрос.Текст = Запрос.Текст + ДеньгиКлиентСервер.ТекстРазделителяЗапросов(" " + СтруктураЗапросов.Выборка_ВсеСтатьиВарианта + " выборка статей варианта") + 
	"ВЫБРАТЬ 
	|	КлючиСтатей.*,
	|	КлючиСтатей.ПорядокПоУмолчанию КАК ОбщийПорядок,
	|	НЕ (АктуальныеСтатьи.СтатьяБюджета ЕСТЬ NULL) КАК Видимость
	|ИЗ
	|	КлючиСтатей КАК КлючиСтатей
	|	ЛЕВОЕ СОЕДИНЕНИЕ АктуальныеСтатьи КАК АктуальныеСтатьи
	|		ПО КлючиСтатей.ГрафаБюджета = АктуальныеСтатьи.Графабюджета
	|			И КлючиСтатей.СтатьяБюджета = АктуальныеСтатьи.СтатьяБюджета
	|ГДЕ
	|	ВЫБОР
	|			КОГДА &РазделБюджета = """"
	|				ТОГДА КлючиСтатей.ОтношениеКНакоплениям = 0
	|			КОГДА &РазделБюджета = ЗНАЧЕНИЕ(Справочник.ФинансовыеЦели.ПустаяСсылка)
	|				ТОГДА КлючиСтатей.ОтношениеКНакоплениям <= 0
	|			ИНАЧЕ КлючиСтатей.ОтношениеКНакоплениям >= 0
	|		КОНЕЦ
	|	И КлючиСтатей.СтатьяБюджета <> &РазделБюджета
	|	И 
	|	НЕ (
	|		(КлючиСтатей.ГрафаБюджета = Значение(Справочник.ГрафыБюджета.ВыдачаВзаймы) И КлючиСтатей.СтатьяБюджета Ссылка Справочник.Долги)
	|		ИЛИ (КлючиСтатей.ГрафаБюджета = Значение(Справочник.ГрафыБюджета.ПолучениеКредита) И КлючиСтатей.СтатьяБюджета Ссылка Справочник.Долги)
	|		ИЛИ КлючиСтатей.СтатьяБюджета Ссылка Справочник.Имущество
	|	
	|	)
	|УПОРЯДОЧИТЬ ПО
	|	КлючиСтатей.ТипПоказателя,
	|	КлючиСтатей.КлючСтатьи
	|ИТОГИ 
	|ПО
	|	КлючиСтатей.ТипПоказателя
	|";
	
	Пакетрезультатов = Запрос.ВыполнитьПакет();
	
	// Для быстрого доступа к строкам дерева по бюджетным статьям используем соответствие
	ПоступленияБюджета = Новый Соответствие;
	СписанияБюджета    = Новый Соответствие;
	
	ДеревоДоходов.ПолучитьЭлементы().Очистить();
	ДеревоРасходов.ПолучитьЭлементы().Очистить();
	
	Доходы  = НовоеДеревоСтатей();
	Расходы = НовоеДеревоСтатей();
	
	СчетчикДоходов  = 0;
	СчетчикРасходов = 0;
	
	ВыборкаТиповПоказателей = Пакетрезультатов[СтруктураЗапросов.Выборка_ВсеСтатьиВарианта].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "ТипПоказателя");
	Пока ВыборкаТиповПоказателей.Следующий() Цикл
		
		Если ВыборкаТиповПоказателей.ТипПоказателя = Перечисления.ТипыБюджетныхПоказателей.Поступление Тогда
			СоответствиеСтрок = ПоступленияБюджета;
			Дерево = Доходы;
			Счетчик = СчетчикДоходов;
		Иначе
			СоответствиеСтрок = СписанияБюджета;
			Дерево = Расходы;
			Счетчик = СчетчикРасходов;
		КонецЕсли;
		
		Выборка = ВыборкаТиповПоказателей.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			СтрокаРодительскойСтатьи = Неопределено;
			Если ЗначениеЗаполнено(Выборка.РодительскаяСтатья) Тогда
				СтрокаРодительскойСтатьи = СоответствиеСтрок[Выборка.РодительскаяСтатья];
			КонецЕсли;
			
			СтрокаДерева = ?(СтрокаРодительскойСтатьи = Неопределено, Дерево.Строки.Добавить(), СтрокаРодительскойСтатьи.Строки.Добавить());
			ЗаполнитьЗначенияСвойств(СтрокаДерева, Выборка);
			
			Если СтрокаДерева.СтатьяБюджета = Справочники.ГрафыБюджета.ПрочиеДоходы Или СтрокаДерева.СтатьяБюджета = Справочники.ГрафыБюджета.ПрочиеРасходы Тогда
				СтрокаДерева.ТолькоПросмотр = Истина;
				СтрокаДерева.Видимость = Истина;
			ИначеЕсли СтрокаДерева.СтатьяБюджета = Справочники.ФинансовыеЦели.ОбщиеНакопления И РазделБюджета <> Справочники.ФинансовыеЦели.ОбщиеНакопления Тогда
				СтрокаДерева.Видимость = Истина;
				СтрокаДерева.ТолькоПросмотр = Истина;
			ИначеЕсли СтрокаДерева.СтатьяБюджета = Справочники.ФинансовыеЦели.ПустаяСсылка() И РазделБюджета = Справочники.ФинансовыеЦели.ОбщиеНакопления Тогда
				СтрокаДерева.Видимость = Истина;
				СтрокаДерева.ТолькоПросмотр = Истина;
			КонецЕсли;
			
			СтрокаДерева.КоличествоПометок = ?(СтрокаДерева.Видимость, 1, 0);
			
			СоответствиеСтрок.Вставить(Выборка.СтатьяБюджета, СтрокаДерева);
			
		КонецЦикла;
		
	КонецЦикла;
	
	
	Доходы.Строки.Сортировать("ОбщийПорядок,Наименование", Истина);
	ЗаполнитьДеревоСтатей(ДеревоДоходов, Доходы, РеквизитыТекущейСтроки, "СтраницаДоходов");
	
	Расходы.Строки.Сортировать("ОбщийПорядок,Наименование", Истина);
	ЗаполнитьДеревоСтатей(ДеревоРасходов, Расходы, РеквизитыТекущейСтроки, "СтраницаРасходов");
	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоСтатей(УзелРеквизита, УзелДерева, РеквизитыТекущейСтроки, ИмяТекущейСтарницы)

	Для каждого СтрокаУзла Из УзелДерева.Строки Цикл
		
		СтрокаРеквизита = УзелРеквизита.ПолучитьЭлементы().Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаРеквизита, СтрокаУзла);
		
		Если РеквизитыТекущейСтроки <> Неопределено И СтрокаУзла.ГрафаБюджета = РеквизитыТекущейСтроки.ГрафаБюджета Тогда
			
			Если СтрокаУзла.СтатьяБюджета = РеквизитыТекущейСтроки.СтатьяБюджета Тогда
				Элементы.СтраницыДоходовРасходов.ТекущаяСтраница = Элементы[ИмяТекущейСтарницы];
				Элементы[?(ИмяТекущейСтарницы = "СтраницаДоходов", "ДеревоДоходов", "ДеревоРасходов")].ТекущаяСтрока = СтрокаРеквизита.ПолучитьИдентификатор();
			КонецЕсли;
			
		КонецЕсли;
		
		ЗаполнитьДеревоСтатей(СтрокаРеквизита, СтрокаУзла, РеквизитыТекущейСтроки, ИмяТекущейСтарницы);
		
		Если СтрокаУзла.Строки.Количество() > 0 Тогда
			СтрокаРеквизита.КоличествоПометок = СтрокаУзла.Строки.Итог("КоличествоПометок");
			СтрокаРеквизита.Наименование = СтрокаУзла.Наименование + " ( + " + СтрокаРеквизита.КоличествоПометок + ")";
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВидимостьВыделенныхСтрок(ВыделенныеСтроки, ДеревоСтатей, НоваяВидимость = Неопределено)

	СписокРодителей = Новый Соответствие;
	
	Для каждого ИДСтроки Из ВыделенныеСтроки Цикл
		СтрокаДерева = ДеревоСтатей.НайтиПоИдентификатору(ИДСтроки);
		ИзменитьВидимостьСтроки(СтрокаДерева, НоваяВидимость);
		РодительскаяСтрока = СтрокаДерева.ПолучитьРодителя();
		Если РодительскаяСтрока <> Неопределено Тогда
			СписокРодителей.Вставить(РодительскаяСтрока, Истина);
		КонецЕсли;
	КонецЦикла;

	ОбновитьНаименованияРодителей(СписокРодителей);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВидимостьУзлаДерева(УзелДерева, НоваяВидимость = Неопределено, ВключаяПодчиненные = Истина)

	СписокРодителей = Новый Соответствие;
	
	Для каждого СтрокаДерева Из УзелДерева.ПолучитьЭлементы() Цикл
		ИзменитьВидимостьСтроки(СтрокаДерева, НоваяВидимость);
		
		Если ВключаяПодчиненные Тогда
			ИзменитьВидимостьУзлаДерева(СтрокаДерева, НоваяВидимость, ВключаяПодчиненные);
		КонецЕсли;
		
		ИзменитьВидимостьСтроки(СтрокаДерева, НоваяВидимость);
		РодительскаяСтрока = СтрокаДерева.ПолучитьРодителя();
		Если РодительскаяСтрока <> Неопределено Тогда
			СписокРодителей.Вставить(РодительскаяСтрока, Истина);
		КонецЕсли;
		
	КонецЦикла;

	ОбновитьНаименованияРодителей(СписокРодителей);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьНаименованияРодителей(СписокРодителей)

	Для каждого СтрокаРодителя Из СписокРодителей Цикл
		
		СтрокаРодителя.Ключ.КоличествоПометок = 0;
		Для каждого Подстрока Из СтрокаРодителя.Ключ.ПолучитьЭлементы() Цикл
			Если Подстрока.Видимость Тогда
				СтрокаРодителя.Ключ.КоличествоПометок = СтрокаРодителя.Ключ.КоличествоПометок + 1;
			КонецЕсли;
		КонецЦикла;
		
		СтрокаРодителя.Ключ.Наименование = Строка(СтрокаРодителя.Ключ.СтатьяБюджета) + " ( + " + СтрокаРодителя.Ключ.КоличествоПометок + ")";
		
	КонецЦикла;

КонецПроцедуры
 

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьВидимостьСтроки(Строка, НоваяВидимость)

	Если Не Строка.ТолькоПросмотр Тогда
		Строка.Видимость = ?(НоваяВидимость = Неопределено, Не Строка.Видимость, НоваяВидимость);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ЗаписатьНастройкиСтатей()

	// Заполняем таблицу показателей новым составом
	Набор = РегистрыСведений.ПоказателиБюджета.СоздатьНаборЗаписей();
	ТаблицаСостава = Набор.ВыгрузитьКолонки();
	ТаблицаСостава.Колонки.Добавить("Видимость", Новый ОписаниеТипов("Булево"));
	ТаблицаСостава.Колонки.Добавить("ВидимыйРодитель", Метаданные.РегистрыСведений.ПоказателиБюджета.Измерения.СтатьяБюджета.Тип);
	
	ВыгрузитьВТаблицуОтметки(ТаблицаСостава, ДеревоДоходов, Перечисления.ТипыБюджетныхПоказателей.Поступление);
	ВыгрузитьВТаблицуОтметки(ТаблицаСостава, ДеревоРасходов, Перечисления.ТипыБюджетныхПоказателей.Списание);
	
	НачатьТранзакцию();
	Ошибки = Неопределено;
	
	Попытка
	
		// Обновляем текущий и будущие составы статей бюджета
		БюджетированиеСервер.ОбновитьСоставСтатейВариантаБюджета(ВариантБюджета, РазделБюджета, МинимальнаяДатаПросмотра, ТаблицаСостава, МаксимальнаяДата > НачалоДня(ТекущаяДатаКлиентСервер()));
		
		ЗафиксироватьТранзакцию();
		Модифицированность = Ложь;
		
	Исключение
	
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()), Неопределено);
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
		ОтменитьТранзакцию();
		
		Возврат Ложь;
		
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура ВыгрузитьВТаблицуОтметки(ТаблицаСостава, УзелДерева, ТипПоказателя)

	Если ТипЗнч(УзелДерева) = Тип("ДанныеФормыЭлементДерева") Тогда
		
		Если УзелДерева.Видимость Тогда
			ВидимыйРодитель = УзелДерева.СтатьяБюджета;
		Иначе
			
			СтрокаРодителя = УзелДерева.ПолучитьРодителя();
			Пока СтрокаРодителя <> Неопределено Цикл
				Если СтрокаРодителя.Видимость Тогда
					ВидимыйРодитель = СтрокаРодителя.СтатьяБюджета;
					Прервать;
				КонецЕсли;
				СтрокаРодителя = СтрокаРодителя.ПолучитьРодителя();
			КонецЦикла;
			
		КонецЕсли;
		
	Иначе
		ВидимыйРодитель = Неопределено;
	КонецЕсли;
	
	СчетчикПорядка = 0;
	Для каждого СтрокаУзла Из УзелДерева.ПолучитьЭлементы() Цикл
		
		// Сначала обрабатываем подчинненые строки
		ВыгрузитьВТаблицуОтметки(ТаблицаСостава, СтрокаУзла, ТипПоказателя);
		
		Если Не СтрокаУзла.Видимость Тогда
			Продолжить;
		КонецЕсли;
		
		СчетчикПорядка = СчетчикПорядка + 1;
		Если ЗначениеЗаполнено(СтрокаУзла.Порядок) Тогда
			СчетчикПорядка = Макс(СтрокаУзла.Порядок, СчетчикПорядка)
		КонецЕсли;
		
		Запись = ТаблицаСостава.Добавить();
		Запись.Видимость       = СтрокаУзла.Видимость;
		Запись.ВариантБюджета  = ВариантБюджета;
		Запись.РазделБюджета   = РазделБюджета;
		Запись.ГрафаБюджета    = СтрокаУзла.ГрафаБюджета;
		Запись.ТипПоказателя   = ТипПоказателя;
		Запись.СтатьяБюджета   = СтрокаУзла.СтатьяБюджета;
		Запись.Порядок         = СчетчикПорядка;
		Запись.ВидимыйРодитель = ВидимыйРодитель;
		
	КонецЦикла;

КонецПроцедуры



&НаСервере
Процедура ЗаполнитьНаборНастройкамиДерева(Набор, УзелДерева, ТипПоказателя, УдаляемыеСтатьи, АктуальныйРодитель = Неопределено)

	СтрокиДерева = УзелДерева.ПолучитьЭлементы();
	Для каждого СтрокаДерева Из СтрокиДерева Цикл
		
		Если Не СтрокаДерева.Видимость Тогда
			// Если со статьи сняли видимость и она не видима по умолчанию, нужно перенести 
			//	сумму без шаблонов с этой стати на родительскую статью или на "другие доходы/расходы"
			// Запоминаем такие статьи для последующей обработки
			СтрокаСтатьиКУдалению = УдаляемыеСтатьи.Добавить();
			СтрокаСтатьиКУдалению.ГрафаБюджета           = СтрокаДерева.ГрафаБюджета;
			СтрокаСтатьиКУдалению.СтатьяБюджета          = СтрокаДерева.СтатьяБюджета;
			СтрокаСтатьиКУдалению.ТипПоказателя          = ТипПоказателя;
			СтрокаСтатьиКУдалению.ВидимостьПоУмолчанию   = СтрокаДерева.ВидимостьПоУмолчанию;
			СтрокаСтатьиКУдалению.РодительскаяСтатья     = АктуальныйРодитель;
		КонецЕсли;
		
		Если СтрокаДерева.ТолькоПросмотр Или СтрокаДерева.Видимость Или СтрокаДерева.Видимость <> СтрокаДерева.ВидимостьПоУмолчанию Тогда
			
			ЗаписьНабора = Набор.Добавить();
			ЗаписьНабора.ВариантБюджета        = ВариантБюджета;
			ЗаписьНабора.РазделБюджета         = РазделБюджета;
			ЗаписьНабора.СтатьяБюджета         = СтрокаДерева.СтатьяБюджета;
			ЗаписьНабора.ГрафаБюджета          = СтрокаДерева.ГрафаБюджета;
			ЗаписьНабора.РодительскаяСтатья    = АктуальныйРодитель;
			ЗаписьНабора.Видимость             = СтрокаДерева.Видимость;
			ЗаписьНабора.Порядок               = СтрокаДерева.Порядок;
			
		КонецЕсли;
		
		ЗаполнитьНаборНастройкамиДерева(Набор, СтрокаДерева, ТипПоказателя, УдаляемыеСтатьи, 
					?(СтрокаДерева.ТолькоПросмотр Или СтрокаДерева.Видимость, СтрокаДерева.СтатьяБюджета, АктуальныйРодитель));
		
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ДополнительныеПараметры) Экспорт

	Если ЗаписатьНастройкиСтатей() Тогда
		Закрыть(Истина);
	КонецЕсли;

КонецПроцедуры
 
&НаКлиентеНаСервереБезКонтекста
Функция ТекущаяДатаКлиентСервер()
	#Если Сервер Или ВнешнееСоединение Тогда
		Возврат ТекущаяДатаСеанса();
	#Иначе
		Возврат ОбщегоНазначенияКлиент.ДатаСеанса();
	#КонецЕсли 
КонецФункции 

#КонецОбласти





