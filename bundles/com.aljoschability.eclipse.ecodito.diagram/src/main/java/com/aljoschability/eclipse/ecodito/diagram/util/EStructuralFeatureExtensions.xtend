package com.aljoschability.eclipse.ecodito.diagram.util

import com.aljoschability.eclipse.core.graphiti.util.GraphitiExtensions
import org.eclipse.emf.ecore.EClass
import org.eclipse.graphiti.features.context.ICreateContext

abstract class EStructuralFeatureExtensions extends GraphitiExtensions {
	protected new() {
	}

	def EClass getEClass(ICreateContext context) {
		val bo = context?.targetContainer?.bo
		if (bo instanceof EClass) {
			return bo
		}
	}

	def String nextEStructuralFeatureName(EClass element, String prefix) {
		var index = 1
		var name = prefix + index
		while (element.getEStructuralFeature(name) != null) {
			name = prefix + index++
		}
		return name
	}
}
