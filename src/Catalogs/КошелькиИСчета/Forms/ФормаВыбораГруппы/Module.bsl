////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "БазоваяВалюта", Константы.ВалютаУчета.Получить());
	
	// Установка условного оформления для форм списков:
	РаботаСФормамиСправочников.УстановитьУсловноеОформлениеФормыСписка(ЭтотОбъект, "Список", Истина, , );
	
КонецПроцедуры



////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ДИНАМИЧЕСКОГО СПИСКА



////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ



////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ



