
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВычетПоПроцентамНедоступен     = Параметры.Свойство("ВычетПоПроцентамНедоступен") И Параметры.ВычетПоПроцентамНедоступен;
	Декларация3НДФЛВыбраннаяФорма  = Параметры.Декларация3НДФЛВыбраннаяФорма;
	
	// Загрузка параметров формы в значения ДропРеквизитов формы
	Обработки.ПомощникЗаполнения3НДФЛ.ЗаполнитьДопРеквизитыФормыДокументаПомощника(ЭтотОбъект);
	// Чтение структуры документа
	СтрукураДокументаНаСервере = Обработки.ПомощникЗаполнения3НДФЛ.СтруктураДокументаСТаблицамиИзХранилищ(ДопРеквизитыФормы.СтруктураДокумента);
	// конвертация из предыдущих форматов
	ПроверитьСтруктуруДокумента(СтрукураДокументаНаСервере);
	// заполнение формы
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтрукураДокументаНаСервере, ,);
	
	СобственностьСупругаПредставление = НСтр("ru = 'Собственность оформлена на супруга/супругу'"); // ДЕНЬГИ
	
	ЗаполнитьСписокВыбораСпособовПриобретенияНедвижимости(ЭтотОбъект);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если КодНомераОбъекта = 4 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("КадастровыйНомер");
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("АдресОбъектаНедвижимости");
	КонецЕсли;
	
	Если ЖильеПриобретеноНаВторичномРынке(СпособПриобретенияНедвижимости) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДатаАктаПередачиПрав");
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("ДатаРегистрацииПраваСобственности");
	КонецЕсли;
	
	Если НЕ ОформленоЗаявлениеОРаспределенииВычета Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДатаЗаявленияОРаспределенииРасходов");
	КонецЕсли;
	
	Если НачалоГода(НачалоПримененияВычета) < НачалоГода(ДатаПриобретенияПравНаОбъект(ЭтотОбъект)) Тогда
		ТекстСообщения = НСтр("ru = 'Начало применения вычета меньше года регистрации прав собственности'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "НачалоПримененияВычета", , Отказ);
	КонецЕсли;
	
	// Числитель должен быть меньше знаменателя.
	Если НеобходимоУказыватьДоли(ЭтотОбъект) Тогда
		Если ДоляЧислитель > ДоляЗнаменатель Тогда
			ТекстСообщения = НСтр("ru = 'Значение доли указано неправильно'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "ДоляЧислитель", , Отказ);
		КонецЕсли;
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("ДоляЧислитель");
		МассивНепроверяемыхРеквизитов.Добавить("ДоляЗнаменатель");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ДопРеквизитыФормы.СписокОшибок <> Неопределено Тогда
		// Если форма открывается из списка собщений помощника заполнения, в параметрах будет передан массив "СписокОшибок"
		ПоказатьСписокОшибок(ДопРеквизитыФормы.СписокОшибок);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		
		Отказ = Истина;
		
		#Область ПоказатьВопрос
		ТекстВопроса = НСтр("ru='Записать изменения перед закрытием этой формы?'");
		
		ДополнительныеПараметры = Новый Структура;
		Оповещение = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да,     НСтр("ru='Записать'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет,    НСтр("ru='Закрыть без записи'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru='Отменить закрытие'"));
		
		ПоказатьВопрос(Оповещение, ТекстВопроса, Кнопки, , КодВозвратаДиалога.Да, Заголовок);
		#КонецОбласти
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбъектНедвижимостиПриИзменении(Элемент)
	
	Если ЭтоЗемельныйУчасток(ОбъектНедвижимости) Тогда
		СпособПриобретенияНедвижимости = "Покупка";
		ДатаАктаПередачиПрав = Неопределено;
	Иначе
		ДатаРегистрацииПраваНаЗемлю = Неопределено;
	КонецЕсли;
	
	ЗаполнитьСписокВыбораСпособовПриобретенияНедвижимости(ЭтотОбъект);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ФормаСобственностиПриИзменении(Элемент)
	
	Если Не ЭтоОбщаяДолеваяСобственность(ФормаСобственности)
		И Не ЭтоОбщаяСовместнаяСобственность(ФормаСобственности) Тогда
		ОформленоЗаявлениеОРаспределенииВычета = Ложь;
		ДатаЗаявленияОРаспределенииРасходов = Неопределено;
	КонецЕсли;
	
	Если Не ЭтоОбщаяДолеваяСобственность(ФормаСобственности) Тогда
		СредиСобственниковРебенок = Ложь;
	КонецЕсли;
	
	Если Не ЭтоИндивидуальнаяСобственность(ФормаСобственности) Тогда
		СобственностьСупруга = Ложь;
	КонецЕсли;
	
	Если Не НеобходимоУказыватьДоли(ЭтотОбъект) Тогда
		ДоляЧислитель = 0;
		ДоляЗнаменатель = 0;
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаАктаПередачиПравПриИзменении(Элемент)
	
	НачалоПримененияВычета = ДатаАктаПередачиПрав;
	
	Если Не НеобходимоУказыватьДоли(ЭтотОбъект) Тогда
		ДоляЧислитель = 0;
		ДоляЗнаменатель = 0;
	КонецЕсли;
	
	НачалоПримененияВычетаПриИзменении(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаРегистрацииПраваСобственностиПриИзменении(Элемент)
	
	НачалоПримененияВычета = ДатаРегистрацииПраваСобственности;
	
	Если Не НеобходимоУказыватьДоли(ЭтотОбъект) Тогда
		ДоляЧислитель = 0;
		ДоляЗнаменатель = 0;
	КонецЕсли;
	
	НачалоПримененияВычетаПриИзменении(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоПримененияВычетаРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(НачалоПримененияВычета) Тогда
		СтандартнаяОбработка = Ложь;
		НачалоПримененияВычета = ДобавитьМесяц(НачалоГода(ТекущаяДата()), Направление * 12);
		НачалоПримененияВычетаПриИзменении(Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоПримененияВычетаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(НачалоПримененияВычета) Тогда
		Если ИспользоватьВычетПоПроцентам И НачалоПримененияВычета < Дата(2014, 1, 1) Тогда
			КредитОформленДо2014Года = Истина;
		КонецЕсли;
		Если НачалоПримененияВычета < НачалоГода(Период) Тогда
			ВычетПрименяетсяВпервые = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КодНомераОбъектаПриИзменении(Элемент)
	
	Если КодНомераОбъекта = 4 Тогда
		КадастровыйНомер = "";
	Иначе
		АдресОбъектаНедвижимости = "";
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СпособПриобретенияНедвижимостиПриИзменении(Элемент)
	
	Если ЖильеПриобретеноНаВторичномРынке(СпособПриобретенияНедвижимости) Тогда
		ДатаАктаПередачиПрав = Неопределено;
	Иначе
		ДатаРегистрацииПраваСобственности = Неопределено;
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоЗаявлениеОРаспределенииВычетаПриИзменении(Элемент)
	
	Если Не ОформленоЗаявлениеОРаспределенииВычета Тогда
		ДатаЗаявленияОРаспределенииРасходов = Неопределено;
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьВычетПоПроцентамПриИзменении(Элемент)
	
	Если ИспользоватьВычетПоПроцентам Тогда
		Если НачалоПримененияВычета < Дата(2014, 1, 1) Тогда
			КредитОформленДо2014Года = Истина;
		КонецЕсли;
	Иначе
		КредитОформленДо2014Года = Ложь;
		СуммаПроцентовЗаВсеГоды = 0;
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВычетПрименяетсяВпервыеПриИзменении(Элемент)
	
	Если ВычетПрименяетсяВпервые Тогда
		ВычетПрошлыхЛетСтоимость = 0;
		ВычетПрошлыхЛетПроценты = 0;
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	РезультатПроверки = РезультатПроверкиДокумента();
	
	Если РезультатПроверки.БезОшибок Тогда
		Модифицированность = Ложь;
		ВернутьРезультатВПомощник(РезультатПроверки.РезультатДляВозврата);
	Иначе
		
		ПоказатьСписокОшибок(РезультатПроверки.СписокОшибок);
		
		#Область ПоказатьВопрос
		ТекстВопроса = НСтр("ru='В документе обнаружены ошибки. Записать документ в текущем состоянии?'");
		
		ДополнительныеПараметры = Новый Структура("РезультатПроверки", РезультатПроверки);
		Оповещение = Новый ОписаниеОповещения("ЗаписатьДокументКлиентЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да,     НСтр("ru='Записать с ошибками'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет,    НСтр("ru='Исправить ошибки'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru='Закрыть не записывая'"));
		
		ПоказатьВопрос(Оповещение, ТекстВопроса, Кнопки, , КодВозвратаДиалога.Да, Заголовок);
		#КонецОбласти
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПроверитьСтруктуруДокумента(СтруктураДокумента)
	
	// Для обратной совместимости с декларацией за 2017 год.
	// Изменился состав хранимых значений в поле "ОбъектНедвижимости".
	// Нужно учесть это при чтении данных декларации 2017 года.
	ЗаполнитьОбъектНедвижимостиИзСохраненныхДанных(СтруктураДокумента);
	
	// Для обратной совместимости с декларацией за 2018 год.
	// Реквизит "ЖильеПриобретеноНаВторичномРынке" заменен реквизитом "СпособПриобретенияНедвижимости".
	Если СтруктураДокумента.Свойство("ЖильеПриобретеноНаВторичномРынке")
		И ТипЗнч(СтруктураДокумента.ЖильеПриобретеноНаВторичномРынке) = Тип("Булево")
		И Не СтруктураДокумента.ЖильеПриобретеноНаВторичномРынке Тогда
		СтруктураДокумента.Вставить("СпособПриобретенияНедвижимости", "ДоговорДолевогоУчастия");
	КонецЕсли;
	
	ЭталоннаяСтруктура = Обработки.ПомощникЗаполнения3НДФЛ.НоваяСтруктураДокументаДоходаВычета(
				ДопРеквизитыФормы.ВидДокумента, Декларация3НДФЛВыбраннаяФорма);
	ЗаполнитьЗначенияСвойств(ЭталоннаяСтруктура, СтруктураДокумента);
	СтруктураДокумента = ЭталоннаяСтруктура;
	
КонецПроцедуры


&НаСервере
Процедура ЗаполнитьФормуИзДанных(ДанныеФормы)
	
	Для Каждого ИмяРеквизита Из МассивРеквизитовФормы() Цикл
		ДанныеФормы.Свойство(ИмяРеквизита, ЭтотОбъект[ИмяРеквизита]);
	КонецЦикла;
	
	// Для обратной совместимости с декларацией за 2017 год.
	// Изменился состав хранимых значений в поле "ОбъектНедвижимости".
	// Нужно учесть это при чтении данных декларации 2017 года.
	ЗаполнитьОбъектНедвижимостиИзСохраненныхДанных(ДанныеФормы);
	
	// Для обратной совместимости с декларацией за 2018 год.
	// Реквизит "ЖильеПриобретеноНаВторичномРынке" заменен реквизитом "СпособПриобретенияНедвижимости".
	Если ДанныеФормы.Свойство("ЖильеПриобретеноНаВторичномРынке")
		И ТипЗнч(ДанныеФормы.ЖильеПриобретеноНаВторичномРынке) = Тип("Булево")
		И Не ДанныеФормы.ЖильеПриобретеноНаВторичномРынке Тогда
		СпособПриобретенияНедвижимости = "ДоговорДолевогоУчастия";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОбъектНедвижимостиИзСохраненныхДанных(ДанныеФормы)
	
	Перем СохраненныйОбъектНедвижимости;
	
	Если ДанныеФормы.Свойство("ОбъектНедвижимости", СохраненныйОбъектНедвижимости)
		И ТипЗнч(СохраненныйОбъектНедвижимости) = Тип("Число") Тогда
		
		СохраненныйОбъектНедвижимости = Строка(СохраненныйОбъектНедвижимости);
		
		КодыОбъектаНедвижимости = Отчеты.РегламентированныйОтчет3НДФЛ.КодыНаименованияОбъектаНедвижимости(Декларация3НДФЛВыбраннаяФорма);
		
		// В данных помощника за 2017 год доля в земельном участке имела отдельный код для интерфейсных целей,
		// При подготовке данных декларации этот код превращался в правильный код "4", соответствующий долям.
		Если СохраненныйОбъектНедвижимости = "8" Тогда
			ОбъектНедвижимости = КодыОбъектаНедвижимости.ДоляВЗемельномУчастке;
		Иначе
			Для Каждого Элемент Из КодыОбъектаНедвижимости Цикл
				Если Элемент.Значение = СохраненныйОбъектНедвижимости Тогда
					ОбъектНедвижимости = Элемент.Ключ;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНовуюФорму()
	
	ОбъектНедвижимости = "Квартира";
	СпособПриобретенияНедвижимости = "Покупка";
	ФормаСобственности = 1;
	КодНомераОбъекта   = 1;
	ДоляЧислитель      = 1;
	ДоляЗнаменатель    = 2;
	ВычетПрименяетсяВпервые = Истина;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	ЭтоОбщаяДолеваяСобственность = ЭтоОбщаяДолеваяСобственность(Форма.ФормаСобственности);
	ЭтоОбщаяСовместнаяСобственность = ЭтоОбщаяСовместнаяСобственность(Форма.ФормаСобственности);
	ЭтоЗемельныйУчасток = ЭтоЗемельныйУчасток(Форма.ОбъектНедвижимости);
	ЭтоЖилойДом = ЭтоЖилойДом(Форма.ОбъектНедвижимости);
	ЖильеПриобретеноНаВторичномРынке = ЖильеПриобретеноНаВторичномРынке(Форма.СпособПриобретенияНедвижимости);
	
	Элементы.СпособПриобретенияНедвижимости.Видимость = Не ЭтоЗемельныйУчасток Или ЭтоЖилойДом;
	
	Элементы.ДатаРегистрацииПраваНаЗемлю.Видимость = ЭтоЗемельныйУчасток;
	Элементы.ДатаАктаПередачиПрав.Видимость = НЕ ЖильеПриобретеноНаВторичномРынке;
	Элементы.ДатаРегистрацииПраваСобственности.Видимость = ЖильеПриобретеноНаВторичномРынке;
	
	Элементы.ГруппаЭтоСобственностьСупруга.Видимость = Не ЭтоСобственностьРебенка(Форма.ФормаСобственности);
	
	Элементы.СуммаРасходовРасширеннаяПодсказка.Заголовок = ТекстПодсказкиСуммаРасходов(Форма.ОбъектНедвижимости);
	
	Элементы.КадастровыйНомер.Видимость = Форма.КодНомераОбъекта <> 4;
	Элементы.АдресОбъектаНедвижимости.Видимость = Форма.КодНомераОбъекта = 4;
	
	Элементы.ГруппаНачалоПримененияВычета.Видимость =
		ЕстьКлючПоказателя("ГодНачалаИспользованияВычета", Форма.АдресКлючейПоказателей);
	
	// Долевая собственность
	Элементы.ГруппаЗаявлениеОРаспределенииВычета.Видимость =
		ЕстьКлючПоказателя("ДатаЗаявленияОРаспределенииВычета", Форма.АдресКлючейПоказателей);
	
	Элементы.ОформленоЗаявлениеОРаспределенииВычета.Видимость = (ЭтоОбщаяДолеваяСобственность Или ЭтоОбщаяСовместнаяСобственность);
	Элементы.ДатаЗаявленияОРаспределенииРасходов.Видимость =
		(ЭтоОбщаяДолеваяСобственность ИЛИ ЭтоОбщаяСовместнаяСобственность) И Форма.ОформленоЗаявлениеОРаспределенииВычета;
	
	Элементы.СредиСобственниковРебенок.Видимость = ЭтоОбщаяДолеваяСобственность;
	Элементы.ГруппаДоля.Видимость = НеобходимоУказыватьДоли(Форма);
	
	// Вычет по процентам
	Элементы.ГруппаПроцентыПоИпотеке.Видимость = НЕ Форма.ВычетПоПроцентамНедоступен;
	
	Элементы.КредитОформленДо2014Года.Видимость = Форма.ИспользоватьВычетПоПроцентам;
	Элементы.СуммаПроцентовЗаВсеГоды.Видимость = Форма.ИспользоватьВычетПоПроцентам;
	
	// Сумма вычетов, примененных в предыдущие годы.
	Элементы.ВычетПрошлыхЛетСтоимость.Видимость = Ложь; // ДЕНЬГИ НЕ Форма.ВычетПрименяетсяВпервые;
	Элементы.ВычетПрошлыхЛетПроценты.Видимость = Ложь; // ДЕНЬГИ НЕ Форма.ВычетПрименяетсяВпервые;
	
	УстановитьКлючСохраненияПоложенияОкнаФормы(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьКлючСохраненияПоложенияОкнаФормы(Форма)
	
	Ключ = "" + Форма.ОбъектНедвижимости + Форма.ФормаСобственности + Форма.СпособПриобретенияНедвижимости;
	
	Если Форма.ВычетПоПроцентамНедоступен Тогда
		Ключ = Ключ + "БезПроцентов";
	КонецЕсли;
	
	Если Форма.ИспользоватьВычетПоПроцентам Тогда
		Ключ = Ключ + "ПоказатьПроценты";
	КонецЕсли;
	
	Если НЕ Форма.ВычетПрименяетсяВпервые Тогда
		Ключ = Ключ + "ПоказатьОстатокНаНачало";
	КонецЕсли;
	
	Форма.КлючСохраненияПоложенияОкна = Ключ;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ТекстПодсказкиСуммаРасходов(ОбъектНедвижимости)
	
	ТекстПодсказки = "";
	Если Не ЭтоЗемельныйУчасток(ОбъектНедвижимости) Тогда
		ТекстПодсказки = НСтр("ru = 'Сумма расходов на приобретение недвижимости без учета ее стоимости
		|и расходов на погашение процентов по кредитам.
		|
		|Включаются расходы на:
		| - приобретение отделочных материалов;
		| - работы, связанные с отделкой приобретенной недвижимости;
		| - разработку проектной и сметной документации на проведение отделочных работ.
		|
		|Указываются только документально подтвержденные расходы.'");
	Иначе
		ТекстПодсказки = НСтр("ru = 'Сумма расходов на строительство недвижимости без учета стоимости
		|земельного участка, недостроенного жилого дома и расходов на погашение
		|процентов по кредитам.
		|
		|Включаются расходы на:
		| - на разработку проектной и сметной документации;
		| - на приобретение строительных и отделочных материалов;
		| - на работы или услуги по строительству и отделке;
		| - на подведение коммуникаций.
		|
		|Указываются только документально подтвержденные расходы.'");
	КонецЕсли;
	
	Возврат ТекстПодсказки;
	
КонецФункции

&НаКлиенте
Функция СтруктураДанныхФормы()
	
	СтруктураДанныхФормы = Новый Структура;
	Для Каждого ИмяРеквизита Из МассивРеквизитовФормы() Цикл
		СтруктураДанныхФормы.Вставить(ИмяРеквизита, ЭтотОбъект[ИмяРеквизита]);
	КонецЦикла;
	
	Возврат СтруктураДанныхФормы;
	
КонецФункции

&НаСервере
Функция СтруктураДанныхДекларации()
	
	СтруктураДанныхДекларации = НовыйСтруктураДанныхДекларации();
	
	СтруктураДанныхДекларации.КодНаименованияОбъектаНедвижимости = КодОбъектаНедвижимости(ОбъектНедвижимости, Декларация3НДФЛВыбраннаяФорма);
	
	Если ЭтоЖилойДом(ОбъектНедвижимости) Тогда
		СтруктураДанныхДекларации.СпособПриобретенияНедвижимости =
			КодСпособаПриобретенияЖилогоДома(СпособПриобретенияНедвижимости, Декларация3НДФЛВыбраннаяФорма);
	КонецЕсли;
	
	СтруктураДанныхДекларации.ПризнакНалогоплательщикаОбъектаНедвижимости = ПризнакНалогоплательщика();
	СтруктураДанныхДекларации.ФормаСобственности = Строка(ФормаСобственности);
	
	СтруктураДанныхДекларации.КодНомераОбъектаНедвижимости = Строка(КодНомераОбъекта);
	Если КодНомераОбъекта = 4 Тогда
		СтруктураДанныхДекларации.АдресОбъектаНедвижимости = АдресОбъектаНедвижимости;
	Иначе
		СтруктураДанныхДекларации.КадастровыйНомерОбъектаНедвижимости = КадастровыйНомер;
	КонецЕсли;
	
	Если ЖильеПриобретеноНаВторичномРынке(СпособПриобретенияНедвижимости) Тогда
		СтруктураДанныхДекларации.ДатаРегистрацииПравСобственностиНаЖилье = ДатаРегистрацииПраваСобственности;
	Иначе
		СтруктураДанныхДекларации.ДатаАктаОПередачеОбъектаНедвижимости = ДатаАктаПередачиПрав;
	КонецЕсли;
	
	Если ЭтоЗемельныйУчасток(ОбъектНедвижимости) Тогда
		СтруктураДанныхДекларации.ДатаРегистрацииПравСобственностиНаЗемлю = ДатаРегистрацииПраваНаЗемлю;
	КонецЕсли;
	
	Если ОформленоЗаявлениеОРаспределенииВычета Тогда
		СтруктураДанныхДекларации.ДатаЗаявленияОРаспределенииВычета = ДатаЗаявленияОРаспределенииРасходов;
	КонецЕсли;
	
	СтруктураДанныхДекларации.ОбъектПриобретенДо2014Года = ОбъектПриобретенДо2014Года(ЭтотОбъект);
	Если НеобходимоУказыватьДоли(ЭтотОбъект) Тогда
		СтруктураДанныхДекларации.ДоляВПравеСобственностиЧислитель = ДоляЧислитель;
		СтруктураДанныхДекларации.ДоляВПравеСобственностиЗнаменатель = ДоляЗнаменатель;
	ИначеЕсли СтруктураДанныхДекларации.ОбъектПриобретенДо2014Года Тогда
		СтруктураДанныхДекларации.ДоляВПравеСобственностиЧислитель = 1;
		СтруктураДанныхДекларации.ДоляВПравеСобственностиЗнаменатель = 1;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НачалоПримененияВычета) Тогда
		СтруктураДанныхДекларации.ГодНачалаИспользованияВычета = Год(НачалоПримененияВычета);
	КонецЕсли;
	
	СтруктураДанныхДекларации.СуммаРасходовНаПриобретениеНедвижимости = Стоимость + СуммаРасходов;
	
	Если ИспользоватьВычетПоПроцентам Тогда
		СтруктураДанныхДекларации.СуммаПроцентовПоКредитуНаНедвижимость = СуммаПроцентовЗаВсеГоды;
	КонецЕсли;
	
	// Данные для итогов приложения декларации.
	Если Не ВычетПрименяетсяВпервые Тогда
		ПределыВычетов = ПределыВычетов(Декларация3НДФЛВыбраннаяФорма);
		СтруктураДанныхДекларации.ВычетПрошлыхЛетСтоимость = Мин(ВычетПрошлыхЛетСтоимость, ПределыВычетов.НаПриобретениеНедвижимостиСтоимость);
		СтруктураДанныхДекларации.ВычетПрошлыхЛетПроценты = Мин(ВычетПрошлыхЛетПроценты, ПределыВычетов.НаПриобретениеНедвижимостиПроценты);
	КонецЕсли;
	
	СтруктураДанныхДекларации.КредитОформленДо2014Года = КредитОформленДо2014Года;
	
	Возврат СтруктураДанныхДекларации;
	
КонецФункции

&НаСервере
Функция НовыйСтруктураДанныхДекларации()
	
	СтруктураДанныхДекларации = Новый Структура;
	
	ПустаяДата = Дата(1,1,1);
	
	СтруктураДанныхДекларации.Вставить("КодНаименованияОбъектаНедвижимости", "0");
	СтруктураДанныхДекларации.Вставить("СпособПриобретенияНедвижимости", "");
	СтруктураДанныхДекларации.Вставить("ПризнакНалогоплательщикаОбъектаНедвижимости", "");
	СтруктураДанныхДекларации.Вставить("ФормаСобственности", 0);
	СтруктураДанныхДекларации.Вставить("НалогоплательщикПенсионер", "0");
	СтруктураДанныхДекларации.Вставить("КодНомераОбъектаНедвижимости", "1");
	СтруктураДанныхДекларации.Вставить("КадастровыйНомерОбъектаНедвижимости", "");
	СтруктураДанныхДекларации.Вставить("АдресОбъектаНедвижимости", "");
	СтруктураДанныхДекларации.Вставить("ДатаАктаОПередачеОбъектаНедвижимости", ПустаяДата);
	СтруктураДанныхДекларации.Вставить("ДатаРегистрацииПравСобственностиНаЖилье", ПустаяДата);
	СтруктураДанныхДекларации.Вставить("ДатаРегистрацииПравСобственностиНаЗемлю", ПустаяДата);
	СтруктураДанныхДекларации.Вставить("ДатаЗаявленияОРаспределенииВычета", ПустаяДата);
	СтруктураДанныхДекларации.Вставить("ДоляВПравеСобственностиЧислитель", 0);
	СтруктураДанныхДекларации.Вставить("ДоляВПравеСобственностиЗнаменатель", 0);
	СтруктураДанныхДекларации.Вставить("ГодНачалаИспользованияВычета", 0);
	СтруктураДанныхДекларации.Вставить("СуммаРасходовНаПриобретениеНедвижимости", 0);
	СтруктураДанныхДекларации.Вставить("СуммаПроцентовПоКредитуНаНедвижимость", 0);
	
	// Итоги Приложения декларации.
	СтруктураДанныхДекларации.Вставить("ВычетПрошлыхЛетСтоимость", 0);
	СтруктураДанныхДекларации.Вставить("ВычетПрошлыхЛетПроценты", 0);
	
	// Временные поля для расчета итогов по данному вычету.
	СтруктураДанныхДекларации.Вставить("ОбъектПриобретенДо2014Года", Ложь);
	СтруктураДанныхДекларации.Вставить("КредитОформленДо2014Года", Ложь);
	
	Возврат СтруктураДанныхДекларации;
	
КонецФункции

&НаКлиенте
Функция РассчитатьСуммуВозможногоВычета()
	
	ПределыВычетов = ПределыВычетов(Декларация3НДФЛВыбраннаяФорма);
	Если ВычетПрименяетсяВпервые Тогда
		ДоступныйВычетСтоимость = ПределыВычетов.НаПриобретениеНедвижимостиСтоимость;
		ДоступныйВычетПроценты  = ПределыВычетов.НаПриобретениеНедвижимостиПроценты;
	Иначе
		ДоступныйВычетСтоимость = Макс(0, ПределыВычетов.НаПриобретениеНедвижимостиСтоимость - ВычетПрошлыхЛетСтоимость);
		ДоступныйВычетПроценты  = Макс(0, ПределыВычетов.НаПриобретениеНедвижимостиПроценты - ВычетПрошлыхЛетПроценты);
	КонецЕсли;
	
	СуммаВычета = Мин(Стоимость + СуммаРасходов, ДоступныйВычетСтоимость);
	Если ИспользоватьВычетПоПроцентам И КредитОформленДо2014Года Тогда
		СуммаВычета = СуммаВычета + (СуммаПроцентовЗаВсеГоды - ВычетПрошлыхЛетПроценты);
	ИначеЕсли ИспользоватьВычетПоПроцентам Тогда
		СуммаВычета = СуммаВычета + Мин(СуммаПроцентовЗаВсеГоды, ДоступныйВычетПроценты);
	КонецЕсли;
	
	Возврат СуммаВычета;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция МассивРеквизитовФормы()
	
	Массив = Новый Массив;
	Массив.Добавить("ОбъектНедвижимости");
	Массив.Добавить("ФормаСобственности");
	Массив.Добавить("СпособПриобретенияНедвижимости");
	Массив.Добавить("СобственностьСупруга");
	Массив.Добавить("КодНомераОбъекта");
	Массив.Добавить("КадастровыйНомер");
	Массив.Добавить("АдресОбъектаНедвижимости");
	Массив.Добавить("ДатаАктаПередачиПрав");
	Массив.Добавить("ДатаРегистрацииПраваСобственности");
	Массив.Добавить("ДатаРегистрацииПраваНаЗемлю");
	Массив.Добавить("ДатаЗаявленияОРаспределенииРасходов");
	Массив.Добавить("ДоляЧислитель");
	Массив.Добавить("ДоляЗнаменатель");
	Массив.Добавить("НачалоПримененияВычета");
	Массив.Добавить("Стоимость");
	Массив.Добавить("СуммаРасходов");
	Массив.Добавить("СредиСобственниковРебенок");
	Массив.Добавить("ОформленоЗаявлениеОРаспределенииВычета");
	
	Массив.Добавить("ИспользоватьВычетПоПроцентам");
	Массив.Добавить("КредитОформленДо2014Года");
	Массив.Добавить("СуммаПроцентовЗаВсеГоды");
	
	Массив.Добавить("ВычетПрименяетсяВпервые");
	Массив.Добавить("ВычетПрошлыхЛетСтоимость");
	Массив.Добавить("ВычетПрошлыхЛетПроценты");
	
	Возврат Массив;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПределыВычетов(ВыбраннаяФорма)
	Возврат Отчеты.РегламентированныйОтчет3НДФЛ.ПределыВычетов(ВыбраннаяФорма);
КонецФункции

&НаСервереБезКонтекста
Функция КодОбъектаНедвижимости(Знач ОбъектНедвижимости, Знач ВыбраннаяФорма)
	
	Возврат Отчеты.РегламентированныйОтчет3НДФЛ.КодОбъектаНедвижимости(ОбъектНедвижимости, ВыбраннаяФорма);
	
КонецФункции

&НаСервереБезКонтекста
Функция КодСпособаПриобретенияЖилогоДома(Знач СпособПриобретения, Знач ВыбраннаяФорма)
	
	СпособыПриобретенияНедвижимости = Отчеты.РегламентированныйОтчет3НДФЛ.СпособыПриобретенияНедвижимости(ВыбраннаяФорма);
	
	Если СпособПриобретения = "Покупка" Тогда
		Возврат СпособыПриобретенияНедвижимости.Приобретение;
	ИначеЕсли СпособПриобретения = "Строительство" Тогда
		Возврат СпособыПриобретенияНедвижимости.НовоеСтроительство;
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ПризнакНалогоплательщика()
	
	КодыНалогоплательщика = КодыПризнакаНалогоплательщика(Декларация3НДФЛВыбраннаяФорма);
	
	Если ЭтоСобственностьРебенка(ФормаСобственности) Тогда
		Возврат КодыНалогоплательщика.Родитель;
	ИначеЕсли СобственностьСупруга Тогда
		Если ЭтоОбщаяДолеваяСобственность(ФормаСобственности) И СредиСобственниковРебенок Тогда
			Возврат КодыНалогоплательщика.СупругСобственникаСРебенком;
		Иначе
			Возврат КодыНалогоплательщика.СупругСобственника;
		КонецЕсли;
	Иначе
		Если ЭтоОбщаяДолеваяСобственность(ФормаСобственности) И СредиСобственниковРебенок Тогда
			Возврат КодыНалогоплательщика.СобственникСРебенком;
		Иначе
			Возврат КодыНалогоплательщика.Собственник;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция КодыПризнакаНалогоплательщика(ВыбраннаяФорма)
	Возврат Отчеты.РегламентированныйОтчет3НДФЛ.КодыПризнакаНалогоплательщикаДляИмущественногоВычета(ВыбраннаяФорма);
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция НеобходимоУказыватьДоли(Форма)
	
	ДатаПриобретенияПрав = ДатаПриобретенияПравНаОбъект(Форма);
	Если ЗначениеЗаполнено(ДатаПриобретенияПрав) Тогда
		ТребуютсяДоли = (Год(ДатаПриобретенияПрав) < 2014
			И (ЭтоОбщаяДолеваяСобственность(Форма.ФормаСобственности)
				Или ЭтоОбщаяСовместнаяСобственность(Форма.ФормаСобственности)));
	Иначе
		ТребуютсяДоли = Ложь;
	КонецЕсли;
	
	Возврат ТребуютсяДоли;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ДатаПриобретенияПравНаОбъект(Форма)
	
	Если НЕ ЖильеПриобретеноНаВторичномРынке(Форма.СпособПриобретенияНедвижимости) Тогда
		Возврат Форма.ДатаАктаПередачиПрав;
	Иначе
		Возврат Форма.ДатаРегистрацииПраваСобственности;
	КонецЕсли;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ОбъектПриобретенДо2014Года(Форма)
	
	ЖильеПриобретеноНаВторичномРынке = ЖильеПриобретеноНаВторичномРынке(Форма.СпособПриобретенияНедвижимости);
	
	Если ЖильеПриобретеноНаВторичномРынке И Форма.ДатаРегистрацииПраваСобственности < Дата(2014, 1, 1) Тогда
		Возврат Истина;
	ИначеЕсли НЕ ЖильеПриобретеноНаВторичномРынке И Форма.ДатаАктаПередачиПрав < Дата(2014, 1, 1) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЭтоЗемельныйУчасток(ОбъектНедвижимости)
	
	Возврат ОбъектНедвижимости = "ЗемельныйУчасток"
		Или ОбъектНедвижимости = "ЗемельныйУчастокПодСтроительство"
		Или ОбъектНедвижимости = "ЖилойДомСЗемельнымУчастком"
		Или ОбъектНедвижимости = "ДоляВЗемельномУчастке";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЭтоЖилойДом(ОбъектНедвижимости)
	
	Возврат ОбъектНедвижимости = "ЖилойДом"
		Или ОбъектНедвижимости = "ЖилойДомСЗемельнымУчастком";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЭтоИндивидуальнаяСобственность(ФормаСобственности)
	
	Возврат ФормаСобственности = 1;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЭтоОбщаяДолеваяСобственность(ФормаСобственности)
	
	Возврат ФормаСобственности = 2;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЭтоОбщаяСовместнаяСобственность(ФормаСобственности)
	
	Возврат ФормаСобственности = 3;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЭтоСобственностьРебенка(ФормаСобственности)
	
	Возврат ФормаСобственности = 4;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЕстьКлючПоказателя(Знач ИмяКлюча, Знач АдресКлючейПоказателей)
	
	Возврат Отчеты.РегламентированныйОтчет3НДФЛ.ЕстьКлючПоказателя(ИмяКлюча, АдресКлючейПоказателей);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьСписокВыбораСпособовПриобретенияНедвижимости(Форма)
	
	СписокВыбора = Форма.Элементы.СпособПриобретенияНедвижимости.СписокВыбора;
	СписокВыбора.Очистить();
	
	СписокВыбора.Добавить("Покупка", НСтр("ru = 'Покупка'"));
	СписокВыбора.Добавить("ДоговорДолевогоУчастия", НСтр("ru = 'Договор долевого участия'"));
	
	Если ЭтоЖилойДом(Форма.ОбъектНедвижимости) Тогда
		СписокВыбора.Добавить("Строительство", НСтр("ru = 'Строительство'"));
	КонецЕсли;
	
	Если СписокВыбора.НайтиПоЗначению(Форма.СпособПриобретенияНедвижимости) = Неопределено Тогда
		Форма.СпособПриобретенияНедвижимости = СписокВыбора[0].Значение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ЖильеПриобретеноНаВторичномРынке(СпособПриобретения)
	Возврат СпособПриобретения <> "ДоговорДолевогоУчастия";
КонецФункции




///////////////////////////////////////////////////////
// ДЕНЬГИ
// Проверка и запись документа

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ДополнительныеПараметры) Экспорт

	Если Ответ = КодВозвратаДиалога.Да Тогда
		ЗаписатьДокументКлиент();
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокументКлиент()

	РезультатПроверки = РезультатПроверкиДокумента();
	
	Если РезультатПроверки.БезОшибок Тогда
		Модифицированность = Ложь;
		ВернутьРезультатВПомощник(РезультатПроверки.РезультатДляВозврата);
	Иначе
		
		ПоказатьСписокОшибок(РезультатПроверки.СписокОшибок);
		
		#Область ПоказатьВопрос
		ТекстВопроса = НСтр("ru='В документе обнаружены ошибки. Записать документ в текущем состоянии?'");
		
		ДополнительныеПараметры = Новый Структура("РезультатПроверки", РезультатПроверки);
		Оповещение = Новый ОписаниеОповещения("ЗаписатьДокументКлиентЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да,     НСтр("ru='Записать с ошибками'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет,    НСтр("ru='Исправить ошибки'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru='Закрыть не записывая'"));
		
		ПоказатьВопрос(Оповещение, ТекстВопроса, Кнопки, , КодВозвратаДиалога.Да, Заголовок);
		#КонецОбласти
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция РезультатДляЗаписи()

	СтруктураДокумента = ДопРеквизитыФормы.СтруктураДокумента;
	ЗаполнитьЗначенияСвойств(СтруктураДокумента, ЭтотОбъект, , );
	СтруктураДокумента.Вставить("СтруктураДанныхДекларации", СтруктураДанныхДекларации());
	
	Результат = Новый Структура;
	Результат.Вставить("ВидДокумента", ДопРеквизитыФормы.ВидДокумента);
	Результат.Вставить("СтавкаНалога", 13);
	Результат.Вставить("Представление", СтрШаблон("На приобретение или строительство жилья (%1, %2 руб.)", 
				Элементы.ОбъектНедвижимости.СписокВыбора.НайтиПоЗначению(ОбъектНедвижимости).Представление, Стоимость));
	Результат.Вставить("СтруктураДокумента", СтруктураДокумента);
	Результат.Вставить("СуммаДохода", 0);
	Результат.Вставить("СуммаВычета", СуммаПредполагаемогоВычета());

	Возврат Результат;
	
КонецФункции

&НаСервере
Функция РезультатПроверкиДокумента()

	Результат = Новый Структура();
	Результат.Вставить("РезультатДляВозврата", РезультатДляЗаписи());
	
	Результат.Вставить("СписокОшибок", Новый Массив);
	Результат.Вставить("БезОшибок", Обработки.ПомощникЗаполнения3НДФЛ.ДокументНеСодержитОшибок(
			ДопРеквизитыФормы.ВидДокумента, ДопРеквизитыФормы.ГодОтчета, 
			Результат.РезультатДляВозврата.СтруктураДокумента, Результат.СписокОшибок, 
			Неопределено, Декларация3НДФЛВыбраннаяФорма));
	
	Возврат Результат;

КонецФункции

&НаКлиенте
Процедура ЗаписатьДокументКлиентЗавершение(Ответ, ДополнительныеПараметры) Экспорт

	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		Модифицированность = Ложь;
		ВернутьРезультатВПомощник(ДополнительныеПараметры.РезультатПроверки.РезультатДляВозврата);
		
	ИначеЕсли Ответ = КодВозвратаДиалога.Отмена Тогда
		
		Модифицированность = Ложь;
		Если Открыта() Тогда
			Закрыть();
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВернутьРезультатВПомощник(Результат = Неопределено)

	Если Результат = Неопределено Тогда
		Результат = РезультатДляЗаписи();
	КонецЕсли;
	
	Закрыть(Результат);

КонецПроцедуры

&НаСервере
Функция СуммаПредполагаемогоВычета()

	Результат = Мин(2000000, Стоимость + СуммаРасходов);
	Если ИспользоватьВычетПоПроцентам Тогда
		Результат = Результат + ?(КредитОформленДо2014Года, СуммаПроцентовЗаВсеГоды, Мин(СуммаПроцентовЗаВсеГоды, 3000000));
	КонецЕсли;

	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ПоказатьСписокОшибок(СписокОшибок)

	ОчиститьСообщения();
	Для каждого Ошибка Из СписокОшибок Цикл
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст  = Ошибка.ОписаниеОшибки;
		Сообщение.Поле   = Ошибка.ИмяРеквизита;
		Сообщение.Сообщить(); 
		
	КонецЦикла;

КонецПроцедуры



#КонецОбласти
