package com.aljoschability.eclipse.ecodito.diagram.util;

import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.graphiti.features.context.IAddContext
import org.eclipse.graphiti.features.context.IPictogramElementContext

class EClassExtensions extends EClassifierExtensions {
	val static public INSTANCE = new EClassExtensions

	private new() {
	}

	def String getIcon() {
		EcorePackage.Literals::ECLASS.name
	}

	def EClass getEClass(IPictogramElementContext context) {
		context.bo.EClass
	}

	def EClass getEClass(IAddContext context) {
		context.newObject.EClass
	}

	def private static EClass getEClass(Object element) {
		if (element instanceof EClass) {
			return element
		}
	}
}
