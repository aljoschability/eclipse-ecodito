package com.aljoschability.eclipse.ecodito.diagram.util

import org.eclipse.emf.ecore.EAttribute
import org.eclipse.graphiti.features.context.IAddContext
import org.eclipse.graphiti.features.context.IPictogramElementContext

class EAttributeExtensions extends EStructuralFeatureExtensions {
	val static public INSTANCE = new EAttributeExtensions

	private new() {
	}

	def EAttribute getEAttribute(IPictogramElementContext context) {
		context.bo.EAttribute
	}

	def EAttribute getEAttribute(IAddContext context) {
		context.newObject.EAttribute
	}

	def private static EAttribute getEAttribute(Object element) {
		if (element instanceof EAttribute) {
			return element
		}
	}
}
