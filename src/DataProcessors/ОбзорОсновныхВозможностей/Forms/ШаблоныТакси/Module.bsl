
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВсегоСтраниц = Элементы.ГруппаСтраницыФормы.ПодчиненныеЭлементы.Количество();
	УправлениеФормой(ЭтаФорма);
	
	
	РаботаСФормамиСправочников.ОтметитьПросмотрПодсказкиПользователем("Календарь");
	
КонецПроцедуры


&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;
	
	Если Элементы.ГруппаСтраницыФормы.ТекущаяСтраница = Неопределено Тогда
		НомерТекущейСтраницы = 1;
	Иначе
		НомерТекущейСтраницы = Число(Прав(Элементы.ГруппаСтраницыФормы.ТекущаяСтраница.Имя, 1));
	КонецЕсли; 
	Элементы.Назад.Доступность = НомерТекущейСтраницы > 1;
	Элементы.Вперед.Видимость  = НомерТекущейСтраницы < Форма.ВсегоСтраниц;
	Элементы.Закрыть.Видимость = НомерТекущейСтраницы >= Форма.ВсегоСтраниц;

КонецПроцедуры


&НаКлиенте
Процедура Назад(Команда)
	
	Если Элементы.ГруппаСтраницыФормы.ТекущаяСтраница = Неопределено Тогда
		НомерТекущейСтраницы = 1;
	Иначе
		НомерТекущейСтраницы = Число(Прав(Элементы.ГруппаСтраницыФормы.ТекущаяСтраница.Имя, 1));
	КонецЕсли; 
	Если НомерТекущейСтраницы > 1 Тогда
		НомерТекущейСтраницы = НомерТекущейСтраницы - 1;
		Элементы.ГруппаСтраницыФормы.ТекущаяСтраница = Элементы["ГруппаСтраница" + НомерТекущейСтраницы];
	КонецЕсли; 
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры


&НаКлиенте
Процедура Вперед(Команда)
	
	Если Элементы.ГруппаСтраницыФормы.ТекущаяСтраница = Неопределено Тогда
		НомерТекущейСтраницы = 1;
	Иначе
		НомерТекущейСтраницы = Число(Прав(Элементы.ГруппаСтраницыФормы.ТекущаяСтраница.Имя, 1));
	КонецЕсли; 
	Если НомерТекущейСтраницы < ВсегоСтраниц Тогда
		НомерТекущейСтраницы = НомерТекущейСтраницы + 1;
		Элементы.ГруппаСтраницыФормы.ТекущаяСтраница = Элементы["ГруппаСтраница" + НомерТекущейСтраницы];
	КонецЕсли; 
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры
 