package com.aljoschability.eclipse.ecodito.diagram.util

import org.eclipse.emf.ecore.EEnum
import org.eclipse.graphiti.features.context.IAddContext
import org.eclipse.graphiti.features.context.IPictogramElementContext

class EEnumExtensions extends EClassifierExtensions {
	val static public INSTANCE = new EEnumExtensions

	private new() {
	}

	def EEnum getEEnum(IPictogramElementContext context) {
		context.bo.EEnum
	}

	def EEnum getEEnum(IAddContext context) {
		context.newObject.EEnum
	}

	def private static EEnum getEEnum(Object element) {
		if (element instanceof EEnum) {
			return element
		}
	}
}
