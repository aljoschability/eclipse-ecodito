package com.aljoschability.eclipse.ecodito.diagram.util

import com.aljoschability.eclipse.core.graphiti.services.ContextService
import com.aljoschability.eclipse.core.graphiti.util.GraphitiExtensions
import org.eclipse.emf.ecore.EPackage
import org.eclipse.graphiti.features.context.ITargetContext

abstract class EClassifierExtensions extends GraphitiExtensions {
	extension ContextService = ContextService::INSTANCE

	protected new() {
	}

	def EPackage getEPackage(ITargetContext context) {
		val bo = context?.targetContainer?.model
		if (bo instanceof EPackage) {
			return bo
		}
	}

	def String nextEClassifierName(EPackage ePackage, String prefix) {
		var index = 1
		var name = prefix + index
		while (ePackage.getEClassifier(name) != null) {
			name = prefix + index++
		}
		return name
	}
}
