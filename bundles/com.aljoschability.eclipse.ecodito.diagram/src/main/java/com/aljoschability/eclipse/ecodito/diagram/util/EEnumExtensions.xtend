package com.aljoschability.eclipse.ecodito.diagram.util

import com.aljoschability.eclipse.core.graphiti.services.CreateService
import com.aljoschability.eclipse.core.graphiti.services.SetService
import org.eclipse.emf.ecore.EEnum
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.graphiti.features.context.IAddContext
import org.eclipse.graphiti.features.context.IPictogramElementContext
import org.eclipse.graphiti.mm.algorithms.styles.Style
import org.eclipse.graphiti.mm.pictograms.Diagram
import org.eclipse.graphiti.services.Graphiti
import org.eclipse.graphiti.services.IGaService
import org.eclipse.graphiti.util.IColorConstant

class EEnumExtensions extends EClassifierExtensions {
	val static public INSTANCE = new EEnumExtensions

	extension IGaService = Graphiti::gaService
	extension SetService = SetService::INSTANCE
	extension CreateService = CreateService::INSTANCE

	private new() {
	}

	def String getIdentifier() {
		EcorePackage.Literals::EENUM.name
	}

	def Style getShapeStyle(Diagram diagram) {
		var style = diagram.findStyle(identifier)

		if (style == null) {
			style = diagram.newStyle [
				id = identifier
				background = newGradient[
					normal = #["d2f7d7", "fafcfa"]
					primarySelection = #["cccccc", "eeeeee"]
					secondarySelection = #["cccccc", "eeeeee"]
					forbiddenAction = #["ff0000", "dddddd"]
					allowedAction = #["00ff00", "dddddd"]
				]
				foreground = "62a66a"
			]
		}

		return style
	}

	def Style getTextStyle(Diagram diagram) {
		var style = diagram.findStyle(identifier + "/text")

		if (style == null) {
			style = diagram.newStyle [
				id = identifier + "/text"
				font = diagram.manageFont("Segoe UI", 10, false, true)
				foreground = IColorConstant::BLACK
			]
		}

		return style
	}

	def String getIcon() {
		identifier
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
