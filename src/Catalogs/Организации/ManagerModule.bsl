#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Использование нескольких организаций

// Возвращает организацию по умолчанию.
// Если в ИБ есть только одна организация, которая не помечена на удаление и не является предопределенной,
// то будет возвращена ссылка на нее, иначе будет возвращена пустая ссылка.
//
// Возвращаемое значение:
//     СправочникСсылка.Организации - ссылка на организацию
//
Функция ОрганизацияПоУмолчанию() Экспорт
	
	Организация = Справочники.Организации.ПустаяСсылка();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	Организации.Ссылка КАК Организация
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	НЕ Организации.ПометкаУдаления
	|	И НЕ Организации.Предопределенный";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() И Выборка.Количество() = 1 Тогда
		Организация = Выборка.Организация;
	КонецЕсли;
	
	Возврат Организация;

КонецФункции

// Возвращает количество элементов справочника Организации.
// Не учитывает предопределенные и помеченные на удаление элементы.
//
// Возвращаемое значение:
//     Число - количество организаций
//
Функция КоличествоОрганизаций() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Количество = 0;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(*) КАК Количество
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	НЕ Организации.Предопределенный";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Количество = Выборка.Количество;
	КонецЕсли;
	
	Возврат Количество;
	
КонецФункции

// Возвращает таблицу классификатора ОКВЭД2.
//
// Параметры:
//  ТолькоДоступныеДляВыбора - Булево - В таблицу будут включены только те строки, которые можно выбрать для вида деятельности организации.
// 
// Возвращаемое значение:
//  Таблица - Таблица классификатора ОКВЭД2.
//
Функция КлассификаторОКВЭД2(ТолькоДоступныеДляВыбора = Ложь) Экспорт
	
	КлассификаторОКВЭД2 = НовыйТаблицаДляПоискаОКВЭД();
	// Если выбираются только доступные для выбора,
	// то добавлять отдельную колонку "ДоступенДляВыбора" не имеет смысла,
	// т.к. все строки в результате будут доступны для выбора.
	Если НЕ ТолькоДоступныеДляВыбора Тогда
		КлассификаторОКВЭД2.Колонки.Добавить("ДоступенДляВыбора", Новый ОписаниеТипов("Булево"));
	КонецЕсли;
	
	Макет = ПолучитьМакет("ОКВЭД2");
	
	ТекущаяОбласть = Макет.Области.Найти("Классификатор");
	
	Если НЕ ТекущаяОбласть = Неопределено Тогда
		
		Для НомерСтр = ТекущаяОбласть.Верх По ТекущаяОбласть.Низ Цикл
			
			КодПоказателя = СокрП(Макет.Область(НомерСтр, 1).Текст);
			Название      = СокрП(Макет.Область(НомерСтр, 2).Текст);
			
			Если КодПоказателя = "###" Тогда
				Прервать;
			ИначеЕсли ПустаяСтрока(КодПоказателя) Тогда
				Продолжить;
			Иначе
				
				ДоступенДляВыбора = КодОКВЭД2ДоступенДляВыбора(КодПоказателя);
				Если ТолькоДоступныеДляВыбора
					И НЕ ДоступенДляВыбора Тогда
					Продолжить;
				КонецЕсли;
				
				НоваяСтрока = КлассификаторОКВЭД2.Добавить();
				НоваяСтрока.Код                 = КодПоказателя;
				НоваяСтрока.Наименование        = Название;
				НоваяСтрока.ПредставлениеПоиска = ВРЕГ(КодПоказателя + " " + Название);
				Если НЕ ТолькоДоступныеДляВыбора Тогда
					НоваяСтрока.ДоступенДляВыбора = ДоступенДляВыбора;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат КлассификаторОКВЭД2;
	
КонецФункции

// Возвращает пустую таблицу для поиска в классификаторе ОКВЭД2.
//
Функция НовыйТаблицаДляПоискаОКВЭД() Экспорт
	
	Схема = Справочники.Организации.ПолучитьМакет("ОтборОКВЭД");
	
	ТаблицаДляОтбораОКВЭД = Новый ТаблицаЗначений();
	
	Для Каждого Поле Из Схема.НаборыДанных.ОКВЭД.Поля Цикл
		ТаблицаДляОтбораОКВЭД.Колонки.Добавить(Поле.Поле, Поле.ТипЗначения);
	КонецЦикла;
	
	Возврат ТаблицаДляОтбораОКВЭД;
	
КонецФункции

// Возвращает таблицу ОКВЭД2 с наложенным фильтром по СтрокаПоиска.
// Строка классификатора ОКВЭД включается в результат, если содержит все слова из СтрокаПоиска.
// 
// Параметры:
//  СтрокаПоиска         - Строка - Фильтр для отбора строк классификатора ОКВЭД2.
//  СписокВыбранныхКодов - СписокЗначений - Список, который содержит значения выбранных кодов ОКВЭД.
//  КлассификаторОКВЭД   - ТаблицаЗначений - Таблица классификатора ОКВЭД2. Структуру см. в НовыйТаблицаДляПоискаОКВЭД().
// 
// Возвращаемое значение:
//  Таблица - Таблица классификатора ОКВЭД2 с наложенным отбором по СтрокаПоиска с колонками:
//    - Код          - Строка - Код из классификатора ОКВЭД2
//    - Наименование - Строка - Наименование из классификатора ОКВЭД2
//    - Выбран       - Булево - Истина, если код содержится в СписокВыбранныхКодов.
//
Функция НайтиВКлассификатореОКВЭД2(СтрокаПоиска, СписокВыбранныхКодов, КлассификаторОКВЭД) Экспорт
	
	СхемаКомпоновки = Справочники.Организации.ПолучитьМакет("ОтборОКВЭД");
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновки));
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновки.НастройкиПоУмолчанию);
	
	УстановитьПараметр(КомпоновщикНастроек, "ВыбранныеОКВЭД", СписокВыбранныхКодов);
	
	Отбор = КомпоновщикНастроек.Настройки.Отбор;
	Слова = СтрРазделить(ВРег(СтрЗаменить(СтрокаПоиска, """", "")), " ", Ложь);
	Для Каждого Слово ИЗ Слова Цикл
		ДобавитьОтбор(Отбор, "ПредставлениеПоиска", СокрЛП(Слово), ВидСравненияКомпоновкиДанных.Содержит);
	КонецЦикла;
	
	НастройкиДляКомпоновкиМакета = КомпоновщикНастроек.ПолучитьНастройки();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновки, НастройкиДляКомпоновкиМакета, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ВнешниеНаборы = Новый Структура("ТаблицаОКВЭД", КлассификаторОКВЭД);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборы);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	РезультатЗапроса = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	Возврат РезультатЗапроса;
	
КонецФункции

// Выполняет поиск организации по ИНН и КПП (если указан).
//
// Параметры:
//   ИНН - Строка - ИНН организации или индивидуального предпринимателя.
//   КПП - Строка - КПП организации.
//   БезОбособленныхПодразделений - Булево - исключает из поиска обособленные подразделения.
//
// Возвращаемое значение:
//   СправочникСсылка.Организации - ссылка на найденную организацию или ПустаяСсылка.
//
Функция НайтиОрганизацию(ИНН, КПП = Неопределено, БезОбособленныхПодразделений = Истина) Экспорт
	
	Если ПустаяСтрока(ИНН) Тогда
		Возврат ПустаяСсылка();
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ИНН", ИНН);
	Запрос.УстановитьПараметр("КПП", КПП);
	
	ТекстЗапроса =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Организации.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Организации КАК Организации";
	
	СхемаЗапроса = Новый СхемаЗапроса;
	СхемаЗапроса.УстановитьТекстЗапроса(ТекстЗапроса);
	
	ОператорыЗапроса = СхемаЗапроса.ПакетЗапросов[0].Операторы[0];
	ОператорыЗапроса.Отбор.Добавить("Организации.ИНН = &ИНН");
	
	Если КПП <> Неопределено И Не ПустаяСтрока(КПП) Тогда
		ОператорыЗапроса.Отбор.Добавить("Организации.КПП = &КПП");
	КонецЕсли;
	
	Если БезОбособленныхПодразделений Тогда
		ОператорыЗапроса.Отбор.Добавить("НЕ Организации.ОбособленноеПодразделение");
	КонецЕсли;
	
	ОператорыЗапроса.Отбор.Добавить("НЕ Организации.ПометкаУдаления");
	
	Запрос.Текст = СхемаЗапроса.ПолучитьТекстЗапроса();
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

#КонецОбласти

Функция ПолучитьПараметрыФормыВыбораДляКода(НазваниеМакета, ТекущийПериод) Экспорт
	
	Классификатор = Новый ТаблицаЗначений;
	
	Классификатор.Колонки.Добавить("Код");
	Классификатор.Колонки.Добавить("Наименование");
	Классификатор.Индексы.Добавить("Код");
	
	Макет	= ПолучитьМакет(НазваниеМакета);
	
	ТекущаяОбласть = Макет.Области.Найти("Классификатор");
	
	Если НЕ ТекущаяОбласть = Неопределено Тогда
		
		Для НомерСтр = ТекущаяОбласть.Верх По ТекущаяОбласть.Низ Цикл
			
			КодПоказателя	= СокрП(Макет.Область(НомерСтр, 1).Текст);
			Название		= СокрП(Макет.Область(НомерСтр, 2).Текст);
			
			Если КодПоказателя = "###" Тогда
				Прервать;
			ИначеЕсли ПустаяСтрока(КодПоказателя) Тогда
				Продолжить;
			Иначе
				НоваяСтрока = Классификатор.Добавить();
				НоваяСтрока.Код				= КодПоказателя;
				НоваяСтрока.Наименование	= Название;
			КонецЕсли;	
				
		КонецЦикла;
		
	КонецЕсли;
	
	Параметры = Новый Структура;
	Параметры.Вставить("СписокКодов",	Классификатор);
	
	Возврат Параметры;
	
КонецФункции

Функция КодОКВЭД2ДоступенДляВыбора(Код)
	
	КоличествоЦифрВКоде = СтрДлина(СтрЗаменить(Код, ".", ""));
	Возврат КоличествоЦифрВКоде >= 4;
	
КонецФункции

// Возвращает список реквизитов, которые не нужно редактировать
// с помощью обработки группового изменения объектов
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	МассивРеквизитов = Новый Массив();
	МассивРеквизитов.Добавить("УдалитьЮрФизЛицо");
	МассивРеквизитов.Добавить("УдалитьКодИФНС");
	МассивРеквизитов.Добавить("УдалитьТерриториальныеУсловияПФР");
	МассивРеквизитов.Добавить("УдалитьРайонныйКоэффициентРФ");
	Возврат МассивРеквизитов;
	
КонецФункции

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет код территории по классификатору ОКТМО или ОКАТО, на которой зарегистрирована организация.
//
// Параметры:
//  Организация	 - СправочникСсылка.Организации
//  ТипКода		 - Строка - "ОКТМО" или "ОКАТО"
//               - Дата - с даты применения ОКТМО будет возвращен код по ОКТМО, в остальных случаях - код по ОКАТО
// 
// Возвращаемое значение:
//  Строка - код территории
//
Функция КодТерриторииМестаРегистрации(Организация, ТипКода = "ОКТМО") Экспорт
	
	РегистрацияВНалоговомОргане = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "РегистрацияВНалоговомОргане");
	
	Возврат Справочники.РегистрацииВНалоговомОргане.КодТерритории(РегистрацияВНалоговомОргане, ТипКода);
	
КонецФункции

// Возвращает наименование по умолчанию, присваиваемое при программногом 
// создании организации без заполнения реквизитов.
//
// Возвращаемое значение:
//     Строка - Наименование по умолчанию.
Функция НаименованиеПоУмолчанию() Экспорт
	
	Возврат НСтр("ru='Наша организация'", Метаданные.ОсновнойЯзык.КодЯзыка);
	
КонецФункции


#КонецЕсли

#Область СлужебныйПрограммныйИнтерфейс

// Вызывается при переходе на версию БСП 2.2.1.12
//
Процедура ЗаполнитьКонстантуИспользоватьНесколькоОрганизаций() Экспорт
	
	// ДЕНЬГИ
	//Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") =
	//		ПолучитьФункциональнуюОпцию("НеИспользоватьНесколькоОрганизаций") Тогда
	//	// Опции должны иметь противоположные значения.
	//	// Если это не так, то значит в ИБ раньше не было этих опций - инициализируем их значения.
	//	Константы.ИспользоватьНесколькоОрганизаций.Установить(КоличествоОрганизаций() > 1);
	//КонецЕсли;
	// Конец ДЕНЬГИ
	
КонецПроцедуры

#КонецОбласти



// Возвращает значение параметра компоновки данных.
//
// Параметры:
//  Настройки - НастройкиКомпоновкиДанных, ПользовательскиеНастройкиКомпоновкиДанных, КомпоновщикНастроекКомпоновкиДанных, 
//              КоллекцияЗначенийПараметровКомпоновкиДанных, ОформлениеКомпоновкиДанных - 
//              Настройки, в которых происходит поиск параметра. Не поддерживает тип ДанныеРасшифровкиКомпоновкиДанных.
//  Параметр - Строка, ПараметрКомпоновкиДанных - Имя параметра СКД, для которого нужно вернуть значение параметра.
//
// Возвращаемое значение:
//	ПараметрКомпоновкиДанных, ЗначениеПараметраНастроекКомпоновкиДанных - Искомый параметр.
//	
Функция ПолучитьПараметр(Настройки, Параметр) Экспорт
	
	ЗначениеПараметра = Неопределено;
	ПолеПараметр = ?(ТипЗнч(Параметр) = Тип("Строка"), Новый ПараметрКомпоновкиДанных(Параметр), Параметр);
	
	Если ТипЗнч(Настройки) = Тип("НастройкиКомпоновкиДанных") Тогда
		ЗначениеПараметра = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(ПолеПараметр);
	ИначеЕсли ТипЗнч(Настройки) = Тип("ПользовательскиеНастройкиКомпоновкиДанных") Тогда
		Для Каждого ЭлементНастройки Из Настройки.Элементы Цикл
			Если ТипЗнч(ЭлементНастройки) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") И ЭлементНастройки.Параметр = ПолеПараметр Тогда
				ЗначениеПараметра = ЭлементНастройки;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли ТипЗнч(Настройки) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		Для Каждого ЭлементНастройки Из Настройки.ПользовательскиеНастройки.Элементы Цикл
			Если ТипЗнч(ЭлементНастройки) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") И ЭлементНастройки.Параметр = ПолеПараметр Тогда
				ЗначениеПараметра = ЭлементНастройки;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если ЗначениеПараметра = Неопределено Тогда
			ЗначениеПараметра = Настройки.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(ПолеПараметр);
		КонецЕсли;
	ИначеЕсли ТипЗнч(Настройки) = Тип("КоллекцияЗначенийПараметровКомпоновкиДанных") Тогда
		ЗначениеПараметра = Настройки.Найти(ПолеПараметр);
	ИначеЕсли ТипЗнч(Настройки) = Тип("ОформлениеКомпоновкиДанных") Тогда
		ЗначениеПараметра = Настройки.НайтиЗначениеПараметра(ПолеПараметр);
	КонецЕсли;
	
	Возврат ЗначениеПараметра;
	
КонецФункции

// Устанавливает значение параметра компоновки данных.
//
// Параметры:
//  Настройки - НастройкиКомпоновкиДанных, ПользовательскиеНастройкиКомпоновкиДанных, КомпоновщикНастроекКомпоновкиДанных, 
//              КоллекцияЗначенийПараметровКомпоновкиДанных, ОформлениеКомпоновкиДанных - Настройки, 
//              в которых происходит поиск параметра. 
//	Параметр - Строка, ПараметрКомпоновкиДанных - Имя параметра СКД, для которого нужно установить значение параметра.
//  Значение - Произвольный - Значение параметра.
//	Использование - Булево - Признак использования параметра. По умолчанию всегда принимается равным истине.
//
// Возвращаемое значение:
//	ПараметрКомпоновкиДанных, ЗначениеПараметраНастроекКомпоновкиДанных - Параметр, для которого установлено значение.
//
Функция УстановитьПараметр(Настройки, Параметр, Значение, Использование = Истина) Экспорт
	
	ЗначениеПараметра = ПолучитьПараметр(Настройки, Параметр);
	
	Если ЗначениеПараметра <> Неопределено Тогда
		ЗначениеПараметра.Использование = Использование;
		ЗначениеПараметра.Значение      = Значение;
	КонецЕсли;
	
	Возврат ЗначениеПараметра;
	
КонецФункции

// Возвращает элемент структуры настроек компоновки данных содержащий поле группировки с указанным именем.
// Поиск осуществляется по указанной структуре и все ее подчиненным структурам.
// В случае неудачи возвращает Неопределено.
//
// Параметры:
//   СтруктураГруппировки - ГруппировкаТаблицыКомпоновкиДанных, ГруппировкаКомпоновкиДанных, 
//               КоллекцияЭлементовСтруктурыТаблицыКомпоновкиДанных - элемент структуры компоновки данных.
//   ИмяПоля - Строка - Имя поля группировки.
//
// Возвращаемое значение:
//   ГруппировкаТаблицыКомпоновкиДанных, ГруппировкаКомпоновкиДанных, Неопределено.
//
Функция НайтиГруппировку(СтруктураГруппировки, ИмяПоля) Экспорт
	
	Для каждого Элемент Из СтруктураГруппировки Цикл
		
		Для каждого Поле Из Элемент.ПоляГруппировки.Элементы Цикл
			Если Не ТипЗнч(Поле) = Тип("АвтоПолеГруппировкиКомпоновкиДанных") Тогда
				Если Поле.Поле = Новый ПолеКомпоновкиДанных(ИмяПоля) Тогда
					Возврат Элемент;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		Если Элемент.Структура.Количество() = 0 Тогда
			Возврат Неопределено;
		Иначе
			Группировка = НайтиГруппировку(Элемент.Структура, ИмяПоля);
		КонецЕсли;
	КонецЦикла;
	Возврат Группировка;
	
КонецФункции

// Добавляет отбор в коллекцию отборов компоновщика или группы отборов.
//
// Параметры:
//	ЭлементСтруктуры - КомпоновщикНастроекКомпоновкиДанных, НастройкиКомпоновкиДанных, 
//                     ОтборКомпоновкиДанных - Элемент структуры.
//	Поле - Строка - имя поля, по которому добавляется отбор.
//	Значение - Произвольный - Значение отбора.
//	ВидСравнения - ВидСравненияКомпоновкиДанных - Вид сравнений компоновки данных (по умолчанию: Равно).
//	Использование - Булево - Признак использования отбора (по умолчанию: Истина).
//
// Возвращаемое значение:
//	ЭлементОтбораКомпоновкиДанных - Добавленный элемент отбора.
//
Функция ДобавитьОтбор(ЭлементСтруктуры, Знач Поле, Значение = Неопределено, ВидСравнения = Неопределено, Использование = Истина, ВПользовательскиеНастройки = Ложь) Экспорт
	
	Если ТипЗнч(Поле) = Тип("Строка") Тогда
		Поле = Новый ПолеКомпоновкиДанных(Поле);
	КонецЕсли;
	
	Если ТипЗнч(ЭлементСтруктуры) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		Отбор = ЭлементСтруктуры.Настройки.Отбор;
		
		Если ВПользовательскиеНастройки Тогда
			Для Каждого ЭлементНастройки Из ЭлементСтруктуры.ПользовательскиеНастройки.Элементы Цикл	
				Если ЭлементНастройки.ИдентификаторПользовательскойНастройки = ЭлементСтруктуры.Настройки.Отбор.ИдентификаторПользовательскойНастройки Тогда
					Отбор = ЭлементНастройки;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	ИначеЕсли ТипЗнч(ЭлементСтруктуры) = Тип("НастройкиКомпоновкиДанных") Тогда
		Отбор = ЭлементСтруктуры.Отбор;
	Иначе
		Отбор = ЭлементСтруктуры;
	КонецЕсли;
		
	Если ВидСравнения = Неопределено Тогда
		ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	КонецЕсли;
	
	ЗначениеОтбораКомпоновки = Значение;
	// Механизмы компоновки в качестве списка принимают СписокЗначений,
	// но не более очевидную коллекцию - Массив.
	ТипЗначенияОтбора = ТипЗнч(Значение);
	Если ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке
		Или ВидСравнения = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии
		Или ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке
		Или ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСпискеПоИерархии Тогда
		
		Если ТипЗначенияОтбора = Тип("Массив") Тогда
			ЗначениеОтбораКомпоновки = Новый СписокЗначений;
			ЗначениеОтбораКомпоновки.ЗагрузитьЗначения(Значение);
		ИначеЕсли ТипЗначенияОтбора = Тип("ФиксированныйМассив") Тогда
			ЗначениеОтбораКомпоновки = Новый СписокЗначений;
			ЗначениеОтбораКомпоновки.ЗагрузитьЗначения(Новый Массив(Значение));
		КонецЕсли;
		
	КонецЕсли;
	
	НовыйЭлемент = Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	НовыйЭлемент.Использование  = Использование;
	НовыйЭлемент.ЛевоеЗначение  = Поле;
	НовыйЭлемент.ВидСравнения   = ВидСравнения;
	НовыйЭлемент.ПравоеЗначение = ЗначениеОтбораКомпоновки;
	
	Возврат НовыйЭлемент;
	
КонецФункции

