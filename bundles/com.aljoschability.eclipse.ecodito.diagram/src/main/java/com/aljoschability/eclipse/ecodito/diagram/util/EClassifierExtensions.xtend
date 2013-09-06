package com.aljoschability.eclipse.ecodito.diagram.util

import com.aljoschability.eclipse.core.graphiti.util.GraphitiExtensions
import org.eclipse.emf.ecore.EPackage
import org.eclipse.graphiti.features.context.ITargetContext

abstract class EClassifierExtensions extends GraphitiExtensions {
	protected new() {
	}

	def EPackage getEPackage(ITargetContext context) {
		val bo = context?.targetContainer?.bo
		if (bo instanceof EPackage) {
			return bo
		}
	}

	def String nextName(EPackage ePackage, String prefix) {
		var index = 1
		var name = prefix + index
		while (ePackage.getEClassifier(name) != null) {
			name = prefix + index++
		}
		return name
	}
}
