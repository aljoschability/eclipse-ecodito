package com.aljoschability.eclipse.ecodito.diagram.util

import com.aljoschability.eclipse.core.graphiti.services.ContextService
import com.aljoschability.eclipse.core.graphiti.services.SetService
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.graphiti.features.context.ICreateConnectionContext
import org.eclipse.graphiti.features.context.IReconnectionContext
import org.eclipse.graphiti.services.Graphiti
import org.eclipse.graphiti.services.IGaService
import com.aljoschability.eclipse.core.graphiti.util.GraphitiExtensions
import com.aljoschability.eclipse.core.graphiti.services.AddService

class EClassInheritanceExtensions extends GraphitiExtensions {
	val static public INSTANCE = new EClassInheritanceExtensions

	extension IGaService = Graphiti::gaService

	extension SetService = SetService::INSTANCE
	extension AddService = AddService::INSTANCE
	extension ContextService = ContextService::INSTANCE

	private new() {
	}

	def String getIdentifier() {
		null
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

	def private EClass asEClass(EObject element) {
		if (element instanceof EClass) {
			return element
		}
	}
}
