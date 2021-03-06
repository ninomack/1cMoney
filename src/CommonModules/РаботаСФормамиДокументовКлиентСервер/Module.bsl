////////////////////////////////////////////////////////////////////////////////
// РаботаСФормамиДокументовКлиентСервер: обслуживание форм документов
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс


// Добавляет к наименованию операции сведения о ее состоянии
Процедура ОбновитьСостояниеОперации(Форма) Экспорт

	Объект = Форма.Объект;
	ТекстСостояния = "";
	
	Если Объект.ЭтоШаблон Тогда
		
		Если Объект.ПометкаУдаления Тогда
			ТекстСостояния = НСтр("ru = 'Шаблон помечен на удаление'");
		Иначе
			ТекстСостояния = НСтр("ru = 'Шаблон'");
		КонецЕсли; 
		
	ИначеЕсли НЕ Объект.Ссылка.Пустая() Тогда
		
		Если Объект.ПометкаУдаления Тогда
			ТекстСостояния = НСтр("ru = 'Удалить'");
		ИначеЕсли НЕ Объект.Проведен Тогда
			ТекстСостояния = НСтр("ru = 'Черновик'");
		КонецЕсли; 
		
	КонецЕсли; 
	
	Форма.Заголовок = ТекстСостояния;
	
КонецПроцедуры

// Устанавливает видимость/доступность/заголовки элементов формы, зависящих от 
//	состояния операции и значения реквизита "ЭтоШаблон"
//
//Параметры:
//	Форма - УправляемаяФорма - форма документа
//
Процедура ОбновитьЭлементыФормыПоСостояниюОперации(Форма) Экспорт
	
	Объект    = Форма.Объект;
	Элементы  = Форма.Элементы;
	
	// Обновляем заголовок формы
	ТекстСостояния = "";
	
	Если Объект.ЭтоШаблон Тогда
		
		Если Объект.ПометкаУдаления Тогда
			ТекстСостояния = НСтр("ru = 'Шаблон помечен на удаление'");
		Иначе
			ТекстСостояния = НСтр("ru = 'Шаблон'");
		КонецЕсли; 
		
	ИначеЕсли НЕ Объект.Ссылка.Пустая() Тогда
		
		Если Объект.ПометкаУдаления Тогда
			ТекстСостояния = НСтр("ru = 'Удалить'");
		ИначеЕсли НЕ Объект.Проведен Тогда
			ТекстСостояния = НСтр("ru = 'Черновик'");
		КонецЕсли; 
		
	КонецЕсли; 
	
	Форма.Заголовок = ТекстСостояния;
	
	// Устанавливаем доступность и заголовки команд в соответствии с состоянием операции
	Форма.ТолькоПросмотр = Объект.ПометкаУдаления;
	Элементы.ФормаУстановитьПометкуУдаления.Доступность = Не Форма.ТолькоПросмотр;
	Если Элементы.Найти("НастройкаКолонокАналитики") <> Неопределено Тогда
		Элементы.НастройкаКолонокАналитики.Доступность = Не Форма.ТолькоПросмотр;
	КонецЕсли;
	
	ОбновитьЗаголовкиКомандФормы(Форма);
	
КонецПроцедуры

// Устанавливает заголовки команд в форме документа в зависимости от его состояния и отношения к плановым операциям
//
Процедура ОбновитьЗаголовкиКомандФормы(Форма) Экспорт
	
	Объект    = Форма.Объект;
	Элементы  = Форма.Элементы;
	
	Если Объект.ПометкаУдаления Тогда
		
		Элементы.ФормаПровестиИЗакрыть.Видимость          = Ложь;
		Элементы.ФормаЗаписать.Заголовок                  = НСтр("ru='Снять пометку удаления'");
		Элементы.ФормаГруппаКнопкиУчетаОперации.Видимость = Ложь;
		
		
	ИначеЕсли Объект.ЭтоШаблон Тогда
		
		Элементы.ФормаПровестиИЗакрыть.Видимость          = Ложь;
		Элементы.ФормаЗаписать.Заголовок                  = НСтр("ru='Записать'");
		Элементы.ФормаГруппаКнопкиУчетаОперации.Видимость = Ложь;
		
	Иначе
		
		Элементы.ФормаПровестиИЗакрыть.Видимость = Истина;
		ТекДата = КонецДня(ДеньгиКлиентСервер.ЗначениеТекущейДаты());
		
		Если Объект.Дата > ТекДата Тогда
			
			Элементы.ФормаЗаписать.Заголовок = НСтр("ru='Запланировать'");
			Элементы.ФормаЗаписать.КнопкаПоУмолчанию         = Истина;
			Элементы.ФормаПровестиИЗакрыть.КнопкаПоУмолчанию = Ложь;
			
		Иначе
			
			Элементы.ФормаЗаписать.Заголовок = НСтр("ru='В черновики'");
			Если Не Элементы.ФормаПровестиИЗакрыть.КнопкаПоУмолчанию Тогда
				Элементы.ФормаЗаписать.КнопкаПоУмолчанию         = Ложь;
				Элементы.ФормаПровестиИЗакрыть.КнопкаПоУмолчанию = Истина;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Заменяет названия стандартных команд формы документа
Процедура ПереименоватьКнопкиИПанелиФормыДокумента(Форма) Экспорт

	Объект     = Форма.Объект;
	Элементы   = Форма.Элементы;
	Команды    = Форма.Команды;
	
	Если Объект.ЭтоШаблон Тогда
		
		ПереименоватьЭлементФормы(Элементы, "ФормаОбщаяКомандаСоздатьШаблонОперации", НСтр("ru = 'Создать операцию'")); 
		
		СтруктураСвойств = Новый Структура("Заголовок, Отображение");
		СтруктураСвойств.Отображение = ОтображениеКнопки.КартинкаИТекст;
		
		СтруктураСвойств.Заголовок = НСтр("ru = 'Записать и закрыть'");
		ИзменитьСвойстваЭлементаФормы(Элементы, "ФормаПровестиИЗакрыть", СтруктураСвойств);
		
		СтруктураСвойств.Заголовок = НСтр("ru = 'Записать'");
		ИзменитьСвойстваЭлементаФормы(Элементы, "ФормаЗаписать", СтруктураСвойств);
		
		СтруктураСвойств = Новый Структура("Видимость", Ложь);
		
		ИзменитьСвойстваЭлементаФормы(Элементы, "ФормаОбщаяКомандаСоздатьШаблонОперации", СтруктураСвойств);
		ИзменитьСвойстваЭлементаФормы(Элементы, "ФормаОтменаПроведения", СтруктураСвойств);
		ИзменитьСвойстваЭлементаФормы(Элементы, "ФормаПроведение", СтруктураСвойств);
		ИзменитьСвойстваЭлементаФормы(Элементы, "ФормаПровести", СтруктураСвойств);
		
	Иначе
		
		ПереименоватьЭлементФормы(Элементы, "ФормаПровести",         НСтр("ru = 'Учесть'"));
		ПереименоватьЭлементФормы(Элементы, "ФормаПроведение",       НСтр("ru = 'Учет'"));
		ПереименоватьЭлементФормы(Элементы, "ФормаПровестиИЗакрыть", НСтр("ru = 'Учесть и закрыть'"));
		ПереименоватьЭлементФормы(Элементы, "ФормаОтменаПроведения", НСтр("ru = 'Отменить учет'"));
		
	КонецЕсли; 

КонецПроцедуры

// Заменяет названия стандартных команд формы списа документов
Процедура ПереименоватьКнопкиИПанелиСпискаДокументов(Форма) Экспорт

	Элементы   = Форма.Элементы;
	Команды    = Форма.Команды;
	
	ПереименоватьЭлементФормы(Элементы, "СписокПровести",                 НСтр("ru = 'Учесть'"));
	ПереименоватьЭлементФормы(Элементы, "СписокПроведение",               НСтр("ru = 'Учет'"));
	ПереименоватьЭлементФормы(Элементы, "СписокПровестиИЗакрыть",         НСтр("ru = 'Учесть и закрыть'"));
	ПереименоватьЭлементФормы(Элементы, "СписокОтменаПроведения",         НСтр("ru = 'Отменить учет'"));

	ПереименоватьЭлементФормы(Элементы, "СписокКонтекстноеМенюПровести",                 НСтр("ru = 'Учесть'"));
	ПереименоватьЭлементФормы(Элементы, "СписокКонтекстноеМенюПроведение",               НСтр("ru = 'Учет'"));
	ПереименоватьЭлементФормы(Элементы, "СписокКонтекстноеМенюПровестиИЗакрыть",         НСтр("ru = 'Учесть и закрыть'"));
	ПереименоватьЭлементФормы(Элементы, "СписокКонтекстноеМенюОтменаПроведения",         НСтр("ru = 'Отменить учет'"));

	ПереименоватьЭлементФормы(Элементы, "СписокШаблоновПровести",         НСтр("ru = 'Учесть'"));
	ПереименоватьЭлементФормы(Элементы, "СписокШаблоновПроведение",       НСтр("ru = 'Учет'"));
	ПереименоватьЭлементФормы(Элементы, "СписокШаблоновПровестиИЗакрыть", НСтр("ru = 'Учесть и закрыть'"));
	ПереименоватьЭлементФормы(Элементы, "СписокШаблоновОтменаПроведения", НСтр("ru = 'Отменить учет'"));

	ПереименоватьЭлементФормы(Элементы, "СписокШаблоновКонтекстноеМенюПровести",                 НСтр("ru = 'Учесть'"));
	ПереименоватьЭлементФормы(Элементы, "СписокШаблоновКонтекстноеМенюПроведение",               НСтр("ru = 'Учет'"));
	ПереименоватьЭлементФормы(Элементы, "СписокШаблоновКонтекстноеМенюПровестиИЗакрыть",         НСтр("ru = 'Учесть и закрыть'"));
	ПереименоватьЭлементФормы(Элементы, "СписокШаблоновКонтекстноеМенюОтменаПроведения",         НСтр("ru = 'Отменить учет'"));

	ПереименоватьЭлементФормы(Элементы, "ФормаПровести",                  НСтр("ru = 'Учесть'"));
	ПереименоватьЭлементФормы(Элементы, "ФормаПроведение",                НСтр("ru = 'Учет'"));
	ПереименоватьЭлементФормы(Элементы, "ФормаПровестиИЗакрыть",          НСтр("ru = 'Учесть и закрыть'"));
	ПереименоватьЭлементФормы(Элементы, "ФормаОтменаПроведения",          НСтр("ru = 'Отменить учет'"));
	
	Если Найти(Форма.ИмяФормы, "Шаблон") > 0 Тогда
		СтруктураСвойств = Новый Структура("Видимость", Ложь);
		
		Если Форма.Элементы.Список.РежимВыбора Тогда
			Форма.Заголовок = "Выбор шаблона";
			Форма.Элементы.Список.ТолькоПросмотр = Истина;
			Форма.Элементы.Список.ИзменятьСоставСтрок = Ложь;
			ИзменитьСвойстваЭлементаФормы(Элементы, "ФормаИзменить", СтруктураСвойств);
			ИзменитьСвойстваЭлементаФормы(Элементы, "ФормаСкопировать", СтруктураСвойств);
			ИзменитьСвойстваЭлементаФормы(Элементы, "ФормаСоздать", СтруктураСвойств);
			ИзменитьСвойстваЭлементаФормы(Элементы, "ФормаСоздатьНаОсновании", СтруктураСвойств);
			ИзменитьСвойстваЭлементаФормы(Элементы, "ФормаУдалить", СтруктураСвойств);
			ИзменитьСвойстваЭлементаФормы(Элементы, "ФормаУстановитьПометкуУдаления", СтруктураСвойств);
			
			ИзменитьСвойстваЭлементаФормы(Элементы, "СписокИзменить", СтруктураСвойств);
			ИзменитьСвойстваЭлементаФормы(Элементы, "СписокСкопировать", СтруктураСвойств);
			ИзменитьСвойстваЭлементаФормы(Элементы, "СписокСоздать", СтруктураСвойств);
			ИзменитьСвойстваЭлементаФормы(Элементы, "СписокСоздатьНаОсновании", СтруктураСвойств);
			ИзменитьСвойстваЭлементаФормы(Элементы, "СписокУдалить", СтруктураСвойств);
			ИзменитьСвойстваЭлементаФормы(Элементы, "СписокУстановитьПометкуУдаления", СтруктураСвойств);
			
			ИзменитьСвойстваЭлементаФормы(Элементы, "СписокКонтекстноеМенюИзменить", СтруктураСвойств);
			ИзменитьСвойстваЭлементаФормы(Элементы, "СписокКонтекстноеМенюСкопировать", СтруктураСвойств);
			ИзменитьСвойстваЭлементаФормы(Элементы, "СписокКонтекстноеМенюСоздать", СтруктураСвойств);
			ИзменитьСвойстваЭлементаФормы(Элементы, "СписокКонтекстноеМенюСоздатьНаОсновании", СтруктураСвойств);
			ИзменитьСвойстваЭлементаФормы(Элементы, "СписокКонтекстноеМенюУдалить", СтруктураСвойств);
			ИзменитьСвойстваЭлементаФормы(Элементы, "СписокКонтекстноеМенюУстановитьПометкуУдаления", СтруктураСвойств);
		Иначе
			Форма.Заголовок = "Шаблоны операций";
		КонецЕсли;
		
		//ИзменитьСвойстваЭлементаФормы(Элементы, "ФормаОбщаяКомандаСоздатьШаблонОперации", СтруктураСвойств);
		ИзменитьСвойстваЭлементаФормы(Элементы, "ФормаИнтервал", СтруктураСвойств);
		ИзменитьСвойстваЭлементаФормы(Элементы, "ФормаОтменаПроведения", СтруктураСвойств);
		ИзменитьСвойстваЭлементаФормы(Элементы, "ФормаПроведение", СтруктураСвойств);
		ИзменитьСвойстваЭлементаФормы(Элементы, "ФормаПровести", СтруктураСвойств);
		ИзменитьСвойстваЭлементаФормы(Элементы, "ФормаУстановитьИнтервал", СтруктураСвойств);
		
		ИзменитьСвойстваЭлементаФормы(Элементы, "СписокОбщаяКомандаСоздатьШаблонОперации", СтруктураСвойств);
		ИзменитьСвойстваЭлементаФормы(Элементы, "СписокИнтервал", СтруктураСвойств);
		ИзменитьСвойстваЭлементаФормы(Элементы, "СписокОтменаПроведения", СтруктураСвойств);
		ИзменитьСвойстваЭлементаФормы(Элементы, "СписокПроведение", СтруктураСвойств);
		ИзменитьСвойстваЭлементаФормы(Элементы, "СписокПровести", СтруктураСвойств);
		ИзменитьСвойстваЭлементаФормы(Элементы, "СписокУстановитьИнтервал", СтруктураСвойств);
		
		ИзменитьСвойстваЭлементаФормы(Элементы, "СписокКонтекстноеМенюОбщаяКомандаСоздатьШаблонОперации", СтруктураСвойств);
		ИзменитьСвойстваЭлементаФормы(Элементы, "СписокКонтекстноеМенюИнтервал", СтруктураСвойств);
		ИзменитьСвойстваЭлементаФормы(Элементы, "СписокКонтекстноеМенюОтменаПроведения", СтруктураСвойств);
		ИзменитьСвойстваЭлементаФормы(Элементы, "СписокКонтекстноеМенюПроведение", СтруктураСвойств);
		ИзменитьСвойстваЭлементаФормы(Элементы, "СписокКонтекстноеМенюПровести", СтруктураСвойств);
		ИзменитьСвойстваЭлементаФормы(Элементы, "СписокКонтекстноеМенюУстановитьИнтервал", СтруктураСвойств);
		
	КонецЕсли; 
	
КонецПроцедуры


#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура ПереименоватьЭлементФормы(Элементы, ИмяЭлемента, Заголовок)

	ЭлементКнопки = Элементы.Найти(ИмяЭлемента);
	Если ЭлементКнопки <> Неопределено Тогда
		ЭлементКнопки.Заголовок = Заголовок;
	КонецЕсли; 

КонецПроцедуры

Процедура ИзменитьСвойстваЭлементаФормы(Элементы, ИмяЭлемента, СтруктураСвойств) 
	
	ЭлементФормы = Элементы.Найти(ИмяЭлемента);
	Если ЭлементФормы <> Неопределено Тогда
		Для каждого КлючИЗначение Из СтруктураСвойств Цикл
			ЭлементФормы[КлючИЗначение.Ключ] = КлючИЗначение.Значение;
		КонецЦикла;
	КонецЕсли; 
	
КонецПроцедуры


#КонецОбласти







