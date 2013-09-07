package com.aljoschability.eclipse.ecodito.diagram.util

import com.aljoschability.eclipse.core.graphiti.services.CreateService
import com.aljoschability.eclipse.core.graphiti.services.SetService
import com.aljoschability.eclipse.core.graphiti.util.GraphitiExtensions
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EOperation
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

class EOperationExtensions extends GraphitiExtensions {
	val static public INSTANCE = new EOperationExtensions

	extension IGaService = Graphiti::gaService

	extension SetService = SetService::INSTANCE
	extension CreateService = CreateService::INSTANCE

	private new() {
	}

	def String getIdentifier() {
		EcorePackage.Literals::EOPERATION.name
	}

	def String getSymbol(EOperation element) {
		identifier
	}

	def EOperation getEOperation(IPictogramElementContext context) {
		context.bo.EOperation
	}

	def EOperation getEOperation(IAddContext context) {
		context.newObject.EOperation
	}

	def private static EOperation getEOperation(Object element) {
		if (element instanceof EOperation) {
			return element
		}
	}

	def EClass getEClass(ICreateContext context) {
		val bo = context?.targetContainer?.bo
		if (bo instanceof EClass) {
			return bo
		}
	}

	def Style getShapeStyle(Diagram diagram) {
		var style = diagram.findStyle(identifier)

		if (style == null) {
			style = diagram.newStyle [
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
			style = diagram.newStyle [
				id = identifier + "/text"
				font = diagram.manageFont("Segoe UI", 9, false, false)
				foreground = IColorConstant::BLACK
				horizontalAlignment = Orientation::ALIGNMENT_LEFT
				verticalAlignment = Orientation::ALIGNMENT_MIDDLE
			]
		}

		return style
	}
}
