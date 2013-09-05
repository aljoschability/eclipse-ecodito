package com.aljoschability.eclipse.ecodito.diagram.util

import org.eclipse.emf.ecore.EEnum
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.graphiti.features.context.IAddContext
import org.eclipse.graphiti.features.context.IPictogramElementContext
import org.eclipse.graphiti.mm.algorithms.styles.Style
import org.eclipse.graphiti.mm.pictograms.Diagram
import org.eclipse.graphiti.services.Graphiti
import org.eclipse.graphiti.services.IGaService
import org.eclipse.graphiti.util.IColorConstant
import org.eclipse.graphiti.util.PredefinedColoredAreas

class EEnumExtensions extends EClassifierExtensions {
	val static public INSTANCE = new EEnumExtensions

	extension IGaService = Graphiti::gaService

	private new() {
	}

	def Style getDefaultStyle(Diagram diagram) {
		var style = diagram.findStyle(EcorePackage.Literals::EENUM.name)

		if (style == null) {
			style = diagram.createStyle(EcorePackage.Literals::EENUM.name)

			style.renderingStyle = PredefinedColoredAreas::getBlueWhiteGlossAdaptions
			style.foreground = diagram.manageColor(IColorConstant::BLACK)
		}

		return style
	}

	def String getIcon() {
		EcorePackage.Literals::EENUM.name
	}

	def EEnum getEEnum(IPictogramElementContext context) {
		context.bo.EEnum
	}

	def EEnum getEEnum(IAddContext context) {
		context.newObject.EEnum
	}

	def private static EEnum getEEnum(Object element) {
		if (element instanceof EEnum) {
			return element
		}
	}
}
