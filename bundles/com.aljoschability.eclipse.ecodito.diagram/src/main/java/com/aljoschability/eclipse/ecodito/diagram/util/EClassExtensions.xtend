package com.aljoschability.eclipse.ecodito.diagram.util;

import com.aljoschability.eclipse.core.graphiti.services.CreateService
import com.aljoschability.eclipse.core.graphiti.services.SetService
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.graphiti.features.context.IAddContext
import org.eclipse.graphiti.features.context.IPictogramElementContext
import org.eclipse.graphiti.mm.algorithms.styles.Style
import org.eclipse.graphiti.mm.pictograms.Diagram
import org.eclipse.graphiti.services.Graphiti
import org.eclipse.graphiti.services.IGaService
import org.eclipse.graphiti.util.IColorConstant

class EClassExtensions extends EClassifierExtensions {
	val static public INSTANCE = new EClassExtensions

	extension IGaService = Graphiti::gaService

	extension SetService = SetService::INSTANCE
	extension CreateService = CreateService::INSTANCE

	private new() {
	}

	def String getIdentifier() {
		EcorePackage.Literals::ECLASS.name
	}

	def Style getShapeStyle(Diagram diagram) {
		var style = diagram.findStyle(identifier)

		if (style == null) {
			style = diagram.newStyle [
				id = identifier
				background = newGradient[
					normal = #["f5f2c4", "fcfcfa"]
					primarySelection = #["cccccc", "eeeeee"]
					secondarySelection = #["cccccc", "eeeeee"]
					forbiddenAction = #["ff0000", "dddddd"]
					allowedAction = #["00ff00", "dddddd"]
				]
				foreground = "a6a262"
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

	def EClass getEClass(IPictogramElementContext context) {
		context.bo.EClass
	}

	def EClass getEClass(IAddContext context) {
		context.newObject.EClass
	}

	def private static EClass getEClass(Object element) {
		if (element instanceof EClass) {
			return element
		}
	}

}
