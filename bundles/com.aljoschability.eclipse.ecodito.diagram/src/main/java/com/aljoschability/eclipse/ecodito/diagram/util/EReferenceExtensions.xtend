package com.aljoschability.eclipse.ecodito.diagram.util

import com.aljoschability.eclipse.core.graphiti.services.ContextService
import com.aljoschability.eclipse.core.graphiti.services.SetService
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.graphiti.features.context.IAddContext
import org.eclipse.graphiti.features.context.ICreateConnectionContext
import org.eclipse.graphiti.features.context.IPictogramElementContext
import org.eclipse.graphiti.features.context.IReconnectionContext
import org.eclipse.graphiti.mm.algorithms.styles.LineStyle
import org.eclipse.graphiti.mm.algorithms.styles.Style
import org.eclipse.graphiti.mm.pictograms.Diagram
import org.eclipse.graphiti.services.Graphiti
import org.eclipse.graphiti.services.IGaService
import org.eclipse.graphiti.util.IColorConstant
import com.aljoschability.eclipse.core.graphiti.services.AddService

class EReferenceExtensions extends EStructuralFeatureExtensions {
	val static public INSTANCE = new EReferenceExtensions

	extension IGaService = Graphiti::gaService

	extension SetService = SetService::INSTANCE
	extension AddService = AddService::INSTANCE
	extension ContextService = ContextService::INSTANCE

	private new() {
	}

	def String getSymbol(EReference element) {
		identifier
	}

	def String getIdentifier() {
		EcorePackage.Literals::EREFERENCE.name
	}

	def Style getConnectionStyle(Diagram diagram) {
		var style = diagram.findStyle(identifier)
		if (style == null) {
			style = diagram.addStyle [
				id = identifier
				foreground = IColorConstant::BLACK
				lineStyle = LineStyle::SOLID
			]
		}
		return style
	}

	def private EClass asEClass(EObject element) {
		if (element instanceof EClass) {
			return element
		}
	}

	def EClass getStartEClass(IReconnectionContext context) {
		context.startModel.asEClass
	}

	def EClass getEndEClass(IReconnectionContext context) {
		context.endModel.asEClass
	}

	def EClass newEClass(IReconnectionContext context) {
		context.newModel.asEClass
	}

	def EClass getSourceEClass(ICreateConnectionContext context) {
		context.sourcePictogramElement.model.asEClass
	}

	def EClass getTargetEClass(ICreateConnectionContext context) {
		context.targetPictogramElement.model.asEClass
	}

	def EReference getEReference(IPictogramElementContext context) {
		context.model.asEReference
	}

	def EReference getEReference(IReconnectionContext context) {
		context.model.asEReference
	}

	def EReference getEReference(IAddContext context) {
		context.newObject.asEReference
	}

	def private EReference asEReference(Object element) {
		if (element instanceof EReference) {
			return element
		}
	}
}
