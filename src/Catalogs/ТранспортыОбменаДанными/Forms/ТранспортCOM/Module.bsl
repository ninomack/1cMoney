#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаписатьПараметрыТранспорта(ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Справочники.ТранспортыОбменаДанными.ОбновитьПараметрыСценария(ТекущийОбъект, РасписаниеРегламентногоЗадания, ИспользоватьРегламентноеЗадание);
	
КонецПроцедуры


#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы


&НаКлиенте
Процедура COMВариантРаботыИнформационнойБазыПриИзменении(Элемент)
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура COMАутентификацияОперационнойСистемыПриИзменении(Элемент)
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнятьОбменДаннымиАвтоматическиПриИзменении(Элемент)
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры
  


#КонецОбласти



#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура COMКаталогИнформационнойБазыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ОбработчикВыбораФайловогоКаталога(ЭтотОбъект, "COMКаталогИнформационнойБазы", СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура COMКаталогИнформационнойБазыОткрытие(Элемент, СтандартнаяОбработка)

	ОбменДаннымиКлиент.ОбработчикОткрытияФайлаИлиКаталога(ЭтотОбъект, "COMКаталогИнформационнойБазы", СтандартнаяОбработка)

КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписаниеРегламентногоЗадания(Команда)
	
	РедактированиеРасписанияРегламентногоЗадания();
	
	ОбновитьПредставлениеРасписания();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПроверитьПодключение(Команда)
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ПроверитьПодключениеCOMЗавершение", ЭтотОбъект);
	Запросы = СоздатьЗапросНаИспользованиеВнешнихРесурсов(СтруктураНастроекТранспорта());
	РаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов(Запросы, ЭтотОбъект, ОповещениеОЗакрытии);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	// Подготовка реквизитов формы
	ПрочитатьПараметрыТранспорта();
	COMАутентификацияОперационнойСистемы = (ТипАутентификации = 1);
	
	РасписаниеРегламентногоЗадания = Справочники.ТранспортыОбменаДанными.РасписаниеСценария(Объект.Ссылка, ИспользоватьРегламентноеЗадание);
	ПредставлениеРасписания = Строка(РасписаниеРегламентногоЗадания);
	Элементы.НастроитьРасписаниеРегламентногоЗадания.Заголовок = ПредставлениеРасписания;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	ТекущаяСтраница = ?(Форма.COMВариантРаботыИнформационнойБазы = 0, Элементы.СтраницаВариантРаботыФайловый, Элементы.СтраницаВариантРаботыКлиентСерверный);
	Элементы.ВариантыРаботыИнформационнойБазы.ТекущаяСтраница = ТекущаяСтраница;

	Элементы.COMИмяПользователя.Доступность    = Не Форма.COMАутентификацияОперационнойСистемы;
	Элементы.COMПарольПользователя.Доступность = Не Форма.COMАутентификацияОперационнойСистемы;
	
	Элементы.НастроитьРасписаниеРегламентногоЗадания.Доступность = Форма.ИспользоватьРегламентноеЗадание;
	
	ПредставлениеРасписания = Строка(Форма.РасписаниеРегламентногоЗадания);
	Элементы.НастроитьРасписаниеРегламентногоЗадания.Заголовок = ПредставлениеРасписания;
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьПараметрыТранспорта()

	Для Каждого СтрокаПараметра Из Объект.ПараметрыТранспорта Цикл
		Если ЗначениеЗаполнено(СтрокаПараметра.ИмяПараметра) Тогда
			ЭтаФорма[СтрокаПараметра.ИмяПараметра] = ?(ЗначениеЗаполнено(СтрокаПараметра.ЗначениеДлиннойСтрокой), СтрокаПараметра.ЗначениеДлиннойСтрокой, СтрокаПараметра.ЗначениеПараметра);
		КонецЕсли; 
	КонецЦикла; 

КонецПроцедуры

&НаСервере
Процедура ЗаписатьПараметрыТранспорта(ТекущийОбъект)

	ТекущийОбъект.ПараметрыТранспорта.Очистить();
	НоваяСтрокаПараметровТранспорта(ТекущийОбъект, "COMАутентификацияОперационнойСистемы", COMАутентификацияОперационнойСистемы);
	НоваяСтрокаПараметровТранспорта(ТекущийОбъект, "COMВариантРаботыИнформационнойБазы", COMВариантРаботыИнформационнойБазы);
	НоваяСтрокаПараметровТранспорта(ТекущийОбъект, "COMИмяИнформационнойБазыНаСервере1СПредприятия", COMИмяИнформационнойБазыНаСервере1СПредприятия);
	НоваяСтрокаПараметровТранспорта(ТекущийОбъект, "COMИмяСервера1СПредприятия", COMИмяСервера1СПредприятия);
	НоваяСтрокаПараметровТранспорта(ТекущийОбъект, "COMКаталогИнформационнойБазы", COMКаталогИнформационнойБазы);

КонецПроцедуры

Функция НоваяСтрокаПараметровТранспорта(ТекущийОбъект, ИмяПараметра, ЗначениеПараметра)

	НоваяСтрока = ТекущийОбъект.ПараметрыТранспорта.Добавить();
	НоваяСтрока.ИмяПараметра      = ИмяПараметра;
	НоваяСтрока.ЗначениеПараметра = ЗначениеПараметра;
	Если СтрДлина(ЗначениеПараметра) > 255 Тогда
		НоваяСтрока.ЗначениеДлиннойСтрокой = Строка(ЗначениеПараметра);
	Иначе
		НоваяСтрока.ЗначениеДлиннойСтрокой = "";
	КонецЕсли; 
	
	Возврат НоваяСтрока;

КонецФункции


&НаСервере
Процедура ВыполнитьПроверкуУстановкиВнешнегоСоединения(Отказ)
	
	Возврат;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьПользователяОРезультатахПодключения(Знач ОшибкаПодключения)
	
	ТекстПредупреждения = ?(ОшибкаПодключения, НСтр("ru = 'Не удалось установить подключение.'"),
											   НСтр("ru = 'Подключение успешно установлено.'"));
	ПоказатьПредупреждение(, ТекстПредупреждения);
	
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьВнешнийРесурсЗавершение(Результат, ПараметрыЗаписи) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		ВнешниеРесурсыРазрешены = Истина;
		Записать(ПараметрыЗаписи);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РедактированиеРасписанияРегламентногоЗадания()
	
	// если расписание не инициализировано в форме на сервере, то создаем новое
	Если РасписаниеРегламентногоЗадания = Неопределено Тогда
		
		РасписаниеРегламентногоЗадания = Новый РасписаниеРегламентногоЗадания;
		
	КонецЕсли;
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РасписаниеРегламентногоЗадания);
	
	// открываем диалог для редактирования Расписания
	ОписаниеОповещения = Новый ОписаниеОповещения("РедактированиеРасписанияРегламентногоЗаданияЗавершение", ЭтотОбъект);
	Диалог.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура РедактированиеРасписанияРегламентногоЗаданияЗавершение(Расписание, ДополнительныеПараметры) Экспорт
	
	Если Расписание <> Неопределено Тогда
		
		РасписаниеРегламентногоЗадания = Расписание;
		
		ОбновитьПредставлениеРасписания();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПредставлениеРасписания()
	
	ПредставлениеРасписания = Строка(РасписаниеРегламентногоЗадания);
	
	Элементы.НастроитьРасписаниеРегламентногоЗадания.Заголовок = ПредставлениеРасписания;
	
КонецПроцедуры


&НаСервере
Функция СтруктураНастроекТранспорта()

	Результат = Новый Структура();
	Результат.Вставить("COMАутентификацияОперационнойСистемы", COMАутентификацияОперационнойСистемы);
	Результат.Вставить("COMВариантРаботыИнформационнойБазы", COMВариантРаботыИнформационнойБазы);
	Результат.Вставить("COMИмяИнформационнойБазыНаСервере1СПредприятия", COMИмяИнформационнойБазыНаСервере1СПредприятия);
	Результат.Вставить("COMИмяПользователя", Объект.ИмяПользователяНаРесурсе);
	Результат.Вставить("COMИмяСервера1СПредприятия", COMИмяСервера1СПредприятия);
	Результат.Вставить("COMКаталогИнформационнойБазы", COMКаталогИнформационнойБазы);
	Результат.Вставить("COMПарольПользователя", Объект.ПарольПользователяНаРесурсе);
	Результат.Вставить("ВидТранспортаСообщенийОбменаПоУмолчанию", Объект.ВидТранспорта);
	Результат.Вставить("КоличествоЭлементовВТранзакцииВыгрузкиДанных", Объект.КоличествоЭлементовВТранзакцииВыгрузкиДанных);
	Результат.Вставить("КоличествоЭлементовВТранзакцииЗагрузкиДанных", Объект.КоличествоЭлементовВТранзакцииЗагрузкиДанных);
	Результат.Вставить("Узел", ОбменМобильноеПриложение.ПолучитьЭтотУзел());

	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ПроверитьПодключениеCOMЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		
		Отказ = Ложь;
		
		ОчиститьСообщения();
		
		Если СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая Тогда
			
			ОбщегоНазначенияКлиент.ЗарегистрироватьCOMСоединитель(Ложь);
			
		КонецЕсли;
		
		ВыполнитьПроверкуУстановкиВнешнегоСоединения(Отказ);
		
		ОповеститьПользователяОРезультатахПодключения(Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СоздатьЗапросНаИспользованиеВнешнихРесурсов(ПараметрыПодключения)
	
	ЗапросыРазрешений = Новый Массив;
	РегистрыСведений.НастройкиТранспортаОбменаДанными.ЗапросНаИспользованиеВнешнихРесурсов(ЗапросыРазрешений, Неопределено,
		ПараметрыПодключения);
	Возврат ЗапросыРазрешений;
	
КонецФункции


#КонецОбласти


