package com.aljoschability.eclipse.ecodito.diagram.util

import com.aljoschability.eclipse.core.graphiti.services.SetService
import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.graphiti.features.context.IAddContext
import org.eclipse.graphiti.features.context.IPictogramElementContext
import org.eclipse.graphiti.mm.algorithms.styles.Style
import org.eclipse.graphiti.mm.pictograms.Diagram
import org.eclipse.graphiti.services.Graphiti
import org.eclipse.graphiti.services.IGaService
import org.eclipse.graphiti.util.IColorConstant
import org.eclipse.graphiti.mm.algorithms.styles.Orientation
import com.aljoschability.eclipse.core.graphiti.services.AddService
import org.eclipse.graphiti.mm.algorithms.Text
import org.eclipse.graphiti.mm.algorithms.Image

class EAttributeExtensions extends EStructuralFeatureExtensions {
	val static public INSTANCE = new EAttributeExtensions

	extension IGaService = Graphiti::gaService

	extension SetService = SetService::INSTANCE
	extension AddService = AddService::INSTANCE

	private new() {
	}

	def String getIdentifier() {
		EcorePackage.Literals::EATTRIBUTE.name
	}

	def String getImage(EAttribute element) {
		identifier
	}

	def EAttribute getEAttribute(IPictogramElementContext context) {
		context.bo.EAttribute
	}

	def String getText(EAttribute element) {
		'''«element.name»: «element.EType?.name»'''
	}

	def EAttribute getEAttribute(IAddContext context) {
		context.newObject.EAttribute
	}

	def private static EAttribute getEAttribute(Object element) {
		if (element instanceof EAttribute) {
			return element
		}
	}

	def Style getShapeStyle(Diagram diagram) {
		var style = diagram.findStyle(identifier)

		if (style == null) {
			style = diagram.addStyle [
				id = identifier
				filled = false
				lineVisible = false
			]
		}

		return style
	}

	def Style getTextStyle(Diagram diagram) {
		var style = diagram.findStyle(identifier + "/text")

		if (style == null) {
			style = diagram.addStyle [
				id = identifier + "/text"
				font = diagram.manageFont("Segoe UI", 9, false, false)
				foreground = IColorConstant::BLACK
				horizontalAlignment = Orientation::ALIGNMENT_LEFT
				verticalAlignment = Orientation::ALIGNMENT_MIDDLE
			]
		}

		return style
	}

	def Image getImage(IPictogramElementContext context) {
		context.pictogramElement.graphicsAlgorithm.graphicsAlgorithmChildren.get(0) as Image
	}

	def Text getText(IPictogramElementContext context) {
		context.pictogramElement.graphicsAlgorithm.graphicsAlgorithmChildren.get(1) as Text
	}
}
