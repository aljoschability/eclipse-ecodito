package com.aljoschability.eclipse.ecodito.diagram.util

import com.aljoschability.eclipse.core.graphiti.services.AddService
import com.aljoschability.eclipse.core.graphiti.services.SetService
import org.eclipse.emf.ecore.EDataType
import org.eclipse.emf.ecore.EEnum
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.graphiti.features.context.IAddContext
import org.eclipse.graphiti.features.context.IDirectEditingContext
import org.eclipse.graphiti.features.context.IPictogramElementContext
import org.eclipse.graphiti.mm.algorithms.GraphicsAlgorithm
import org.eclipse.graphiti.mm.algorithms.Text
import org.eclipse.graphiti.mm.algorithms.styles.Style
import org.eclipse.graphiti.services.Graphiti
import org.eclipse.graphiti.services.IGaService
import org.eclipse.graphiti.util.IColorConstant

class EDataTypeExtensions extends EClassifierExtensions {
	val static public INSTANCE = new EDataTypeExtensions

	extension IGaService = Graphiti::gaService
	extension SetService = SetService::INSTANCE
	extension AddService = AddService::INSTANCE

	private new() {
	}

	def String getIdentifier() {
		EcorePackage.Literals::EDATA_TYPE.name
	}

	def String getText(EDataType element) {
		element.name
	}

	def String getTypeName(EDataType element) {
		"«" + element.instanceClassName + "»"
	}

	def Style getMainStyle(GraphicsAlgorithm element) {
		var style = element.diagram.findStyle(identifier)
		if (style == null) {
			style = element.diagram.addStyle [
				id = identifier
				background = newGradient[
					normal = #["f7f7f7", "fcfcfc"]
					primarySelection = #["cccccc", "eeeeee"]
					secondarySelection = #["cccccc", "eeeeee"]
					forbiddenAction = #["ff0000", "dddddd"]
					allowedAction = #["00ff00", "dddddd"]
				]
				foreground = "a6a6a6"
			]
		}

		return style
	}

	def Style getNameStyle(GraphicsAlgorithm element) {
		var style = element.diagram.findStyle(identifier + "/text")

		if (style == null) {
			style = element.diagram.addStyle [
				id = identifier + "/text"
				filled = false
				font = element.diagram.manageFont("Segoe UI", 10, false, true)
				foreground = IColorConstant::BLACK
			]
		}

		return style
	}

	def Style getTypeStyle(GraphicsAlgorithm element) {
		var style = element.diagram.findStyle(identifier + "/type")

		if (style == null) {
			style = element.diagram.addStyle [
				id = identifier + "/type"
				filled = false
				font = element.diagram.manageFont("Consolas", 9, false, false)
				foreground = IColorConstant::BLACK
			]
		}

		return style
	}

	def String getIcon() {
		identifier
	}

	def EDataType getEDataType(IPictogramElementContext context) {
		context.bo.EDataType
	}

	def EDataType getEDataType(IAddContext context) {
		context.newObject.EDataType
	}

	def Text getNameText(IDirectEditingContext context) {
		val text = context.graphicsAlgorithm.graphicsAlgorithmChildren.get(1)
		if (text instanceof Text) {
			return text
		}
	}

	def private static EDataType getEDataType(Object element) {
		if (element instanceof EDataType) {
			if (!(element instanceof EEnum)) {
				return element
			}
		}
	}
}
