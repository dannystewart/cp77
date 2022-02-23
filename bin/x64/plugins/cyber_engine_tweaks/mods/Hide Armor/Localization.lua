local GameLocale = require('GameLocale')

local Localization = {
    version = '1.0'
}

-- en-us pl-pl es-es fr-fr it-it de-de es-mx kr-kr zh-cn ru-ru pt-br jp-jp zh-tw ar-ar cz-cz hu-hu tr-tr th-th
local languagesShort = {}
local languageCurrent

languagesShort['system'] = 1
languagesShort['en-us'] = 2
languagesShort['pl-pl'] = 3
languagesShort['fr-fr'] = 4
languagesShort['ru-ru'] = 5
languagesShort['zh-tw'] = 6
languagesShort['pt-br'] = 7

Localization.Categories = {}
Localization.Names = {}
Localization.Descriptions = {}

-- English
Localization.Categories[languagesShort['en-us']] = {}
Localization.Categories[languagesShort['en-us']]['Visibility'] = "Clothes Visibility"
Localization.Categories[languagesShort['en-us']]['Preferences'] = "Preferences"

Localization.Names[languagesShort['en-us']] = {}
Localization.Names[languagesShort['en-us']]['Head'] = "Head"
Localization.Names[languagesShort['en-us']]['Face'] = "Face"
Localization.Names[languagesShort['en-us']]['OuterChest'] = "Outer Torso"
Localization.Names[languagesShort['en-us']]['InnerChest'] = "Inner Torso"
Localization.Names[languagesShort['en-us']]['Legs'] = "Legs"
Localization.Names[languagesShort['en-us']]['Feet'] = "Feet"
Localization.Names[languagesShort['en-us']]['Outfit'] = "Outfit"
Localization.Names[languagesShort['en-us']]['Inventory'] = "Toggle in the UI"

Localization.Descriptions[languagesShort['en-us']] = {}
Localization.Descriptions[languagesShort['en-us']]['Head'] = "Controls visibility of the headgear"
Localization.Descriptions[languagesShort['en-us']]['Face'] = "Controls visibility of the facegear"
Localization.Descriptions[languagesShort['en-us']]['OuterChest'] = "Controls visibility of the jackets"
Localization.Descriptions[languagesShort['en-us']]['InnerChest'] = "Controls visibility of the shirts"
Localization.Descriptions[languagesShort['en-us']]['Legs'] = "Controls visibility of the trouses"
Localization.Descriptions[languagesShort['en-us']]['Feet'] = "Controls visibility of the footwear"
Localization.Descriptions[languagesShort['en-us']]['Outfit'] = "Controls visibility of the outfit"
Localization.Descriptions[languagesShort['en-us']]['Inventory'] = "Experimental: Enables visibility toggle in the inventory UI"

-- Polish
Localization.Categories[languagesShort['pl-pl']] = {}
Localization.Categories[languagesShort['pl-pl']]['Visibility'] = "Widoczność ubrań"
Localization.Categories[languagesShort['pl-pl']]['Preferences'] = "Preferencje"

Localization.Names[languagesShort['pl-pl']] = {}
Localization.Names[languagesShort['pl-pl']]['Head'] = "Głowa"
Localization.Names[languagesShort['pl-pl']]['Face'] = "Twarz"
Localization.Names[languagesShort['pl-pl']]['OuterChest'] = "Tułów (odzież wierzchnia)"
Localization.Names[languagesShort['pl-pl']]['InnerChest'] = "Tułów (odzież spodnia)"
Localization.Names[languagesShort['pl-pl']]['Legs'] = "Nogi"
Localization.Names[languagesShort['pl-pl']]['Feet'] = "Obuwie"
Localization.Names[languagesShort['pl-pl']]['Outfit'] = "Strój"
Localization.Names[languagesShort['pl-pl']]['Inventory'] = "Przełącznik w UI"

Localization.Descriptions[languagesShort['pl-pl']] = {}
Localization.Descriptions[languagesShort['pl-pl']]['Head'] = "Ustawia widoczność nakrycia głowy"
Localization.Descriptions[languagesShort['pl-pl']]['Face'] = "Ustawia widoczność dodatków twarzy"
Localization.Descriptions[languagesShort['pl-pl']]['OuterChest'] = "Ustawia widoczność odzieży wierzchniej"
Localization.Descriptions[languagesShort['pl-pl']]['InnerChest'] = "Ustawia widoczność odzieży spodniej"
Localization.Descriptions[languagesShort['pl-pl']]['Legs'] = "Ustawia widoczność spodni"
Localization.Descriptions[languagesShort['pl-pl']]['Feet'] = "Ustawia widoczność obuwia"
Localization.Descriptions[languagesShort['pl-pl']]['Outfit'] = "Ustawia widoczność stroju"
Localization.Descriptions[languagesShort['pl-pl']]['Inventory'] = "Eksperymentalne: Dodaje przełącznik widoczności w UI ekwipunku"

-- French
Localization.Categories[languagesShort['fr-fr']] = {}
Localization.Categories[languagesShort['fr-fr']]['Visibility'] = "Visibilité"
Localization.Categories[languagesShort['fr-fr']]['Preferences'] = "Préférences"
 
Localization.Names[languagesShort['fr-fr']] = {}
Localization.Names[languagesShort['fr-fr']]['Head'] = "Tête"
Localization.Names[languagesShort['fr-fr']]['Face'] = "Visage"
Localization.Names[languagesShort['fr-fr']]['OuterChest'] = "Haut"
Localization.Names[languagesShort['fr-fr']]['InnerChest'] = "Haut léger"
Localization.Names[languagesShort['fr-fr']]['Legs'] = "Bas"
Localization.Names[languagesShort['fr-fr']]['Feet'] = "Pieds"
Localization.Names[languagesShort['fr-fr']]['Outfit'] = "Ensembles vestimentaires"
Localization.Names[languagesShort['fr-fr']]['Inventory'] = "Basculer dans l'interface"

 
Localization.Descriptions[languagesShort['fr-fr']] = {}
Localization.Descriptions[languagesShort['fr-fr']]['Head'] = "Contrôle la visibilité du couvre-chef"
Localization.Descriptions[languagesShort['fr-fr']]['Face'] = "Contrôle la visibilité du masque/lunette"
Localization.Descriptions[languagesShort['fr-fr']]['OuterChest'] = "Contrôle la visibilité du manteau"
Localization.Descriptions[languagesShort['fr-fr']]['InnerChest'] = "Contrôle la visibilité du tee-shirt"
Localization.Descriptions[languagesShort['fr-fr']]['Legs'] = "Contrôle la visibilité du pantalon/short"
Localization.Descriptions[languagesShort['fr-fr']]['Feet'] = "Contrôle la visibilité des chaussures/bottes"
Localization.Descriptions[languagesShort['fr-fr']]['Outfit'] = "Contrôle la visibilité du costumes"
Localization.Descriptions[languagesShort['fr-fr']]['Inventory'] = "Expérimental : Active le basculement de la visibilité dans l'interface d'inventaire"

-- Russian
Localization.Categories[languagesShort['ru-ru']] = {}
Localization.Categories[languagesShort['ru-ru']]['Visibility'] = "Видимость"
Localization.Categories[languagesShort['ru-ru']]['Preferences'] = "Настройки"

Localization.Names[languagesShort['ru-ru']] = {}
Localization.Names[languagesShort['ru-ru']]['Head'] = "Голова"
Localization.Names[languagesShort['ru-ru']]['Face'] = "Лицо"
Localization.Names[languagesShort['ru-ru']]['OuterChest'] = "Торс (верх)"
Localization.Names[languagesShort['ru-ru']]['InnerChest'] = "Торс (низ)"
Localization.Names[languagesShort['ru-ru']]['Legs'] = "Ноги"
Localization.Names[languagesShort['ru-ru']]['Feet'] = "Ступни"
Localization.Names[languagesShort['ru-ru']]['Outfit'] = "Наборы одежды"
Localization.Names[languagesShort['ru-ru']]['Inventory'] = "Кнопка в интерфейсе"

Localization.Descriptions[languagesShort['ru-ru']] = {}
Localization.Descriptions[languagesShort['ru-ru']]['Head'] = "Устанавливает видимость предмета в слоте головы"
Localization.Descriptions[languagesShort['ru-ru']]['Face'] = "Устанавливает видимость предмета в слоте лица"
Localization.Descriptions[languagesShort['ru-ru']]['OuterChest'] = "Устанавливает видимость предмета в слоте торса (верх)"
Localization.Descriptions[languagesShort['ru-ru']]['InnerChest'] = "Устанавливает видимость предмета в слоте торса (низ)"
Localization.Descriptions[languagesShort['ru-ru']]['Legs'] = "Устанавливает видимость предмета в слоте ног"
Localization.Descriptions[languagesShort['ru-ru']]['Feet'] = "Устанавливает видимость предмета в слоте ступней"
Localization.Descriptions[languagesShort['ru-ru']]['Outfit'] = "Устанавливает видимость предмета в слоте наборов одежды"
Localization.Descriptions[languagesShort['ru-ru']]['Inventory'] = "Экспериментально: включает переключатель видимости в интерфейсе инвентаря"

-- Traditional Chinese
Localization.Categories[languagesShort['zh-tw']] = {}
Localization.Categories[languagesShort['zh-tw']]['Visibility'] = "顯示部位"
Localization.Categories[languagesShort['zh-tw']]['Preferences'] = "偏好"
 
Localization.Names[languagesShort['zh-tw']] = {}
Localization.Names[languagesShort['zh-tw']]['Head'] = "頭部"
Localization.Names[languagesShort['zh-tw']]['Face'] = "臉部"
Localization.Names[languagesShort['zh-tw']]['OuterChest'] = "上身外衣"
Localization.Names[languagesShort['zh-tw']]['InnerChest'] = "上身內襯"
Localization.Names[languagesShort['zh-tw']]['Legs'] = "腿部"
Localization.Names[languagesShort['zh-tw']]['Feet'] = "腳部"
Localization.Names[languagesShort['zh-tw']]['Outfit'] = "服裝組"
Localization.Names[languagesShort['zh-tw']]['Inventory'] = "在界面切換"
 
Localization.Descriptions[languagesShort['zh-tw']] = {}
Localization.Descriptions[languagesShort['zh-tw']]['Head'] = "控制頭部裝備的顯示或隱藏"
Localization.Descriptions[languagesShort['zh-tw']]['Face'] = "控制臉部裝備的顯示或隱藏"
Localization.Descriptions[languagesShort['zh-tw']]['OuterChest'] = "控制上身外衣裝備的顯示或隱藏"
Localization.Descriptions[languagesShort['zh-tw']]['InnerChest'] = "控制上身內襯裝備的顯示或隱藏"
Localization.Descriptions[languagesShort['zh-tw']]['Legs'] = "控制腿部裝備的顯示或隱藏"
Localization.Descriptions[languagesShort['zh-tw']]['Feet'] = "控制腳部裝備的顯示或隱藏"
Localization.Descriptions[languagesShort['zh-tw']]['Outfit'] = "控制服裝組裝備的顯示或隱藏"
Localization.Descriptions[languagesShort['zh-tw']]['Inventory'] = "實驗性：在庫存界面中啟用可見性切換"

-- Brazilian Portuguese
Localization.Categories[languagesShort['pt-br']] = {}
Localization.Categories[languagesShort['pt-br']]['Visibility'] = "Deseja exibir que equipamentos?"
Localization.Categories[languagesShort['pt-br']]['Preferences'] = "Preferências"

Localization.Names[languagesShort['pt-br']] = {}
Localization.Names[languagesShort['pt-br']]['Head'] = "Cabeça"
Localization.Names[languagesShort['pt-br']]['Face'] = "Rosto"
Localization.Names[languagesShort['pt-br']]['OuterChest'] = "Peitoral Externo"
Localization.Names[languagesShort['pt-br']]['InnerChest'] = "Peitoral Interno"
Localization.Names[languagesShort['pt-br']]['Legs'] = "Pernas"
Localization.Names[languagesShort['pt-br']]['Feet'] = "Pés"
Localization.Names[languagesShort['pt-br']]['Outfit'] = "Roupas Especiais"
Localization.Names[languagesShort['pt-br']]['Inventory'] = "Mudar pelo Inventário?"

Localization.Descriptions[languagesShort['pt-br']] = {}
Localization.Descriptions[languagesShort['pt-br']]['Head'] = "Não será mais exibido nenhum capacete, chapéu, boné ou outras peças"
Localization.Descriptions[languagesShort['pt-br']]['Face'] = "Não será mais exibido nenhuma máscara, óculos e outros acessórios"
Localization.Descriptions[languagesShort['pt-br']]['OuterChest'] = "Não será mais exibido nenhuma jaqueta, casaco, colete ou outra roupa externa"
Localization.Descriptions[languagesShort['pt-br']]['InnerChest'] = "Não será mais exibido nenhuma camisa, regata, trajes ou outra roupa interna"
Localization.Descriptions[languagesShort['pt-br']]['Legs'] = "Não será mais exibido nenhuma calça, bermuda, saia ou outras peças de roupa"
Localization.Descriptions[languagesShort['pt-br']]['Feet'] = "Não será mais exibido nenhum tênis, sandálias, botas ou outros calçados"
Localization.Descriptions[languagesShort['pt-br']]['Outfit'] = "Deseja ocultar roupas especiais?"
Localization.Descriptions[languagesShort['pt-br']]['Inventory'] = "Experimental: Torna possível alterar a visibilidade dos equipamentos diretamente pela aba de Inventário"

function Localization.Initialize()
    GameLocale.Initialize()
end

function GetLanguageID(Language)
    if languagesShort[Language] then
        return languagesShort[Language]
    end

    return 2
end

function Localization.GetLanguage()
	local current = GameLocale.GetInterfaceLanguage()
	return GetLanguageID(current)
end

function Localization.GetCategory(Language, Name)
    if Localization.Categories[Language] and Localization.Categories[Language][Name] then
        return Localization.Categories[Language][Name]
    end

    if not Localization.Categories[2][Name] then
        return "_error_"
    else
        return Localization.Categories[2][Name]
    end
end

function Localization.GetName(Language, Name)
    if Localization.Names[Language] and Localization.Names[Language][Name] then
        return Localization.Names[Language][Name]
    end

    if not Localization.Names[2][Name] then
        return "_error_"
    else
        return Localization.Names[2][Name]
    end
end

function Localization.GetDescription(Language, Name)
    if Localization.Descriptions[Language] and Localization.Descriptions[Language][Name] then
        return Localization.Descriptions[Language][Name]
    end

    if not Localization.Descriptions[2][Name] then
        return "_error_"
    else
        return Localization.Descriptions[2][Name]
    end
end

return Localization