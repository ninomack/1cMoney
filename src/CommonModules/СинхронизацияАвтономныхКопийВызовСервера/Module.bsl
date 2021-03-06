////////////////////////////////////////////////////////////////////////////////
// СинхронизацияАвтономныхКопийВызовСервера
//	функционал для синхронизации с локальными копиями
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает узел плана обмена, соответствующий центральной базе
//
//Параметры:
//	ИмяПланаОбмена - наименование плана обмена, в котором нужно найти узел ЦБ.
//					по умолчанию используется "СинхронизацияАвтономныхКопий"
//
//Возвращаемое значение:
//	ПланОбменаСсылка
//
Функция УзелЦентральнойБазы(ИмяПланаОбмена = "СинхронизацияАвтономныхКопий") Экспорт

	Результат = Неопределено;
	МенеджерПланаОбмена = ПланыОбмена[ИмяПланаОбмена];
	Если ЭтоЦентральнаяБаза() Тогда
		
		Результат = МенеджерПланаОбмена.ЭтотУзел();
		Если СтрДлина(СокрП(Результат.Код)) < 30 И Результат.Код <> "000" Тогда
			// код "000" может быть заменен на код из пакета обмена
			ОбновитьИнформациюЭтогоУзла(Результат, НСтр("ru='Центральная база'"));
		КонецЕсли;
		
	Иначе
		
		Если ОбщегоНазначения.ПодсистемаСуществует("ФункционалКонфигурацииДеньги.ДеньгиВОблаке") Тогда
			МодульОбмена = ОбщегоНазначения.ОбщийМодуль("ДеньгиОбменСЦентральнойБазой");
			Результат = МодульОбмена.ПроверитьСоздатьУзелЦентральнойБазы();
		КонецЕсли;
		
	КонецЕсли;

	Возврат Результат;
	
КонецФункции

// Возвращает код центральной базы
//
//Параметры:
//	ИмяПланаОбмена - наименование плана обмена, в котором нужно найти узел ЦБ.
//					по умолчанию используется "СинхронизацияАвтономныхКопий"
//
//Возвращаемое значение:
//	Строка
//
Функция КодЦентральнойБазы(ИмяПланаОбмена = "СинхронизацияАвтономныхКопий") Экспорт

	Возврат СокрЛП(УзелЦентральнойБазы(ИмяПланаОбмена).Код);

КонецФункции

// Обновляет код центральной базы в планах обмена
//
//Параметры:
//	НовыйКод - Строка - код, который нужно установить для "центральной базы" в планах обмена
//
Процедура ЗаменитьКодЦентральнойБазы(НовыйКод) Экспорт
	
	Узел = УзелЦентральнойБазы("СинхронизацияАвтономныхКопий");
	Если Узел.Код <> НовыйКод Тогда
		УзелОбъект = Узел.ПолучитьОбъект();	
		УзелОбъект.Код = НовыйКод;
		УзелОбъект.ОбменДанными.Загрузка = Истина;
		УзелОбъект.Записать();
	КонецЕсли;
	
	Узел = УзелЦентральнойБазы("МобильноеПриложение");
	Если Узел.Код <> НовыйКод Тогда
		УзелОбъект = Узел.ПолучитьОбъект();	
		УзелОбъект.Код = НовыйКод;
		УзелОбъект.ОбменДанными.Загрузка = Истина;
		УзелОбъект.Записать();
	КонецЕсли;
	
КонецПроцедуры
 

// Возвращает ссылку на этот узел указанного плана обмена
//
//Параметры:
//	ИмяПланаОбмена - наименование плана обмена, в котором нужно найти узел ЦБ.
//					по умолчанию используется "СинхронизацияАвтономныхКопий"
//
//Возвращаемое значение:
//	Строка
//
Функция ЭтотУзел(ИмяПланаОбмена = "СинхронизацияАвтономныхКопий") Экспорт

	МенеджерПланаОбмена = ПланыОбмена[ИмяПланаОбмена];
	Результат = МенеджерПланаОбмена.ЭтотУзел();
	Если СтрДлина(СокрП(Результат.Код)) < 30 Тогда
		Если ЭтоЦентральнаяБаза() Тогда
			ИмяУзла = НСтр("ru='Центральная база'"); 
		Иначе
			ИмяУзла = НСтр("ru='Эта информационная база'"); 
		КонецЕсли;
		ОбновитьИнформациюЭтогоУзла(Результат, ИмяУзла);
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

// Возвращает код центральной базы
//
//Параметры:
//	ИмяПланаОбмена - наименование плана обмена, в котором нужно найти узел ЦБ.
//					по умолчанию используется "СинхронизацияАвтономныхКопий"
//
//Возвращаемое значение:
//	Строка
//
Функция КодЭтогоУзла(ИмяПланаОбмена = "СинхронизацияАвтономныхКопий") Экспорт

	Возврат СокрЛП(ЭтотУзел(ИмяПланаОбмена).Код);

КонецФункции

// Определяет, является текущая база центральной по отношении к другим базам
//
//Параметры:
//	нет
//
//Возвращаемое значение:
//	Булево
//
Функция ЭтоЦентральнаяБаза() Экспорт

	Возврат ОбщегоНазначения.РазделениеВключено() 
		Или ДеньгиВызовСервераПовтИсп.РежимИспользованияПриложения() = "ЦентрМобильных";

КонецФункции

// Определяет, является текущая база автономной копией базы в облаке
//
//Параметры:
//	нет
//
//Возвращаемое значение:
//	Булево
//
Функция ЭтоАвтономнаяКопия() Экспорт
	
	Возврат Не ОбщегоНазначения.РазделениеВключено() 
		И ДеньгиВызовСервераПовтИсп.РежимИспользованияПриложения() = "КлиентОблака";
	
КонецФункции

// Определяет, является ли мобильным приложением узел с указаннмы кодом
//
//Параметры:
//	КодУзла - строка - код проверяемого узда плана обмена "СинхронизацияАвтономныхКопий"
//
//Возвращаемое значение:
//	Булево - Истина, если узел является мобильным приложением
//
Функция ЭтоМобильноеПриложение(ИмяПланаОбмена, КодУзла) Экспорт
	
	Если НРег(ИмяПланаОбмена) = "мобильноеприложение" Тогда
		Возврат Истина;
	КонецЕсли;
	
	Узел = СинхронизацияАвтономныхКопий.УзелПланаОбменаПоКоду(ИмяПланаОбмена, КодУзла, Ложь);
	Если Не ЗначениеЗаполнено(Узел) Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru='Нет узла с кодом ""%1"" в пдане обмена %2'"), КодУзла, ИмяПланаОбмена);
	КонецЕсли;
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Узел, "МобильноеУстройство", Ложь);
	
КонецФункции 

// Записывает информацию об ошибке в журнал регистрации и отмечает результат обмена в регистре сведений КонтрольОбменаДанными
//
//Параметры:
//	Ошибка - Строка или ИнформацияОбОшибке - то, что нужно зафиксировать
//	Узел - ПланОбменаСсылка - узел, при обмене с которым произошла ошибка
//	ДействиеПриОбмене - Строка - "ЗагрузкаДанных" или "ВыгрузкаДанных"
//	ОписаниеПроблемы - Строка - выходной параметр - сюда помещается подготовленное описание проблемы
//
Процедура ЗарегистрироватьОшибкуОбменаСУзлом(Ошибка, Узел, ДействиеПриОбмене, ОписаниеПроблемы = "") Экспорт
	Перем НачалоТекстаОшибки, ПредставлениеОшибки, ПодробностиОшибки;
	
	// Формирование представления ошибки
	Если ДействиеПриОбмене = "ЗагрузкаДанных" Тогда
		НачалоТекстаОшибки = НСтр("ru = 'Ошибка загрузки данных от %1'");
		ДействиеСсылка = Перечисления.ДействияПриОбмене.ЗагрузкаДанных;
	ИначеЕсли ДействиеПриОбмене = "ВыгрузкаДанных" Тогда
		НачалоТекстаОшибки = НСтр("ru = 'Ошибка отправки данных на %1'");
		ДействиеСсылка = Перечисления.ДействияПриОбмене.ВыгрузкаДанных;
	Иначе
		НачалоТекстаОшибки = НСтр("ru = 'Ошибка обмена данными с %1'");
		ДействиеСсылка = Перечисления.ДействияПриОбмене.ПустаяСсылка();
	КонецЕсли;
	НачалоТекстаОшибки = СтрШаблон(НачалоТекстаОшибки, ?(ЗначениеЗаполнено(Узел), """" + Узел + """", НСтр("ru='<неизвестный узел>'")));
	
	Если ТипЗнч(Ошибка) = Тип("ИнформацияОбОшибке") Тогда
		ПредставлениеОшибки = НачалоТекстаОшибки + Символы.ПС + КраткоеПредставлениеОшибки(Ошибка);
		ПодробностиОшибки = ПодробноеПредставлениеОшибки(Ошибка);
	Иначе
		ПредставлениеОшибки = НачалоТекстаОшибки + Символы.ПС +  Ошибка;
		ПодробностиОшибки = "";
	КонецЕсли; 
	
	ОписаниеПроблемы = ПредставлениеОшибки + ?(ПодробностиОшибки = "", "", Символы.ПС) + ПодробностиОшибки;
	
	Если ЗначениеЗаполнено(Узел) Тогда
		// отметка в регистре сведений
		Если ДействиеПриОбмене = "ЗагрузкаДанных" Тогда
			РегистрыСведений.КонтрольОбменаДанными.ОтметитьРезультатПолученияДанных(Узел, ПредставлениеОшибки);
		ИначеЕсли ДействиеПриОбмене = "ВыгрузкаДанных" Тогда
			РегистрыСведений.КонтрольОбменаДанными.ОтметитьРезультатОтправкиДанных(Узел, ПредставлениеОшибки);
		КонецЕсли;
	КонецЕсли;
	
	// запись журнала регистрации
	ЗаписьЖурналаРегистрации(КлючСообщенияОбмена(ДействиеСсылка, Узел), 
		УровеньЖурналаРегистрации.Ошибка,
		,
		,
		ОписаниеПроблемы); 
		
	// Запись в регистре БСП
	Если ЗначениеЗаполнено(ДействиеСсылка) И ЗначениеЗаполнено(Узел)
		И Не ОбщегоНазначения.РазделениеВключено() Тогда
		
		ЗаписьОтметки = Новый Структура;
		ЗаписьОтметки.Вставить("УзелИнформационнойБазы", Узел);
		ЗаписьОтметки.Вставить("ДействиеПриОбмене", ДействиеСсылка);
		ЗаписьОтметки.Вставить("РезультатВыполненияОбмена", Перечисления.РезультатыВыполненияОбмена.Ошибка);
		ЗаписьОтметки.Вставить("ДатаОкончания", ТекущаяДатаСеанса());
		
		РегистрыСведений.СостоянияОбменовДанными.ДобавитьЗапись(ЗаписьОтметки);
		
	КонецЕсли;
	
КонецПроцедуры


// Определяет необходимость сжатия файла при обмене
//
//Параметры:
//	ИмяПланаОбмена - Строка - Наименование плана обмена
//	КодУзла - Строка - код узла обмена информационной базы
//
//Возвращаемое значение:
//	Булево - Истина, если файлы сообщения нужно сжимать
//
Функция ИспользоватьСжатиеФайлаДляУзла(ИмяПланаОбмена, КодУзла) Экспорт
	
	Если НРег(ИмяПланаОбмена) = "мобильноеприложение" Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Попытка
		ОбменСМобильным = ЭтоМобильноеПриложение(ИмяПланаОбмена, КодУзла);
	Исключение
		Возврат Ложь;
	КонецПопытки; 
	
	Возврат Не ОбменСМобильным;
	
КонецФункции 

// Проверяет возможность выполнить указанную операцию, 
//	Вызывает исключение в случае недоступности услуги
//
//Параметры:
//	ДейсвтиеПриОбмене - ПеречсилениеСсылка.ДействияПриОбмене
//
Процедура ПроверитьДоступностьОбмена(Узел, ДейсвтиеПриОбмене) Экспорт
	
	ИмяПланаОбмена = Узел.Метаданные().Имя;
	
	Если ЭтоЦентральнаяБаза() Тогда
		
		УзелЦБ = ПланыОбмена[ИмяПланаОбмена].ЭтотУзел();
		Попытка
			УзелОбъект = УзелЦБ.ПолучитьОбъект();
			УзелОбъект.Заблокировать();
		Исключение
			ВызватьИсключение НСтр("ru='На сервере выполняется перезапись данных. Повторите попытку позже'");;
		КонецПопытки; 
		УзелОбъект.Разблокировать();
		
	КонецЕсли;
	
	Если ДеньгиВызовСервераПовтИсп.РежимИспользованияПриложения() <> "Разделенный" Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ФункционалКонфигурацииДеньги.ОбменСЦентральнойБазой") Тогда
		
		Модуль = ОбщегоНазначения.ОбщийМодуль("ДеньгиОбменСЦентральнойБазой");
		Модуль.ПроверитьДоступностьОбменаНаСервере(Узел, ДейсвтиеПриОбмене, ИмяПланаОбмена);
		
	КонецЕсли;
	
	
КонецПроцедуры


#КонецОбласти


#Область СлужебныйПрограммныйИнтерфейс


// Возвращает ключ сообщения в журнал регистрации для указанного в параметрах узла
//	с учетом пустого значения
Функция КлючСообщенияОбмена(Знач ДействиеПриОбмене, Узел = Неопределено) Экспорт

	Если ТипЗнч(ДействиеПриОбмене) = Тип("Строка") Тогда
		ДействиеПриОбмене = Перечисления.ДействияПриОбмене[ДействиеПриОбмене];
	КонецЕсли;
	
	Если Узел = Неопределено Тогда
		Возврат "Обмен данными.Синхронизация автономных копий." + ДействиеПриОбмене;
	Иначе
		Возврат ОбменДаннымиСервер.КлючСообщенияЖурналаРегистрации(Узел, ДействиеПриОбмене);
	КонецЕсли;
	
КонецФункции


#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура ОбновитьИнформациюЭтогоУзла(Узел, ИмяПоУмолчанию) 
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ОблачныеСервисыДенег") Тогда
		
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОСДБиллинг");
		Модуль.ОбновитьИнформациюЭтогоУзла(Узел, ИмяПоУмолчанию);
		
	Иначе
		
		УзелОбъект = Узел.ПолучнитьОбъект();
		УзелОбъект.Код          = СтандартныеПодсистемыСервер.ИдентификаторИнформационнойБазы();
		УзелОбъект.Наименование = ИмяПоУмолчанию;
		Если Не ЗначениеЗаполнено(УзелОбъект.ВерсияФорматаОбмена) Тогда
			УзелОбъект.ВерсияФорматаОбмена = СинхронизацияАвтономныхКопийКлиентСервер.ТекущаяВерсияФормата();
		КонецЕсли;
		УзелОбъект.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

Функция НовыйУзелПланаОбмена(ИмяПланаОбмена, КодУзла, ИмяУзла) 

	МенеджерПланаОбмена = ПланыОбмена[ИмяПланаОбмена];
	УзелОбъект = МенеджерПланаОбмена.СоздатьУзел();
	УзелОбъект.Заполнить(Неопределено);
	УзелОбъект.Код          = КодУзла;
	УзелОбъект.Наименование = ИмяУзла;
	УзелОбъект.Активность   = Истина;
	УзелОбъект.Записать();
	Возврат УзелОбъект.Ссылка;

КонецФункции

#КонецОбласти