package com.aljoschability.eclipse.ecodito.diagram.styles

import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.graphiti.mm.StyleContainer
import org.eclipse.graphiti.mm.algorithms.styles.GradientColoredArea
import org.eclipse.graphiti.mm.algorithms.styles.GradientColoredAreas
import org.eclipse.graphiti.mm.algorithms.styles.LocationType
import org.eclipse.graphiti.mm.algorithms.styles.StylesFactory
import org.eclipse.graphiti.mm.algorithms.styles.StylesPackage
import org.eclipse.graphiti.util.ColorUtil
import org.eclipse.graphiti.util.IGradientType
import org.eclipse.graphiti.util.IPredefinedRenderingStyle
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1

class StylesExtensions {
	val static public INSTANCE = new StylesExtensions

	val static START = LocationType::LOCATION_TYPE_ABSOLUTE_START
	val static END = LocationType::LOCATION_TYPE_ABSOLUTE_END

	private new() {
	}

	def createGradientColoredAreas(Procedure1<GradientColoredAreas> initializer) {
		val element = StylesFactory::eINSTANCE.createGradientColoredAreas
		if (initializer != null) {
			initializer.apply(element)
		}
		return element
	}

	def createGradientColoredArea(Procedure1<GradientColoredArea> initializer) {
		val element = StylesFactory::eINSTANCE.createGradientColoredArea
		if (initializer != null) {
			initializer.apply(element)
		}
		return element
	}

	def createLocation(String color, LocationType type, int value) {
		val element = StylesFactory::eINSTANCE.createGradientColoredLocation
		element.color = color.createColor
		element.locationType = type
		element.locationValue = value
		return element
	}

	def createColor(String hex) {
		val color = StylesFactory::eINSTANCE.createColor
		color.eSet(StylesPackage.Literals::COLOR__RED, ColorUtil::getRedFromHex(hex))
		color.eSet(StylesPackage.Literals::COLOR__GREEN, ColorUtil::getGreenFromHex(hex))
		color.eSet(StylesPackage.Literals::COLOR__BLUE, ColorUtil::getBlueFromHex(hex))
		return color
	}

	def addSolidStop(GradientColoredAreas areas, String color, LocationType location, int start, int end) {
		areas.gradientColor += createGradientColoredArea[
			start = createLocation(color, location, start)
			end = createLocation(color, location, end)
		]
	}

	def addGradient(GradientColoredAreas areas, String startColor, String endColor, int start, int end) {
		areas.gradientColor += createGradientColoredArea[
			start = createLocation(startColor, START, start)
			end = createLocation(endColor, END, end)
		]
	}
}

class EDataTypeStyles {
	val static public INSTANCE = new EDataTypeStyles

	val static START = LocationType::LOCATION_TYPE_ABSOLUTE_START
	val static END = LocationType::LOCATION_TYPE_ABSOLUTE_END

	extension StylesExtensions = StylesExtensions::INSTANCE

	private new() {
	}

	def private createDefaultAreas() {
		createGradientColoredAreas[
			styleAdaption = IPredefinedRenderingStyle::STYLE_ADAPTATION_DEFAULT
			addSolidStop("F8FBFE", START, 0, 1)
			addSolidStop("EDF5FC", START, 1, 2)
			addSolidStop("DEEDFA", START, 2, 3)
			addGradient("D4E7F8", "FAFBFC", 3, 2)
			addSolidStop("E2E5E9", END, 2, 0)
		]
	}

	def private createPrimarySelectedAreas() {
		createGradientColoredAreas[
			styleAdaption = IPredefinedRenderingStyle::STYLE_ADAPTATION_PRIMARY_SELECTED
			addSolidStop("EEF6FD", START, 0, 1)
			addSolidStop("D0E6F9", START, 1, 2)
			addSolidStop("ACD2F4", START, 2, 3)
			addGradient("81B9EA", "AAD0F2", 3, 2)
			addSolidStop("9ABFE0", END, 2, 0)
		]
	}

	def private createSecondarySelectedAreas() {
		createGradientColoredAreas[
			styleAdaption = IPredefinedRenderingStyle::STYLE_ADAPTATION_SECONDARY_SELECTED
			addSolidStop("F5F9FE", START, 0, 1)
			addSolidStop("E2EFFC", START, 1, 2)
			addSolidStop("CBE3F9", START, 2, 3)
			addGradient("BBDAF7", "C5E0F7", 3, 2)
			addSolidStop("B2CDE5", END, 2, 0)
		]
	}

	def createGradientColoredAreas(StyleContainer container) {
		val element = StylesFactory::eINSTANCE.createAdaptedGradientColoredAreas
		element.definedStyleId = EcorePackage.Literals.EDATA_TYPE.name
		element.gradientType = IGradientType::VERTICAL
		element.adaptedGradientColoredAreas.add(IPredefinedRenderingStyle::STYLE_ADAPTATION_DEFAULT, createDefaultAreas)
		element.adaptedGradientColoredAreas.add(IPredefinedRenderingStyle::STYLE_ADAPTATION_PRIMARY_SELECTED,
			createPrimarySelectedAreas)
		element.adaptedGradientColoredAreas.add(IPredefinedRenderingStyle::STYLE_ADAPTATION_SECONDARY_SELECTED,
			createSecondarySelectedAreas)
		return element
	}
}
