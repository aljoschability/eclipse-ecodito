package com.aljoschability.eclipse.ecodito.diagram.util

import com.aljoschability.eclipse.core.graphiti.services.SetService
import com.aljoschability.eclipse.core.graphiti.util.GraphitiExtensions
import org.eclipse.emf.ecore.EEnum
import org.eclipse.emf.ecore.EEnumLiteral
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.graphiti.features.context.IAddContext
import org.eclipse.graphiti.features.context.ICreateContext
import org.eclipse.graphiti.features.context.IPictogramElementContext
import org.eclipse.graphiti.mm.algorithms.styles.Orientation
import org.eclipse.graphiti.mm.algorithms.styles.Style
import org.eclipse.graphiti.mm.pictograms.Diagram
import org.eclipse.graphiti.services.Graphiti
import org.eclipse.graphiti.services.IGaService
import org.eclipse.graphiti.util.IColorConstant
import com.aljoschability.eclipse.core.graphiti.services.AddService

class EEnumLiteralExtensions extends GraphitiExtensions {
	val static public INSTANCE = new EEnumLiteralExtensions

	extension IGaService = Graphiti::gaService

	extension SetService = SetService::INSTANCE
	extension AddService = AddService::INSTANCE

	private new() {
	}

	def String getSymbol(EEnumLiteral element) {
		identifier
	}

	def String getIdentifier() {
		EcorePackage.Literals::EENUM_LITERAL.name
	}

	def EEnum getEEnum(ICreateContext context) {
		val bo = context?.targetContainer?.bo
		if (bo instanceof EEnum) {
			return bo
		}
	}

	def EEnumLiteral getEEnumLiteral(IPictogramElementContext context) {
		context.bo.EEnumLiteral
	}

	def EEnumLiteral getEEnumLiteral(IAddContext context) {
		context.newObject.EEnumLiteral
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

	def private static EEnumLiteral getEEnumLiteral(Object element) {
		if (element instanceof EEnumLiteral) {
			return element
		}
	}
}
