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
}