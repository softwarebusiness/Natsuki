local Players = cloneref(game:GetService("Players"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService = cloneref(game:GetService("RunService"))
local TweenService = cloneref(game:GetService("TweenService"))
local Lighting = cloneref(game:GetService("Lighting"))
local GuiService = cloneref(game:GetService("GuiService"))
local TextService = cloneref(game:GetService("TextService"))
local HttpService = cloneref(game:GetService("HttpService"))

local Env = (getgenv and getgenv()) or _G
if Env.NatsukiUI and Env.NatsukiUI.Unload then
	pcall(Env.NatsukiUI.Unload)
end

local Themes = {
	Dark = {
		Accent = Color3.fromRGB(255, 182, 193),
		Background = Color3.fromRGB(5, 5, 5),
		BackgroundTransparency = 0.08,
		Outline = Color3.fromRGB(62, 62, 62),
		Panel = Color3.fromRGB(17, 17, 17),
		PanelTransparency = 0.25,
		Element = Color3.fromRGB(11, 11, 11),
		Border = Color3.fromRGB(40, 40, 40),
		Line = Color3.fromRGB(36, 36, 36),
		Text = Color3.fromRGB(240, 240, 240),
		SubText = Color3.fromRGB(140, 140, 140),
		ValueText = Color3.fromRGB(165, 165, 165),
		Hover = Color3.fromRGB(195, 195, 195),
		KeyHover = Color3.fromRGB(72, 72, 72),
		Check = Color3.fromRGB(12, 12, 12),
		Knob = Color3.fromRGB(255, 255, 255),
		TitleStart = Color3.fromRGB(255, 255, 255),
	},
	Light = {
		Accent = Color3.fromRGB(240, 128, 155),
		Background = Color3.fromRGB(246, 246, 248),
		BackgroundTransparency = 0.08,
		Outline = Color3.fromRGB(205, 205, 212),
		Panel = Color3.fromRGB(255, 255, 255),
		PanelTransparency = 0.15,
		Element = Color3.fromRGB(236, 236, 240),
		Border = Color3.fromRGB(214, 214, 220),
		Line = Color3.fromRGB(224, 224, 229),
		Text = Color3.fromRGB(28, 28, 32),
		SubText = Color3.fromRGB(125, 125, 134),
		ValueText = Color3.fromRGB(95, 95, 104),
		Hover = Color3.fromRGB(70, 70, 78),
		KeyHover = Color3.fromRGB(170, 170, 178),
		Check = Color3.fromRGB(255, 255, 255),
		Knob = Color3.fromRGB(255, 255, 255),
		TitleStart = Color3.fromRGB(40, 40, 46),
	},
}
local Theme = table.clone(Themes.Dark)

local TextSize = 14
local FontId = "rbxassetid://12187365364"
local MainFont = Font.new(FontId, Enum.FontWeight.SemiBold)
local FontBold = Font.new(FontId, Enum.FontWeight.Bold)
local FontSymbol = Font.new("rbxasset://fonts/families/Arimo.json")

local WindowSize = Vector2.new(660, 432)
local MinWindowSize = Vector2.new(520, 320)
local TopbarHeight = 32
local BottombarHeight = 36

local Connections = {}
local Flags = {}

local function Connect(Signal, Fn)
	local C = Signal:Connect(Fn)
	table.insert(Connections, C)
	return C
end

local ThemeBindings = {}
local ThemeCallbacks = {}

local function BindTheme(Inst, Map)
	for Prop, Key in Map do
		Inst[Prop] = Theme[Key]
		table.insert(ThemeBindings, { Inst, Prop, Key })
	end
end

local function OnTheme(Fn)
	table.insert(ThemeCallbacks, Fn)
end

local function Create(Class, Props, Children)
	local Inst = Instance.new(Class)
	local Parent, ThemeMap
	for K, V in Props or {} do
		if K == "Parent" then
			Parent = V
		elseif K == "Theme" then
			ThemeMap = V
		else
			Inst[K] = V
		end
	end
	if ThemeMap then BindTheme(Inst, ThemeMap) end
	for _, Child in Children or {} do
		Child.Parent = Inst
	end
	if Parent then Inst.Parent = Parent end
	return Inst
end

local function Corner(R)
	return Create("UICorner", { CornerRadius = R == "full" and UDim.new(1, 0) or UDim.new(0, R) })
end

local function Stroke(Key)
	return Create("UIStroke", {
		Thickness = 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Theme = { Color = Key or "Border" },
	})
end

local Languages = {
	English = {},
	Russian = {
		["Combat"] = "Бой", ["Visuals"] = "Визуалы", ["Misc"] = "Разное", ["Skins"] = "Скины", ["Settings"] = "Настройки",
		["Aimbot"] = "Аимбот", ["Fov"] = "FOV", ["Checks"] = "Проверки", ["Weapon"] = "Оружие",
		["Removals"] = "Удаление", ["Modifications"] = "Модификации", ["Ragebot"] = "Ragebot",
		["ESP"] = "ESP", ["World"] = "Мир", ["Camera"] = "Камера", ["Movement"] = "Движение", ["Other"] = "Другое",
		["Crosshair"] = "Прицел", ["Viewmodel"] = "Вьюмодель", ["Chams"] = "Чамсы", ["Shoot"] = "Стрельба", ["Hit"] = "Попадания",
		["Local"] = "Локальные", ["Exploits"] = "Эксплойты", ["Menu"] = "Меню", ["Configs"] = "Конфиги",
		["Hit Notifications"] = "Уведомления о попаданиях", ["Enabled"] = "Включено",
		["Method"] = "Метод", ["Mouse"] = "Мышь", ["Redirection"] = "Перенаправление",
		["Target Bone"] = "Целевая кость", ["Head"] = "Голова", ["Torso"] = "Торс",
		["Smoothness"] = "Плавность", ["Origin Scan"] = "Скан Вектора", ["Scan Distance"] = "Дистанция скана", 
		["Scan Intensity"] = "Интенсивность скана", ["Another Scan Thread"] = "Доп. поток скана", ["Scan Indicator"] = "Индикатор скана",
		["Fov Circle"] = "Круг FOV", ["Fov Transparency"] = "Прозрачность FOV", ["Fov Fill"] = "Заливка FOV",
		["Filled Transparency"] = "Прозрачность заливки", ["Fov Gradient"] = "Градиент FOV", ["Gradient Speed"] = "Скорость градиента",
		["Snapline"] = "Снаплайн", ["Snapline Transparency"] = "Прозрачность снаплайна",
		["Visibility Check"] = "Проверка видимости", ["Team Check"] = "Проверка команды", 
		["Spawn Protection Check"] = "Проверка защиты спавна", ["Shield Check"] = "Проверка щита",
		["Custom Shoot Sound"] = "Свой звук выстрела", ["Shoot Sound"] = "Звук выстрела",
		["Bullet Tracers"] = "Трейсеры пуль", ["Transparency"] = "Прозрачность", ["Lifetime"] = "Время жизни",
		["Texture"] = "Текстура", ["Show Other Tracers"] = "Трейсеры других",
		["Hit Sound"] = "Звук попадания", ["Sound"] = "Звук", ["Remove Recoil"] = "Убрать отдачу",
		["Remove Spread"] = "Убрать разброс", ["Remove Kickback"] = "Убрать откид", ["Remove Bobbling"] = "Убрать покачивание",
		["Remove Muzzle Flash"] = "Убрать вспышку", ["Remove Slowdown"] = "Убрать замедление",
		["Instant Equip"] = "Мгновенное экипирование", ["Instant ADS"] = "Мгновенный прицел", ["Fast Reload"] = "Быстрая перезарядка",
		["Automatic"] = "Автоматический", ["RPM Modification"] = "Модификация RPM", ["RPM Multiplier"] = "Множитель RPM",
		["Ignore Fov"] = "Игнорировать FOV", ["Force Reload"] = "Форс. перезарядка",
		["Target Mode"] = "Режим цели", ["Magnitude"] = "По дистанции", ["Closest To Centre"] = "Ближайший к центру",
		["Weapon Chams"] = "Чамсы оружия", ["Weapon Transparency"] = "Прозрачность оружия", ["Weapon Material"] = "Материал оружия",
		["Arms Chams"] = "Чамсы рук", ["Arms Transparency"] = "Прозрачность рук", ["Arms Material"] = "Материал рук",
		["Custom Offset"] = "Свой сдвиг", ["Offset X"] = "Сдвиг X", ["Offset Y"] = "Сдвиг Y", ["Offset Z"] = "Сдвиг Z",
		["Custom Fov"] = "Свой FOV", ["Esp"] = "ESP", ["Box"] = "Бокс", ["Box Transparency"] = "Прозрачность бокса",
		["Box Outline"] = "Обводка бокса", ["Outline Transparency"] = "Прозрачность обводки", ["Outline Size"] = "Размер обводки",
		["Healthbar"] = "Полоска здоровья", ["Healthbar Position"] = "Позиция полоски", ["Name"] = "Имя",
		["Name Position"] = "Позиция имени", ["Name Transparency"] = "Прозрачность имени", ["Distance"] = "Дистанция",
		["Distance Position"] = "Позиция дистанции", ["Distance Transparency"] = "Прозрачность дистанции",
		["Tool"] = "Предмет", ["Tool Position"] = "Позиция предмета", ["Tool Transparency"] = "Прозрачность предмета",
		["Health"] = "Здоровье", ["Health Position"] = "Позиция здоровья", ["Health Transparency"] = "Прозрачность здоровья",
		["Skeleton"] = "Скелет", ["Skeleton Transparency"] = "Прозрачность скелета", ["Skeleton Thickness"] = "Толщина скелета",
		["Image"] = "Изображение", ["Bold Text"] = "Жирный текст", ["Ambient"] = "Окружение", ["Outdoor Ambient"] = "Улица",
		["Skybox"] = "Скайбокс", ["Global Shadows"] = "Глобальные тени", ["Crosshair"] = "Прицел", ["Spin"] = "Вращение",
		["Spin Speed"] = "Скорость вращения", ["To Target"] = "К цели", ["Size"] = "Размер", ["Gap"] = "Отступ", ["Thickness"] = "Толщина",
		["Spoof Name"] = "Подмена имени", ["Spoof Device"] = "Подмена устройства", ["Device"] = "Устройство",
		["Spoof Ping"] = "Подмена пинга", ["Ping"] = "Пинг", ["Anti-Aim"] = "Анти-аим", ["Spinbot"] = "Спинбот",
		["Spoof Angles"] = "Подмена углов", ["Angle"] = "Угол", ["Pitch"] = "Наклон", ["Pitch Value"] = "Значение наклона",
		["Instant Actions"] = "Мгновенные действия", ["Unlock All"] = "Разблокировать всё", ["Flight"] = "Полёт",
		["Flight Speed"] = "Скорость полёта", ["Instant Lean"] = "Мгновенный наклон", ["Instant Crouch"] = "Мгновенный присед",
		["Instant Prone"] = "Мгновенное положение лёжа", ["Third Person"] = "Третье лицо", ["Third Person Distance"] = "Дистанция третьего лица",
		["Menu Key"] = "Клавиша меню", ["Keybind List"] = "Список биндов", ["Dynamic Island"] = "Динамический остров",
		["Target HUD"] = "Таргет HUD", ["Theme"] = "Тема", ["Accent Color"] = "Цвет акцента", ["Language"] = "Язык",
		["UI Transparency"] = "Прозрачность интерфейса", ["Unload"] = "Выгрузить", ["Config Name"] = "Название конфига",
		["Saved Configs"] = "Сохранённые конфиги", ["Save"] = "Сохранить", ["Load"] = "Загрузить", ["Delete"] = "Удалить",
		["Refresh"] = "Обновить", ["Auto Load"] = "Автозагрузка", ["None"] = "Нет", ["No config selected"] = "Конфиг не выбран",
		["Type a name..."] = "Введите название...", ["Dark"] = "Тёмная", ["Light"] = "Светлая", ["English"] = "English",
		["Russian"] = "Русский", ["Ukranian"] = "Украинский", ["Left"] = "Слева", ["Right"] = "Справа", ["Top"] = "Сверху",
		["Bottom"] = "Снизу", ["Neon"] = "Неон", ["ForceField"] = "Силовое поле", ["Glass"] = "Стекло",
		["Laser"] = "Лазер", ["Bow"] = "Лук", ["Bubble"] = "Пузырь", ["Swirl"] = "Завихрение", ["Lightning"] = "Молния",
		["Chain"] = "Цепь", ["Glitch"] = "Глитч", ["Cheese"] = "Сыр", ["Lunar"] = "Лунный", ["Dink"] = "Динь",
		["Gamesense"] = "Gamesense", ["Rust"] = "Rust", ["Neverlose"] = "Neverlose", ["Quake"] = "Quake",
		["Among-Us"] = "Among-Us", ["Ding"] = "Динь", ["Minecraft"] = "Minecraft", ["Blackout"] = "Блэкаут", ["Osu"] = "Osu",
	},
	Ukranian = {
		["Combat"] = "Бій", ["Visuals"] = "Візуали", ["Misc"] = "Різне", ["Skins"] = "Скіни", ["Settings"] = "Налаштування",
		["Aimbot"] = "Аімбот", ["Fov"] = "FOV", ["Checks"] = "Перевірки", ["Weapon"] = "Зброя",
		["Removals"] = "Видалення", ["Modifications"] = "Модифікації", ["Ragebot"] = "Ragebot",
		["ESP"] = "ESP", ["World"] = "Світ", ["Camera"] = "Камера", ["Movement"] = "Рух", ["Other"] = "Інше",
		["Crosshair"] = "Приціл", ["Viewmodel"] = "В'юмодель", ["Chams"] = "Чамси", ["Shoot"] = "Стрільба", ["Hit"] = "Влучання",
		["Local"] = "Локальні", ["Exploits"] = "Експлойти", ["Menu"] = "Меню", ["Configs"] = "Конфіги",
		["Hit Notifications"] = "Сповіщення про влучання", ["Enabled"] = "Увімкнено",
		["Method"] = "Метод", ["Mouse"] = "Мишка", ["Redirection"] = "Перенаправлення",
		["Target Bone"] = "Цільова кістка", ["Head"] = "Голова", ["Torso"] = "Торс",
		["Smoothness"] = "Плавність", ["Origin Scan"] = "Скан початку", ["Scan Distance"] = "Дистанція скану",
		["Scan Intensity"] = "Інтенсивність скану", ["Another Scan Thread"] = "Дод. потік скану", ["Scan Indicator"] = "Індикатор скану",
		["Fov Circle"] = "Коло FOV", ["Fov Transparency"] = "Прозорість FOV", ["Fov Fill"] = "Заливка FOV",
		["Filled Transparency"] = "Прозорість заливки", ["Fov Gradient"] = "Градієнт FOV", ["Gradient Speed"] = "Швидкість градієнта",
		["Snapline"] = "Снаплайн", ["Snapline Transparency"] = "Прозорість снаплайну",
		["Visibility Check"] = "Перевірка видимості", ["Team Check"] = "Перевірка команди",
		["Spawn Protection Check"] = "Перевірка захисту спавну", ["Shield Check"] = "Перевірка щита",
		["Custom Shoot Sound"] = "Власний звук пострілу", ["Shoot Sound"] = "Звук пострілу",
		["Bullet Tracers"] = "Трейсери куль", ["Transparency"] = "Прозорість", ["Lifetime"] = "Час життя",
		["Texture"] = "Текстура", ["Show Other Tracers"] = "Трейсери інших",
		["Hit Sound"] = "Звук влучання", ["Sound"] = "Звук", ["Remove Recoil"] = "Прибрати віддачу",
		["Remove Spread"] = "Прибрати розкид", ["Remove Kickback"] = "Прибрати відкид", ["Remove Bobbling"] = "Прибрати похитування",
		["Remove Muzzle Flash"] = "Прибрати спалах", ["Remove Slowdown"] = "Прибрати уповільнення",
		["Instant Equip"] = "Миттєве спорядження", ["Instant ADS"] = "Миттєвий приціл", ["Fast Reload"] = "Швидка перезарядка",
		["Automatic"] = "Автоматичний", ["RPM Modification"] = "Модифікація RPM", ["RPM Multiplier"] = "Множник RPM",
		["Ignore Fov"] = "Ігнорувати FOV", ["Force Reload"] = "Примусова перезарядка",
		["Target Mode"] = "Режим цілі", ["Magnitude"] = "За дистанцією", ["Closest To Centre"] = "Найближчий до центру",
		["Weapon Chams"] = "Чамси зброї", ["Weapon Transparency"] = "Прозорість зброї", ["Weapon Material"] = "Матеріал зброї",
		["Arms Chams"] = "Чамси рук", ["Arms Transparency"] = "Прозорість рук", ["Arms Material"] = "Матеріал рук",
		["Custom Offset"] = "Власний зсув", ["Offset X"] = "Зсув X", ["Offset Y"] = "Зсув Y", ["Offset Z"] = "Зсув Z",
		["Custom Fov"] = "Власний FOV", ["Esp"] = "ESP", ["Box"] = "Бокс", ["Box Transparency"] = "Прозорість боксу",
		["Box Outline"] = "Обведення боксу", ["Outline Transparency"] = "Прозорість обведення", ["Outline Size"] = "Розмір обведення",
		["Healthbar"] = "Смуга здоров'я", ["Healthbar Position"] = "Позиція смуги", ["Name"] = "Ім'я",
		["Name Position"] = "Позиція імені", ["Name Transparency"] = "Прозорість імені", ["Distance"] = "Дистанція",
		["Distance Position"] = "Позиція дистанції", ["Distance Transparency"] = "Прозорість дистанції",
		["Tool"] = "Предмет", ["Tool Position"] = "Позиція предмета", ["Tool Transparency"] = "Прозорість предмета",
		["Health"] = "Здоров'я", ["Health Position"] = "Позиція здоров'я", ["Health Transparency"] = "Прозорість здоров'я",
		["Skeleton"] = "Скелет", ["Skeleton Transparency"] = "Прозорість скелета", ["Skeleton Thickness"] = "Товщина скелета",
		["Image"] = "Зображення", ["Bold Text"] = "Жирний текст", ["Ambient"] = "Оточення", ["Outdoor Ambient"] = "Вулиця",
		["Skybox"] = "Скайбокс", ["Global Shadows"] = "Глобальні тіні", ["Crosshair"] = "Приціл", ["Spin"] = "Обертання",
		["Spin Speed"] = "Швидкість обертання", ["To Target"] = "До цілі", ["Size"] = "Розмір", ["Gap"] = "Відступ", ["Thickness"] = "Товщина",
		["Spoof Name"] = "Підміна імені", ["Spoof Device"] = "Підміна пристрою", ["Device"] = "Пристрій",
		["Spoof Ping"] = "Підміна пінгу", ["Ping"] = "Пінг", ["Anti-Aim"] = "Анти-аім", ["Spinbot"] = "Спінбот",
		["Spoof Angles"] = "Підміна кутів", ["Angle"] = "Кут", ["Pitch"] = "Нахил", ["Pitch Value"] = "Значення нахилу",
		["Instant Actions"] = "Миттєві дії", ["Unlock All"] = "Розблокувати все", ["Flight"] = "Політ",
		["Flight Speed"] = "Швидкість польоту", ["Instant Lean"] = "Миттєвий нахил", ["Instant Crouch"] = "Миттєве присідання",
		["Instant Prone"] = "Миттєве положення лежачи", ["Third Person"] = "Третя особа", ["Third Person Distance"] = "Дистанція третьої особи",
		["Menu Key"] = "Клавіша меню", ["Keybind List"] = "Список біндов", ["Dynamic Island"] = "Динамічний острів",
		["Target HUD"] = "Таргет HUD", ["Theme"] = "Тема", ["Accent Color"] = "Колір акценту", ["Language"] = "Мова",
		["UI Transparency"] = "Прозорість інтерфейсу", ["Unload"] = "Вивантажити", ["Config Name"] = "Назва конфігу",
		["Saved Configs"] = "Збережені конфіги", ["Save"] = "Зберегти", ["Load"] = "Завантажити", ["Delete"] = "Видалити",
		["Refresh"] = "Оновити", ["Auto Load"] = "Автозавантаження", ["None"] = "Немає", ["No config selected"] = "Конфіг не вибрано",
		["Type a name..."] = "Введіть назву...", ["Dark"] = "Темна", ["Light"] = "Світла", ["English"] = "English",
		["Russian"] = "Російська", ["Ukranian"] = "Українська", ["Left"] = "Зліва", ["Right"] = "Справа", ["Top"] = "Зверху",
		["Bottom"] = "Знизу", ["Neon"] = "Неон", ["ForceField"] = "Силове поле", ["Glass"] = "Скло",
		["Laser"] = "Лазер", ["Bow"] = "Лук", ["Bubble"] = "Бульбашка", ["Swirl"] = "Завихрення", ["Lightning"] = "Блискавка",
		["Chain"] = "Ланцюг", ["Glitch"] = "Глітч", ["Cheese"] = "Сир", ["Lunar"] = "Місячний", ["Dink"] = "Дінь",
		["Gamesense"] = "Gamesense", ["Rust"] = "Rust", ["Neverlose"] = "Neverlose", ["Quake"] = "Quake",
		["Among-Us"] = "Among-Us", ["Ding"] = "Дінь", ["Minecraft"] = "Minecraft", ["Blackout"] = "Блекаут", ["Osu"] = "Osu",
	},
}
local Lang = { Current = "English", Bindings = {}, Callbacks = {} }

local function T(Text)
	if Text == nil then return nil end
	local Dict = Languages[Lang.Current]
	return (Dict and Dict[Text]) or Text
end

local function IsTranslatable(Text)
	return type(Text) == "string" and Languages.Russian[Text] ~= nil
end

local function Translatable(Inst, Prop, Key)
	Inst[Prop] = T(Key)
	table.insert(Lang.Bindings, { Inst, Prop, Key })
end

local function OnLanguage(Fn)
	table.insert(Lang.Callbacks, Fn)
end

local HitPartsRu = {
	Head = "голову", Torso = "торс", Arms = "руки", Legs = "ноги",
	["Left Arm"] = "левую руку", ["Right Arm"] = "правую руку",
	["Left Leg"] = "левую ногу", ["Right Leg"] = "правую ногу",
	HumanoidRootPart = "HumanoidRootPart",
}

local MonthsRu = { "янв.", "фев.", "мар.", "апр.", "мая", "июн.", "июл.", "авг.", "сен.", "окт.", "ноя.", "дек." }
local DaysRu = { "Вс", "Пн", "Вт", "Ср", "Чт", "Пт", "Сб" }

local function LongDate()
	if Lang.Current ~= "Russian" then return os.date("%b. %d, %Y") end
	local DateParts = os.date("*t")
	return string.format("%02d %s %d", DateParts.day, MonthsRu[DateParts.month], DateParts.year)
end

local function ShortDate()
	if Lang.Current ~= "Russian" then return os.date("%a, %b %d") end
	local DateParts = os.date("*t")
	return string.format("%s, %02d %s", DaysRu[DateParts.wday], DateParts.day, MonthsRu[DateParts.month])
end

local function Label(Props)
	Props.BackgroundTransparency = 1
	Props.FontFace = Props.FontFace or MainFont
	Props.TextSize = Props.TextSize or TextSize
	Props.TextXAlignment = Props.TextXAlignment or Enum.TextXAlignment.Left
	Props.TextYAlignment = Props.TextYAlignment or Enum.TextYAlignment.Center
	if Props.TextColor3 == nil and Props.Theme == nil then
		Props.Theme = { TextColor3 = Props.Color or "Text" }
	end
	Props.Color = nil
	local Key = Props.Text
	local Inst = Create("TextLabel", Props)
	if IsTranslatable(Key) then Translatable(Inst, "Text", Key) end
	return Inst
end

local function Line(Props, Children)
	Props.BorderSizePixel = 0
	if Props.BackgroundColor3 == nil and Props.Theme == nil then
		Props.Theme = { BackgroundColor3 = Props.Color or "Line" }
	end
	Props.Color = nil
	return Create("Frame", Props, Children)
end

local function Tween(Inst, Goal, Duration, Style, Direction)
	Duration = Duration or 0.2
	if Duration <= 0 then
		for K, V in Goal do Inst[K] = V end
		return
	end
	local Tw = TweenService:Create(
		Inst,
		TweenInfo.new(Duration, Style or Enum.EasingStyle.Quint, Direction or Enum.EasingDirection.Out),
		Goal
	)
	Tw:Play()
	return Tw
end

local function IsClick(Input)
	return Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch
end

local function IsMove(Input)
	return Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch
end

local function MouseLocation()
	return UserInputService:GetMouseLocation() - GuiService:GetGuiInset()
end

local function PointInFrame(Point, Frame)
	local P, FrameSize = Frame.AbsolutePosition, Frame.AbsoluteSize
	return Point.X >= P.X and Point.Y >= P.Y and Point.X <= P.X + FrameSize.X and Point.Y <= P.Y + FrameSize.Y
end

local function FormatNumber(N)
	local Formatted = string.format("%.3f", N)
	Formatted = Formatted:gsub("0+$", ""):gsub("%.$", "")
	return Formatted
end

local Icons = { Cache = {} }
local IconSource = "https://wsrv.nl/?url=api.iconify.design/lucide/%s.svg%%3Fcolor%%3Dwhite&w=64&h=64&output=png"
local IconFolder = "Natsuki/icons"
local IconNames = {
	"swords", "eye", "ellipsis", "palette", "settings", "chevron-down", "check",
	"info", "circle-check", "triangle-alert", "circle-x",
	"gauge", "wifi", "clock", "users",
}
local IconFallback = {
	swords = "x", eye = "o", ellipsis = "...", palette = "*", settings = "*",
	["chevron-down"] = "▼", check = "✓", keyboard = "#",
	info = "i", ["circle-check"] = "✓", ["triangle-alert"] = "!", ["circle-x"] = "x",
	gauge = "~", users = "@", wifi = "^", clock = "o",
}

function Icons.Get(Name)
	local Cached = Icons.Cache[Name]
	if Cached ~= nil then return Cached or nil end
	local Ok, Asset = pcall(function()
		local Path = IconFolder .. "/" .. Name .. ".png"
		if not isfile(Path) then
			local Data = game:HttpGet(IconSource:format(Name))
			assert(Data:sub(2, 4) == "PNG", "not a png")
			writefile(Path, Data)
		end
		return getcustomasset(Path)
	end)
	Icons.Cache[Name] = Ok and Asset or false
	return Ok and Asset or nil
end

do
	if makefolder and isfolder then
		pcall(function()
			if not isfolder("natsuki") then makefolder("natsuki") end
			if not isfolder(IconFolder) then makefolder(IconFolder) end
		end)
	end
	local Pending = #IconNames
	for _, Name in IconNames do
		task.spawn(function()
			Icons.Get(Name)
			Pending -= 1
		end)
	end
	local Started = os.clock()
	while Pending > 0 and os.clock() - Started < 10 do
		task.wait()
	end
end

local function Icon(Name, Size, Props)
	Props = Props or {}
	Props.Size = Props.Size or UDim2.fromOffset(Size, Size)
	Props.BackgroundTransparency = 1
	Props.ScaleType = Enum.ScaleType.Fit
	local Asset = Icons.Get(Name)
	Props.Image = Asset or ""
	local Img = Create("ImageLabel", Props)
	if not Asset then
		local Glyph = Create("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			FontFace = FontSymbol,
			TextScaled = true,
			Text = IconFallback[Name] or "?",
			Parent = Img,
		})
		local function Sync()
			Glyph.TextColor3 = Img.ImageColor3
			Glyph.TextTransparency = Img.ImageTransparency
		end
		Img:GetPropertyChangedSignal("ImageColor3"):Connect(Sync)
		Img:GetPropertyChangedSignal("ImageTransparency"):Connect(Sync)
		Sync()
	end
	return Img
end

if not isfolder("Natsuki") then makefolder("Natsuki") end
if not isfolder("Natsuki/assets") then makefolder("Natsuki/assets") end
if not isfile("Natsuki/assets/Natsuki.faggot") then
	writefile("Natsuki/assets/Natsuki.faggot", game:HttpGet("https://raw.githubusercontent.com/softwarebusiness/Natsuki/refs/heads/main/natsuki.png"))
end
if not isfile("Natsuki/assets/Monika.faggot") then
	writefile("Natsuki/assets/Monika.faggot", game:HttpGet("https://raw.githubusercontent.com/softwarebusiness/Natsuki/refs/heads/main/Monika.png"))
end
if not isfile("Natsuki/assets/Sayori.faggot") then
	writefile("Natsuki/assets/Sayori.faggot", game:HttpGet("https://raw.githubusercontent.com/softwarebusiness/Natsuki/refs/heads/main/Sayori.png"))
end
if not isfile("Natsuki/assets/Armyane.faggot") then
	writefile("Natsuki/assets/Armyane.faggot", game:HttpGet("https://raw.githubusercontent.com/softwarebusiness/Natsuki/refs/heads/main/Armyane.png"))
end
if not isfile("Natsuki/assets/Dvizuha.faggot") then
	writefile("Natsuki/assets/Dvizuha.faggot", game:HttpGet("https://raw.githubusercontent.com/softwarebusiness/Natsuki/refs/heads/main/Dvizuha.png"))
end
if not isfile("Natsuki/assets/Wypher.faggot") then
	writefile("Natsuki/assets/Wypher.faggot", game:HttpGet("https://raw.githubusercontent.com/softwarebusiness/Natsuki/refs/heads/main/Wypher.png"))
end

local EspImages = { "Natsuki", "Monika", "Sayori", "Armyane", "Dvizuha", "Wypher" }
local EspPositions = { "Top", "Bottom", "Left", "Right" }

local EspImageCache = {}
local function EspImageAsset(Name)
	if EspImageCache[Name] ~= nil then return EspImageCache[Name] or nil end
	local Ok, Asset = pcall(function()
		local Dst = "Natsuki/esp/" .. Name .. ".png"
		if not isfolder("Natsuki/esp") then makefolder("Natsuki/esp") end
		if not isfile(Dst) then writefile(Dst, readfile("Natsuki/assets/" .. Name .. ".faggot")) end
		return getcustomasset(Dst)
	end)
	EspImageCache[Name] = Ok and Asset or false
	return Ok and Asset or nil
end

local ScreenGui = Create("ScreenGui", {
	Name = "Natsuki",
	IgnoreGuiInset = true,
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	DisplayOrder = 999,
})
local Ok = pcall(function()
	ScreenGui.Parent = (gethui and gethui()) or cloneref(game:GetService("CoreGui"))
end)
if not Ok then
	ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

local Viewport = workspace.CurrentCamera.ViewportSize
local Main = Create("CanvasGroup", {
	Name = "Main",
	Position = UDim2.fromOffset(
		math.floor((Viewport.X - WindowSize.X) / 2),
		math.floor((Viewport.Y - WindowSize.Y) / 2)
	),
	Size = UDim2.fromOffset(WindowSize.X, WindowSize.Y),
	GroupTransparency = 1,
	Parent = ScreenGui,
	Theme = { BackgroundColor3 = "Background", BackgroundTransparency = "BackgroundTransparency" },
}, { Corner(8), Stroke("Outline") })
local MainScale = Create("UIScale", { Scale = 0.96, Parent = Main })

local Blur = { Enabled = true, Targets = {} }
do
	for _, D in Lighting:GetChildren() do
		if D:IsA("DepthOfFieldEffect") and D.Name == "NatsukiBlur" then
			D:Destroy()
		end
	end

	local Dof = Create("DepthOfFieldEffect", {
		Name = "NatsukiBlur",
		FarIntensity = 0,
		FocusDistance = 51.6,
		InFocusRadius = 50,
		NearIntensity = 1,
		Enabled = false,
		Parent = Lighting,
	})
	Blur.Effect = Dof

	function Blur.Add(Frame)
		local Part = Create("Part", {
			Name = "NatsukiBlurPart",
			Anchored = true,
			CanCollide = false,
			CanQuery = false,
			CanTouch = false,
			CastShadow = false,
			Material = Enum.Material.Glass,
			Transparency = 0.98,
			Color = Color3.new(0, 0, 0),
			Size = Vector3.new(1, 1, 0),
		})
		table.insert(Blur.Targets, { Frame = Frame, Part = Part })
	end

	function Blur.Remove(Frame)
		for I, Target in Blur.Targets do
			if Target.Frame == Frame then
				Target.Part:Destroy()
				table.remove(Blur.Targets, I)
				return
			end
		end
	end

	local BlurDepth = 0.5
	local function ToCameraSpace(Cam, X, Y)
		local Dir = Cam:ViewportPointToRay(X, Y + GuiService:GetGuiInset().Y, 0).Direction
		local Look = Cam.CFrame.LookVector
		local World = Cam.CFrame.Position + Dir * (BlurDepth / Dir:Dot(Look))
		return Cam.CFrame:PointToObjectSpace(World)
	end

	Connect(RunService.RenderStepped, function()
		local Cam = workspace.CurrentCamera
		local AnyActive = false
		for _, Target in Blur.Targets do
			local Frame, Part = Target.Frame, Target.Part
			if not Part or not Part.Parent and Part.Parent ~= nil then
				continue
			end
			local Active = Cam and Blur.Enabled and ScreenGui.Enabled and Frame.Visible and Frame.AbsoluteSize.Y > 1
			if not Active then
				if Part.Parent then
					pcall(function() Part.Parent = nil end)
				end
				continue
			end
			AnyActive = true
			if Part.Parent ~= Cam then
				local Ok2 = pcall(function() Part.Parent = Cam end)
				if not Ok2 then
					continue
				end
			end
			local Pos, Size = Frame.AbsolutePosition, Frame.AbsoluteSize
			local A = ToCameraSpace(Cam, Pos.X + 2, Pos.Y + 2)
			local B = ToCameraSpace(Cam, Pos.X + Size.X - 2, Pos.Y + Size.Y - 2)
			Part.Size = Vector3.new(math.abs(B.X - A.X), math.abs(B.Y - A.Y), 0)
			Part.CFrame = Cam.CFrame * CFrame.new((A.X + B.X) / 2, (A.Y + B.Y) / 2, -BlurDepth)
		end
		-- Dof.Enabled = AnyActive
	end)
end
Blur.Add(Main)

local TopBar = Create("Frame", {
	Name = "TopBar",
	Size = UDim2.new(1, 0, 0, TopbarHeight),
	BackgroundTransparency = 1,
	Parent = Main,
})
do
	local Title = Label({
		Text = "Natsuki.pink",
		FontFace = FontBold,
		TextColor3 = Color3.new(1, 1, 1),
		Position = UDim2.fromOffset(14, 0),
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.new(0, 0, 1, 0),
		Parent = TopBar,
	})
	local Gradient = Create("UIGradient", { Parent = Title })
	local function Paint()
		Gradient.Color = ColorSequence.new(Theme.TitleStart, Theme.Accent)
	end
	Paint()
	OnTheme(Paint)
end
local DateLabel = Label({
	Text = LongDate(),
	FontFace = FontBold,
	TextXAlignment = Enum.TextXAlignment.Right,
	Position = UDim2.new(0.5, 0, 0, 0),
	Size = UDim2.new(0.5, -12, 1, 0),
	Parent = TopBar,
})
Line({ Position = UDim2.new(0, 0, 1, -1), Size = UDim2.new(1, 0, 0, 1), Parent = TopBar })
OnLanguage(function() DateLabel.Text = LongDate() end)

do
	local Dragging, DragStart, StartPos
	Connect(TopBar.InputBegan, function(Input)
		if IsClick(Input) then
			Dragging, DragStart, StartPos = true, Input.Position, Main.Position
		end
	end)
	Connect(UserInputService.InputChanged, function(Input)
		if Dragging and IsMove(Input) then
			local Delta = Input.Position - DragStart
			Main.Position = UDim2.fromOffset(
				math.floor(StartPos.X.Offset + Delta.X),
				math.floor(StartPos.Y.Offset + Delta.Y)
			)
		end
	end)
	Connect(UserInputService.InputEnded, function(Input)
		if IsClick(Input) then Dragging = false end
	end)
end

local BottomBar = Create("Frame", {
	Name = "BottomBar",
	Position = UDim2.new(0, 0, 1, -BottombarHeight),
	Size = UDim2.new(1, 0, 0, BottombarHeight),
	BackgroundTransparency = 1,
	Parent = Main,
})
Line({ Size = UDim2.new(1, 0, 0, 1), Parent = BottomBar })
local TabIndicator = Line({
	Color = "Accent",
	Size = UDim2.fromOffset(0, 2),
	ZIndex = 2,
	Parent = BottomBar,
}, { Corner("full") })
local TabListLayout = Create("UIListLayout", {
	FillDirection = Enum.FillDirection.Horizontal,
	VerticalAlignment = Enum.VerticalAlignment.Center,
	Padding = UDim.new(0, 21),
	SortOrder = Enum.SortOrder.LayoutOrder,
})
local TabList = Create("Frame", {
	BackgroundTransparency = 1,
	Size = UDim2.new(1, -30, 1, 0),
	Parent = BottomBar,
}, { TabListLayout, Create("UIPadding", { PaddingLeft = UDim.new(0, 14) }) })

do
	local Grip = Create("TextButton", {
		Name = "ResizeGrip",
		Text = "",
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -14, 1, -14),
		Size = UDim2.fromOffset(14, 14),
		ZIndex = 10,
		Parent = Main,
	})
	local Dots = {}
	for _, P in { { 9, 9 }, { 5, 9 }, { 9, 5 } } do
		table.insert(Dots, Create("Frame", {
			Position = UDim2.fromOffset(P[1] - 1, P[2] - 1),
			Size = UDim2.fromOffset(2, 2),
			BorderSizePixel = 0,
			ZIndex = 10,
			Parent = Grip,
		}, { Corner("full") }))
	end
	local Hovered, Resizing = false, false
	local function Paint()
		for _, D in Dots do
			Tween(D, { BackgroundColor3 = (Hovered or Resizing) and Theme.Accent or Theme.SubText })
		end
	end
	Paint()
	OnTheme(Paint)

	local StartMouse, StartSize
	Connect(Grip.MouseEnter, function() Hovered = true; Paint() end)
	Connect(Grip.MouseLeave, function() Hovered = false; Paint() end)
	Connect(Grip.InputBegan, function(Input)
		if IsClick(Input) then
			Resizing, StartMouse, StartSize = true, Input.Position, Main.AbsoluteSize / MainScale.Scale
			Paint()
		end
	end)
	Connect(UserInputService.InputChanged, function(Input)
		if Resizing and IsMove(Input) then
			local Delta = Input.Position - StartMouse
			local MaxSize = workspace.CurrentCamera.ViewportSize - Main.AbsolutePosition
			Main.Size = UDim2.fromOffset(
				math.floor(math.clamp(StartSize.X + Delta.X, MinWindowSize.X, math.max(MinWindowSize.X, MaxSize.X))),
				math.floor(math.clamp(StartSize.Y + Delta.Y, MinWindowSize.Y, math.max(MinWindowSize.Y, MaxSize.Y)))
			)
		end
	end)
	Connect(UserInputService.InputEnded, function(Input)
		if Resizing and IsClick(Input) then
			Resizing = false
			Paint()
		end
	end)

	Flags["WindowSize"] = {
		Save = function()
			return {
				X = math.floor(Main.Size.X.Offset),
				Y = math.floor(Main.Size.Y.Offset),
			}
		end,
		Load = function(Data)
			if type(Data) == "table" and type(Data.X) == "number" and type(Data.Y) == "number" then
				Main.Size = UDim2.fromOffset(Data.X, Data.Y)
			end
		end,
	}
end

local Pages = Create("Frame", {
	Name = "Pages",
	BackgroundTransparency = 1,
	Position = UDim2.fromOffset(0, TopbarHeight),
	Size = UDim2.new(1, 0, 1, -TopbarHeight - BottombarHeight),
	ClipsDescendants = true,
	Parent = Main,
})

local Popups = {}

local function NewPopup(PopupWidth, PopupHeight)
	local Popup = {}
	local Frame = Create("CanvasGroup", {
		Size = UDim2.fromOffset(PopupWidth, PopupHeight),
		GroupTransparency = 1,
		Visible = false,
		ZIndex = 50,
		Parent = ScreenGui,
		Theme = { BackgroundColor3 = "Element" },
	}, { Corner(5), Stroke() })
	local Scale = Create("UIScale", { Scale = 0.95, Parent = Frame })
	Popup.Frame = Frame

	local Token = 0
	function Popup.Open(Anchor)
		if Popup.ClosedAnchor == Anchor and os.clock() - (Popup.ClosedAt or 0) < 0.25 then
			return false
		end
		Token += 1
		Popup.Anchor = Anchor
		local Origin = ScreenGui.AbsolutePosition
		local Screen = ScreenGui.AbsoluteSize
		local P, AnchorSize = Anchor.AbsolutePosition - Origin, Anchor.AbsoluteSize
		local X = math.max(4, P.X + AnchorSize.X - PopupWidth)
		local Y = P.Y + AnchorSize.Y + 4
		if Y + PopupHeight > Screen.Y - 4 then Y = P.Y - PopupHeight - 4 end
		Frame.Position = UDim2.fromOffset(math.floor(X), math.floor(Y))
		Frame.Visible = true
		Tween(Frame, { GroupTransparency = 0 }, 0.18)
		Tween(Scale, { Scale = 1 }, 0.18)
		return true
	end

	function Popup.Close()
		if not Frame.Visible then return end
		Token += 1
		local Current = Token
		Popup.ClosedAnchor, Popup.ClosedAt = Popup.Anchor, os.clock()
		Tween(Frame, { GroupTransparency = 1 }, 0.14)
		Tween(Scale, { Scale = 0.95 }, 0.14)
		task.delay(0.14, function()
			if Token == Current then Frame.Visible = false end
		end)
	end

	Connect(UserInputService.InputBegan, function(Input)
		if not Frame.Visible then return end
		local InputType = Input.UserInputType
		if InputType ~= Enum.UserInputType.MouseButton1 and InputType ~= Enum.UserInputType.MouseButton2 then return end
		if not PointInFrame(MouseLocation(), Frame) then Popup.Close() end
	end)

	table.insert(Popups, Popup)
	return Popup
end

local function ClosePopups()
	for _, Popup in Popups do Popup.Close() end
end

local Modes = { "Hold", "Toggle", "Always" }
local ModeMenu = { Labels = {} }
do
	local Popup = NewPopup(86, #Modes * 22 + 6)
	ModeMenu.Popup = Popup
	local Holder = Create("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Parent = Popup.Frame,
	}, {
		Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }),
		Create("UIPadding", { PaddingTop = UDim.new(0, 3), PaddingBottom = UDim.new(0, 3) }),
	})
	local Hovered
	local function Paint()
		for Mode, L in ModeMenu.Labels do
			local Color = (Mode == ModeMenu.Current and Theme.Accent) or (Mode == Hovered and Theme.Text) or Theme.SubText
			Tween(L, { TextColor3 = Color }, 0.15)
		end
	end
	OnTheme(Paint)
	for I, Mode in Modes do
		local B = Create("TextButton", {
			Text = "",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 22),
			LayoutOrder = I,
			Parent = Holder,
		})
		ModeMenu.Labels[Mode] = Label({
			Text = Mode,
			TextSize = 13,
			TextColor3 = Theme.SubText,
			Position = UDim2.fromOffset(10, 0),
			Size = UDim2.new(1, -10, 1, 0),
			Parent = B,
		})
		Connect(B.MouseEnter, function() Hovered = Mode; Paint() end)
		Connect(B.MouseLeave, function() if Hovered == Mode then Hovered = nil end; Paint() end)
		Connect(B.MouseButton1Click, function()
			ModeMenu.Current = Mode
			Paint()
			Popup.Close()
			if ModeMenu.Callback then ModeMenu.Callback(Mode) end
		end)
	end

	function ModeMenu.Open(Anchor, Current, Callback)
		ModeMenu.Current, ModeMenu.Callback = Current, Callback
		Paint()
		Popup.Open(Anchor)
	end
end

local ColorPopup = {}
do
	local PopupWidth, PopupHeight = 196, 168
	local Popup = NewPopup(PopupWidth, PopupHeight)
	ColorPopup.Popup = Popup
	local HueValue, Saturation, BrightnessValue = 0, 0, 1

	local Sv = Create("Frame", {
		Position = UDim2.fromOffset(8, 8),
		Size = UDim2.new(1, -38, 0, 122),
		BorderSizePixel = 0,
		Parent = Popup.Frame,
	}, { Corner(4) })
	Create("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		Parent = Sv,
	}, { Corner(4), Create("UIGradient", { Transparency = NumberSequence.new(0, 1) }) })
	Create("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BorderSizePixel = 0,
		ZIndex = 2,
		Parent = Sv,
	}, { Corner(4), Create("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(1, 0) }) })
	local SvCursor = Create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(8, 8),
		BackgroundTransparency = 1,
		ZIndex = 3,
		Parent = Sv,
	}, { Corner("full"), Create("UIStroke", { Color = Color3.new(1, 1, 1), Thickness = 1.5 }) })

	local HueKeys = {}
	for I = 0, 6 do
		table.insert(HueKeys, ColorSequenceKeypoint.new(I / 6, Color3.fromHSV(I / 6, 1, 1)))
	end
	local Hue = Create("Frame", {
		Position = UDim2.new(1, -22, 0, 8),
		Size = UDim2.fromOffset(14, 122),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		Parent = Popup.Frame,
	}, { Corner(4), Create("UIGradient", { Rotation = 90, Color = ColorSequence.new(HueKeys) }) })
	local HueCursor = Create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(1, 4, 0, 4),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		Parent = Hue,
	}, { Corner(2), Create("UIStroke", { Color = Color3.new(0, 0, 0), Transparency = 0.6 }) })

	local Preview = Create("Frame", {
		Position = UDim2.fromOffset(8, 138),
		Size = UDim2.fromOffset(22, 22),
		BorderSizePixel = 0,
		Parent = Popup.Frame,
	}, { Corner(4), Stroke() })
	local Hex = Create("TextBox", {
		Position = UDim2.fromOffset(36, 138),
		Size = UDim2.new(1, -44, 0, 22),
		ClearTextOnFocus = false,
		FontFace = MainFont,
		TextSize = 13,
		Text = "",
		Parent = Popup.Frame,
		Theme = { BackgroundColor3 = "Panel", TextColor3 = "Text" },
	}, { Corner(4), Stroke(), Create("UIPadding", { PaddingLeft = UDim.new(0, 7) }) })
	Hex.TextXAlignment = Enum.TextXAlignment.Left

	local function Render(Fire)
		local Color = Color3.fromHSV(HueValue, Saturation, BrightnessValue)
		Sv.BackgroundColor3 = Color3.fromHSV(HueValue, 1, 1)
		SvCursor.Position = UDim2.fromScale(Saturation, 1 - BrightnessValue)
		HueCursor.Position = UDim2.fromScale(0.5, HueValue)
		Preview.BackgroundColor3 = Color
		if not Hex:IsFocused() then Hex.Text = "#" .. Color:ToHex():upper() end
		if Fire and ColorPopup.Callback then ColorPopup.Callback(Color) end
	end

	local Mode
	local function Update()
		local Pos = MouseLocation()
		if Mode == "sv" then
			Saturation = math.clamp((Pos.X - Sv.AbsolutePosition.X) / Sv.AbsoluteSize.X, 0, 1)
			BrightnessValue = 1 - math.clamp((Pos.Y - Sv.AbsolutePosition.Y) / Sv.AbsoluteSize.Y, 0, 1)
		elseif Mode == "hue" then
			HueValue = math.clamp((Pos.Y - Hue.AbsolutePosition.Y) / Hue.AbsoluteSize.Y, 0, 1)
		end
		Render(true)
	end
	Connect(Sv.InputBegan, function(Input)
		if IsClick(Input) then Mode = "sv"; Update() end
	end)
	Connect(Hue.InputBegan, function(Input)
		if IsClick(Input) then Mode = "hue"; Update() end
	end)
	Connect(UserInputService.InputChanged, function(Input)
		if Mode and IsMove(Input) then Update() end
	end)
	Connect(UserInputService.InputEnded, function(Input)
		if IsClick(Input) then Mode = nil end
	end)
	Connect(Hex.FocusLost, function()
		local Ok2, Color = pcall(Color3.fromHex, (Hex.Text:gsub("#", "")))
		if Ok2 then
			HueValue, Saturation, BrightnessValue = Color:ToHSV()
		end
		Render(Ok2)
	end)

	function ColorPopup.Open(Anchor, Color, Callback)
		ColorPopup.Callback = nil
		HueValue, Saturation, BrightnessValue = Color:ToHSV()
		Render(false)
		if Popup.Open(Anchor) then
			ColorPopup.Callback = Callback
		end
	end
end

local function LogoBadge(Parent, Size, Position)
	local Badge = Create("Frame", {
		Position = Position,
		Size = UDim2.fromOffset(Size, Size),
		BackgroundColor3 = Color3.new(1, 1, 1),
		Parent = Parent,
	}, { Corner("full") })
	local Gradient = Create("UIGradient", { Rotation = 45, Parent = Badge })
	Label({
		Text = "N",
		FontFace = FontBold,
		TextSize = math.floor(Size * 0.55),
		TextColor3 = Color3.fromRGB(245, 245, 245),
		TextXAlignment = Enum.TextXAlignment.Center,

		Position = UDim2.fromOffset(Size < 26 and -1 or 0, Size % 2 == 1 and -1 or 0),
		Size = UDim2.fromScale(1, 1),
		Parent = Badge,
	})
	local function Paint()
		Gradient.Color = ColorSequence.new(Theme.Accent, Theme.Accent:Lerp(Color3.fromRGB(150, 40, 80), 0.45))
	end
	Paint()
	OnTheme(Paint)
	return Badge
end

local function GradientText(Props, StartKey)
	Props.FontFace = Props.FontFace or FontBold
	Props.TextColor3 = Color3.new(1, 1, 1)
	local Text = Label(Props)
	local Gradient = Create("UIGradient", { Parent = Text })
	local function Paint()
		Gradient.Color = ColorSequence.new(StartKey and Theme[StartKey] or Color3.fromRGB(245, 245, 245), Theme.Accent)
	end
	Paint()
	OnTheme(Paint)
	return Text
end

local NotifyWidth = 290
local NotifyGap = 8

local NotificationHolder = Create("Frame", {
	Name = "Notifications",
	AnchorPoint = Vector2.new(1, 1),
	Position = UDim2.new(1, -16, 1, -16),
	Size = UDim2.new(0, NotifyWidth, 1, -32),
	BackgroundTransparency = 1,
	ZIndex = 60,
	Parent = ScreenGui,
}, {
	Create("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Bottom,
	}),
})
local NotifyOrder = 0

local function Notify(Opts)
	Opts = Opts or {}
	local Duration = Opts.Duration or 4
	NotifyOrder += 1

	local Wrapper = Create("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		LayoutOrder = NotifyOrder,
		Parent = NotificationHolder,
	})
	local Content = Opts.Content or ""
	local TextHeight = 0
	if Content ~= "" then
		local Params = Instance.new("GetTextBoundsParams")
		Params.Text = Content
		Params.Font = MainFont
		Params.Size = 13
		Params.Width = NotifyWidth - 52
		local Measured, Bounds = pcall(TextService.GetTextBoundsAsync, TextService, Params)
		TextHeight = Measured and math.ceil(Bounds.Y) or 16
	end
	local CardHeight = 31 + TextHeight + 12

	local Card = Create("CanvasGroup", {
		Position = UDim2.fromOffset(NotifyWidth + 24, 0),
		Size = UDim2.new(1, 0, 0, CardHeight),
		GroupTransparency = 1,
		Parent = Wrapper,
		Theme = { BackgroundColor3 = "Background", BackgroundTransparency = "BackgroundTransparency" },
	}, { Corner(6), Stroke("Outline") })
	LogoBadge(Card, 18, UDim2.fromOffset(12, 11))
	GradientText({
		Text = "Natsuki.pink",
		AutomaticSize = Enum.AutomaticSize.X,
		Position = UDim2.fromOffset(40, 10),
		Size = UDim2.fromOffset(0, 20),
		Parent = Card,
	}, "TitleStart")
	Label({
		Text = Content,
		TextSize = 13,
		Color = "SubText",
		TextWrapped = true,
		TextYAlignment = Enum.TextYAlignment.Top,
		Position = UDim2.fromOffset(40, 31),
		Size = UDim2.new(1, -52, 0, TextHeight),
		Parent = Card,
	})
	local Progress = Create("Frame", {
		Position = UDim2.new(0, 0, 1, -2),
		Size = UDim2.new(1, 0, 0, 2),
		BorderSizePixel = 0,
		Parent = Card,
		Theme = { BackgroundColor3 = "Accent" },
	})
	local Dismiss = Create("TextButton", {
		Text = "",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 5,
		Parent = Card,
	})
	Blur.Add(Card)

	local Closed = false
	local function Close()
		if Closed then return end
		Closed = true
		Tween(Card, { Position = UDim2.fromOffset(NotifyWidth + 24, 0), GroupTransparency = 1 }, 0.3)
		task.delay(0.22, function()
			Tween(Wrapper, { Size = UDim2.new(1, 0, 0, 0) }, 0.25)
		end)
		task.delay(0.5, function()
			Blur.Remove(Card)
			Wrapper:Destroy()
		end)
	end
	Connect(Dismiss.MouseButton1Click, Close)

	task.defer(function()
		Tween(Wrapper, { Size = UDim2.new(1, 0, 0, CardHeight + NotifyGap) }, 0.3)
		Tween(Card, { Position = UDim2.fromOffset(0, 0), GroupTransparency = 0 }, 0.45)
		Tween(Progress, { Size = UDim2.new(0, 0, 0, 2) }, Duration, Enum.EasingStyle.Linear)
		task.delay(Duration, Close)
	end)
	return { Close = Close }
end

local HitHeight = 24
local HitGap = 4
local HitNotifications = { Enabled = true, Duration = 3, Max = 6, Active = {} }

local HitHolder = Create("Frame", {
	Name = "HitNotifications",
	Position = UDim2.fromOffset(16, GuiService:GetGuiInset().Y + 12),
	Size = UDim2.new(0, 500, 1, -GuiService:GetGuiInset().Y - 24),
	BackgroundTransparency = 1,
	ZIndex = 60,
	Parent = ScreenGui,
}, {
	Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }),
})
local HitOrder = 0

local function Highlight(Text)
	return string.format('<font color="#%s">%s</font>', Theme.Accent:ToHex(), tostring(Text))
end

local function HitNotify(Opts)
	if not HitNotifications.Enabled then return end
	Opts = Opts or {}
	local Text = Opts.Text
	if not Text then
		Text = T("Hit ") .. Highlight(Opts.Target or "?")
		if Opts.Part then
			local Part = Lang.Current == "Russian" and (HitPartsRu[Opts.Part] or T(Opts.Part)) or Opts.Part
			Text ..= T(" in the ") .. Highlight(Part)
		end
		if Opts.Damage then Text ..= T(" for ") .. Highlight(FormatNumber(Opts.Damage)) end
		if Opts.Health then Text ..= T(" (") .. FormatNumber(Opts.Health) .. T(" hp left)") end
	end
	local Duration = Opts.Duration or HitNotifications.Duration
	HitOrder += 1

	local Wrapper = Create("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		LayoutOrder = HitOrder,
		Parent = HitHolder,
	})
	local Card = Create("CanvasGroup", {
		Position = UDim2.fromOffset(-24, 0),
		Size = UDim2.fromOffset(0, HitHeight),
		AutomaticSize = Enum.AutomaticSize.X,
		GroupTransparency = 1,
		Parent = Wrapper,
		Theme = { BackgroundColor3 = "Background", BackgroundTransparency = "BackgroundTransparency" },
	}, {
		Corner(4),
		Stroke("Outline"),
		Create("UIPadding", { PaddingRight = UDim.new(0, 10) }),
	})
	Line({ Color = "Accent", Size = UDim2.new(0, 2, 1, 0), Parent = Card })
	Label({
		Text = Text,
		RichText = true,
		TextSize = 13,
		Position = UDim2.fromOffset(10, 0),
		Size = UDim2.new(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.X,
		Parent = Card,
	})
	local Progress = Line({
		Color = "Accent",
		Position = UDim2.new(0, 0, 1, -1),
		Size = UDim2.new(1, 10, 0, 1),
		BackgroundTransparency = 0.4,
		Parent = Card,
	})

	local Entry = {}
	local Closed = false
	function Entry.Close()
		if Closed then return end
		Closed = true
		local Index = table.find(HitNotifications.Active, Entry)
		if Index then table.remove(HitNotifications.Active, Index) end
		Tween(Card, { Position = UDim2.fromOffset(-24, 0), GroupTransparency = 1 }, 0.25)
		task.delay(0.15, function()
			Tween(Wrapper, { Size = UDim2.new(1, 0, 0, 0) }, 0.22)
		end)
		task.delay(0.4, function() Wrapper:Destroy() end)
	end
	table.insert(HitNotifications.Active, Entry)
	while #HitNotifications.Active > HitNotifications.Max do
		HitNotifications.Active[1].Close()
	end

	Tween(Wrapper, { Size = UDim2.new(1, 0, 0, HitHeight + HitGap) }, 0.25)
	Tween(Card, { Position = UDim2.fromOffset(0, 0), GroupTransparency = 0 }, 0.35)
	Tween(Progress, { Size = UDim2.new(0, 0, 0, 1) }, Duration, Enum.EasingStyle.Linear)
	task.delay(Duration, Entry.Close)
	return Entry
end

local KeyNames = {
	LeftShift = "LShift", RightShift = "RShift",
	LeftControl = "LCtrl", RightControl = "RCtrl",
	LeftAlt = "LAlt", RightAlt = "RAlt",
	Return = "Enter", CapsLock = "Caps", Backquote = "`",
	Zero = "0", One = "1", Two = "2", Three = "3", Four = "4",
	Five = "5", Six = "6", Seven = "7", Eight = "8", Nine = "9",
	MouseButton1 = "MB1", MouseButton2 = "MB2", MouseButton3 = "MB3",
}

local function KeyName(Key)
	if not Key then return "None" end
	return KeyNames[Key.Name] or Key.Name
end

local function InputMatches(Input, Key)
	if not Key then return false end
	if Key.EnumType == Enum.KeyCode then
		return Input.KeyCode == Key
	end
	return Input.UserInputType == Key
end

local KeybindList = { Entries = {} }
do
	local Frame = Create("Frame", {
		Name = "KeybindList",
		Position = UDim2.fromOffset(16, math.floor(Viewport.Y * 0.4)),
		Size = UDim2.fromOffset(200, 30),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = ScreenGui,
		Theme = { BackgroundColor3 = "Background", BackgroundTransparency = "BackgroundTransparency" },
	}, { Corner(6), Stroke("Outline") })
	local Header = Create("Frame", {
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundTransparency = 1,
		Parent = Frame,
	})
	local Keyboard = Create("Frame", {
		Position = UDim2.fromOffset(11, 9),
		Size = UDim2.fromOffset(15, 11),
		BackgroundTransparency = 1,
		Parent = Header,
	}, {
		Corner(3),
		Create("UIStroke", { Thickness = 1.2, Theme = { Color = "Accent" } }),
	})
	for Col = 0, 3 do
		Line({
			Color = "Accent",
			Position = UDim2.fromOffset(2 + Col * 3, 3),
			Size = UDim2.fromOffset(2, 2),
			Parent = Keyboard,
		})
	end
	Line({ Color = "Accent", Position = UDim2.fromOffset(4, 6), Size = UDim2.fromOffset(7, 2), Parent = Keyboard })
	Label({
		Text = "Keybinds",
		FontFace = FontBold,
		Position = UDim2.fromOffset(33, 0),
		Size = UDim2.new(1, -44, 1, 0),
		Parent = Header,
	})
	local Sep = Line({ Position = UDim2.new(0, 0, 0, 30), Size = UDim2.new(1, 0, 0, 1), Visible = false, Parent = Frame })
	local Holder = Create("Frame", {
		Position = UDim2.fromOffset(0, 31),
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Visible = false,
		Parent = Frame,
	}, {
		Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }),
		Create("UIPadding", {
			PaddingLeft = UDim.new(0, 11),
			PaddingRight = UDim.new(0, 10),
			PaddingTop = UDim.new(0, 4),
			PaddingBottom = UDim.new(0, 6),
		}),
	})
	KeybindList.Frame, KeybindList.Holder, KeybindList.Separator = Frame, Holder, Sep

	local Dragging, DragStart, StartPos
	Connect(Header.InputBegan, function(Input)
		if IsClick(Input) then
			Dragging, DragStart, StartPos = true, Input.Position, Frame.Position
		end
	end)
	Connect(UserInputService.InputChanged, function(Input)
		if Dragging and IsMove(Input) then
			local Delta = Input.Position - DragStart
			Frame.Position = UDim2.fromOffset(
				math.floor(StartPos.X.Offset + Delta.X),
				math.floor(StartPos.Y.Offset + Delta.Y)
			)
		end
	end)
	Connect(UserInputService.InputEnded, function(Input)
		if IsClick(Input) then Dragging = false end
	end)
end

local KeybindRow = 22
local KeybindListToken = 0

function KeybindList.Refresh()
	local Any = false
	for _, Entry in KeybindList.Entries do
		Entry.Update()
		if Entry.Active then Any = true end
	end
	KeybindListToken += 1
	local Token = KeybindListToken
	if Any then
		KeybindList.Holder.Visible = true
		KeybindList.Separator.Visible = true
	else
		task.delay(0.22, function()
			if Token == KeybindListToken then
				KeybindList.Holder.Visible = false
				KeybindList.Separator.Visible = false
			end
		end)
	end
end

OnLanguage(function() KeybindList.Refresh() end)

function KeybindList.Register(Name, Bind, GetState)
	local Row = Create("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		ClipsDescendants = true,
		BackgroundTransparency = 1,
		LayoutOrder = #KeybindList.Entries + 1,
		Parent = KeybindList.Holder,
	})
	local NameLabel = Label({
		Text = Name,
		TextSize = 13,
		TextTransparency = 1,
		Size = UDim2.new(1, -90, 0, KeybindRow),
		Parent = Row,
	})
	local Right = Create("Frame", {
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.fromScale(1, 0),
		Size = UDim2.fromOffset(0, KeybindRow),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		Parent = Row,
	}, {
		Create("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 7),
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
	})
	local ModeLabel = Label({
		TextSize = 12,
		Color = "SubText",
		TextTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.fromOffset(0, KeybindRow),
		LayoutOrder = 1,
		Parent = Right,
	})
	local KeyLabel = Label({
		FontFace = FontBold,
		TextSize = 12,
		Color = "Accent",
		TextTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.fromOffset(0, KeybindRow),
		LayoutOrder = 2,
		Parent = Right,
	})

	local Entry = { Active = false }
	function Entry.Update()
		local Active = Bind.Mode == "Always" or (Bind.Key ~= nil and GetState())
		KeyLabel.Text = Bind.Mode == "Always" and "-" or KeyName(Bind.Key)
		ModeLabel.Text = T(Bind.Mode)
		if Active == Entry.Active then return end
		Entry.Active = Active
		Tween(Row, { Size = UDim2.new(1, 0, 0, Active and KeybindRow or 0) }, 0.22)
		for _, L in { NameLabel, ModeLabel, KeyLabel } do
			Tween(L, { TextTransparency = Active and 0 or 1 }, 0.22)
		end
	end
	table.insert(KeybindList.Entries, Entry)
	KeybindList.Refresh()
	return Entry
end

local Watermark = {}
do
	local Stats = cloneref(game:GetService("Stats"))
	local Inset = GuiService:GetGuiInset().Y

	local Warn = Color3.fromRGB(255, 196, 92)
	local Bad = Color3.fromRGB(255, 105, 115)

	local CompactLayout = { Size = Vector2.new(380, 33), Radius = 17 }
	local ExpandedLayout = { Size = Vector2.new(330, 96), Radius = 26 }
	local FlashHeight, FlashRadius = 38, 19

	local Island = Create("Frame", {
		Name = "DynamicIsland",
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, math.max(6, math.floor(Inset / 2 - CompactLayout.Size.Y / 2) + 4)),
		Size = UDim2.fromOffset(CompactLayout.Size.X, CompactLayout.Size.Y),
		Theme = { BackgroundColor3 = "Background" },
		ClipsDescendants = true,
		Parent = ScreenGui,
	})
	local IslandCorner = Create("UICorner", { CornerRadius = UDim.new(0, CompactLayout.Radius), Parent = Island })
	local IslandScale = Create("UIScale", { Scale = 0.6, Parent = Island })
	Watermark.Frame = Island
	Blur.Add(Island)

	local Visible = false
	local function IslandTransparency()
		return Theme.BackgroundTransparency * 0.75
	end
	function Watermark.RefreshTransparency()
		if Visible then Tween(Island, { BackgroundTransparency = IslandTransparency() }, 0.2) end
	end
	OnTheme(Watermark.RefreshTransparency)

	local function StateGroup(Name)
		return Create("CanvasGroup", {
			Name = Name,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			GroupTransparency = 1,
			Parent = Island,
		})
	end

	local function Logo(Parent, Size, Position)
		return LogoBadge(Parent, Size, Position)
	end

	local function GradientTitle(Props)
		Props.Text = "Natsuki.pink"
		Props.FontFace = FontBold
		Props.TextColor3 = Color3.new(1, 1, 1)
		Props.AutomaticSize = Enum.AutomaticSize.X
		local Title = Label(Props)
		local Gradient = Create("UIGradient", { Parent = Title })
		local function Paint()
			Gradient.Color = ColorSequence.new(Theme.TitleStart, Theme.Accent)
		end
		Paint()
		OnTheme(Paint)
		return Title
	end

	local function Unit(Value, Suffix)
		return string.format('%s<font color="#%s"> %s</font>', tostring(Value), Theme.SubText:ToHex(), Suffix)
	end

	local function ReadUID()
		local E = getgenv and getgenv()
		local U = E and E.NatsukiUIDnigga
		if type(U) == "string" and U ~= "" then return U end
		if type(U) == "number" then return tostring(U) end
		return "-1"
	end
	local function ReadRank()
		local E = getgenv and getgenv()
		local R = E and E.natsukiRANKnigga
		if type(R) == "string" and R ~= "" then return R end
		if type(R) == "number" then return tostring(R) end
		return "Developer"
	end

	local CompactGroup = StateGroup("Compact")
	Logo(CompactGroup, 21, UDim2.fromOffset(6, 6))
	GradientTitle({ TextSize = 13, Position = UDim2.fromOffset(35, 0), Size = UDim2.new(0, 0, 1, 0), Parent = CompactGroup })
	local CompactStats = Label({
		RichText = true,
		FontFace = FontBold,
		TextSize = 13,
		Color = "Text",
		TextXAlignment = Enum.TextXAlignment.Right,
		Position = UDim2.new(1, -250, 0, 0),
		Size = UDim2.new(0, 238, 1, 0),
		Parent = CompactGroup,
	})

	local ExpandedGroup = StateGroup("Expanded")
	Logo(ExpandedGroup, 30, UDim2.fromOffset(14, 12))
	GradientTitle({ TextSize = 14, Position = UDim2.fromOffset(52, 12), Size = UDim2.fromOffset(0, 16), Parent = ExpandedGroup })
	Label({
		Text = Players.LocalPlayer.DisplayName,
		TextSize = 12,
		Color = "SubText",
		Position = UDim2.fromOffset(52, 28),
		Size = UDim2.fromOffset(150, 14),
		Parent = ExpandedGroup,
	})
	local Clock = Label({
		FontFace = FontBold,
		TextSize = 15,
		Color = "Text",
		TextXAlignment = Enum.TextXAlignment.Right,
		Position = UDim2.new(1, -116, 0, 12),
		Size = UDim2.fromOffset(100, 16),
		Parent = ExpandedGroup,
	})
	local IslandDate = Label({
		Text = ShortDate(),
		TextSize = 11,
		Color = "SubText",
		TextXAlignment = Enum.TextXAlignment.Right,
		Position = UDim2.new(1, -116, 0, 28),
		Size = UDim2.fromOffset(100, 14),
		Parent = ExpandedGroup,
	})
	OnLanguage(function() IslandDate.Text = ShortDate() end)

	local Blocks = Create("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(12, 54),
		Size = UDim2.new(1, -24, 0, 30),
		Parent = ExpandedGroup,
	}, {
		Create("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, 6),
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
	})
	local function StatBlock(Order, IconName, Caption)
		local Block = Create("Frame", {
			Size = UDim2.new(1 / 3, -4, 1, 0),
			Theme = { BackgroundColor3 = "Element" },
			LayoutOrder = Order,
			Parent = Blocks,
		}, { Corner(10), Create("UIStroke", { Thickness = 1, Theme = { Color = "Border" } }) })
		local Img = Icon(IconName, 13, {
			Position = UDim2.new(0, 9, 0.5, -6),
			Parent = Block,
			Theme = { ImageColor3 = "Accent" },
		})
		local Value = Label({
			FontFace = FontBold,
			TextSize = 13,
			Color = "Text",
			Position = UDim2.fromOffset(28, 0),
			Size = UDim2.new(0, 40, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			Parent = Block,
		})
		Label({
			Text = Caption,
			TextSize = 10,
			Color = "SubText",
			TextXAlignment = Enum.TextXAlignment.Right,
			Position = UDim2.new(1, -58, 0, 0),
			Size = UDim2.new(0, 50, 1, 0),
			Parent = Block,
		})
		return Value, Img
	end
	local FpsValue, FpsIcon = StatBlock(1, "gauge", "FPS")
	local PingValue, PingIcon = StatBlock(2, "wifi", "PING")
	local PlayersValue = StatBlock(3, "users", "PLAYERS")

	local Flash = StateGroup("Flash")
	local FlashIcon = Icon("circle-check", 18, {
		Position = UDim2.new(0, 10, 0.5, -9),
		Parent = Flash,
	})
	local FlashText = Label({
		FontFace = FontBold,
		TextSize = 13,
		Color = "Text",
		Position = UDim2.fromOffset(36, 0),
		Size = UDim2.new(1, -100, 1, 0),
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = Flash,
	})
	local FlashPill = Create("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -8, 0.5, 0),
		Size = UDim2.fromOffset(44, 22),
		Parent = Flash,
	}, { Corner("full") })
	local FlashPillText = Label({
		FontFace = FontBold,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Center,
		Size = UDim2.fromScale(1, 1),
		Parent = FlashPill,
	})

	local Groups = { Compact = CompactGroup, Expanded = ExpandedGroup, Flash = Flash }
	local Hovered, Flashing, FlashWidth = false, false, 200
	local Current
	local function Apply()
		local Target = (Flashing and "Flash") or (Hovered and "Expanded") or "Compact"
		if Target == Current then return end
		local Growing = Current == nil or Target ~= "Compact"
		Current = Target

		local Size, Radius
		if Target == "Flash" then
			Size, Radius = Vector2.new(FlashWidth, FlashHeight), FlashRadius
		elseif Target == "Expanded" then
			Size, Radius = ExpandedLayout.Size, ExpandedLayout.Radius
		else
			Size, Radius = CompactLayout.Size, CompactLayout.Radius
		end
		local Style = Growing and Enum.EasingStyle.Back or Enum.EasingStyle.Quint
		Tween(Island, { Size = UDim2.fromOffset(Size.X, Size.Y) }, 0.5, Style)
		Tween(IslandCorner, { CornerRadius = UDim.new(0, Radius) }, 0.5, Enum.EasingStyle.Quint)

		for Name, Group in Groups do
			if Name == Target then
				Group.Visible = true
				task.delay(0.12, function()
					if Current == Name then Tween(Group, { GroupTransparency = 0 }, 0.25) end
				end)
			else
				Tween(Group, { GroupTransparency = 1 }, 0.12)
			end
		end
	end

	Connect(RunService.RenderStepped, function()
		local Over = Island.Visible and PointInFrame(MouseLocation(), Island)
		if Over ~= Hovered then
			Hovered = Over
			Apply()
		end
	end)

	local FlashEnabled = false
	local function PaintFlash()
		FlashIcon.ImageColor3 = FlashEnabled and Theme.Accent or Theme.SubText
		FlashPill.BackgroundColor3 = FlashEnabled and Theme.Accent or Theme.Border
		FlashPillText.Text = T(FlashEnabled and "ON" or "OFF")
		FlashPillText.TextColor3 = FlashEnabled and Theme.Check or Theme.SubText
	end
	OnTheme(PaintFlash)

	local FlashToken = 0
	function Watermark.Flash(Text, Enabled)
		FlashToken += 1
		local Token = FlashToken
		local Params = Instance.new("GetTextBoundsParams")
		Params.Text = Text
		Params.Font = FontBold
		Params.Size = 13
		Params.Width = 1000
		local Ok2, Bounds = pcall(TextService.GetTextBoundsAsync, TextService, Params)
		FlashWidth = math.clamp(36 + (Ok2 and math.ceil(Bounds.X) or 100) + 70, 180, 360)

		FlashText.Text = T(Text)
		FlashIcon.Image = Icons.Get(Enabled and "circle-check" or "circle-x") or ""
		FlashEnabled = Enabled
		PaintFlash()

		if Flashing then Current = nil end
		Flashing = true
		Apply()
		task.delay(1.6, function()
			if Token == FlashToken then
				Flashing = false
				Apply()
			end
		end)
	end

	local function GetPing()
		local Ok, Ping = pcall(function() return Players.LocalPlayer:GetNetworkPing() * 1000 end)
		if Ok and Ping and Ping > 0 then return Ping end
		Ok, Ping = pcall(function()
			return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
		end)
		return Ok and Ping or 0
	end

	local Fps, Ping = 60, 0
	local function Refresh()
		Ping = math.round(GetPing())
		local Parts = {}
		table.insert(Parts, Unit(ReadUID(), T("uid")))
		table.insert(Parts, Unit(ReadRank(), T("rank")))
		table.insert(Parts, Unit(Fps, T("fps")))
		table.insert(Parts, Unit(Ping, T("ms")))
		CompactStats.Text = table.concat(Parts, "  ")
		FpsValue.Text = tostring(Fps)
		PingValue.Text = tostring(Ping)
		PlayersValue.Text = tostring(#Players:GetPlayers())
		Clock.Text = os.date("%H:%M")
		Tween(FpsIcon, { ImageColor3 = (Fps < 30 and Bad) or (Fps < 55 and Warn) or Theme.Accent }, 0.3)
		Tween(PingIcon, { ImageColor3 = (Ping > 200 and Bad) or (Ping > 100 and Warn) or Theme.Accent }, 0.3)
	end
	local Frames, Elapsed = 0, 0
	Connect(RunService.RenderStepped, function(Dt)
		Frames += 1
		Elapsed += Dt
		if Elapsed < 0.5 then return end
		Fps = math.round(Frames / Elapsed)
		Frames, Elapsed = 0, 0
		Refresh()
	end)
	Refresh()

	local VisibleToken = 0
	function Watermark.SetVisible(V)
		VisibleToken += 1
		local Token = VisibleToken
		Visible = V
		if V then
			Island.Visible = true
			Island.BackgroundTransparency = 1
			Tween(Island, { BackgroundTransparency = IslandTransparency() }, 0.25)
			Tween(IslandScale, { Scale = 1 }, 0.5, Enum.EasingStyle.Back)
			Current = nil
			Apply()
		else
			Tween(Island, { BackgroundTransparency = 1 }, 0.25)
			Tween(IslandScale, { Scale = 0.6 }, 0.3)
			for _, Group in Groups do Tween(Group, { GroupTransparency = 1 }, 0.15) end
			task.delay(0.3, function()
				if Token == VisibleToken then Island.Visible = false end
			end)
		end
	end
	Watermark.SetVisible(true)
end

local TargetHuds = {}
local TargetHud = {}
TargetHud.__index = TargetHud

local AvatarCache = {}
local function GetAvatar(UserId, Callback)
	if AvatarCache[UserId] then return Callback(AvatarCache[UserId]) end
	task.spawn(function()
		local Ok, Image = pcall(function()
			return Players:GetUserThumbnailAsync(UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
		end)
		if Ok and Image then
			AvatarCache[UserId] = Image
			Callback(Image)
		end
	end)
end

local function CreateTargetHud()
	local HudWidth, HudHeight = 260, 74
	local Inset = GuiService:GetGuiInset().Y

	local Frame = Create("CanvasGroup", {
		Name = "TargetHud",
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.new(0.5, 0, 1, -Inset - 150),
		Size = UDim2.fromOffset(HudWidth, HudHeight),
		GroupTransparency = 1,
		Visible = false,
		Parent = ScreenGui,
		Theme = { BackgroundColor3 = "Background", BackgroundTransparency = "BackgroundTransparency" },
	}, { Corner(8), Stroke("Outline") })
	local Scale = Create("UIScale", { Scale = 0.95, Parent = Frame })
	Blur.Add(Frame)

	local Avatar = Create("ImageLabel", {
		Position = UDim2.fromOffset(12, 12),
		Size = UDim2.fromOffset(50, 50),
		Parent = Frame,
		Theme = { BackgroundColor3 = "Element" },
	}, { Corner("full"), Stroke() })

	local DisplayName = Label({
		Text = "",
		FontFace = FontBold,
		Position = UDim2.fromOffset(74, 12),
		Size = UDim2.new(1, -150, 0, 16),
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = Frame,
	})
	local DistanceText = Label({
		Text = "",
		RichText = true,
		FontFace = FontBold,
		Color = "Accent",
		TextXAlignment = Enum.TextXAlignment.Right,
		Position = UDim2.new(1, -82, 0, 12),
		Size = UDim2.fromOffset(70, 16),
		Parent = Frame,
	})
	local Details = Label({
		Text = "",
		TextSize = 12,
		Color = "SubText",
		Position = UDim2.fromOffset(74, 29),
		Size = UDim2.new(1, -86, 0, 14),
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = Frame,
	})

	local Track = Create("Frame", {
		Position = UDim2.fromOffset(74, 52),
		Size = UDim2.new(1, -86, 0, 8),
		ClipsDescendants = true,
		Parent = Frame,
		Theme = { BackgroundColor3 = "Element" },
	}, { Corner("full"), Stroke() })
	local Ghost = Create("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 0.55,
		BorderSizePixel = 0,
		Parent = Track,
	}, { Corner("full") })
	local Fill = Create("Frame", {
		Size = UDim2.fromScale(1, 1),
		BorderSizePixel = 0,
		Parent = Track,
		Theme = { BackgroundColor3 = "Accent" },
	}, { Corner("full") })
	Create("UIGradient", {
		Color = ColorSequence.new(Color3.fromRGB(205, 205, 205), Color3.new(1, 1, 1)),
		Parent = Fill,
	})

	local Self = setmetatable({
		Frame = Frame,
		Target = nil,
		Visible = false,
		Shown = false,
		Connections = {},
		DisplayedHealth = 1,
		LastHealth = 1,
		Token = 0,
	}, TargetHud)
	local function Own(Connection)
		table.insert(Self.Connections, Connection)
		return Connection
	end

	local Dragging, DragStart, StartPos
	Own(Frame.InputBegan:Connect(function(Input)
		if IsClick(Input) then
			Dragging, DragStart = true, Input.Position
			StartPos = Frame.AbsolutePosition - ScreenGui.AbsolutePosition
		end
	end))
	Own(UserInputService.InputChanged:Connect(function(Input)
		if Dragging and IsMove(Input) then
			local Delta = Input.Position - DragStart
			Frame.AnchorPoint = Vector2.zero
			Frame.Position = UDim2.fromOffset(math.floor(StartPos.X + Delta.X), math.floor(StartPos.Y + Delta.Y))
		end
	end))
	Own(UserInputService.InputEnded:Connect(function(Input)
		if IsClick(Input) then Dragging = false end
	end))

	Own(RunService.RenderStepped:Connect(function(Dt)
		local ShouldShow = Self.Visible and Self.Target ~= nil and Self.Target.Parent ~= nil
		if ShouldShow ~= Self.Shown then
			Self.Shown = ShouldShow
			Self.Token += 1
			local Token = Self.Token
			if ShouldShow then Frame.Visible = true end
			Tween(Frame, { GroupTransparency = ShouldShow and 0 or 1 }, 0.25)
			Tween(Scale, { Scale = ShouldShow and 1 or 0.95 }, 0.25)
			if not ShouldShow then
				task.delay(0.25, function()
					if Token == Self.Token then Frame.Visible = false end
				end)
			end
		end
		if not Frame.Visible or not Self.Target then return end

		local Player = Self.Target
		local Character = Player.Character
		local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
		local Health = Humanoid and Humanoid.Health or 0
		local MaxHealth = Humanoid and math.max(Humanoid.MaxHealth, 1) or 100
		local Percent = math.clamp(Health / MaxHealth, 0, 1)

		Self.DisplayedHealth += (Percent - Self.DisplayedHealth) * math.min(1, Dt * 14)
		Fill.Size = UDim2.fromScale(Self.DisplayedHealth, 1)
		if Percent < Self.LastHealth - 0.001 then
			task.delay(0.35, function()
				Tween(Ghost, { Size = UDim2.fromScale(Percent, 1) }, 0.45)
			end)
		elseif Percent > Ghost.Size.X.Scale then
			Ghost.Size = UDim2.fromScale(Percent, 1)
		end
		Self.LastHealth = Percent

		local Root = Character and Character:FindFirstChild("HumanoidRootPart")
		local LocalRoot = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		local Meters = (Root and LocalRoot) and math.floor((Root.Position - LocalRoot.Position).Magnitude / 3.5714 + 0.5) or 0
		DistanceText.Text = string.format('%d<font color="#%s">m</font>', Meters, Theme.SubText:ToHex())

		local Parts = { "@" .. Player.Name }
		local Tool = Character and Character:FindFirstChildOfClass("Tool")
		if Tool then table.insert(Parts, Tool.Name) end
		Details.Text = table.concat(Parts, "  ·  ")
	end))

	function Self:SetTarget(Player)
		if Player == self.Target then return self end
		self.Target = Player
		if Player then
			DisplayName.Text = Player.DisplayName
			Avatar.Image = ""
			GetAvatar(Player.UserId, function(Image)
				if self.Target == Player then Avatar.Image = Image end
			end)
			local Humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
			local Percent = Humanoid and math.clamp(Humanoid.Health / math.max(Humanoid.MaxHealth, 1), 0, 1) or 1
			self.DisplayedHealth, self.LastHealth = Percent, Percent
			Ghost.Size = UDim2.fromScale(Percent, 1)
		end
		return self
	end

	table.insert(TargetHuds, Self)
	return Self
end

function TargetHud:SetVisible(Visible)
	self.Visible = Visible and true or false
	return self
end

function TargetHud:SetPosition(Position)
	self.Frame.AnchorPoint = Vector2.zero
	self.Frame.Position = Position
	return self
end

function TargetHud:GetTarget()
	return self.Target
end

function TargetHud:IsVisible()
	return self.Visible
end

function TargetHud:Destroy()
	for _, Connection in self.Connections do Connection:Disconnect() end
	table.clear(self.Connections)
	Blur.Remove(self.Frame)
	self.Frame:Destroy()
	local Index = table.find(TargetHuds, self)
	if Index then table.remove(TargetHuds, Index) end
end

local function EncodeKey(Key)
	if not Key then return nil end
	return Key.EnumType.Name .. "." .. Key.Name
end

local function DecodeKey(Text)
	if type(Text) ~= "string" then return nil end
	local EnumName, Item = Text:match("^(%w+)%.(%w+)$")
	if not EnumName then
		EnumName, Item = Text:match("^Enum%.(%w+)%.(%w+)$")
	end
	if not EnumName then return nil end
	local Ok, Key = pcall(function() return Enum[EnumName][Item] end)
	return Ok and Key or nil
end

local function DecodeColor(Hex, FallbackColor)
	local Ok, Color = pcall(Color3.fromHex, Hex)
	return Ok and Color or FallbackColor
end

local Container = {}
Container.__index = Container

function Container.new(Holder, Path)
	return setmetatable({ Holder = Holder, Order = 0, Path = Path or "" }, Container)
end

function Container:NextOrder()
	self.Order += 1
	return self.Order
end

function Container:Row(Height, Auto)
	return Create("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, Height),
		AutomaticSize = Auto and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
		LayoutOrder = self:NextOrder(),
		Parent = self.Holder,
	})
end

function Container:RegisterFlag(Name, Opts, Save, Load)
	if Opts.Flag == false then return end
	local Flag = Opts.Flag or (self.Path .. "/" .. Name)
	if Flags[Flag] then
		local I = 2
		while Flags[Flag .. "#" .. I] do I += 1 end
		Flag = Flag .. "#" .. I
	end
	Flags[Flag] = { Save = Save, Load = Load }
end

local function RightControls(Row)
	return Create("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(0, 18),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		Parent = Row,
	}, {
		Create("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 6),
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
	})
end

local function ColorSwatch(Parent, Color, OnChanged)
	local Current = Color
	local Swatch = Create("TextButton", {
		Size = UDim2.fromOffset(24, 13),
		BackgroundColor3 = Color,
		AutoButtonColor = false,
		Text = "",
		Parent = Parent,
	}, { Corner(3), Stroke() })
	local Scale = Create("UIScale", { Parent = Swatch })
	local function Set(NewColor)
		Current = NewColor
		Tween(Swatch, { BackgroundColor3 = NewColor }, 0.15)
		if OnChanged then OnChanged(NewColor) end
	end
	Connect(Swatch.MouseEnter, function() Tween(Scale, { Scale = 1.08 }, 0.15) end)
	Connect(Swatch.MouseLeave, function() Tween(Scale, { Scale = 1 }, 0.15) end)
	Connect(Swatch.MouseButton1Click, function()
		ColorPopup.Open(Swatch, Current, function(NewColor)
			Current = NewColor
			Swatch.BackgroundColor3 = NewColor
			if OnChanged then OnChanged(NewColor) end
		end)
	end)
	return Swatch, function() return Current end, Set
end

local function KeybindBox(Parent, Opts)
	local Bind = { Key = Opts.Default, Mode = Opts.Mode or "Toggle", Listening = false }
	local BoxStroke = Create("UIStroke", { Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border })
	local Box = Create("TextButton", {
		Size = UDim2.fromOffset(32, 18),
		AutoButtonColor = false,
		FontFace = FontBold,
		TextSize = 12,
		Text = "",
		LayoutOrder = 10,
		Parent = Parent,
		Theme = { BackgroundColor3 = "Element" },
	}, { Corner(4), BoxStroke })

	local Hovered = false
	local function Paint()
		local StrokeColor = (Bind.Listening and Theme.Accent) or (Hovered and Theme.KeyHover) or Theme.Border
		local TextColor = (Bind.Listening and Theme.Accent) or (Hovered and Theme.Text) or Theme.ValueText
		Tween(BoxStroke, { Color = StrokeColor }, 0.15)
		Tween(Box, { TextColor3 = TextColor }, 0.15)
	end
	local function Render()
		Box.Text = Bind.Listening and "..." or KeyName(Bind.Key)
		Tween(Box, { Size = UDim2.fromOffset(math.max(32, Box.TextBounds.X + 16), 18) }, 0.15)
		Paint()
	end
	Render()
	OnTheme(Paint)

	function Bind.Set(Key, Mode)
		Bind.Key = Key
		if Mode and table.find(Modes, Mode) then Bind.Mode = Mode end
		Render()
		if Opts.Changed then Opts.Changed(Key) end
	end

	Connect(Box.MouseEnter, function() Hovered = true; Paint() end)
	Connect(Box.MouseLeave, function() Hovered = false; Paint() end)
	Connect(Box.MouseButton1Click, function()
		if Bind.Listening then return end
		Bind.Listening = true
		Render()
	end)
	if Opts.Modes then
		Connect(Box.MouseButton2Click, function()
			ModeMenu.Open(Box, Bind.Mode, function(Mode)
				Bind.Mode = Mode
				if Opts.ModeChanged then Opts.ModeChanged(Mode) end
			end)
		end)
	end

	Connect(UserInputService.InputBegan, function(Input)
		if not Bind.Listening then return end
		local InputType = Input.UserInputType
		local NewKey = Bind.Key
		if InputType == Enum.UserInputType.Keyboard then
			if Input.KeyCode == Enum.KeyCode.Backspace or Input.KeyCode == Enum.KeyCode.Delete then
				NewKey = nil
			elseif Input.KeyCode ~= Enum.KeyCode.Escape then
				NewKey = Input.KeyCode
			end
		elseif InputType == Enum.UserInputType.MouseButton2 or InputType == Enum.UserInputType.MouseButton3 then
			NewKey = InputType
		elseif InputType ~= Enum.UserInputType.MouseButton1 then
			return
		end
		Bind.Key = NewKey
		task.defer(function()
			Bind.Listening = false
			Render()
		end)
		Box.Text = KeyName(NewKey)
		if Opts.Changed then Opts.Changed(NewKey) end
	end)
	return Bind
end

function Container:Toggle(Name, Opts)
	Opts = Opts or {}
	local State = false
	local Hovered = false
	local Row = self:Row(20)
	local BoxStroke = Create("UIStroke", { Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border })
	local Box = Create("Frame", {
		Position = UDim2.new(0, 0, 0.5, -9),
		Size = UDim2.fromOffset(18, 18),
		Parent = Row,
	}, { Corner(4), BoxStroke })
	local CheckScale = Create("UIScale", { Scale = 0.4 })
	local Check = Icon("check", 13, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		ImageTransparency = 1,
		Parent = Box,
		Theme = { ImageColor3 = "Check" },
	})
	CheckScale.Parent = Check

	local Text = Label({
		Text = Name,
		TextColor3 = Theme.SubText,
		Position = UDim2.fromOffset(26, 0),
		Size = UDim2.new(1, -26, 1, 0),
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = Row,
	})
	local Button = Create("TextButton", {
		Text = "",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Parent = Row,
	})
	local Right = RightControls(Row)

	local function Paint(Instant)
		local Duration = Instant and 0 or 0.2
		Tween(Box, { BackgroundColor3 = State and Theme.Accent or Theme.Element }, Duration)
		Tween(BoxStroke, { Color = State and Theme.Accent or Theme.Border }, Duration)
		Tween(Text, { TextColor3 = (State and Theme.Text) or (Hovered and Theme.Hover) or Theme.SubText }, Duration)
	end
	OnTheme(Paint)

	local function Set(Value, Silent)
		State = Value
		Paint()
		Tween(CheckScale, { Scale = Value and 1 or 0.4 }, 0.28, Value and Enum.EasingStyle.Back or Enum.EasingStyle.Quint)
		Tween(Check, { ImageTransparency = Value and 0 or 1 }, 0.18)
		KeybindList.Refresh()
		if Opts.Callback and not Silent then task.spawn(Opts.Callback, Value) end
	end
	Connect(Button.MouseButton1Click, function() Set(not State) end)
	Connect(Button.MouseEnter, function() Hovered = true; Paint() end)
	Connect(Button.MouseLeave, function() Hovered = false; Paint() end)

	local Colors = {}
	for I = 1, math.min(#(Opts.Colors or {}), 2) do
		local Swatch, Get, SetColor = ColorSwatch(Right, Opts.Colors[I], function(Color)
			if Opts.ColorChanged then task.spawn(Opts.ColorChanged, I, Color) end
		end)
		Swatch.LayoutOrder = I
		Colors[I] = { Get = Get, Set = SetColor }
	end

	local Bind
	if Opts.Key ~= nil then
		Bind = KeybindBox(Right, {
			Default = Opts.Key,
			Mode = Opts.Mode,
			Modes = true,
			Changed = function() KeybindList.Refresh() end,
			ModeChanged = function(Mode)
				if Mode == "Always" then
					Set(true)
				elseif Mode == "Hold" then
					Set(false)
				end
				KeybindList.Refresh()
			end,
		})
		Connect(UserInputService.InputBegan, function(Input, Gpe)
			if Gpe or Bind.Listening or not InputMatches(Input, Bind.Key) then return end
			if Bind.Mode == "Toggle" then
				Set(not State)
				task.spawn(Watermark.Flash, Name, State)
			elseif Bind.Mode == "Hold" then
				Set(true)
			end
		end)
		Connect(UserInputService.InputEnded, function(Input)
			if Bind.Mode == "Hold" and not Bind.Listening and InputMatches(Input, Bind.Key) then
				Set(false)
			end
		end)
		KeybindList.Register(Name, Bind, function() return State end)
	end

	self:RegisterFlag(Name, Opts, function()
		local Data = { State = State }
		if Bind then
			Data.Key = EncodeKey(Bind.Key)
			Data.Mode = Bind.Mode
		end
		if #Colors > 0 then
			Data.Colors = {}
			for I, C in Colors do Data.Colors[I] = C.Get():ToHex() end
		end
		return Data
	end, function(Data)
		if type(Data) ~= "table" then return end
		if Bind then Bind.Set(DecodeKey(Data.Key), Data.Mode) end
		for I, Hex in Data.Colors or {} do
			if Colors[I] then Colors[I].Set(DecodeColor(Hex, Colors[I].Get())) end
		end
		if type(Data.State) == "boolean" and Data.State ~= State then Set(Data.State) end
	end)

	Paint(true)
	Set(Opts.Default or false, true)
	return {
		Set = Set,
		Get = function() return State end,
		Bind = Bind,
		GetColor = function(I) return Colors[I] and Colors[I].Get() end,
	}
end

function Container:Keybind(Name, Opts)
	Opts = Opts or {}
	local Row = self:Row(20)
	Label({ Text = Name, Color = "SubText", Size = UDim2.new(1, -60, 1, 0), Parent = Row })
	local Bind = KeybindBox(RightControls(Row), { Default = Opts.Default, Changed = Opts.Changed })
	self:RegisterFlag(Name, Opts, function()
		return EncodeKey(Bind.Key)
	end, function(Value)
		Bind.Set(DecodeKey(Value))
	end)
	return Bind
end

function Container:Slider(Name, Opts)
	Opts = Opts or {}
	local Min, Max, Step = Opts.Min or 0, Opts.Max or 100, Opts.Step or 1
	local Value = Opts.Default or Min
	local Row = self:Row(31)
	Label({ Text = Name, Size = UDim2.new(1, -60, 0, 16), Parent = Row })
	local ValueText = Label({
		Text = "",
		Color = "ValueText",
		TextXAlignment = Enum.TextXAlignment.Right,
		Position = UDim2.new(1, -60, 0, 0),
		Size = UDim2.new(0, 60, 0, 16),
		Parent = Row,
	})
	local Track = Create("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.fromOffset(0, 26),
		Size = UDim2.new(1, 0, 0, 6),
		Parent = Row,
		Theme = { BackgroundColor3 = "Element" },
	}, { Corner("full"), Stroke() })
	local Fill = Create("Frame", {
		Size = UDim2.fromScale(0, 1),
		BorderSizePixel = 0,
		Parent = Track,
		Theme = { BackgroundColor3 = "Accent" },
	}, { Corner("full") })
	Create("UIGradient", {
		Color = ColorSequence.new(Color3.fromRGB(205, 205, 205), Color3.new(1, 1, 1)),
		Parent = Fill,
	})

	local function Set(V, Silent, Instant)
		V = math.clamp(math.floor((V - Min) / Step + 0.5) * Step + Min, Min, Max)
		Value = V
		local Pct = (V - Min) / (Max - Min)
		Tween(Fill, { Size = UDim2.fromScale(Pct, 1) }, Instant and 0 or 0.14)
		ValueText.Text = FormatNumber(V)
		if Opts.Callback and not Silent then task.spawn(Opts.Callback, V) end
	end

	local Dragging, Hovered = false, false
	local function KnobSize()
		local TrackHeight = (Dragging and 9) or (Hovered and 8) or 6
		Tween(Track, { Size = UDim2.new(1, 0, 0, TrackHeight) }, 0.18)
		Tween(ValueText, { TextColor3 = Dragging and Theme.Accent or Theme.ValueText }, 0.18)
	end
	OnTheme(KnobSize)
	local function Update(X)
		local Pct = math.clamp((X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
		Set(Min + (Max - Min) * Pct)
	end
	local Hit = Create("TextButton", {
		Text = "",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(-4, 16),
		Size = UDim2.new(1, 8, 0, 18),
		Parent = Row,
	})
	Connect(Hit.MouseEnter, function() Hovered = true; KnobSize() end)
	Connect(Hit.MouseLeave, function() Hovered = false; KnobSize() end)
	Connect(Hit.InputBegan, function(Input)
		if IsClick(Input) then
			Dragging = true
			KnobSize()
			Update(MouseLocation().X)
		end
	end)
	Connect(UserInputService.InputChanged, function(Input)
		if Dragging and IsMove(Input) then Update(MouseLocation().X) end
	end)
	Connect(UserInputService.InputEnded, function(Input)
		if Dragging and IsClick(Input) then
			Dragging = false
			KnobSize()
		end
	end)

	self:RegisterFlag(Name, Opts, function()
		return Value
	end, function(V)
		if type(V) == "number" then Set(V) end
	end)

	Set(Value, true, true)
	return { Set = Set, Get = function() return Value end }
end

function Container:Dropdown(Name, Opts)
	Opts = Opts or {}
	local Options = Opts.Options or {}
	local Multi = Opts.Multi
	local Value, Selected = nil, {}
	if Multi then
		for _, Opt in Opts.Default or {} do Selected[Opt] = true end
	else
		Value = Opts.Default
		if Value == nil and not Opts.Placeholder then Value = Options[1] end
	end

	local OptionHeight = 21
	local Top = Name and 19 or 0
	local ListHeight = 0
	local Row = self:Row(Top + 22, true)
	if Name then
		Label({ Text = Name, Size = UDim2.new(1, 0, 0, 16), Parent = Row })
	end
	local BoxStroke = Create("UIStroke", { Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border })
	local Box = Create("TextButton", {
		Position = UDim2.fromOffset(0, Top),
		Size = UDim2.new(1, 0, 0, 22),
		AutoButtonColor = false,
		Text = "",
		Parent = Row,
		Theme = { BackgroundColor3 = "Element" },
	}, { Corner(4), BoxStroke })
	local Current = Label({
		Text = "",
		Position = UDim2.fromOffset(7, 0),
		Size = UDim2.new(1, -30, 1, 0),
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = Box,
	})
	local Chevron = Icon("chevron-down", 14, {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -6, 0.5, 0),
		Parent = Box,
		Theme = { ImageColor3 = "SubText" },
	})

	local Clip = Create("Frame", {
		Position = UDim2.fromOffset(0, Top + 22),
		Size = UDim2.new(1, 0, 0, 0),
		ClipsDescendants = true,
		BackgroundTransparency = 1,
		Visible = false,
		Parent = Row,
	})
	local List = Create("Frame", {
		Position = UDim2.fromOffset(0, 4),
		Size = UDim2.new(1, 0, 0, 0),
		Parent = Clip,
		Theme = { BackgroundColor3 = "Element" },
	}, {
		Corner(4),
		Stroke(),
		Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }),
		Create("UIPadding", { PaddingTop = UDim.new(0, 3), PaddingBottom = UDim.new(0, 3) }),
	})

	local Open, HoveredBox, HoveredOption = false, false, nil
	local OptionWidgets = {}

	local function IsSelected(Opt)
		if Multi then return Selected[Opt] == true end
		return Value == Opt
	end

	local function SelectedValues()
		local Values = {}
		for _, Opt in Options do
			if Selected[Opt] then table.insert(Values, Opt) end
		end
		return Values
	end

	local function Display()
		if not Multi then
			if Value == nil then return T(Opts.Placeholder or "None") end
			return T(tostring(Value))
		end
		local Parts = {}
		for _, Opt in SelectedValues() do table.insert(Parts, T(tostring(Opt))) end
		return #Parts > 0 and table.concat(Parts, ", ") or T("None")
	end

	local function Paint()
		Tween(BoxStroke, { Color = (Open and Theme.Accent) or (HoveredBox and Theme.KeyHover) or Theme.Border }, 0.15)
		Current.TextColor3 = (Value == nil and not Multi) and Theme.SubText or Theme.Text
		for Opt, W in OptionWidgets do
			local Sel = IsSelected(Opt)
			Tween(W.Label, {
				TextColor3 = (Sel and Theme.Accent) or (HoveredOption == Opt and Theme.Text) or Theme.SubText,
			}, 0.15)
			if W.Check then
				W.Check.ImageColor3 = Theme.Accent
				Tween(W.Check, { ImageTransparency = Sel and 0 or 1 }, 0.15)
			end
		end
	end
	OnTheme(Paint)

	local Token = 0
	local function SetOpen(V)
		Open = V
		Token += 1
		local MyToken = Token
		if V then Clip.Visible = true end
		Tween(Clip, { Size = UDim2.new(1, 0, 0, V and ListHeight + 4 or 0) }, 0.24)
		Tween(Chevron, { Rotation = V and 180 or 0 }, 0.24)
		Paint()
		if not V then
			task.delay(0.24, function()
				if Token == MyToken then Clip.Visible = false end
			end)
		end
	end

	local function Fire()
		if not Opts.Callback then return end
		task.spawn(Opts.Callback, Multi and SelectedValues() or Value)
	end

	local function BuildOptions()
		for _, W in OptionWidgets do W.Button:Destroy() end
		table.clear(OptionWidgets)
		ListHeight = #Options * OptionHeight + 6
		List.Size = UDim2.new(1, 0, 0, ListHeight)
		for I, Opt in Options do
			local B = Create("TextButton", {
				Text = "",
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, OptionHeight),
				LayoutOrder = I,
				Parent = List,
			})
			local W = { Button = B }
			W.Label = Label({
				Text = tostring(Opt),
				TextColor3 = Theme.SubText,
				Position = UDim2.fromOffset(7, 0),
				Size = UDim2.new(1, -30, 1, 0),
				TextTruncate = Enum.TextTruncate.AtEnd,
				Parent = B,
			})
			if Multi then
				W.Check = Icon("check", 12, {
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -8, 0.5, 0),
					ImageTransparency = 1,
					Parent = B,
				})
			end
			OptionWidgets[Opt] = W
			B.MouseEnter:Connect(function() HoveredOption = Opt; Paint() end)
			B.MouseLeave:Connect(function() if HoveredOption == Opt then HoveredOption = nil end; Paint() end)
			B.MouseButton1Click:Connect(function()
				if Multi then
					Selected[Opt] = not Selected[Opt] or nil
				else
					Value = Opt
					SetOpen(false)
				end
				Current.Text = Display()
				Paint()
				Fire()
			end)
		end
		if Open then Tween(Clip, { Size = UDim2.new(1, 0, 0, ListHeight + 4) }, 0.24) end
	end
	BuildOptions()

	Connect(Box.MouseEnter, function() HoveredBox = true; Paint() end)
	Connect(Box.MouseLeave, function() HoveredBox = false; Paint() end)
	Connect(Box.MouseButton1Click, function() SetOpen(not Open) end)
	Connect(UserInputService.InputBegan, function(Input)
		if Open and Input.UserInputType == Enum.UserInputType.MouseButton1 and not PointInFrame(MouseLocation(), Row) then
			SetOpen(false)
		end
	end)

	local Api = {}
	function Api.Set(V)
		if Multi then
			Selected = {}
			for _, Opt in V or {} do Selected[Opt] = true end
		else
			Value = V
		end
		Current.Text = Display()
		Paint()
		Fire()
	end
	function Api.Get()
		if Multi then return SelectedValues() end
		return Value
	end
	function Api.SetOptions(NewOptions)
		Options = NewOptions
		if not Multi and Value ~= nil and not table.find(Options, Value) then Value = nil end
		BuildOptions()
		Current.Text = Display()
		Paint()
	end

	self:RegisterFlag(Name or "Dropdown", Opts, Api.Get, function(V)
		if Multi and type(V) == "table" then
			Api.Set(V)
		elseif not Multi and V ~= nil and table.find(Options, V) then
			Api.Set(V)
		end
	end)

	OnLanguage(function() Current.Text = Display() end)
	Current.Text = Display()
	Paint()
	return Api
end

function Container:Color(Name, Opts)
	Opts = Opts or {}
	local Row = self:Row(17)
	Label({ Text = Name, Color = "SubText", Size = UDim2.new(1, -40, 1, 0), Parent = Row })
	local _, Get, Set = ColorSwatch(RightControls(Row), Opts.Default or Color3.new(1, 1, 1), function(Color)
		if Opts.Callback then task.spawn(Opts.Callback, Color) end
	end)
	self:RegisterFlag(Name, Opts, function()
		return Get():ToHex()
	end, function(Hex)
		Set(DecodeColor(Hex, Get()))
	end)
	return { Get = Get, Set = Set }
end

function Container:Input(Name, Opts)
	Opts = Opts or {}
	local Top = Name and 19 or 0
	local Row = self:Row(Top + 22)
	if Name then
		Label({ Text = Name, Size = UDim2.new(1, 0, 0, 16), Parent = Row })
	end
	local BoxStroke = Create("UIStroke", { Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border })
	local Frame = Create("Frame", {
		Position = UDim2.fromOffset(0, Top),
		Size = UDim2.new(1, 0, 0, 22),
		Parent = Row,
		Theme = { BackgroundColor3 = "Element" },
	}, { Corner(4), BoxStroke })
	local Box = Create("TextBox", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(7, 0),
		Size = UDim2.new(1, -14, 1, 0),
		ClearTextOnFocus = false,
		FontFace = MainFont,
		TextSize = TextSize,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = Opts.Default or "",
		PlaceholderText = T(Opts.Placeholder or ""),
		Parent = Frame,
		Theme = { TextColor3 = "Text", PlaceholderColor3 = "SubText" },
	})
	if IsTranslatable(Opts.Placeholder) then Translatable(Box, "PlaceholderText", Opts.Placeholder) end
	local function Paint()
		Tween(BoxStroke, { Color = Box:IsFocused() and Theme.Accent or Theme.Border }, 0.15)
	end
	Paint()
	OnTheme(Paint)
	Connect(Box.Focused, Paint)
	Connect(Box.FocusLost, function(Enter)
		Paint()
		if Opts.Callback then task.spawn(Opts.Callback, Box.Text, Enter) end
	end)
	self:RegisterFlag(Name or "Input", Opts, function()
		return Box.Text
	end, function(Text)
		if type(Text) == "string" then Box.Text = Text end
	end)
	return {
		Get = function() return Box.Text end,
		Set = function(Text) Box.Text = Text end,
	}
end

local function MakeButton(Parent, Name, Callback, Size, Order)
	local B = Create("TextButton", {
		Size = Size,
		AutoButtonColor = false,
		FontFace = MainFont,
		TextSize = TextSize,
		Text = Name,
		LayoutOrder = Order or 0,
		Parent = Parent,
		Theme = { BackgroundColor3 = "Element" },
	}, { Corner(4) })
	if IsTranslatable(Name) then Translatable(B, "Text", Name) end
	local BStroke = Create("UIStroke", { Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = B })
	local Scale = Create("UIScale", { Parent = B })
	local Hovered = false
	local function Paint()
		Tween(B, { TextColor3 = Hovered and Theme.Accent or Theme.Text }, 0.15)
		Tween(BStroke, { Color = Hovered and Theme.Accent or Theme.Border }, 0.15)
	end
	Paint()
	OnTheme(Paint)
	Connect(B.MouseEnter, function() Hovered = true; Paint() end)
	Connect(B.MouseLeave, function() Hovered = false; Paint() end)
	Connect(B.MouseButton1Down, function() Tween(Scale, { Scale = 0.97 }, 0.1) end)
	Connect(B.MouseButton1Up, function() Tween(Scale, { Scale = 1 }, 0.15) end)
	Connect(B.MouseButton1Click, function()
		if Callback then task.spawn(Callback) end
	end)
	return B
end

function Container:Button(Name, Callback)
	MakeButton(self:Row(24), Name, Callback, UDim2.fromScale(1, 1))
end

function Container:Buttons(Buttons)
	local Gap = 6
	local Row = self:Row(24)
	Create("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		Padding = UDim.new(0, Gap),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = Row,
	})
	local N = #Buttons
	for I, B in Buttons do
		MakeButton(Row, B[1], B[2], UDim2.new(1 / N, -math.ceil(Gap * (N - 1) / N), 1, 0), I)
	end
end

function Container:Divider()
	local Row = self:Row(7)
	Line({
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(1, 0, 0, 1),
		Parent = Row,
	})
end

local ColumnPadding = 10
local ColumnPaddingTop = 6

local function ScrollingColumn(Parent, Position, Size)
	return Create("ScrollingFrame", {
		Position = Position,
		Size = Size,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 0,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Parent = Parent,
	}, {
		Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, ColumnPadding) }),
		Create("UIPadding", {
			PaddingLeft = UDim.new(0, ColumnPadding),
			PaddingRight = UDim.new(0, ColumnPadding),
			PaddingTop = UDim.new(0, ColumnPaddingTop),
			PaddingBottom = UDim.new(0, ColumnPadding),
		}),
	})
end

local Tab = {}
Tab.__index = Tab

local SectionHeader = 26
local SectionPaddingTop, SectionPaddingBottom = 10, 11
local SectionInset = 12

function Tab:Section(Title, Side)
	self.SectionOrder += 1
	local Frame = Create("Frame", {
		Size = UDim2.new(1, 0, 0, SectionHeader),
		ClipsDescendants = true,
		LayoutOrder = self.SectionOrder,
		Parent = Side == "Left" and self.LeftScroll or self.RightScroll,
		Theme = { BackgroundColor3 = "Panel", BackgroundTransparency = "PanelTransparency" },
	}, { Corner(5), Stroke() })
	local Header = Create("TextButton", {
		Text = "",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, SectionHeader),
		Parent = Frame,
	})
	Label({ Text = Title, Position = UDim2.fromOffset(SectionInset, 0), Size = UDim2.new(1, -40, 1, 0), Parent = Header })
	local Chevron = Icon("chevron-down", 15, {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -SectionInset + 2, 0.5, 0),
		Parent = Header,
		Theme = { ImageColor3 = "Text" },
	})
	Line({
		Color = "Border",
		Position = UDim2.fromOffset(0, SectionHeader),
		Size = UDim2.new(1, 0, 0, 1),
		Parent = Frame,
	})
	local Layout = Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8) })
	local Holder = Create("Frame", {
		Position = UDim2.fromOffset(0, SectionHeader + 1),
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Parent = Frame,
	}, {
		Layout,
		Create("UIPadding", {
			PaddingLeft = UDim.new(0, SectionInset),
			PaddingRight = UDim.new(0, SectionInset),
			PaddingTop = UDim.new(0, SectionPaddingTop),
			PaddingBottom = UDim.new(0, SectionPaddingBottom),
		}),
	})

	local Open, Animating = true, false
	local function TargetHeight()
		if not Open then return SectionHeader end
		local Content = math.round(Layout.AbsoluteContentSize.Y / MainScale.Scale)
		return SectionHeader + 1 + Content + SectionPaddingTop + SectionPaddingBottom
	end
	Connect(Layout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		if not Animating then Frame.Size = UDim2.new(1, 0, 0, TargetHeight()) end
	end)
	Connect(Header.MouseButton1Click, function()
		Open = not Open
		Animating = true
		Tween(Frame, { Size = UDim2.new(1, 0, 0, TargetHeight()) }, 0.3)
		Tween(Chevron, { Rotation = Open and 0 or -90 }, 0.3)
		task.delay(0.3, function()
			Animating = false
			Frame.Size = UDim2.new(1, 0, 0, TargetHeight())
		end)
	end)
	return Container.new(Holder, self.Name .. "/" .. Title)
end

local Window = { Tabs = {}, ActiveTab = nil }

local function MoveTabIndicator(Instant)
	local TabObject = Window.ActiveTab
	if not TabObject then return end
	local Scale = MainScale.Scale
	local X = (TabObject.Button.AbsolutePosition.X - BottomBar.AbsolutePosition.X) / Scale
	local W = TabObject.Button.AbsoluteSize.X / Scale
	Tween(TabIndicator, {
		Position = UDim2.fromOffset(math.round(X), 0),
		Size = UDim2.fromOffset(math.round(W), 2),
	}, Instant and 0 or 0.35)
end
Connect(TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function() MoveTabIndicator(true) end)

function Window:PaintTabs()
	for _, OtherTab in self.Tabs do
		local Color = (OtherTab == self.ActiveTab and Theme.Accent) or (OtherTab.Hovered and Theme.Hover) or Theme.Text
		Tween(OtherTab.Label, { TextColor3 = Color }, 0.2)
		Tween(OtherTab.Icon, { ImageColor3 = Color }, 0.2)
	end
end
OnTheme(function() Window:PaintTabs() end)

function Window:SelectTab(TabObject)
	if self.ActiveTab == TabObject then return end
	local Previous = self.ActiveTab
	self.ActiveTab = TabObject
	self:PaintTabs()
	MoveTabIndicator(Previous == nil)
	if Previous then Previous.Page.Visible = false end
	ClosePopups()

	local Page = TabObject.Page
	Page.Visible = true
	Page.GroupTransparency = 1
	Page.Position = UDim2.fromOffset(0, 10)
	Tween(Page, { GroupTransparency = 0, Position = UDim2.fromOffset(0, 0) }, 0.32)
end

local TabIcons = { Combat = "swords", Visuals = "eye", Misc = "ellipsis", Skins = "palette", Settings = "settings" }

function Window:Tab(Name)
	local TabObject = setmetatable({ Name = Name, SectionOrder = 0, Hovered = false }, Tab)

	TabObject.Button = Create("TextButton", {
		Text = "",
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.new(0, 0, 1, 0),
		LayoutOrder = #self.Tabs + 1,
		Parent = TabList,
	}, {
		Create("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 8),
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
	})
	TabObject.Icon = Icon(TabIcons[Name] or "ellipsis", 16, {
		ImageColor3 = Theme.Text,
		LayoutOrder = 1,
		Parent = TabObject.Button,
	})
	TabObject.Label = Label({
		Text = Name,
		FontFace = FontBold,
		TextColor3 = Theme.Text,
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.new(0, 0, 1, 0),
		LayoutOrder = 2,
		Parent = TabObject.Button,
	})

	TabObject.Page = Create("CanvasGroup", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Visible = false,
		Parent = Pages,
	})
	TabObject.LeftScroll = ScrollingColumn(TabObject.Page, UDim2.new(), UDim2.new(0.5, 0, 1, 0))
	Line({
		Position = UDim2.fromScale(0.5, 0),
		Size = UDim2.new(0, 1, 1, 0),
		Parent = TabObject.Page,
	})
	TabObject.RightScroll = ScrollingColumn(TabObject.Page, UDim2.new(0.5, 1, 0, 0), UDim2.new(0.5, -1, 1, 0))

	Connect(TabObject.Button.MouseButton1Click, function() Window:SelectTab(TabObject) end)
	Connect(TabObject.Button.MouseEnter, function() TabObject.Hovered = true; Window:PaintTabs() end)
	Connect(TabObject.Button.MouseLeave, function() TabObject.Hovered = false; Window:PaintTabs() end)
	table.insert(self.Tabs, TabObject)
	if not self.ActiveTab then self:SelectTab(TabObject) else self:PaintTabs() end
	return TabObject
end

local function RefreshTheme(Duration)
	for _, Binding in ThemeBindings do
		Tween(Binding[1], { [Binding[2]] = Theme[Binding[3]] }, Duration or 0.3)
	end
	for _, Fn in ThemeCallbacks do Fn() end
end

local function ApplyTheme(Name)
	local Palette = Themes[Name]
	if not Palette then return end
	for K, V in Palette do Theme[K] = V end
	RefreshTheme()
	Notify({ Content = T("%s mode applied."):format(T(Name)), Duration = 2.5 })
end

local function SetLanguage(Name)
	if not Languages[Name] or Name == Lang.Current then return end
	Lang.Current = Name
	for _, Binding in Lang.Bindings do
		Binding[1][Binding[2]] = T(Binding[3])
	end
	for _, Fn in Lang.Callbacks do Fn() end
	Notify({ Content = T("Language set to English."), Duration = 2.5 })
end

local PendingAccent
local function SetAccent(Color)
	local Scheduled = PendingAccent ~= nil
	PendingAccent = Color
	if Scheduled then return end
	task.defer(function()
		RunService.RenderStepped:Wait()
		local Accent = PendingAccent
		PendingAccent = nil
		for _, Palette in Themes do Palette.Accent = Accent end
		Theme.Accent = Accent
		RefreshTheme(0.15)
	end)
end

local ConfigFolder = "Natsuki/configs"
local AutoloadFile = "Natsuki/autoload.txt"
local Config = {}

pcall(function()
	if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end
end)

local function ConfigPath(Name)
	return ConfigFolder .. "/" .. Name .. ".json"
end

function Config.Sanitize(Name)
	Name = tostring(Name or ""):gsub("[^%w%-_ ]", "")
	return (Name:gsub("^%s+", ""):gsub("%s+$", ""))
end

function Config.List()
	local Names = {}
	local Ok, Files = pcall(listfiles, ConfigFolder)
	if not Ok then return Names end
	for _, Path in Files do
		local Name = Path:match("([^/\\]+)%.json$")
		if Name then table.insert(Names, Name) end
	end
	table.sort(Names, function(A, B) return A:lower() < B:lower() end)
	return Names
end

function Config.Save(Name)
	local Data = {}
	for Flag, Entry in Flags do
		local Ok, Value = pcall(Entry.Save)
		if Ok and Value ~= nil then Data[Flag] = Value end
	end
	writefile(ConfigPath(Name), HttpService:JSONEncode({ Version = 1, Flags = Data }))
end

function Config.Load(Name)
	local Decoded = HttpService:JSONDecode(readfile(ConfigPath(Name)))
	local Failed = 0
	for Flag, Value in Decoded.Flags or {} do
		local Entry = Flags[Flag]
		if Entry and not pcall(Entry.Load, Value) then Failed += 1 end
	end
	return Failed
end

function Config.Delete(Name)
	delfile(ConfigPath(Name))
end

function Config.Exists(Name)
	return Name ~= "" and isfile(ConfigPath(Name))
end

function Config.GetAutoload()
	local Ok, Name = pcall(readfile, AutoloadFile)
	return Ok and Name ~= "" and Name or nil
end

function Config.SetAutoload(Name)
	if Name then
		writefile(AutoloadFile, Name)
	elseif isfile(AutoloadFile) then
		delfile(AutoloadFile)
	end
end

function Config.SetFolder(Path)
	if type(Path) ~= "string" or Path == "" then return end
	ConfigFolder = Path
	AutoloadFile = Path .. "/autoload.txt"
	pcall(function()
		if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end
	end)
end

local function SetBlurStrength(Percent)
	Blur.Effect.NearIntensity = math.clamp(Percent / 100, 0, 1)
end

local function SetTransparency(Percent)
	local Value = math.clamp(Percent / 100, 0, 0.95)
	for _, Palette in Themes do Palette.BackgroundTransparency = Value end
	Theme.BackgroundTransparency = Value
	for _, Binding in ThemeBindings do
		if Binding[3] == "BackgroundTransparency" then
			Tween(Binding[1], { [Binding[2]] = Value }, 0.2)
		end
	end
	Watermark.RefreshTransparency()
end

local MenuKey = Enum.KeyCode.RightShift
local MenuOpen = false
local MenuToken = 0

local function SetMenuOpen(V)
	MenuOpen = V
	MenuToken += 1
	local Token = MenuToken
	if V then
		Main.Visible = true
		Tween(Main, { GroupTransparency = 0 }, 0.28)
		Tween(MainScale, { Scale = 1 }, 0.28)
	else
		ClosePopups()
		Tween(Main, { GroupTransparency = 1 }, 0.2)
		Tween(MainScale, { Scale = 0.96 }, 0.2)
		task.delay(0.2, function()
			if Token == MenuToken then Main.Visible = false end
		end)
	end
end

Connect(UserInputService.InputBegan, function(Input, Gpe)
	if not Gpe and InputMatches(Input, MenuKey) then
		SetMenuOpen(not MenuOpen)
	end
end)

local EspSettings = {
	Enabled = false,
	Bold_Text = false,
	Team_Check = false,
	Self_Esp = false,
	Visible_Check = false,
	Maximal_Distance = 3000,
	Box = { Enabled = false, Color = Color3.new(1, 1, 1), Transparency = 0 },
	Box_Outline = { Enabled = false, Color = Color3.new(0, 0, 0), Transparency = 0, Outline_Size = 1 },
	Healthbar = { Enabled = false, Position = "Left", Color = Color3.new(1, 1, 1), Color_Lerp = Color3.fromRGB(222, 123, 241) },
	Name = { Enabled = false, Position = "Top", Color = Color3.new(1, 1, 1), Transparency = 0, OutlineColor = Color3.new(0, 0, 0) },
	Distance = { Enabled = false, Position = "Bottom", Color = Color3.new(1, 1, 1), Transparency = 0, OutlineColor = Color3.new(0, 0, 0) },
	Tool = { Enabled = false, Position = "Right", Color = Color3.new(1, 1, 1), Transparency = 0, OutlineColor = Color3.new(0, 0, 0) },
	Health = { Enabled = false, Position = "Right", Transparency = 0, OutlineColor = Color3.new(0, 0, 0) },
	Skeleton = { Enabled = false, Color = Color3.new(1, 1, 1), Transparency = 0, Thickness = 1 },
	Image = { Enabled = false, Image = "Natsuki" },
}

local function Unload()
	for _, C in Connections do C:Disconnect() end
	table.clear(Connections)
	pcall(function() cloneref(game:GetService("ContextActionService")):UnbindAction("NatsukiPreviewZoom") end)
	for _, Hud in table.clone(TargetHuds) do pcall(Hud.Destroy, Hud) end
	for _, Target in Blur.Targets do Target.Part:Destroy() end
	if Blur.Effect then Blur.Effect:Destroy() end
	ScreenGui:Destroy()
	Env.NatsukiUI = nil
end

local EspSkeleton = {
	R15 = {
		{ "Head", Vector3.zero, "UpperTorso", Vector3.zero },
		{ "UpperTorso", Vector3.zero, "LowerTorso", Vector3.zero },
		{ "UpperTorso", Vector3.zero, "LeftUpperArm", Vector3.zero },
		{ "LeftUpperArm", Vector3.zero, "LeftLowerArm", Vector3.zero },
		{ "LeftLowerArm", Vector3.zero, "LeftHand", Vector3.zero },
		{ "UpperTorso", Vector3.zero, "RightUpperArm", Vector3.zero },
		{ "RightUpperArm", Vector3.zero, "RightLowerArm", Vector3.zero },
		{ "RightLowerArm", Vector3.zero, "RightHand", Vector3.zero },
		{ "LowerTorso", Vector3.zero, "LeftUpperLeg", Vector3.zero },
		{ "LeftUpperLeg", Vector3.zero, "LeftLowerLeg", Vector3.zero },
		{ "LeftLowerLeg", Vector3.zero, "LeftFoot", Vector3.zero },
		{ "LowerTorso", Vector3.zero, "RightUpperLeg", Vector3.zero },
		{ "RightUpperLeg", Vector3.zero, "RightLowerLeg", Vector3.zero },
		{ "RightLowerLeg", Vector3.zero, "RightFoot", Vector3.zero },
	},
	R6 = {
		{ "Head", Vector3.new(0, -0.5, 0), "Torso", Vector3.new(0, 1, 0) },
		{ "Torso", Vector3.new(0, 1, 0), "Torso", Vector3.new(0, -1, 0) },
		{ "Torso", Vector3.zero, "Left Arm", Vector3.new(0, 1, 0) },
		{ "Torso", Vector3.zero, "Right Arm", Vector3.new(0, 1, 0) },
		{ "Left Arm", Vector3.new(0, 1, 0), "Left Arm", Vector3.new(0, -1, 0) },
		{ "Right Arm", Vector3.new(0, 1, 0), "Right Arm", Vector3.new(0, -1, 0) },
		{ "Torso", Vector3.new(0, -1, 0), "Left Leg", Vector3.new(0, 1, 0) },
		{ "Torso", Vector3.new(0, -1, 0), "Right Leg", Vector3.new(0, 1, 0) },
		{ "Left Leg", Vector3.new(0, 1, 0), "Left Leg", Vector3.new(0, -1, 0) },
		{ "Right Leg", Vector3.new(0, 1, 0), "Right Leg", Vector3.new(0, -1, 0) },
	},
	ViewModel = {
		{ "torso", Vector3.zero, "head", Vector3.zero },
		{ "torso", Vector3.zero, "shoulder1", Vector3.zero },
		{ "shoulder1", Vector3.zero, "arm1", Vector3.zero },
		{ "torso", Vector3.zero, "shoulder2", Vector3.zero },
		{ "shoulder2", Vector3.zero, "arm2", Vector3.zero },
		{ "torso", Vector3.zero, "hip1", Vector3.zero },
		{ "hip1", Vector3.zero, "leg1", Vector3.zero },
		{ "torso", Vector3.zero, "hip2", Vector3.zero },
		{ "hip2", Vector3.zero, "leg2", Vector3.zero },
	},
}

local function DetectRig(Model)
	if Model:FindFirstChild("UpperTorso") and Model:FindFirstChild("LowerTorso") then
		return "R15"
	end
	if Model:FindFirstChild("Torso") and Model:FindFirstChild("Head") then
		return "R6"
	end
	if Model:FindFirstChild("torso") and Model:FindFirstChild("head")
		and (Model:FindFirstChild("leg1") or Model:FindFirstChild("leg2")) then
		return "ViewModel"
	end
	return "Custom"
end

local CachedEnt, LastEntScan = nil, 0
local function GetEntityLibrary()
	local Now = os.clock()
	if CachedEnt ~= nil and (CachedEnt or Now - LastEntScan < 5) then
		return CachedEnt or nil
	end
	LastEntScan = Now
	local Found
	local Ok = pcall(function()
		for _, M in getloadedmodules() do
			local Ok2, R = pcall(require, M)
			if Ok2 and typeof(R) == "table"
				and typeof(R.GetEntity) == "function"
				and typeof(R.GetAllCategoryEntities) == "function" then
				Found = R
				break
			end
		end
	end)
	CachedEnt = (Ok and Found) or nil
	return CachedEnt
end

local function HasRealParts(Model)
	if not Model then return false end
	for _, D in Model:GetDescendants() do
		if D:IsA("BasePart") and D.Size.Magnitude > 0.05 then
			return true
		end
	end
	return false
end

local function BuildEspPreviewWindow(S, VisualsTab)
	local PreviewWidth, Gap = 250, 10
	local PreviewDistance = "24m"
	local TextSizeEsp, TextStep = 12, 13
	local CameraDistance, CameraFov = 12.5, 40

	local PreviewWindow = Create("CanvasGroup", {
		Name = "EspPreview",
		Size = UDim2.fromOffset(PreviewWidth, WindowSize.Y),
		GroupTransparency = 1,
		Visible = false,
		Parent = ScreenGui,
		Theme = { BackgroundColor3 = "Background", BackgroundTransparency = "BackgroundTransparency" },
	}, { Corner(8), Stroke("Outline") })
	Blur.Add(PreviewWindow)

	local Header = Create("Frame", {
		Size = UDim2.new(1, 0, 0, TopbarHeight),
		BackgroundTransparency = 1,
		Parent = PreviewWindow,
	})
	Icon("eye", 15, {
		Position = UDim2.new(0, 14, 0.5, -7),
		Parent = Header,
		Theme = { ImageColor3 = "Accent" },
	})
	Label({
		Text = "ESP Preview",
		FontFace = FontBold,
		Position = UDim2.fromOffset(36, 0),
		Size = UDim2.new(1, -48, 1, 0),
		Parent = Header,
	})
	Line({ Position = UDim2.new(0, 0, 1, -1), Size = UDim2.new(1, 0, 0, 1), Parent = Header })

	local Canvas = Create("Frame", {
		Position = UDim2.fromOffset(ColumnPadding, TopbarHeight + ColumnPaddingTop),
		Size = UDim2.new(1, -ColumnPadding * 2, 1, -TopbarHeight - ColumnPaddingTop - ColumnPadding),
		ClipsDescendants = true,
		Active = true,
		Parent = PreviewWindow,
		Theme = { BackgroundColor3 = "Element" },
	}, { Corner(6), Stroke() })

	local ViewportFrame = Create("ViewportFrame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Ambient = Color3.fromRGB(170, 170, 175),
		LightColor = Color3.fromRGB(255, 255, 255),
		LightDirection = Vector3.new(-1, -1, -1),
		Parent = Canvas,
	})
	local Camera = Create("Camera", { FieldOfView = CameraFov, Parent = ViewportFrame })
	ViewportFrame.CurrentCamera = Camera

	local Overlay = Create("CanvasGroup", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 2,
		Parent = Canvas,
	})
	local function RectFrame(Z)
		return Create("Frame", { BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = Z, Parent = Overlay })
	end
	local Image = Create("ImageLabel", { BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Stretch, ZIndex = 1, Parent = Overlay })
	local OutlineOuter, OutlineInner, Box = RectFrame(2), RectFrame(2), RectFrame(3)
	local OutlineOuterStroke = Create("UIStroke", { Thickness = 1, Parent = OutlineOuter })
	local OutlineInnerStroke = Create("UIStroke", { Thickness = 1, Parent = OutlineInner })
	local BoxStroke = Create("UIStroke", { Thickness = 1, Parent = Box })
	local HbOutline = Create("Frame", { BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, ZIndex = 4, Parent = Overlay })
	local HbFill = Create("Frame", { BorderSizePixel = 0, ZIndex = 5, Parent = Overlay })
	local Bones = {}
	for I = 1, #EspSkeleton.R15 do
		Bones[I] = Create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), BorderSizePixel = 0, ZIndex = 6, Parent = Overlay })
	end
	local Texts = {}
	for _, Key in { "Name", "Distance", "Tool", "Health" } do
		Texts[Key] = Create("TextLabel", {
			BackgroundTransparency = 1,
			TextSize = TextSizeEsp,
			AutomaticSize = Enum.AutomaticSize.XY,
			Size = UDim2.new(),
			TextStrokeTransparency = 0,
			ZIndex = 7,
			Parent = Overlay,
		})
	end
	local Status = Label({
		Text = "ESP disabled",
		TextSize = 12,
		Color = "SubText",
		Position = UDim2.fromOffset(10, 6),
		Size = UDim2.fromOffset(230, 16),
		ZIndex = 8,
		Parent = Canvas,
	})

	local Clone, CloneRoot, CloneHumanoid, CloneSource
	local function FindRoot(Model)
		if Model:FindFirstChild("HumanoidRootPart") then return Model.HumanoidRootPart end
		if Model.PrimaryPart then return Model.PrimaryPart end
		for _, Name in { "Root", "HRP", "Torso", "UpperTorso", "LowerTorso", "torso", "head", "Head" } do
			local Part = Model:FindFirstChild(Name)
			if Part and Part:IsA("BasePart") then return Part end
		end
		for _, D in Model:GetDescendants() do
			if D:IsA("BasePart") then return D end
		end
		return nil
	end

	local function FindViewmodelFolders()
		local Found = {}
		local Seen = {}
		local function Consider(Inst)
			if not Inst or Seen[Inst] then return end
			Seen[Inst] = true
			local Lower = Inst.Name:lower()
			if Lower == "viewmodels" or Lower == "viewmodel" or Lower == "viewmodelcontainer"
				or Lower == "characterviewmodels" or Lower == "playerviewmodels" then
				table.insert(Found, Inst)
			end
		end
		Consider(workspace:FindFirstChild("Viewmodels"))
		Consider(workspace:FindFirstChild("ViewModels"))
		Consider(workspace:FindFirstChild("viewmodels"))
		Consider(workspace:FindFirstChild("Viewmodel"))
		Consider(workspace:FindFirstChild("ViewmodelFolder"))
		Consider(workspace:FindFirstChild("ViewmodelContainer"))
		Consider(workspace:FindFirstChild("CharacterViewmodels"))
		for _, D in workspace:GetChildren() do
			if D:IsA("Folder") or D:IsA("Model") then
				Consider(D)
				for _, C in D:GetChildren() do
					if C:IsA("Folder") and C.Name:lower():find("viewmodel", 1, true) then
						Consider(C)
					end
				end
			end
		end
		return Found
	end

	local function IsViewmodelRig(Model)
		if not Model or not Model:IsA("Model") then return false end
		if Model.Name == "LocalViewmodel" then return false end
		local Torso = Model:FindFirstChild("torso") or Model:FindFirstChild("Torso")
		if not Torso then return false end
		local Head = Model:FindFirstChild("head") or Model:FindFirstChild("Head")
		if not Head then return false end
		return true
	end

	local function FindLocalViewmodel()
		local Player = Players.LocalPlayer
		local Char = Player.Character

		for _, Folder in FindViewmodelFolders() do
			for _, Child in Folder:GetChildren() do
				if IsViewmodelRig(Child) then
					local Torso = Child:FindFirstChild("torso") or Child:FindFirstChild("Torso")
					local Motor = Torso:FindFirstChild("JointMotor") or Torso:FindFirstChildOfClass("Motor6D")
					if Motor and Motor.Part0 then
						local Owner = Motor.Part0.Parent
						if Owner == Char or (Owner and Char and Owner.Name == Char.Name) then
							return Child
						end
					end
					local OwnerAttr = Child:GetAttribute("Player") or Child:GetAttribute("Owner")
						or Child:GetAttribute("UserId") or Child:GetAttribute("PlayerName")
					if OwnerAttr == Player.UserId or OwnerAttr == Player.Name then
						return Child
					end
					if Child.Name == Player.Name or Child.Name == Player.DisplayName
						or Child.Name == Player.Name .. "_Viewmodel" then
						return Child
					end
				end
			end
		end

		for _, Folder in FindViewmodelFolders() do
			for _, Child in Folder:GetChildren() do
				if IsViewmodelRig(Child) then
					return Child
				end
			end
		end

		for _, D in workspace:GetDescendants() do
			if D:IsA("Model") and IsViewmodelRig(D) and D.Name ~= "LocalViewmodel" then
				return D
			end
		end
		return nil
	end

	local function FindLocalEntityModel()
		local Ent = GetEntityLibrary()
		if not Ent then return nil end
		local Player = Players.LocalPlayer
		local Tries = {
			function() return Ent.GetEntity(Player) end,
			function() return Ent.GetEntityById(Player.UserId) end,
			function() return Ent.GetLocalEntity and Ent.GetLocalEntity() end,
			function() return Ent.GetEntityFromPlayer and Ent.GetEntityFromPlayer(Player) end,
		}
		for _, Fn in Tries do
			local Ok2, Entity = pcall(Fn)
			if Ok2 and Entity then
				local Model = Entity.Model or Entity.Character or Entity.Rig or Entity.ViewModel
				if Model and Model.Parent and HasRealParts(Model) then
					return Model
				end
			end
		end
		return nil
	end

	local function FindWorkspaceModel()
		local Player = Players.LocalPlayer
		local Names = { Player.Name, Player.DisplayName, tostring(Player.UserId) }
		for _, Folder in workspace:GetChildren() do
			if Folder:IsA("Model") then
				for _, Name in Names do
					if Folder.Name == Name and HasRealParts(Folder) then
						return Folder
					end
				end
				local OwnerAttr = Folder:GetAttribute("Player") or Folder:GetAttribute("Owner") or Folder:GetAttribute("UserId")
				if OwnerAttr == Player.UserId or OwnerAttr == Player.Name then
					if HasRealParts(Folder) then return Folder end
				end
			elseif Folder:IsA("Folder") or Folder:IsA("Workspace") then
				for _, Child in Folder:GetChildren() do
					if Child:IsA("Model") then
						for _, Name in Names do
							if Child.Name == Name and HasRealParts(Child) then
								return Child
							end
						end
						local OwnerAttr = Child:GetAttribute("Player") or Child:GetAttribute("Owner") or Child:GetAttribute("UserId")
						if (OwnerAttr == Player.UserId or OwnerAttr == Player.Name) and HasRealParts(Child) then
							return Child
						end
					end
				end
			end
		end
		return nil
	end

	local function FindSourceModel()
		local Entity = FindLocalEntityModel()
		if Entity then return Entity, "Entity" end
		local Vm = FindLocalViewmodel()
		if Vm and HasRealParts(Vm) then return Vm, "Viewmodel" end
		local Ws = FindWorkspaceModel()
		if Ws then return Ws, "Workspace" end
		local Char = Players.LocalPlayer.Character
		if Char and HasRealParts(Char) then return Char, "Character" end
		return nil, nil
	end

	local function BuildStubModel(Name)
		local VisualModel = Instance.new("Model")
		VisualModel.Name = (Name or "Character") .. "_Stub"
		local Parts = {
			{ "Torso",     Vector3.new(0, 0, 0),    Vector3.new(2, 2, 1) },
			{ "Head",      Vector3.new(0, 1.5, 0),  Vector3.new(1.2, 1.2, 1.2) },
			{ "Left Arm",  Vector3.new(-1.5, 0, 0), Vector3.new(1, 2, 1) },
			{ "Right Arm", Vector3.new(1.5, 0, 0),  Vector3.new(1, 2, 1) },
			{ "Left Leg",  Vector3.new(-0.5, -2, 0),Vector3.new(1, 2, 1) },
			{ "Right Leg", Vector3.new(0.5, -2, 0), Vector3.new(1, 2, 1) },
		}
		for _, P in Parts do
			local Part = Instance.new("Part")
			Part.Name = P[1]
			Part.Anchored = true
			Part.CanCollide = false
			Part.CanQuery = false
			Part.CanTouch = false
			Part.CastShadow = false
			Part.Size = P[3]
			Part.Position = P[2]
			Part.Color = Color3.fromRGB(180, 180, 190)
			Part.Material = Enum.Material.SmoothPlastic
			Part.Parent = VisualModel
		end
		local Root = Instance.new("Part")
		Root.Name = "HumanoidRootPart"
		Root.Anchored = true
		Root.CanCollide = false
		Root.CanQuery = false
		Root.CanTouch = false
		Root.CastShadow = false
		Root.Size = Vector3.new(2, 2, 1)
		Root.Transparency = 1
		Root.Parent = VisualModel
		VisualModel.PrimaryPart = Root
		return VisualModel
	end

	local function RebuildClone()
		if Clone then Clone:Destroy() end
		Clone, CloneRoot, CloneHumanoid, CloneSource = nil, nil, nil, nil

		local Source, SourceKind = FindSourceModel()
		if not Source then return end

		local Archivable = Source.Archivable
		Source.Archivable = true
		local Ok2, Copy = pcall(function() return Source:Clone() end)
		Source.Archivable = Archivable
		if not Ok2 or not Copy then return end

		for _, D in Copy:GetDescendants() do
			if D:IsA("BaseScript") or D:IsA("Sound") or D:IsA("ParticleEmitter")
				or D:IsA("Trail") or D:IsA("Beam") or D:IsA("Fire") or D:IsA("Smoke")
				or D:IsA("Sparkles") or D:IsA("Explosion") or D:IsA("Highlight")
				or D:IsA("SelectionBox") or D:IsA("SelectionSphere")
				or D:IsA("BillboardGui") or D:IsA("SurfaceGui") or D:IsA("ProximityPrompt") then
				D:Destroy()
			elseif D:IsA("BasePart") then
				D.Anchored = true
				D.CanCollide = false
				D.CanQuery = false
				D.CanTouch = false
				D.Transparency = 0
				D.LocalTransparencyModifier = 0
				D.CastShadow = false
			elseif D:IsA("Decal") or D:IsA("Texture") then
				D.Transparency = 0
			elseif D:IsA("SurfaceAppearance") then
				D.AlphaMode = Enum.AlphaMode.Overlay
			end
		end

		local Root = FindRoot(Copy)
		if not Root then
			Copy:Destroy()
			return
		end

		local HRP = Copy:FindFirstChild("HumanoidRootPart")
		if HRP then HRP.Transparency = 1 end

		local Ok3, BoundsCF, BoundsSize = pcall(function()
			local CF, Sz = Copy:GetBoundingBox()
			return CF, Sz
		end)
		local NeedStub = not Ok3 or not BoundsSize or BoundsSize.Magnitude < 0.5

		if NeedStub then
			local Stub = BuildStubModel(Copy.Name)
			Copy:Destroy()
			Copy = Stub
			Root = Copy.PrimaryPart
			BoundsCF = CFrame.new(0, 0, 0)
			CloneHumanoid = nil
		else
			CloneHumanoid = Copy:FindFirstChildOfClass("Humanoid")
		end

		if BoundsCF then
			Copy:PivotTo(Copy:GetPivot() + (Vector3.new(0, -0.4, 0) - BoundsCF.Position))
		end

		Copy.Parent = ViewportFrame
		Clone, CloneRoot = Copy, Root
		CloneSource = SourceKind
	end

	local RebuildToken = 0
	local function QueueRebuild()
		RebuildToken += 1
		local Token = RebuildToken
		task.delay(0.35, function()
			if Token == RebuildToken then RebuildClone() end
		end)
	end

	local function WatchCharacter(Character)
		task.delay(1, QueueRebuild)
		Connect(Character.DescendantAdded, function(Child)
			if Child:IsA("Accessory") or Child:IsA("BasePart") or Child:IsA("MeshPart") then
				QueueRebuild()
			end
		end)
	end
	local function WaitAndRebuild(Character)
		if not Character then return end
		local HRP = Character:FindFirstChild("HumanoidRootPart")
		if not HRP and not Character:FindFirstChild("torso") then
			local Deadline = os.clock() + 5
			while os.clock() < Deadline do
				task.wait(0.1)
				HRP = Character:FindFirstChild("HumanoidRootPart")
				if HRP or Character:FindFirstChild("torso") then break end
			end
		end
		QueueRebuild()
	end
	if Players.LocalPlayer.Character then
		WatchCharacter(Players.LocalPlayer.Character)
		WaitAndRebuild(Players.LocalPlayer.Character)
	end
	Connect(Players.LocalPlayer.CharacterAdded, WatchCharacter)
	Connect(Players.LocalPlayer.CharacterAdded, WaitAndRebuild)

	local VmFolder = workspace:FindFirstChild("Viewmodels")
	if VmFolder then
		Connect(VmFolder.ChildAdded, QueueRebuild)
		Connect(VmFolder.ChildRemoved, QueueRebuild)
	end
	Connect(workspace.ChildAdded, function(Child)
		if Child.Name == "Viewmodels" then
			Connect(Child.ChildAdded, QueueRebuild)
			Connect(Child.ChildRemoved, QueueRebuild)
			QueueRebuild()
		end
	end)

	local RebuildPoll = 0
	Connect(RunService.Heartbeat, function(Dt)
		RebuildPoll += Dt
		if RebuildPoll < 2 then return end
		RebuildPoll = 0
		if not Clone then
			QueueRebuild()
			return
		end
		if CloneSource == "Entity" then
			local Ent = GetEntityLibrary()
			if Ent then
				local Ok2, Entity = pcall(Ent.GetEntity, Players.LocalPlayer)
				local Model = Ok2 and Entity and (Entity.Model or Entity.Character)
				if Model and Model ~= CloneSource and Model.Parent then
					QueueRebuild()
				end
			end
		end
	end)

	local function Project(Size, Point)
		local P = Camera.CFrame:PointToObjectSpace(Point)
		local PointDepth = -P.Z
		if PointDepth <= 0.05 then return nil end
		local TanY = math.tan(math.rad(Camera.FieldOfView) / 2)
		local Aspect = Size.X / Size.Y
		return Vector2.new(
			(P.X / (PointDepth * TanY * Aspect) + 1) / 2 * Size.X,
			(1 - P.Y / (PointDepth * TanY)) / 2 * Size.Y
		)
	end

	local function Place(Frame, X, Y, W, H)
		Frame.Position = UDim2.fromOffset(math.floor(X), math.floor(Y))
		Frame.Size = UDim2.fromOffset(math.floor(W), math.floor(H))
	end

	local Shown, ShowToken = false, 0
	local function SetShown(V)
		if V == Shown then return end
		Shown = V
		ShowToken += 1
		local Token = ShowToken
		if V then PreviewWindow.Visible = true end
		Tween(PreviewWindow, { GroupTransparency = V and 0 or 1 }, 0.25)
		if not V then
			task.delay(0.25, function()
				if Token == ShowToken then PreviewWindow.Visible = false end
			end)
		end
	end

	local Angle, Pitch = 0, 0.8
	local Distance, TargetDistance = CameraDistance, CameraDistance
	local Orbiting, LastInteraction, LastMouse = false, -math.huge, Vector2.zero
	local MinDistance, MaxDistance = 6, 20

	cloneref(game:GetService("ContextActionService")):BindActionAtPriority("NatsukiPreviewZoom", function()
		if PreviewWindow.Visible and PointInFrame(MouseLocation(), Canvas) then
			return Enum.ContextActionResult.Sink
		end
		return Enum.ContextActionResult.Pass
	end, false, Enum.ContextActionPriority.High.Value, Enum.UserInputType.MouseWheel)

	Connect(UserInputService.InputBegan, function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 and PreviewWindow.Visible
			and PointInFrame(MouseLocation(), Canvas) then
			Orbiting = true
			LastMouse = MouseLocation()
			LastInteraction = os.clock()
		end
	end)
	Connect(UserInputService.InputEnded, function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 and Orbiting then
			Orbiting = false
			LastInteraction = os.clock()
		end
	end)
	Connect(UserInputService.InputChanged, function(Input)
		if Orbiting and Input.UserInputType == Enum.UserInputType.MouseMovement then
			local Mouse = MouseLocation()
			local Delta = Mouse - LastMouse
			LastMouse = Mouse
			Angle = (Angle - Delta.X * 0.012) % (math.pi * 2)
			Pitch = math.clamp(Pitch + Delta.Y * 0.03, -2.5, 4)
			LastInteraction = os.clock()
		elseif Input.UserInputType == Enum.UserInputType.MouseWheel and PreviewWindow.Visible
			and PointInFrame(MouseLocation(), Canvas) then
			TargetDistance = math.clamp(TargetDistance - Input.Position.Z * 1.2, MinDistance, MaxDistance)
			LastInteraction = os.clock()
		end
	end)
	Connect(RunService.RenderStepped, function(Dt)
		SetShown(MenuOpen and Window.ActiveTab == VisualsTab)
		if not PreviewWindow.Visible then return end

		local MainPos = Main.AbsolutePosition - ScreenGui.AbsolutePosition
		local MainSize = Main.AbsoluteSize / MainScale.Scale
		local X = MainPos.X + Main.AbsoluteSize.X + Gap
		if X + PreviewWidth > ScreenGui.AbsoluteSize.X then X = MainPos.X - PreviewWidth - Gap end
		PreviewWindow.Position = UDim2.fromOffset(math.floor(X), math.floor(MainPos.Y))
		PreviewWindow.Size = UDim2.fromOffset(PreviewWidth, math.floor(MainSize.Y))

		local Enabled = S.Enabled
		Overlay.GroupTransparency = Enabled and 0 or 0.65
		if Clone then
			Status.Text = ""
			Status.Visible = false
		else
			Status.Text = "Waiting for model..."
			Status.Visible = true
		end

		if not Clone or not Clone.Parent then
			Overlay.Visible = false
			return
		end
		Overlay.Visible = true

		if not Orbiting and os.clock() - LastInteraction > 3 then
			Angle = (Angle + Dt * 0.6) % (math.pi * 2)
		end
		Distance += (TargetDistance - Distance) * math.min(1, Dt * 12)
		local Eye = Vector3.new(math.sin(Angle) * Distance, Pitch, -math.cos(Angle) * Distance)
		Camera.CFrame = CFrame.lookAt(Eye, Vector3.new(0, -0.4, 0))

		local Size = Canvas.AbsoluteSize
		if Size.X <= 0 or Size.Y <= 0 then return end

		local Rig = DetectRig(Clone)
		local Bx, By, Bw, Bh

		if Rig == "ViewModel" then
			local Head = Clone:FindFirstChild("head") or Clone:FindFirstChild("Head")
			local Leg1 = Clone:FindFirstChild("leg1") or Clone:FindFirstChild("Leg1")
			local Leg2 = Clone:FindFirstChild("leg2") or Clone:FindFirstChild("Leg2")
			if not Head then return end
			local VHead = Project(Size, Head.Position)
			if not VHead then return end
			local BottomY = VHead.Y
			for _, Leg in { Leg1, Leg2 } do
				if Leg then
					local VL = Project(Size, Leg.Position)
					if VL then BottomY = math.max(BottomY, VL.Y) end
				end
			end
			local RawH = math.abs(BottomY - VHead.Y)
			if RawH <= 1 then return end
			local H = RawH * 1.2
			local TopY = math.min(VHead.Y, BottomY) - (H - RawH) * 0.5
			local W = H / 2
			local SumX, Count = VHead.X, 1
			for _, Leg in { Leg1, Leg2 } do
				if Leg then
					local VL = Project(Size, Leg.Position)
					if VL then SumX, Count = SumX + VL.X, Count + 1 end
				end
			end
			local CX = SumX / Count
			Bx, By, Bw, Bh = math.floor(CX - W * 0.5 + 0.5), math.floor(TopY + 0.5), math.floor(W + 0.5), math.floor(H + 0.5)
		else
			local OkBox, ModelCF, ModelSize = pcall(function() return Clone:GetBoundingBox() end)
			if not OkBox then return end
			local Half = ModelSize / 2
			local MinX, MinY, MaxX, MaxY = math.huge, math.huge, -math.huge, -math.huge
			for _, Sx in { -1, 1 } do
				for _, Sz in { -1, 1 } do
					for _, Sy in { -1, 1 } do
						local V = Project(Size, (ModelCF * CFrame.new(Half.X * Sx, Half.Y * Sy, Half.Z * Sz)).Position)
						if V then
							MinX, MaxX = math.min(MinX, V.X), math.max(MaxX, V.X)
							MinY, MaxY = math.min(MinY, V.Y), math.max(MaxY, V.Y)
						end
					end
				end
			end
			if MinX == math.huge then return end
			Bx, By, Bw, Bh = math.floor(MinX + 0.5), math.floor(MinY + 0.5), math.floor(MaxX - MinX + 0.5), math.floor(MaxY - MinY + 0.5)
		end

		local Humanoid = CloneHumanoid
		local RealHumanoid = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		local MaxHealth = (RealHumanoid and RealHumanoid.MaxHealth) or (Humanoid and Humanoid.MaxHealth) or 100
		local Health = MaxHealth * (0.6 + 0.4 * math.sin(os.clock() * 0.9))
		local Pct = math.clamp(Health / math.max(MaxHealth, 1), 0, 1)

		Image.Visible = S.Image.Enabled
		if S.Image.Enabled then
			Image.Image = EspImageAsset(S.Image.Image) or ""
			Place(Image, Bx, By, Bw, Bh)
		end

		Box.Visible = S.Box.Enabled
		Place(Box, Bx, By, Bw, Bh)
		BoxStroke.Color = S.Box.Color
		BoxStroke.Transparency = S.Box.Transparency or 0
		local OutlineOn = S.Box.Enabled and S.Box_Outline.Enabled
		OutlineOuter.Visible, OutlineInner.Visible = OutlineOn, OutlineOn
		Place(OutlineOuter, Bx - 1, By - 1, Bw + 2, Bh + 2)
		Place(OutlineInner, Bx + 1, By + 1, Bw - 2, Bh - 2)
		for _, StrokeObject in { OutlineOuterStroke, OutlineInnerStroke } do
			StrokeObject.Color = S.Box_Outline.Color
			StrokeObject.Transparency = S.Box_Outline.Transparency or 0
		end

		local Hb = S.Healthbar
		local HbColor = Hb.Color:Lerp(Hb.Color_Lerp, Pct)
		HbOutline.Visible, HbFill.Visible = Hb.Enabled, Hb.Enabled
		local TopCursor, BottomCursor = By - 3, By + Bh + 3
		local LeftEdge, RightEdge = Bx - 4, Bx + Bw + 4
		if Hb.Enabled then
			HbFill.BackgroundColor3 = HbColor
			if Hb.Position == "Left" or Hb.Position == "Right" then
				local Hx = Hb.Position == "Left" and Bx - 7 or Bx + Bw + 3
				Place(HbOutline, Hx, By, 4, Bh)
				local Fill = math.floor((Bh - 2) * Pct)
				Place(HbFill, Hx + 1, By + 1 + (Bh - 2 - Fill), 2, Fill)
				if Hb.Position == "Left" then LeftEdge = Hx - 3 else RightEdge = Hx + 7 end
			else
				local Hy = Hb.Position == "Top" and By - 7 or By + Bh + 3
				Place(HbOutline, Bx, Hy, Bw, 4)
				Place(HbFill, Bx + 1, Hy + 1, math.floor((Bw - 2) * Pct), 2)
				if Hb.Position == "Top" then TopCursor = Hy - 3 else BottomCursor = Hy + 7 end
			end
		end

		local Tool = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
		local Values = {
			Name = Players.LocalPlayer.Name,
			Distance = PreviewDistance,
			Tool = Tool and Tool.Name or "Nothing",
			Health = tostring(math.floor(Health + 0.5)),
		}
		local LeftCursor, RightCursor = By, By
		for _, Key in { "Name", "Distance", "Tool", "Health" } do
			local ElementSettings = S[Key]
			local TextObject = Texts[Key]
			TextObject.Visible = ElementSettings.Enabled
			if ElementSettings.Enabled then
				TextObject.Text = Values[Key]
				TextObject.FontFace = S.Bold_Text and FontBold or MainFont
				TextObject.TextColor3 = Key == "Health" and HbColor or ElementSettings.Color
				TextObject.TextStrokeColor3 = ElementSettings.OutlineColor or Color3.new(0, 0, 0)
				TextObject.TextTransparency = ElementSettings.Transparency or 0
				local Position = ElementSettings.Position
				if Position == "Top" then
					TextObject.AnchorPoint = Vector2.new(0.5, 1)
					TextObject.Position = UDim2.fromOffset(Bx + Bw / 2, TopCursor)
					TopCursor -= TextStep
				elseif Position == "Bottom" then
					TextObject.AnchorPoint = Vector2.new(0.5, 0)
					TextObject.Position = UDim2.fromOffset(Bx + Bw / 2, BottomCursor)
					BottomCursor += TextStep
				elseif Position == "Left" then
					TextObject.AnchorPoint = Vector2.new(1, 0)
					TextObject.Position = UDim2.fromOffset(LeftEdge, LeftCursor)
					LeftCursor += TextStep
				else
					TextObject.AnchorPoint = Vector2.new(0, 0)
					TextObject.Position = UDim2.fromOffset(RightEdge, RightCursor)
					RightCursor += TextStep
				end
			end
		end

		local Sk = S.Skeleton
		local ConnTable = EspSkeleton[Rig]
		local DrawSkeleton = Sk.Enabled and ConnTable ~= nil
		for I, B in Bones do
			local Conn = DrawSkeleton and ConnTable[I]
			local A, C
			if Conn then
				local PartA = Clone:FindFirstChild(Conn[1])
				local PartB = Clone:FindFirstChild(Conn[3])
				if PartA and PartB then
					A = Project(Size, (PartA.CFrame * CFrame.new(Conn[2])).Position)
					C = Project(Size, (PartB.CFrame * CFrame.new(Conn[4])).Position)
				end
			end
			if A and C then
				local Delta = C - A
				B.Position = UDim2.fromOffset((A.X + C.X) / 2, (A.Y + C.Y) / 2)
				B.Size = UDim2.fromOffset(Delta.Magnitude, Sk.Thickness or 1)
				B.Rotation = math.deg(math.atan2(Delta.Y, Delta.X))
				B.BackgroundColor3 = Sk.Color
				B.BackgroundTransparency = Sk.Transparency or 0
				B.Visible = true
			else
				B.Visible = false
			end
		end
	end)
end

return {
	Window = Window,
	Notify = Notify,
	Config = Config,
	Flags = Flags,
	Themes = Themes,
	Icons = Icons,
	Blur = Blur,
	KeybindList = KeybindList,
	Watermark = Watermark,
	CreateTargetHud = CreateTargetHud,
	BuildEspPreviewWindow = BuildEspPreviewWindow,
	EspSettings = EspSettings,
	EspPositions = EspPositions,
	EspImages = EspImages,
	HitNotifications = HitNotifications,
	HitNotify = HitNotify,
	T = T,
	Translatable = Translatable,
	OnLanguage = OnLanguage,
	SetMenuOpen = SetMenuOpen,
	SetAccent = SetAccent,
	SetLanguage = SetLanguage,
	SetTransparency = SetTransparency,
	SetBlurStrength = SetBlurStrength,
	ApplyTheme = ApplyTheme,
	Unload = Unload,
	MenuKey = MenuKey,
}
